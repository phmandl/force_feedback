classdef nonlinearModel < handle
    % Nonlinear model framework for estimation of non-linear grey box
    % models via local analytic linearization
    
    
    properties
        
        %%% Nonlinear Model Properties
        derivativeFunction  % defines the derivative function: x_dot = f(x,u,theta);    % only x,u,theta, considered as function arguments, set additional function arguments outside of the model 
                                                                                        % class and constructor and pass reduced funtion handle red_func = @(x,u,theta) full_func(x,u,theta,arg1,arg2,...)
        outputFunction      % defines the output function:         y = g(x,u,theta);
        
        nrOfInputs          % Dimension of Inputs
        nrOfOutputs         % Dimension of Outputs
        nrOfStates          % Dimension of State Vector
        
        theta               % Numerical parameters as vector
        theta_labels        % Labels of numerical parameters
        
        %%% Standard Values if not Set Differently
        simTol = 1e-4;             % relative tolerance for nonlinear simulation with ODE15s
        simTimeOut = -1;           % Time after which ODE15s terminates. If set to -1, TimeOut is disabled (CURRENTLY HACKED INTO ODE15s ONLY) 
        statSolMethod = 'sol'      % choose the method of how the steady state is calculated 'sim', 'sol' or 'none'
        statSolSimEndtime = 1000;  % Amount of time used in the steady state simulation if statSolMethod = 'sim' 
        Sigma = [];                % covariance matrix of parameter vector
        FimNormFlag = 0;           % normalize d_y_d_theta with y_normFac \ d_y_d_theta * theta
        
        ODESol = 'ode15s'          % choose the ODE Solver 
        
        ODEOpt                 % Provide additional ODE options (MATLABS odeset)
        OPTOpt                 % Provide additional OPT options (Solver specific)
        
        %%% Analytically linearized States Space Matrices (as Functions
        %%% A_func(x,u,theta), B_func(x,u,theta), C_func(x,u,theta), D_func(x,u,theta);
        A_func
        B_func
        C_func
        D_func
               
        % Analytically linearized State space Matrices as symbolic
        % expressions
        A_sym
        B_sym
        C_sym
        D_sym
        
        %%% Analytical nonlinear FIM functions as symbolic expressions
        f_theta
        g_theta
        
        %%% Analytical nonlinear FIM functions as functions
        f_theta_i
        g_theta_i
        
        % State Vector, Inputs and Parameters as symbolic expressions
        x_sym
        u_sym
        theta_sym
        
        %%% Additional Properties for Model Parameterization from Data
        identData 
        freeParamsForOptIdx
        penalizeInstability = 0; % Set to 1 if instable systems are to be penalized in optimization
        weightOnStatError = 0.5; % If 0: weight only dynamic error considered, If 1: only static error considered, use to tune the weighting of static vs dynamic error
        paramOptBase = 'lin';
        SS_Mat_Derivs
        x_normFac
        y_normFac
        ErrorFilt
        regularizationFlag = 'off';
        regularizationWeight = 0;
        
        %%% Additional Properties
        dependencyFolders
    end
    
    methods
        
        
        function obj = nonlinearModel(varargin)
            % CONSTRUCTER: Process name value pairs as to set
            % obj.(name) = value
            if (nargin > 0)
                n_props = length(varargin)/2; % number of properties to set
                names_props     = varargin(1:2:end-1); % cell of prop.names
                values_props    = varargin(2:2:end);   % cell of values
                
                if (rem(n_props,1)==0) % even # of args?
                    for idx = 1:n_props
                        obj.(names_props{idx}) = values_props{idx}; % assign
                    end
                else
                    error('nonlinearModel:Constructor','Constructor Name/Value pairs not even');
                end

                
                %add the folders with additional model dependencies to the
                %search path:
                if ~isempty(obj.dependencyFolders)
                    n_folders = length(obj.dependencyFolders);
                    for idx = 1:n_folders
                        addpath(obj.dependencyFolders{idx});
                    end
                end
                
                %%% Set Some Additional (Runtime Dependent) Default Values
                
                if isempty(obj.x_normFac)
                    obj.x_normFac = ones(1,obj.nrOfStates);
                end
                if isempty(obj.y_normFac)
                    obj.y_normFac = ones(1,obj.nrOfOutputs);
                end
                
                if isempty(obj.freeParamsForOptIdx)     
                    %In General: All parameters free for Optimization if not
                    %specified otherwise
                    obj.freeParamsForOptIdx = 1:length(obj.theta);
                end
                
            end
            
        end
        
        % Nonlinear Simulation of specified model via MATLAB ode solvers
        [y_vec,x_vec,t_vec] = nonlinearSimulation(obj,x_initial,u,thetaSpecific,t_vec)
        
        % Interpolation of time-dependent input signals for the nonlinear
        % simulation
        x_dot = interpDerivativeFunction(obj,t,x,u,theta_specific,t_vec);
        
        %Solution for steady stat
        [x0,t_v,x_vec] = solveForSteadyState(obj,x_initGuess,u0,thetaSpecific)
        
        
        %%%% Methods for Identification
        
        % Preprocessing
        analyticLinearization(obj);
        preProcessingSSDerivatives(obj)
        createIdentDataStruct(obj,nrOfExperiments);
        % FIM
        [FIM,d_y_d_theta,d_x_d_theta] = calcFIMLinearized(obj,x0,u0,u,theta_specific,dt)
        [FIM,d_y_d_theta] = calcFIMNumeric(obj,x0,u,thetaSpecific,t_vec)
        [FIM, d_y_d_theta, d_x_d_theta] = calcFIMNonlinear(obj, x0, u_num, theta_specific, t_vec)
        [d_expm_d_thetan] = expMatPartialDiff(obj,A,A_diff_thetan,dt)  
        [orderedAbsParamIdx] = analyzeParamSignificance(obj,FIM)
        
        % Optimization
        [LinSys,A,B,C,D] = getLinSys(obj,x0,u0,theta_specific);
        J = objFuncOptimzation(obj,thetaSubsetForOptRel,plotflag)
        thetaOpt = paramOptimization(obj,method,plotflag)

        
        createTestcaseData(obj, model);
        checkTestcaseModel(obj, model);
        checkToolbox(obj, model);
        CI = getCI(obj, theta_hat, FIM, n, gamma);
        
        
            
    end
end

