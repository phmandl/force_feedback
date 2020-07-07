function [FIM, d_y_d_theta, d_x_d_theta] = calcFIMNonlinear(obj, x0, u_num, theta_specific, t_vec)

    %{
    creation date: 2020-04-16
    created by: Zhang Peng DU
    %}
    
    %% covariance matrix
    
    Sigma = obj.Sigma;
    
    if isempty(Sigma) % check if covariance matrix is empty

        % assign identity matrix to covariance matrix
        Sigma = eye(obj.nrOfOutputs);

    end
    
    %% normalization
    
    if obj.FimNormFlag == 0

        Yn = eye(length(obj.y_normFac));

    else

        Yn = diag(obj.y_normFac);

    end
    
    %% define optimisation parameters
    
    % derivative function
    f.orig = obj.derivativeFunction;

    % output function
    % not normalized output function
    g.unnorm = obj.outputFunction;
    % normalized output function
    g.orig = @(x, u, theta) Yn \ g.unnorm(x, u, theta);

    n_u = obj.nrOfInputs;	% number of inputs
    n_y = obj.nrOfOutputs;	% number of outputs
    n_m = obj.nrOfStates;	% number of states

    % real model parameters
    theta.real = theta_specific;
    
    % number of parameters to estimate
    n_theta = length(obj.freeParamsForOptIdx);

    %% calculate derivatives if necessary
    
    if isempty(obj.f_theta) || isempty(obj.g_theta) ||...
            isempty(obj.f_theta_i) || isempty(obj.f_theta_i)
        
        n_x = 2 * n_m + n_u; % size of stacked state variable

        x.sym = obj.x_sym;                      % symbolic states
        u.sym = obj.u_sym;                      % symbolic inputs
        xi.sym = sym('xi',[n_m, n_theta]);      % symbolic xis
        x_A.sym = sym( zeros(n_x, n_theta) );	% symbolic stacked variable
        theta.sym = obj.theta_sym;              % symbolic parameters
        % initialize derivatives of derivative function
        f.theta = sym( zeros(n_m, n_theta) );   % symbolic, d/(d theta)
        f.theta_i = cell(1, n_theta);           % function, d/(d theta)
        f.x = sym( zeros(n_m, n_m) );           % symbolic, d/(d x)
        % initialize derivative of output function
        g.theta = sym( zeros(n_y, n_theta) );   % symbolic, d/(d theta)
        g.theta_i = cell(1, n_theta);           % function, d/(d theta)
        g.x = sym( zeros(n_y, n_m) );           % symbolic, d/(d x)

        % derivative of functions with respect to x
        if isempty(obj.A_func) || isempty(obj.B_func) ||...
                isempty(obj.C_func) || isempty(obj.D_func)

             obj.analyticLinearization();

        end

        f.x = obj.A_sym;
        g.x = Yn \ obj.C_sym;

        % alternative
%         for k = 1 : n_m
%     
%             f.x(:,k) = diff( f.orig(x.sym, u.sym, theta.sym), x.sym(k) );
%             g.x(:,k) = diff( g.orig(x.sym, u.sym, theta.sym), x.sym(k) );
%     
%         end

        % derivative of function with respect to theta
        for k = 1 : n_theta

            % create stacked variable
            x_A.sym(:, k) = [x.sym; u.sym; xi.sym(:, k)];

            f.theta(:, k) =...
                diff( f.orig(x.sym, u.sym, theta.sym), theta.sym(...
                obj.freeParamsForOptIdx(k)) ) + f.x * xi.sym(:, k);
            g.theta(:, k) =...
                diff( g.orig(x.sym, u.sym, theta.sym), theta.sym(...
                obj.freeParamsForOptIdx(k)) ) + g.x * xi.sym(:, k);

            f.theta_i{k} = matlabFunction(f.theta(:, k), 'Vars',...
                {x_A.sym(:, k), theta.sym});
            g.theta_i{k} = matlabFunction(g.theta(:, k), 'Vars',...
                {x_A.sym(:, k), theta.sym});

        end

        % save symbolic functions to object
        obj.f_theta = f.theta;
        obj.g_theta = g.theta;

        % save functions to object
        obj.f_theta_i = f.theta_i;
        obj.g_theta_i = g.theta_i;
        
    else
        
        % load symbolic functions from object
        f.theta = obj.f_theta;
        g.theta = obj.g_theta;

        % load functions from object
        f.theta_i = obj.f_theta_i;
        g.theta_i = obj.g_theta_i;
        
    end

    %% calculate states
    
    % replace unnormalized output function with normalized one
    obj.outputFunction = g.orig;
    
    % calculate states
    [~, x_num, ~] = obj.nonlinearSimulation(x0, u_num, theta.real, t_vec);
    
    % replace normalized output function with unnormalized one
    obj.outputFunction = g.unnorm;
    
    %% calculate xi
    
    % initialize xi matrix
    xi_temp = zeros(length(t_vec), n_m, n_theta);
    
    % integration options
    options = odeset('RelTol', obj.simTol, 'AbsTol', obj.simTol,...
        'stats', 'off');
    
    parfor k = 1 : n_theta
        
        fun = f.theta_i{k};
        
        % initial values for optimization
        solveForSteadyState = @(x) fun([x0; u_num(:, 1); x],...
            theta.real);
        foptions = optimoptions('fsolve');
        foptions.OptimalityTolerance = 1e-10;
        foptions.StepTolerance = 1e-9;
        foptions.MaxFunctionEvaluations = 1e6;
        foptions.MaxIterations = 1e5;
        foptions.Display = 'off';
        xi_init = fsolve(solveForSteadyState, ones(size(x0)), foptions);
        
        % create function handle for integration
        simFunc = @(t,x) fun_interp(fun, t, x, x_num, u_num,...
            theta.real, t_vec);

        [~, xi_temp(:, :, k)] = ode15s(simFunc, t_vec, xi_init, options);
        
    end
    
    % rearrange xi
    xi.num = permute(xi_temp, [2 1 3]);
    
    d_x_d_theta = xi.num;
    
    %% calculate psi
    
    psi = zeros(n_y, length(t_vec), n_theta);
    
    for p = 1 : n_theta
        
        parfor k = 1 : length(t_vec)
            
            x_A_temp = [x_num(:, k); u_num(:, k); xi.num(:, k, p)];
            
            psi(:, k, p) = g.theta_i{p}(x_A_temp, theta.real);
        
        end
        
        if obj.FimNormFlag == 1

            %{
            Normalization with respect to nominal parameter value: care
            for zero
            %}
            psi(:, :, p) = psi(:, :, p) *...
                theta.real( obj.freeParamsForOptIdx(p) );

        end
        
    end
    
    d_y_d_theta = psi;
    
    %% calculate FIM
    
    % initialize FIM
    FIM = zeros(n_theta);
    
    % rearrange psi
    psi = permute(psi, [1, 3, 2]);
    
    parfor k = 1 : length(t_vec)
        
        FIM = FIM + psi(:, :, k)' * (Sigma \ psi(:, :, k));
        
    end
    
end

% interpolate function for integration
function fun_res = fun_interp(fun, t, x, x_num, u_num, theta_specific,...
    t_vec)
    
    % interpolate input signal
    u_interp = interp1(t_vec, u_num', t);
    % interpolate state
    x_interp = interp1(t_vec, x_num', t);
    % create temporary stacked variable
    x_A_temp = [x_interp'; u_interp'; x];
    % evaluate function for given point
    fun_res = fun(x_A_temp, theta_specific);  

end