function x_kp1 = stateTransitionFnc(x_k,u)

dt = 1e-3;

x_kp1 = x_k + dt*specificNonlinearModel.derivativeFunction(x_k,u,theta);

end

