function createTestcaseData(obj, model)
    %{
    creation date: 2020-03-06
    created by: Zhang Peng DU

    No definitions here, just calculations.
    %}
    %% initialization

    str{1} = [datestr(now), ' starting testcase data creation'];
    disp(str);
    load(['.\Testcases\', model, '_model.mat']); % load model data
    obj = eval(model); % load model as a object

    %% solve for steady state and non-linear simulation

    obj.statSolMethod = 'sim';

    [x0, t_v, x_vec] = obj.solveForSteadyState(x0_initGuess,...
        u0, obj.theta);
    
    sol.solveForSteadyState.sim.x0 = norm(x0, 'fro');
    sol.solveForSteadyState.sim.t_v = norm(t_v, 'fro');
    sol.solveForSteadyState.sim.x_vec = norm(x_vec, 'fro');

    obj.statSolMethod = 'sol';

    [x0, t_v, x_vec] = obj.solveForSteadyState(x0_initGuess,...
        u0, obj.theta);

    sol.solveForSteadyState.sol.x0 = norm(x0, 'fro');
    sol.solveForSteadyState.sol.t_v = norm(t_v, 'fro');
    sol.solveForSteadyState.sol.x_vec = norm(x_vec, 'fro');

    y0 = obj.outputFunction(x0, u0, obj.theta);
    
    sol.outputFunction.y0 = norm(y0, 'fro');

    x = obj.interpDerivativeFunction(( t_vec(2) -...
        t_vec(1) )/2, x0, u, obj.theta, t_vec);
    
    sol.interpDerivativeFunction.x = norm(x, 'fro');

    [y_vec, x_vec, t_vec] = obj.nonlinearSimulation(x0, u,...
        obj.theta, t_vec);
    
    sol.nonlinearSimulation.y_vec = norm(y_vec, 'fro');
    sol.nonlinearSimulation.x_vec = norm(x_vec, 'fro');
    sol.nonlinearSimulation.t_vec = norm(t_vec, 'fro');

    %% get linearized system and linear simulation

    obj.analyticLinearization;

    sol.analyticLinearization.A = norm( obj.A_func(...
        x0_initGuess, u0, obj.theta), 'fro' );
    sol.analyticLinearization.B = norm( obj.B_func(...
        x0_initGuess, u0, obj.theta), 'fro' );
    sol.analyticLinearization.C = norm( obj.C_func(...
        x0_initGuess, u0, obj.theta), 'fro' );
    sol.analyticLinearization.D = norm( obj.D_func(...
        x0_initGuess, u0, obj.theta), 'fro' );

    [linSys, A, B, C, D] = obj.getLinSys(x0, u0,...
        obj.theta);
    y_vec_lin = lsim(linSys, u - u0, t_vec)' + y0;

    sol.getLinSys.A = norm(A, 'fro');
    sol.getLinSys.B = norm(B, 'fro');
    sol.getLinSys.C = norm(C, 'fro');
    sol.getLinSys.D = norm(D, 'fro');
    sol.getLinSys.y = norm(y_vec_lin, 'fro');

    %% Calculate FIM on the linearized model around operating point

    obj.preProcessingSSDerivatives;
    
    for n = obj.freeParamsForOptIdx
        
        sol.preProcessingSSDerivatives.A{n} = norm(...
            obj.SS_Mat_Derivs.A_diff_func{n}(x0, u0,...
            obj.theta), 'fro' );
        sol.preProcessingSSDerivatives.B{n} = norm(...
            obj.SS_Mat_Derivs.B_diff_func{n}(x0, u0,...
            obj.theta), 'fro' );
        sol.preProcessingSSDerivatives.C{n} = norm(...
            obj.SS_Mat_Derivs.C_diff_func{n}(x0, u0,...
            obj.theta), 'fro' );
        sol.preProcessingSSDerivatives.D{n} = norm(...
            obj.SS_Mat_Derivs.D_diff_func{n}(x0, u0,...
            obj.theta), 'fro' );
        
    end

    [FIM, d_y_d_theta, d_x_d_theta] = obj.calcFIMLinearized(...
        x0, u0, u, obj.theta, dt);
    
    y_col = size(d_y_d_theta, 2);
    d_y_d_theta_A = zeros(size(d_y_d_theta, 1), y_col *...
        size(d_y_d_theta, 3));
    
    for n = 1 : size(d_y_d_theta, 3)
        
        d_y_d_theta_A(:, (n - 1) * y_col + (1 : y_col)) =...
            d_y_d_theta(:, :, n);
        
    end
    
    sol.calcFIMLinearized.FIM = norm(FIM, 'fro');
    sol.calcFIMLinearized.d_y_d_theta = norm(d_y_d_theta_A, 'fro');
    % change if d_x_d_theta is saved for every parameter
    % now d_x_d_theta is saved only for the last parameter
    sol.calcFIMLinearized.d_x_d_theta = norm(d_x_d_theta, 'fro');
    
    [FIM, d_y_d_theta, d_x_d_theta] = obj.calcFIMNonlinear(x0, u,...
        obj.theta, t_vec);
    
    d_y_d_theta = permute(d_y_d_theta, [1, 3, 2]);
    d_x_d_theta = permute(d_x_d_theta, [1, 3, 2]);
    
    d_y_d_theta_A = zeros(size(d_y_d_theta, 1), y_col *...
        size(d_y_d_theta, 3));
    d_x_d_theta_A = zeros(size(d_x_d_theta, 1), y_col *...
        size(d_y_d_theta, 3));
    
    for n = 1 : size(d_y_d_theta, 3)
        
        d_y_d_theta_A(:, (n - 1) * y_col + (1 : y_col)) =...
            d_y_d_theta(:, :, n);
        d_x_d_theta_A(:, (n - 1) * y_col + (1 : y_col)) =...
            d_x_d_theta(:, :, n);
        
    end
    
    sol.calcFIMNonlinear.FIM = norm(FIM, 'fro');
    sol.calcFIMNonlinear.d_y_d_theta = norm(d_y_d_theta_A, 'fro');
    sol.calcFIMNonlinear.d_x_d_theta = norm(d_x_d_theta_A, 'fro');

    sol.analyzeParamSignificance.idx =...
        obj.analyzeParamSignificance(FIM);

    %% Test Optimization: "Forget" theta and reestimate theta from data

    sol.createIdentDataStruct = nonlinearModel;
    sol.createIdentDataStruct.createIdentDataStruct(1);
    
    % save old settings
    paramOptBase_old = obj.paramOptBase;
    penalizeInstability_old = obj.penalizeInstability;
    regularizationFlag_old = obj.regularizationFlag;
    dataDomain_old = obj.identData(1).dataDomain;
    regularizationWeight_old = obj.regularizationWeight;
    
    paramOptBase = {'log', 'lin'};
    penalizeInstability = [0, 1];
    regularizationFlag = {'off', 'on'};
    dataDomain = {'linear', 'nonlinear'};
    obj.regularizationWeight = 1e9;
    
    n = 0;
    
    for paramOptBase_idx = 1 : length(paramOptBase)
        
        obj.paramOptBase = paramOptBase{paramOptBase_idx};
        
        for penalizeInstability_idx = 1 : length(penalizeInstability)
            
            obj.penalizeInstability =...
                penalizeInstability(penalizeInstability_idx);
            
            for regularizationFlag_idx = 1 : length(regularizationFlag)
                
                obj.regularizationFlag =...
                    regularizationFlag{regularizationFlag_idx};

                for dataDomain_idx = 1 : length(dataDomain)
                    
                    n = n + 1;
                    
                    obj.identData(1).dataDomain =...
                        dataDomain{dataDomain_idx};
                    
                    % save used options as string
                    sol.objFuncOptimization_opt{n} = ['paramOptBase = ',...
                        paramOptBase{paramOptBase_idx},...
                        ', penalizeInstability = ',...
                        num2str(penalizeInstability(...
                        penalizeInstability_idx)),...
                        ', regularizationFlag = ',...
                        regularizationFlag{regularizationFlag_idx},...
                        ', dataDomain = ', dataDomain{dataDomain_idx}];
                    sol.objFuncOptimization{n} =...
                        obj.objFuncOptimization(ones(1, size(obj.theta(...
                        obj.freeParamsForOptIdx), 1)) * 1.01, 'off');
                    
                end

            end
            
        end
        
    end
    
    % reload old settings
    obj.paramOptBase = paramOptBase_old;
    obj.penalizeInstability = penalizeInstability_old;
    obj.regularizationFlag = regularizationFlag_old;
    obj.identData(1).dataDomain = dataDomain_old;
    obj.regularizationWeight = regularizationWeight_old;

    paramOptimization = {'fmincon', 'fsolve', 'fminsearch', 'fminunc'};
    theta = obj.theta;  % save real theta
    obj.theta = theta0; % initial theta for optimization
    
    for n = 1 : length(paramOptimization)
        
        sol.paramOptimization{n} = obj.paramOptimization(...
            paramOptimization{n}, 'off' )';
        
    end
    
    %% calculate confidence interval
    
    % calculate confidence interval with arbitrary theta_hat and FIM
    CI = obj.getCI(ones( size( obj.freeParamsForOptIdx ) ) * 3,...
        eye( length( obj.freeParamsForOptIdx ) ) * 3, 1, .95);
    
    sol.getCI.CI = norm(CI, 'fro');
    
    %% finalisation
    
    save(['.\Testcases\', model, '_data.mat'], 'sol'); % save testcase data
    str{2} = [datestr(now), ' testcase data creation finished'];
    disp(str');

end