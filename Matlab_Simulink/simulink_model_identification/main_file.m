clear; clc;
Ts = 0.005;

%% DO IDENTIFICATION
load('data.mat');

y = out.output.signals.values;
u = out.input.signals.values;
dt = Ts;

z = iddata(y, u, dt, 'Name', 'FF-Motor');
z.InputName = 'Input';
z.InputUnit =  '-';
z.OutputName = {'Angular position'};
z.OutputUnit = {'-'};
z.Tstart = 0;
z.TimeUnit = 's';

FileName      = 'FF_wheel_m';       % File describing the model structure.
Order         = [1 1 2];           % Model orders [ny nu nx].
% Parameters    = [0.1429; 0.389; 5; 1]; 
Parameters    = [0.1429; 0.389]; 
InitialStates = [y(1); 0];            % Initial initial states.
Ts            = 0;                 % Time-continuous system.
nlgr = idnlgrey(FileName, Order, Parameters, InitialStates, Ts, ...
                'Name', 'FF_wheel');
            
set(nlgr, 'InputName', 'Input', 'InputUnit', '-',               ...
          'OutputName', {'Angular position'}, ...
          'OutputUnit', {'-'},                         ...
          'TimeUnit', 's');

nlgr.SimulationOptions.AbsTol = 1e-6;
nlgr.SimulationOptions.RelTol = 1e-5;
% nlgr.Parameters(1).Fixed = true;
% nlgr.Parameters(2).Fixed = true;
% nlgr.Parameters(3).Fixed = true;

compare(z, nlgr);

% nlgr = setinit(nlgr, 'Fixed', {false false}); % Estimate the initial states.
% opt = nlgreyestOptions('Display', 'on', 'SearchMethod', 'auto');

opt = nlgreyestOptions;
opt.Display = 'on';
% opt.SearchMethod = 'lsqnonlin';
% opt.SearchOptions.Advanced.UseParallel = true;
opt.SearchOptions.MaxIterations = 50;
opt.Regularization.Lambda = 0; %No regularization


nlgr = nlgreyest(z, nlgr, opt);


% y_calc = sim(nlgr,z)

compare(z, nlgr)

% figure; 
% h1 = subplot(2,1,1)
% plot(diff(y)/dt)
% hold on;
% plot(diff(y_calc.y)/dt);
% hold off;
% 
% h2 = subplot(2,1,2)
% plot(z.u)
% linkaxes([h1,h2],'x');
% pe(z, nlgr);


% getpar(nlgr)
% 
% ans =
% 
%   3×1 cell array für 4ten datensatz
% 
%     {[0.2134]}
%     {[4.4721]}
%     {[     1]}

% getpar(nlgr)
% 
% ans =
% 
%   3×1 cell array für 5ten Datensatz
%     {[0.2096]}
%     {[0.7386]}
%     {[     1]}