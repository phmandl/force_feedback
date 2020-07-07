function checkToolbox(obj, model)
    %{
    creation date: 2020-03-10
    created by: Zhang Peng DU

    No definitions here, just calculations and comparisons.
    %}
    %% initialization

    str{1} = [datestr(now), ' starting toolbox check'];
    disp(str);
    load(['.\Testcases\', model, '_model.mat']); % load model data
    load(['.\Testcases\', model, '_data.mat']); % load model testcase data
    obj = eval(model); % load model as a object
    
    errors = 0; % error counter
    accuracyCoeff = 10; % accuracy coefficient for comparison
    accuracyCoeffEst = 1e9; % accuracy coefficient for estimation results
    opt_mod = '\n%s\n\n'; % format of method string
    opt_num = '%.20e\t%s\n'; % format of numeric output
    opt_text = '%s\n'; % format of regular text
    opt_text_n = '%s\n\n'; % format of regular text with new following line
    
    check_log = fopen( [datestr(now, 'yyyymmddHHMMSS'),...
        '_log_checkToolbox_', model, '.txt'], 'wt' ); % create log file
    fprintf(check_log, opt_text, str{1});
    fprintf(check_log, opt_text, ['used model: ', model]);
    fprintf(check_log, opt_text, ['accuracyCoeff = ',...
        num2str(accuracyCoeff), ' * eps(reference value)']);
    fprintf(check_log, opt_text_n, ['accuracyCoeffEst = ',...
        num2str(accuracyCoeffEst), ' * eps(reference value)']);
    fprintf(check_log, opt_text, repelem('-', 100));

    %% solve for steady state and non-linear simulation

    obj.statSolMethod = 'sim';

    [x0, t_v, x_vec] = obj.solveForSteadyState(x0_initGuess,...
        u0, obj.theta);

    curr.solveForSteadyState.sim.x0 = norm(x0, 'fro');
    curr.solveForSteadyState.sim.t_v = norm(t_v, 'fro');
    curr.solveForSteadyState.sim.x_vec = norm(x_vec, 'fro');

    errors = check(sol.solveForSteadyState.sim,...
        curr.solveForSteadyState.sim,...
        'solveForSteadyState with option ''sim''', accuracyCoeff,...
        errors, check_log, opt_mod, opt_text, opt_text_n, opt_num);

    obj.statSolMethod = 'sol';

    [x0, t_v, x_vec] = obj.solveForSteadyState(x0_initGuess,...
        u0, obj.theta);

    curr.solveForSteadyState.sol.x0 = norm(x0, 'fro');
    curr.solveForSteadyState.sol.t_v = norm(t_v, 'fro');
    curr.solveForSteadyState.sol.x_vec = norm(x_vec, 'fro');
    
    errors = check(sol.solveForSteadyState.sol,...
        curr.solveForSteadyState.sol,...
        'solveForSteadyState with option ''sol''', accuracyCoeff,...
        errors, check_log, opt_mod, opt_text, opt_text_n, opt_num);
    
    y0 = obj.outputFunction(x0, u0, obj.theta);
    
    curr.outputFunction.y0 = norm(y0, 'fro');
    
    errors = check(sol.outputFunction,...
        curr.outputFunction,...
        'outputFunction', accuracyCoeff,...
        errors, check_log, opt_mod, opt_text, opt_text_n, opt_num);

    x = obj.interpDerivativeFunction(( t_vec(2) -...
        t_vec(1) )/2, x0, u, obj.theta, t_vec);
    
    curr.interpDerivativeFunction.x = norm(x, 'fro');
    
    errors = check(sol.interpDerivativeFunction,...
        curr.interpDerivativeFunction,...
        'interpDerivativeFunction', accuracyCoeff,...
        errors, check_log, opt_mod, opt_text, opt_text_n, opt_num);

    [y_vec, x_vec, t_vec] = obj.nonlinearSimulation(x0, u,...
        obj.theta, t_vec);
    
    curr.nonlinearSimulation.y_vec = norm(y_vec, 'fro');
    curr.nonlinearSimulation.x_vec = norm(x_vec, 'fro');
    curr.nonlinearSimulation.t_vec = norm(t_vec, 'fro');
    
    errors = check(sol.nonlinearSimulation,...
        curr.nonlinearSimulation,...
        'nonlinearSimulation', accuracyCoeff,...
        errors, check_log, opt_mod, opt_text, opt_text_n, opt_num);

    %% get linearized system and linear simulation

    obj.analyticLinearization;

    curr.analyticLinearization.A = norm( obj.A_func(...
        x0_initGuess, u0, obj.theta), 'fro' );
    curr.analyticLinearization.B = norm( obj.B_func(...
        x0_initGuess, u0, obj.theta), 'fro' );
    curr.analyticLinearization.C = norm( obj.C_func(...
        x0_initGuess, u0, obj.theta), 'fro' );
    curr.analyticLinearization.D = norm( obj.D_func(...
        x0_initGuess, u0, obj.theta), 'fro' );
    
    errors = check(sol.analyticLinearization,...
        curr.analyticLinearization,...
        'analyticLinearization', accuracyCoeff,...
        errors, check_log, opt_mod, opt_text, opt_text_n, opt_num);

    [linSys, A, B, C, D] = obj.getLinSys(x0, u0,...
        obj.theta);
    y_vec_lin = lsim(linSys, u - u0, t_vec)' + y0;

    curr.getLinSys.A = norm(A, 'fro');
    curr.getLinSys.B = norm(B, 'fro');
    curr.getLinSys.C = norm(C, 'fro');
    curr.getLinSys.D = norm(D, 'fro');
    curr.getLinSys.y = norm(y_vec_lin, 'fro');
    
    errors = check(sol.getLinSys,...
        curr.getLinSys,...
        'getLinSys', accuracyCoeff,...
        errors, check_log, opt_mod, opt_text, opt_text_n, opt_num);

    %% Calculate FIM on the linearized model around operating point

    obj.preProcessingSSDerivatives;
    
    for n = obj.freeParamsForOptIdx
        
        curr.preProcessingSSDerivatives.A{n} = norm(...
            obj.SS_Mat_Derivs.A_diff_func{n}(x0, u0,...
            obj.theta), 'fro' );
        curr.preProcessingSSDerivatives.B{n} = norm(...
            obj.SS_Mat_Derivs.B_diff_func{n}(x0, u0,...
            obj.theta), 'fro' );
        curr.preProcessingSSDerivatives.C{n} = norm(...
            obj.SS_Mat_Derivs.C_diff_func{n}(x0, u0,...
            obj.theta), 'fro' );
        curr.preProcessingSSDerivatives.D{n} = norm(...
            obj.SS_Mat_Derivs.D_diff_func{n}(x0, u0,...
            obj.theta), 'fro' );
        
    end
    
    errors = check(sol.preProcessingSSDerivatives.A,...
        curr.preProcessingSSDerivatives.A,...
        'preProcessingSSDerivatives Matrix A', accuracyCoeff,...
        errors, check_log, opt_mod, opt_text, opt_text_n, opt_num);
    errors = check(sol.preProcessingSSDerivatives.B,...
        curr.preProcessingSSDerivatives.B,...
        'preProcessingSSDerivatives Matrix B', accuracyCoeff,...
        errors, check_log, opt_mod, opt_text, opt_text_n, opt_num);
    errors = check(sol.preProcessingSSDerivatives.C,...
        curr.preProcessingSSDerivatives.C,...
        'preProcessingSSDerivatives Matrix C', accuracyCoeff,...
        errors, check_log, opt_mod, opt_text, opt_text_n, opt_num);
    errors = check(sol.preProcessingSSDerivatives.D,...
        curr.preProcessingSSDerivatives.D,...
        'preProcessingSSDerivatives Matrix D', accuracyCoeff,...
        errors, check_log, opt_mod, opt_text, opt_text_n, opt_num);

    [FIM, d_y_d_theta, d_x_d_theta] = obj.calcFIMLinearized(...
        x0, u0, u, obj.theta, dt);
    
    y_col = size(d_y_d_theta, 2);
    d_y_d_theta_A = zeros(size(d_y_d_theta, 1), y_col *...
        size(d_y_d_theta, 3));
    
    for n = 1 : size(d_y_d_theta, 3)
        
        d_y_d_theta_A(:, (n - 1) * y_col + (1 : y_col)) =...
            d_y_d_theta(:, :, n);
        
    end
    
    curr.calcFIMLinearized.FIM = norm(FIM, 'fro');
    curr.calcFIMLinearized.d_y_d_theta = norm(d_y_d_theta_A, 'fro');
    % change if d_x_d_theta is saved for every parameter
    % now d_x_d_theta is saved only for the last parameter
    curr.calcFIMLinearized.d_x_d_theta = norm(d_x_d_theta, 'fro');
    
    errors = check(sol.calcFIMLinearized,...
        curr.calcFIMLinearized,...
        'calcFIMLinearized', accuracyCoeff,...
        errors, check_log, opt_mod, opt_text, opt_text_n, opt_num);
    
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
    
    curr.calcFIMNonlinear.FIM = norm(FIM, 'fro');
    curr.calcFIMNonlinear.d_y_d_theta = norm(d_y_d_theta_A, 'fro');
    curr.calcFIMNonlinear.d_x_d_theta = norm(d_x_d_theta_A, 'fro');
    
    errors = check(sol.calcFIMNonlinear,...
        curr.calcFIMNonlinear,...
        'calcFIMNonlinear', accuracyCoeff,...
        errors, check_log, opt_mod, opt_text, opt_text_n, opt_num);

    curr.analyzeParamSignificance.idx =...
        obj.analyzeParamSignificance(FIM);
    
    % transform numeric array to cell array for further computation
    orig_temp = mat2cell(sol.analyzeParamSignificance.idx, 1, ones(1,...
        length(sol.analyzeParamSignificance.idx)));
    new_temp = mat2cell(curr.analyzeParamSignificance.idx, 1, ones(1,...
        length(curr.analyzeParamSignificance.idx)));
    
    errors = check(orig_temp,...
        new_temp,...
        'analyzeParamSignificance', accuracyCoeff,...
        errors, check_log, opt_mod, opt_text, opt_text_n, opt_num);

    %% Test Optimization: "Forget" theta and reestimate theta from data

    curr.createIdentDataStruct = nonlinearModel;
    curr.createIdentDataStruct.createIdentDataStruct(1);
    
    errors = check(sol.createIdentDataStruct.identData,...
        curr.createIdentDataStruct.identData,...
        'createIdentDataStruct', accuracyCoeff,...
        errors, check_log, opt_mod, opt_text, opt_text_n, opt_num);
    
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
                    
                    curr.objFuncOptimization{n} =...
                        obj.objFuncOptimization(ones(1, size(obj.theta(...
                        obj.freeParamsForOptIdx), 1)) * 1.01, 'off');
                    
                end

            end
            
        end
        
    end
    
    errors = check(sol.objFuncOptimization,...
        curr.objFuncOptimization,...
        'objFuncOptimization', accuracyCoeff,...
        errors, check_log, opt_mod, opt_text, opt_text_n, opt_num);
    
    % reload old settings
    obj.paramOptBase = paramOptBase_old;
    obj.penalizeInstability = penalizeInstability_old;
    obj.regularizationFlag = regularizationFlag_old;
    obj.identData(1).dataDomain = dataDomain_old;
    obj.regularizationWeight = regularizationWeight_old;

    paramOptimization = {'fmincon', 'fsolve', 'fminsearch',...
        'fminunc'};
    theta = obj.theta;  % save real theta
    obj.theta = theta0; % initial theta for optimization
    
    for n = 1 : length(paramOptimization)
        
        curr.paramOptimization{n} = obj.paramOptimization(...
            paramOptimization{n}, 'off' );
        
    end

    errors = check(sol.paramOptimization,...
        curr.paramOptimization,...
        'paramOptimization', accuracyCoeffEst,...
        errors, check_log, opt_mod, opt_text, opt_text_n, opt_num);
    
    %% calculate confidence interval
    
    % check confidence interval with arbitrary theta_hat and FIM
    CI = obj.getCI(ones( size( obj.freeParamsForOptIdx ) ) * 3,...
        eye( length( obj.freeParamsForOptIdx ) ) * 3, 1, .95);
    
    curr.getCI.CI = norm(CI, 'fro');
    
    errors = check(sol.getCI, curr.getCI, 'getCI', accuracyCoeff,...
        errors, check_log, opt_mod, opt_text, opt_text_n, opt_num);
    
    %% finalisation
    
    if errors == 0
        
        str{2} = [datestr(now), ' toolbox check SUCCESSFULL'];
    
    else
        
        str{2} = [datestr(now), ' toolbox check FAILED', ...
            ', number of errors: ', num2str(errors),...
            ', see log file for more information'];
        
    end
    
	fprintf(check_log, '\n%s', str{2});
    fclose(check_log);
    disp(str');

end

% use the structure variable one level above the variables to be checked
function errors = check(orig_struct, new_struct, mod_str, accuracyCoeff,...
    errors, check_log, opt_mod, opt_text, opt_text_n, opt_num)

    fprintf(check_log, opt_mod,...
        ['>>> check ', mod_str]);
    
    err_flag = 0; % flag for errors during this run
    
    % structure array?
    if isstruct(orig_struct) && ~strcmp(mod_str,'createIdentDataStruct')
    
        names = fieldnames(orig_struct); % get names of saved variables
        n_max = length(names);
        
    % cell array?
    elseif iscell(orig_struct)
        
        orig_val = cell2mat(orig_struct);
        new_val = cell2mat(new_struct);
        n_max = length(orig_val);
        
    % createIdentDataStruct?
    elseif strcmp(mod_str,'createIdentDataStruct')
        
        names = fieldnames(orig_struct); % get names of saved variables
        n_max = length(names);
        Ident_flag = 1;
        
    end
    
    if ~exist('Ident_flag', 'var')
        
        for n = 1 : n_max

            if isstruct(orig_struct)

                orig_data = orig_struct.(names{n});
                new_data = new_struct.(names{n});
                fprintf(check_log, opt_text,...
                    ['check solution of ', names{n}]);

            else

                orig_data = orig_val(n);
                new_data = new_val(n);
                fprintf(check_log, opt_text,...
                    ['check solution of value', num2str(n)]);

            end

            differ = abs(orig_data - new_data);
            acc = accuracyCoeff * eps( orig_data );

            fprintf(check_log, opt_num, orig_data,...
                'reference solution');
            fprintf(check_log, opt_num, new_data,...
                'current solution');
            fprintf(check_log, opt_num, differ, 'difference');
            fprintf(check_log, opt_num, acc, 'check accuracy');

            if differ <= acc

                fprintf(check_log, opt_text_n, 'solution OK');

            else

                err_flag = err_flag + 1;
                errors = errors + 1;
                fprintf(check_log, opt_text_n, 'solution WRONG');

            end 

        end
        
    else
        
        for n = 1 : n_max
            
            orig_data = orig_struct.(names{n});
            new_data = new_struct.(names{n});
            fprintf(check_log, opt_text,...
                ['check if ', names{n}, ' is identical']);

            if isequal(orig_data, new_data)

                fprintf(check_log, opt_text_n, 'solution OK');

            else

                err_flag = err_flag + 1;
                errors = errors + 1;
                fprintf(check_log, opt_text_n, 'solution WRONG');

            end 

        end
        
    end
    
    if err_flag == 0
        
        fprintf(check_log, opt_text_n, ['>>> ', mod_str, ' OK']);
        
    else
        
        fprintf(check_log, opt_text_n, ['XXX ', mod_str, ' FAULTY']);
        
    end
    
    fprintf(check_log, opt_text, repelem('-', 100));
    
end