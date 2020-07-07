clear all;
clc;

%% Create nonlinear ODE Model
                      
test_func = @(x,u,theta) [x(2);
    1/theta(1)*(u + theta(2) - 2*theta(2)/(1 + exp(-theta(3)*x(2))))];
% test_func = @(x,u,theta) [x(2); 1/theta(1)*(u - theta(2)*x(2))];
output_func = @(x,u,theta) x(1);

SimpleOdeModel = nonlinearModel('derivativeFunction',test_func,...
                      'outputFunction',output_func,...
                      'theta',[0.21;1;5],...
                      'simTol',1e-15,...
                      'statSolMethod','sol',... 
                      'nrOfInputs',1,...
                      'nrOfOutputs',1,...
                      'nrOfStates',2,...
                      'freeParamsForOptIdx',[2,3],...
                      'theta_labels', {'a','b'});
                  
%% Get my saved data
load('data_23_28_10_home_brewn.mat');
t_vec = out.tout(1:end-1)';
y_vec = out.saveData.Data(1:end-1,1)';
u = out.saveData.Data(1:end-1,2)';

% figure(1);
% plot(t_vec,y_vec,'DisplayName','y_vec'); hold on;
% plot(t_vec,u,'DisplayName','u'); hold off;
% legend;

dt = t_vec(2) - t_vec(1);
% x0_initGuess = ones(SimpleOdeModel.nrOfStates,1);
x0_initGuess = [y_vec(1);0.01];
% x0_initGuess = [1;100];

%% Nonlinear Test Optimization: "Forget" theta and reestimate theta from data
%  The nonlinear model is parameterized to the global experiment.

SimpleOdeModel.theta = [0.21;1;5]; % "Wrong parameters" for the start of the optimization
SimpleOdeModel.createIdentDataStruct(1)

%%% Load Data into Framework
n_set = 1;
SimpleOdeModel.identData(n_set).dataDomain = 'nonlinear';
SimpleOdeModel.identData(n_set).timeDomain = 'transient';
SimpleOdeModel.identData(n_set).inputData = u;
SimpleOdeModel.identData(n_set).outputData = y_vec;
SimpleOdeModel.identData(n_set).timeVec = t_vec;
SimpleOdeModel.identData(n_set).dt = dt;
SimpleOdeModel.identData(n_set).u0 = u(1);
SimpleOdeModel.identData(n_set).x0_initGuess = x0_initGuess;
SimpleOdeModel.identData(n_set).weight = 10000;


%%% Toolbox Settings
SimpleOdeModel.simTol = 1e-4;
SimpleOdeModel.paramOptBase = 'lin';
% SimpleOdeModel.simTimeOut = -1;
% SimpleOdeModel.penalizeInstability = 0;
% SimpleOdeModel.weightOnStatError = 0.5;
% SimpleOdeModel.regularizationFlag = 'off';
% SimpleOdeModel.regularizationWeight = 0;

%%% Optimization Solver Settings
method = 'fminsearch';
% method = 'fmincon';

options = optimset(method);
options.Display = 'iter';
options.PlotFcns = {@optimplotfval,@optimplotx};
options.TolX = 1e-4;
options.TolFun = 1e-12;

SimpleOdeModel.OPTOpt = options;

%%% Start Optimization
thetaOpt_nonlin = SimpleOdeModel.paramOptimization(method,'on');

% %%
% SimpleOdeModel.theta = thetaOpt_nonlin;
% 
% [x0, ~, ~] = SimpleOdeModel.solveForSteadyState(x0_initGuess, u(1),...     % steady state states at operating point
%     SimpleOdeModel.theta);
% 
% [y_vec, ~, ~] = SimpleOdeModel.nonlinearSimulation(x0, u,...                 % nonlinear simulated output
%     SimpleOdeModel.theta, t_vec);
% 














