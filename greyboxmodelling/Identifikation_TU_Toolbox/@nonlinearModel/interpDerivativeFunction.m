function x_dot = interpDerivativeFunction(obj,t,x,u,theta_specific,t_vec)

u_k = interp1(t_vec,u',t);
x_dot = obj.derivativeFunction(x,u_k',theta_specific);   
% t
end