function [linSys,A,B,C,D] = getLinSys(obj,x0,u0,theta_specific)
%%% This function returns the numerical state space matrices, 
%%% Required: A-priori analytic calculations (A_func,B_func,C_func,D_func)

if isempty(obj.A_func) || isempty(obj.B_func) || isempty(obj.C_func) || isempty(obj.D_func)
     obj.analyticLinearization();
end

A = obj.A_func(x0,u0,theta_specific);
B = obj.B_func(x0,u0,theta_specific);
C = obj.C_func(x0,u0,theta_specific);
D = obj.D_func(x0,u0,theta_specific);

linSys = ss(A,B,C,D);

end

