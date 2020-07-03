clear all;
clc;

%%% This MATLAB script shows a minimum working example on how to use the
%%% local linear structured state-space identification Toolbox. The following
%%% nonlinear SISO system is considered:
%%%                   x_dot = -theta_1 x^2 - theta_2 x + u
%%%                       y = x


%% Create nonlinear ODE Model
test_func = @(x,u,theta,z) -theta(1)*x^2 - theta(2)*x + u;
output_func = @(x,u,theta) x;


SimpleOdeModel = nonlinearModel('derivativeFunction',test_func,...
                      'outputFunction',output_func,...
                      'theta',[5;1],...
                      'simTol',1e-7,...
                      'statSolMethod','sol',... 
                      'nrOfInputs',1,...
                      'nrOfOutputs',1,...
                      'nrOfStates',1,...
                      'freeParamsForOptIdx',[1 2],...
                      'theta_labels', {'p1','p2'});

                  
%% Define an Input Signal
dt = 0.01;          % Sampling Time
x0_initGuess = 1.5; % Guess of initial state vector: Used as initial point to solve for steady state                  
u0 = 1;

t_vec = [0 : dt :5];
u = u0*ones(size(t_vec));
u(:,1) = u0;
u(100:end) = 3;
u(200:end) = 5;
u(300:end) = 7;
u(400:end) = 9;

%% Solve for steady state and Simulate non-linear System

[x0,~,x0_vec] = SimpleOdeModel.solveForSteadyState(x0_initGuess,u0,SimpleOdeModel.theta);
y0 = SimpleOdeModel.outputFunction(x0,u0,SimpleOdeModel.theta);


SimpleOdeModel.ODESol = 'ode15s';   %choose a specific ODE Solver
[y_vec,x_vec,t_vec] = SimpleOdeModel.nonlinearSimulation(x0,u,SimpleOdeModel.theta,t_vec);

plot(t_vec,y_vec,'DisplayName','nonlinear');
hold on
legend;
xlabel('Time in s');
ylabel('Output in ?');


%% Get linearized system and linear simulation

linSys = SimpleOdeModel.getLinSys(x0,u0,SimpleOdeModel.theta);
y_vec_lin = lsim(linSys,u-u0,t_vec); % Reference input around operating point for linear simulation

plot(t_vec,y_vec_lin+y0,'DisplayName','linear');
hold off;

%% Calculate FIM on the linearized model around operating point

FIM = SimpleOdeModel.calcFIMLinearized(x0,u0,u,SimpleOdeModel.theta,dt); 
% SimpleOdeModel.analyzeParamSignificance(FIM);

%% Nonlinear Test Optimization: "Forget" theta and reestimate theta from data
%  The nonlinear model is parameterized to the global experiment.

SimpleOdeModel.theta = [10;3]; % "Wrong parameters" for the start of the optimization
SimpleOdeModel.createIdentDataStruct(1)

%%% Load Data into Framework
n_set = 1;
SimpleOdeModel.identData(n_set).dataDomain = 'nonlinear';
SimpleOdeModel.identData(n_set).timeDomain = 'transient';
SimpleOdeModel.identData(n_set).inputData = u;
SimpleOdeModel.identData(n_set).outputData = y_vec;
SimpleOdeModel.identData(n_set).timeVec = t_vec;
SimpleOdeModel.identData(n_set).dt = dt;
SimpleOdeModel.identData(n_set).u0 = u(:,1);
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

options = optimset(method);
options.Display = 'iter';
options.PlotFcns = {@optimplotfval,@optimplotx};
options.TolX = 1e-4;
options.TolFun = 1e-9;

SimpleOdeModel.OPTOpt = options;

%%% Start Optimization
thetaOpt_nonlin = SimpleOdeModel.paramOptimization(method,'on');


%% Simulate Multiple Local Experiments

SimpleOdeModel.theta = [5;1]; % Reinstate original parameters for Simulation

% Generating experiments at operating points
u0_vec = [1 3 6 9]; % operating points defined by steady state input (Nr of Experiments = length of this vector)

% Create the Data Structure to hold the local experiments
SimpleOdeModel.createIdentDataStruct(length(u0_vec)); 



for nExp = 1:length(u0_vec)

%Define Input Signal (Hardcoded Step Sequence)    
t_vec = [0 : dt :5];
u_mult{nExp} = u0_vec(nExp)*ones(size(t_vec));
u_mult{nExp}(50:end) = u0_vec(nExp)*1.05;
u_mult{nExp}(100:end) = u0_vec(nExp)*0.9;
u_mult{nExp}(200:end) = u0_vec(nExp)*1.0;
u_mult{nExp}(220:end) = u0_vec(nExp)*0.95;
u_mult{nExp}(280:end) = u0_vec(nExp)*1.1;
u_mult{nExp}(3500:end) = u0_vec(nExp)*1.05;
u_mult{nExp}(400:end) = u0_vec(nExp)*0.94;
u_mult{nExp}(420:end) = u0_vec(nExp)*0.87;
u_mult{nExp}(480:end) = u0_vec(nExp)*1;


% Simulate the Outputs
[x0,~,x0_vec] = SimpleOdeModel.solveForSteadyState(x0_initGuess,u0_vec(nExp),SimpleOdeModel.theta);
y0 = SimpleOdeModel.outputFunction(x0,u0,SimpleOdeModel.theta);

% Chose a Specific ODE Solver
SimpleOdeModel.ODESol = 'ode15s';
[y_vec,x_vec,t_vec] = SimpleOdeModel.nonlinearSimulation(x0,u_mult{nExp},SimpleOdeModel.theta,t_vec);

y_mult{nExp} = y_vec;


% Load Data into Structure
SimpleOdeModel.identData(nExp).dataDomain = 'linear'; % By Setting the dataDomain to linear, a local linear state space model (defined by u0) will be used in the estimatino for this dataset.
SimpleOdeModel.identData(nExp).timeDomain = 'transient';
SimpleOdeModel.identData(nExp).inputData = u_mult{nExp};
SimpleOdeModel.identData(nExp).outputData = y_mult{nExp};
SimpleOdeModel.identData(nExp).timeVec = t_vec;
SimpleOdeModel.identData(nExp).dt = dt;
SimpleOdeModel.identData(nExp).u0 = u_mult{nExp}(:,1);
SimpleOdeModel.identData(nExp).x0_initGuess = x0_initGuess;
SimpleOdeModel.identData(nExp).weight = 10000;


end

%% Multiple Local Linear Structured State Space Test Optimization
%  The nonlinear model is parameterized via multiple local linear structured state space models.


SimpleOdeModel.theta = [10;3]; % "Wrong parameters" for the start of the optimization

%%% Toolbox Settings
SimpleOdeModel.simTol = 1e-4;
SimpleOdeModel.paramOptBase = 'lin';
SimpleOdeModel.simTimeOut = -1;
% SimpleOdeModel.penalizeInstability = 0;
% SimpleOdeModel.weightOnStatError = 0.5;
% SimpleOdeModel.regularizationFlag = 'off';
% SimpleOdeModel.regularizationWeight = 0;

%%% Optimization Solver Settings
method = 'fmincon';

options = optimset(method);
options.Display = 'iter';
options.PlotFcns = {@optimplotfval,@optimplotx};
options.TolX = 1e-4;
options.TolFun = 1e-12;

SimpleOdeModel.OPTOpt = options;

%%% Start Optimization
thetaOpt_lin = SimpleOdeModel.paramOptimization(method,'on');


%% Run model in Simulink
% There exists a Simulink API to run the model in Simulink. Check the
% following implementation:

u_SIM = [t_vec' u'];

TestSIMapi
