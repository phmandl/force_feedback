clear; clc;

load('data_23_28_10_home_brewn.mat');

y = out.saveData.Data(1:end-1,1);
u = out.saveData.Data(1:end-1,2);
dt = 0.01;

z = iddata(y, u, dt, 'Name', 'FF-Motor');
z.InputName = 'Input';
z.InputUnit =  '-';
z.OutputName = {'Angular position'};
z.OutputUnit = {'-'};
z.Tstart = 0;
z.TimeUnit = 's';

FileName      = 'FF_wheel_m';       % File describing the model structure.
Order         = [1 1 2];           % Model orders [ny nu nx].
Parameters    = [0.2134; 2; 1];         % Initial parameters. Np = 2.
InitialStates = [y(1); 0];            % Initial initial states.
Ts            = 0;                 % Time-continuous system.
nlgr = idnlgrey(FileName, Order, Parameters, InitialStates, Ts, ...
                'Name', 'FF_wheel');
            
set(nlgr, 'InputName', 'Input', 'InputUnit', '-',               ...
          'OutputName', {'Angular position'}, ...
          'OutputUnit', {'-'},                         ...
          'TimeUnit', 's');
      
%       get(nlgr)

nlgr.SimulationOptions.AbsTol = 1e-6;
nlgr.SimulationOptions.RelTol = 1e-5;
nlgr.Parameters(1).Fixed = true;

compare(z, nlgr);

nlgr = setinit(nlgr, 'Fixed', {false false}); % Estimate the initial states.
opt = nlgreyestOptions('Display', 'on', 'SearchMethod', 'auto');
opt.SearchOptions.MaxIterations = 50;
nlgr = nlgreyest(z, nlgr, opt);


compare(z, nlgr);
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