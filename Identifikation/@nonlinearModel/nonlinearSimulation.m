function [y_vec,x_vec,t_vec] = nonlinearSimulation(obj,x_initial,u,thetaSpecific,t_vec)
%nonlinearSimulation: Nonlinear Simulation of specified
% model using matlabs internal solvers

if isempty(obj.ODEOpt)
    options = odeset('RelTol',obj.simTol,'AbsTol',obj.simTol,'stats','off');
else
    options = obj.ODEOpt;
end
% Simulate ODEs
simFunc = @(t,x) obj.interpDerivativeFunction(t,x,u,thetaSpecific,t_vec);


if obj.simTimeOut == -1
    eval(['[~,x_vec] = ',obj.ODESol,'(simFunc,t_vec,x_initial,options);']);
else
    % Currently only the ODE15s available for force time out
    [~,x_vec] = ode15sTimeOut(simFunc,t_vec,x_initial,options,obj.simTimeOut);
end


x_vec=x_vec';

y_vec=nan(obj.nrOfOutputs,size(x_vec,2));

% Evaluate Output Equation

for k = 1:size(x_vec,2)
    y_vec(:,k) = obj.outputFunction(x_vec(:,k),u(:,k),thetaSpecific);
end

end