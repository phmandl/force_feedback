function checkTestcaseModel(obj, model)
    %{
    creation date: 2020-03-09
    created by: Zhang Peng DU

    No definitions here, just checking, if the model is suitable.
    %}
    %% initialization
    
    str{1} = [datestr(now), ' starting testcase model check'];
    disp(str);
    str_c = 2;
    
    load(['.\Testcases\', model, '_model.mat']); % load model data
    
    if exist(model)
        
        % nonlinearModel object and model have to have the same name
        obj = eval(model); % load model as a object
        
    else
        
        disp(['''', model, ''' nonlinearModel object not found, ',...
            'nonlinearModel object and model have to have the same name']);
        return
        
    end

    %% check model definitions
    
    errors = 0;
    
    if isempty(obj.derivativeFunction)
        
        errors = errors + 1;
        str{str_c} = '''derivativeFunction'' not defined';
        str_c = str_c + 1;
        
    end
    
    if isempty(obj.outputFunction)
        
        errors = errors + 1;
        str{str_c} = '''outputFunction'' not defined';
        str_c = str_c + 1;
        
    end
    
    if isempty(obj.theta)
        
        errors = errors + 1;
        str{str_c} = '''theta'' not defined';
        str_c = str_c + 1;
        
    end
    
    if isempty(obj.nrOfInputs)
        
        errors = errors + 1;
        str{str_c} = '''nrOfInputs'' not defined';
        str_c = str_c + 1;
        
    end
    
    if isempty(obj.nrOfOutputs)
        
        errors = errors + 1;
        str{str_c} = '''nrOfOutputs'' not defined';
        str_c = str_c + 1;
        
    end
    
    if isempty(obj.nrOfStates)
        
        errors = errors + 1;
        str{str_c} = '''nrOfStates'' not defined';
        str_c = str_c + 1;
        
    end
    
    if isempty(obj.freeParamsForOptIdx)
        
        errors = errors + 1;
        str{str_c} = '''freeParamsForOptIdx'' not defined';
        str_c = str_c + 1;
        
    end
    
    if isempty(obj.freeParamsForOptIdx)
        
        errors = errors + 1;
        str{str_c} = '''freeParamsForOptIdx'' not defined';
        str_c = str_c + 1;
        
    end
    
    if isempty(obj.theta_labels)
        
        errors = errors + 1;
        str{str_c} = '''theta_labels'' not defined';
        str_c = str_c + 1;
        
    end
    
    if exist('dt', 'var') == 0
        
        errors = errors + 1;
        str{str_c} = '''dt'' not defined';
        str_c = str_c + 1;
        
    end
    
    if exist('x0_initGuess', 'var') == 0
        
        errors = errors + 1;
        str{str_c} = '''x0_initGuess'' not defined';
        str_c = str_c + 1;
        
    end
    
    if exist('u0', 'var') == 0
        
        errors = errors + 1;
        str{str_c} = '''u0'' not defined';
        str_c = str_c + 1;
        
    end
    
    if exist('t_vec', 'var') == 0
        
        errors = errors + 1;
        str{str_c} = '''t_vec'' not defined';
        str_c = str_c + 1;
        
    end
    
    if exist('u', 'var') == 0
        
        errors = errors + 1;
        str{str_c} = '''u'' not defined';
        str_c = str_c + 1;
        
    end
    
    if exist('n_set', 'var') == 0
        
        errors = errors + 1;
        str{str_c} = '''n_set'' not defined';
        str_c = str_c + 1;
        
    else
        
        for n = 1 : n_set
            
            if isempty(obj.identData(n).inputData)

                errors = errors + 1;
                str{str_c} = ['''identData(', num2str(n),...
                    ').inputData'' not defined'];
                str_c = str_c + 1;

            end
            
            if isempty(obj.identData(n).outputData)

                errors = errors + 1;
                str{str_c} = ['''identData(', num2str(n),...
                    ').outputData'' not defined'];
                str_c = str_c + 1;

            end
            
            if isempty(obj.identData(n).timeVec)

                errors = errors + 1;
                str{str_c} = ['''identData(', num2str(n),...
                    ').timeVec'' not defined'];
                str_c = str_c + 1;

            end
            
            if isempty(obj.identData(n).dt)

                errors = errors + 1;
                str{str_c} = ['''identData(', num2str(n),...
                    ').dt'' not defined'];
                str_c = str_c + 1;

            end
            
            if isempty(obj.identData(n).u0)

                errors = errors + 1;
                str{str_c} = ['''identData(', num2str(n),...
                    ').u0'' not defined'];
                str_c = str_c + 1;

            end
            
            if isempty(obj.identData(n).x0_initGuess)

                errors = errors + 1;
                str{str_c} = ['''identData(', num2str(n),...
                    ').x0_initGuess'' not defined'];
                str_c = str_c + 1;

            end
            
            if isempty(obj.identData(n).timeDomain)

                errors = errors + 1;
                str{str_c} = ['''identData(', num2str(n),...
                    ').timeDomain'' not defined'];
                str_c = str_c + 1;

            end
            
            if isempty(obj.identData(n).dataDomain)

                errors = errors + 1;
                str{str_c} = ['''identData(', num2str(n),...
                    ').dataDomain'' not defined'];
                str_c = str_c + 1;

            end
            
            if isempty(obj.identData(n).weight)

                errors = errors + 1;
                str{str_c} = ['''identData(', num2str(n),...
                    ').weight'' not defined'];
                str_c = str_c + 1;

            end
            
        end
        
    end
    
    if exist('theta0', 'var') == 0
        
        errors = errors + 1;
        str{str_c} = '''theta0'' not defined';
        str_c = str_c + 1;
        
    end
    
    %% finalisation
    
    if errors == 0
        
        str{str_c} = [datestr(now), ' testcase model is suitable'];
    
    else
        
        str{str_c} = [datestr(now), ' testcase model is not suitable', ...
            ', number of errors: ', num2str(errors),...
            ', see messages above'];
        
    end
    
    disp(str');

end