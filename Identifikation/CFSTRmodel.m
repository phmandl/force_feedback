%{
creation date: 2020-02-17
created by: Zhang Peng DU
 
function reference:
Chen, Cheng-Liang & Wang, Tzxy-Chyi & Hsu, Shuo-Huan. (2002). An LMI
approach to H-infinity PI controller design. Journal of Chemical
Engineering of Japan - J CHEM ENG JPN. 35. 83-93. 10.1252/jcej.35.83.
%}
 
%% define parameters
 
C_Af    = 1;        % mol/l         feed concentration
T_f     = 350;      % K             feed temperature
T_cf    = 350;      % K             average coolant temperature
V       = 100;      % l             reactor volume
h_A     = 7e5;      % cal/(min K)   heat transfer coefficient
k_0     = 7.2e10;   % 1/min         reaction rate
E_R     = 10^4;     % K             activation energy term
Delta_H = -2e5;     % cal/mol       heat of reaction
rho     = 10^3;     % g/l           liquid density
rho_c   = 10^3;     % g/l           liquid density
C_p     = 1;        % cal/(g K)     specific heat
C_pc    = 1;        % cal/(g K)     specific heat
 
% additional parameters (not defined in reference)
 
sigm    = 5.67e-8;      % W/(m^2 K^4)   Stefan-Boltzmann constant
%                                       (Wikipedia)
m       = 0.37741*60;   % g/(min m)     dynamic viscosity of water
%                                       (Wikipedia) linear interpolated
D       = 2.8;          % m             pipe diameter (calculated by
%                                       by assuming laminar flow)
 
%% calculate parameters
 
% defined in reference
 
k_1 = -Delta_H * k_0 / ( rho * C_p );
k_2 = rho_c * C_pc / ( rho * C_p * V );
k_3 = h_A / ( rho_c * C_pc );
 
% not defined in reference
 
k_4 = 4 * m * D * pi / rho_c; % parameter for flow friction coefficient
%                               (laminar flow assumed)
%                               Fanning friction factor (Wikipedia)
%                               l/min

% parameter vector
theta = [V; C_Af; k_0; E_R; T_f; k_1; k_2; k_3; T_cf; sigm; k_4];
 
%% define function
 
%{
x = [C_A; T]
C_A mol/l   reactant concentration
T   K       reactor temperature
 
u = [f; f_c]
f   l/min   process flow rate
f_c l/min   coolant flow rate
 
theta = [V; C_Af; k_0; E_R; T_f; k_1; k_2; k_3; T_cf; sigm; k_4];
         1  2     3    4    5    6    7    8    9     10    11
11 parameters
 
y = [C_A; T; q_dot; f_F]
 
q_dot   W/m^2   heat flux density from reactor to surrounding
                (black wall assumed)
f_F     1       flow friction coefficient (laminar flow assumed)
 
original test_func without theta
test_func = @(x, u, theta) [...
    u(1) / V * ( C_Af - x(1) ) - k_0 * x(1) * exp( -E_R / x(2) );...
    u(1) / V * ( T_f - x(2) ) + k_1 * x(1) * exp( -E_R / x(2) ) +...
    k_2 * u(2) * ( 1 - exp( -k_3 / u(2) ) ) * ( T_cf - x(2) )];
 
original output_func without theta
output_func = @(x, u, theta) [...
    x(1);...
    x(2);...
    sigm * x(2)^4;...
    k_4 / u(2)];
%}
 
% f function
test_func = @(x, u, theta) [...
    u(1) / theta(1) * ( theta(2) - x(1) ) - theta(3) * x(1) *...
    exp( -theta(4) / x(2) );...
    u(1) / theta(1) * ( theta(5) - x(2) ) + theta(6) * x(1) *...
    exp( -theta(4) / x(2) ) + theta(7) * u(2) * ( 1 -...
    exp( -theta(8) / u(2) ) ) * ( theta(9) - x(2) )];
 
% g function
output_func = @(x, u, theta) [...
    x(1);...
    x(2);...
    theta(10) * x(2)^4;...
    theta(11) / u(2)];

%% initialize validation
 
CFSTR = nonlinearModel('derivativeFunction', test_func,...                  % f function
                      'outputFunction', output_func,...                     % g function
                      'theta', theta,...                                    % parameter values, could be numerical values
                      'simTol', 1e-15,...                                   % optional
                      'statSolMethod', 'sol',...                            % optional, alternative 'sim'
                      'nrOfInputs', 2,...                                   % number of inputs
                      'nrOfOutputs', 4,...                                  % number of outputs
                      'nrOfStates', 2,...                                   % number of states
                      'freeParamsForOptIdx', [2,7,10,11],...                % indices of parameter, which should be estimated [1:2,4:11], estimate 3 or 4, not both
                      'theta_labels', {'V', 'C_Af', 'k_0', 'E_R', 'T_f',...
                      'k_1', 'k_2', 'k_3', 'T_cf', 'sigm', 'k_4'});         % label of parameters
 
dt = 0.01;                                              % sampling time
x0_initGuess = ones(CFSTR.nrOfStates,1);                % not allowed to be zeros
t_vec = [0 : dt : 18];                                  % time vector
CFSTR.y_normFac = [0.96389; 353.55; 885.93; 0.007705];  % optional
n_set = 2;                                              % number of operating points or data sets
 
u0 = [100; 103.41];                         % nominal operating conditions, see reference
u = zeros(CFSTR.nrOfInputs, length(t_vec));	% initialize input vector

% creating input vector
u(1, :) = u0(1);	% operating point
u(2, :) = u0(2);	% operating point
u(1, 2:end) = u(1, 2:end) + u0(1)*repelem( (randn(1, 3) / 30),...   % some small movements around operating point
    ones(3, 1) * 600 );
u(2, 2:end) = u(2, 2:end) + u0(2)*repelem( (randn(1, 3) / 30),...   % some small movements around operating point
    ones(3, 1) * 600 );
 
[x0, ~, ~] = CFSTR.solveForSteadyState(x0_initGuess, u(:,1),...     % steady state states at operating point
    CFSTR.theta);
         
[y_vec, ~, ~] = CFSTR.nonlinearSimulation(x0, u,...                 % nonlinear simulated output
    CFSTR.theta, t_vec);

CFSTR.createIdentDataStruct(n_set);                                 % initialize empty struct array
rng(1);                                                             % initialize random number generator
 
for n = 1 : n_set
    
    % generate noisy data for estimation
    y_vec_noisy = y_vec + CFSTR.y_normFac .* randn(size(y_vec)) / 300;
    
    CFSTR.identData(n).dt = dt;                     % sampling time
    CFSTR.identData(n).timeVec = t_vec;             % time vector, t_vec = [t_1 : dt : t_end]
    CFSTR.identData(n).inputData = u;               % input vector, size (number of inputs, length(t_vec)), from real measurements or artificially generated
    CFSTR.identData(n).u0 = u(:,1);                 % initial input values, size (number of inputs, 1)
    CFSTR.identData(n).x0_initGuess = x0_initGuess; % first guess of states, size (number of states, 1), ATTENTION: zeros not allowed
    CFSTR.identData(n).outputData = y_vec_noisy;    % output vector, size (number of outputs, length(t_vec)), from real measurements or computation (see method nonlinearSimulation or analyticLinearization in combination with lsim)
    CFSTR.identData(n).dataDomain = 'linear';       % 'nonlinear' or 'linear' estimation
    CFSTR.identData(n).timeDomain = 'transient';    % 'transient' or 'static', ATTENTION: 'static' not implemented yet
    CFSTR.identData(n).weight = 1e8;                % weight of residuals of current data set

end
 
p = 0;
theta0 = CFSTR.theta; % create theta0 vector for estimation
 
for n = 1 : length(CFSTR.freeParamsForOptIdx)
     
    idx = CFSTR.freeParamsForOptIdx(n);
     
    theta0(idx) = theta0(idx) * (1 + (-1)^p * 0.01); % alternating deviation of +/- 1 %
    p = p + 1;
     
end

clear p n idx;

%% solve for steady state and run non-linear simulation

[x0, ~, ~] = CFSTR.solveForSteadyState(x0_initGuess, u0, CFSTR.theta);

y0 = CFSTR.outputFunction(x0, u0, CFSTR.theta);

[y_vec, ~, ~] = CFSTR.nonlinearSimulation(x0, u, CFSTR.theta, t_vec);

figure;
subplot(2, 3 , 1);
plot(t_vec, y_vec(1, :));
title('y_1: C_A');
hold on;
subplot(2, 3 , 2);
plot(t_vec, y_vec(2, :));
title('y_2: T');
hold on;
subplot(2, 3 , 4);
plot(t_vec, y_vec(3, :));
title('y_3: q dot');
hold on;
subplot(2, 3 , 5);
plot(t_vec, y_vec(4, :));
title('y_4: f_F');
hold on;
subplot(2, 3 , 3);
plot(t_vec, u(1, :));
title('u_1: f');
subplot(2, 3 , 6);
plot(t_vec, u(2, :));
title('u_2: f_c');

%% get linearized system and run linear simulation

[linSys, ~, ~, ~, ~] = CFSTR.getLinSys(x0, u0, CFSTR.theta);
y_vec_lin = lsim(linSys, u - u0, t_vec)' + y0;

subplot(2, 3 , 1);
plot(t_vec, y_vec_lin(1, :));
legend('nonlinear', 'linear');
hold off;
subplot(2, 3 , 2);
plot(t_vec, y_vec_lin(2, :));
legend('nonlinear', 'linear');
hold off;
subplot(2, 3 , 4);
plot(t_vec, y_vec_lin(3, :));
legend('nonlinear', 'linear');
hold off;
subplot(2, 3 , 5);
plot(t_vec, y_vec_lin(4, :));
legend('nonlinear', 'linear');
hold off;

%% Calculate FIM with linearized and non-linear algorithm

% define covariance matrix
CFSTR.Sigma = diag(CFSTR.y_normFac.^2 * 1/300^2);

[FIM_lin, ~, ~] = CFSTR.calcFIMLinearized(x0, u0, u, CFSTR.theta, dt);
[FIM_nonl, ~, ~] = CFSTR.calcFIMNonlinear(x0, u, CFSTR.theta, t_vec);

ParamSign = CFSTR.analyzeParamSignificance(FIM_nonl);

%% Test Optimization: "Forget" theta and reestimate theta from data

CFSTR.theta = theta0;

theta_hat = CFSTR.paramOptimization('fmincon', 'on');