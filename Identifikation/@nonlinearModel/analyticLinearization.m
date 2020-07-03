function analyticLinearization(obj)
%Symbolic Linearization of the specified non-linear model
x_sym = sym('x_sym',[obj.nrOfStates,1]);
u_sym = sym('u_sym',[obj.nrOfInputs,1]);
theta_sym = sym('theta_sym',size(obj.theta));


disp('Starting Analytic Linearization ...');
for n = 1 : obj.nrOfStates
    A_sym(:,n) = diff(obj.derivativeFunction(x_sym,u_sym,theta_sym),x_sym(n));
end
obj.A_func = matlabFunction(A_sym,'Vars',{x_sym,u_sym,theta_sym});
disp('A Matrix finished');


for n = 1 : obj.nrOfInputs
    B_sym(:,n) = diff(obj.derivativeFunction(x_sym,u_sym,theta_sym),u_sym(n));
end
obj.B_func = matlabFunction(B_sym,'Vars',{x_sym,u_sym,theta_sym});
disp('B Matrix finished');


for n = 1 : obj.nrOfStates
    C_sym(:,n) = diff(obj.outputFunction(x_sym,u_sym,theta_sym),x_sym(n));
end
obj.C_func = matlabFunction(C_sym,'Vars',{x_sym,u_sym,theta_sym});
disp('C Matrix finished');


for n = 1 : obj.nrOfInputs
    D_sym(:,n) = diff(obj.outputFunction(x_sym,u_sym,theta_sym),u_sym(n));
end
obj.D_func = matlabFunction(D_sym,'Vars',{x_sym,u_sym,theta_sym});
disp('D Matrix finished');
disp('---- All Done ! ----');


%% Save Symbolic calculations in the model object
obj.x_sym = x_sym;
obj.u_sym = u_sym;
obj.theta_sym = theta_sym;

obj.A_sym = A_sym;
obj.B_sym = B_sym;
obj.C_sym = C_sym;
obj.D_sym = D_sym;

end