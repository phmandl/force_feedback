function [x0,t_v,x_vec] = solveForSteadyState(obj,x_initGuess,u0,thetaSpecific)
%Function Inputs: x_init,u0,theta,method


% Solution for steady state for a STABLE SYSTEM obtained by either numerical
% transient simulation for constant inputs (provided the system is STABLE)
% or by solving numerically for f(x,u,theta) = 0

% Inspired by the analysis of the PEMFC model, where
% solving 0 = f(x,u,theta) requires significant computational effort and
% often fails
%
% In the case were no steady state solution for the start of the
% optimization is desired (i.e. x0 is explicitely known) use the statSolMethode 'none' 




if strcmp(obj.statSolMethod,'sim')
    %
    dt = 1e-1;
    u = repmat(u0,1,obj.statSolSimEndtime*1/dt);
    t_v = [0:length(u)-1]*dt;
    
    [~,x_vec,~] = obj.nonlinearSimulation(x_initGuess,u,thetaSpecific,t_v);
        
    x0 = x_vec(:,end);

elseif strcmp(obj.statSolMethod,'sol')
    statFunc = @(x)  obj.derivativeFunction(x.*x_initGuess,u0,thetaSpecific);
    foptions = optimoptions('fsolve');
    foptions.OptimalityTolerance = 1e-10;
    foptions.StepTolerance = 1e-9;
    foptions.MaxFunctionEvaluations = 1e6;
    foptions.MaxIterations = 1e5;
    foptions.Display = 'off';
    x0 = fsolve(statFunc,ones(size(x_initGuess)),foptions);
    x0 = x0.*x_initGuess;
    t_v = [];
    x_vec =[];
    
elseif strcmp(obj.statSolMethod,'none')
    x0 = x_initGuess;
    t_v =[];
    x_vec = [];
end

% Numerically Check if Steady State is plausible
x0_dot = obj.derivativeFunction(x0,u0,thetaSpecific);
conv_crit = norm(x0_dot);
if conv_crit >= 1e-5
    warning('solveForSteadyState: Steady state possibly not reached');
end


end

