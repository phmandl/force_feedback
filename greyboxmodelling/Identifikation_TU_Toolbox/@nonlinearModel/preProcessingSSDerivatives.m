function  preProcessingSSDerivatives(obj)
%Symbolic Differentiation of State Space Matrices A_sym,B_sym, C_sym,
%D_sym, theta
% keyboard;


%%% Check for Prerequisites
if isempty(obj.freeParamsForOptIdx)
    error('PreProcessingSSDerivatives\freeParamsForOptIdx: Indices of parameters to be optmized is not set')
elseif isempty(obj.A_func) || isempty(obj.B_func) || isempty(obj.C_func) || isempty(obj.D_func)
    disp('Analytic state space matrices not found: Starting preprocessing');
    obj.analyticLinearization();
end

%%% Unload Symbolic Expressions from Object
x_sym = obj.x_sym;
u_sym = obj.u_sym;
theta_sym = obj.theta_sym;

A_sym = obj.A_sym;
B_sym = obj.B_sym;
C_sym = obj.C_sym;
D_sym = obj.D_sym;

disp('Preprocessing Symbolic Parametric Partial Derivatives of SS-Matrices...');

nc = 1;
for n = obj.freeParamsForOptIdx
    
    A_diff_sym=diff(A_sym,theta_sym(n));
    B_diff_sym=diff(B_sym,theta_sym(n));
    C_diff_sym=diff(C_sym,theta_sym(n));
    D_diff_sym=diff(D_sym,theta_sym(n));
%     M_diff_sym=diff(M_sym,theta_sym(n));
    
    % Convert to functions
    
    SS_Mat_Derivs.A_diff_func{n}=matlabFunction(A_diff_sym,'Vars',{x_sym,u_sym,theta_sym});
    SS_Mat_Derivs.B_diff_func{n}=matlabFunction(B_diff_sym,'Vars',{x_sym,u_sym,theta_sym});
    SS_Mat_Derivs.C_diff_func{n}=matlabFunction(C_diff_sym,'Vars',{x_sym,u_sym,theta_sym});
    SS_Mat_Derivs.D_diff_func{n}=matlabFunction(D_diff_sym,'Vars',{x_sym,u_sym,theta_sym});
%     Mat_Funcs.M_diff_func{n}=matlabFunction(M_diff_sym,'Vars',{x_sym,u_sym,theta_sym});
    disp(['Param: ',num2str(nc),' of ',num2str(length(obj.freeParamsForOptIdx))])
    
    nc = nc+1;
end

SS_Mat_Derivs.N_states=length(A_sym);
SS_Mat_Derivs.N_inputs=size(B_sym,2);
SS_Mat_Derivs.N_outputs=size(C_sym,1);

%%% Save Preprocessed Derivatives on Object
obj.SS_Mat_Derivs = SS_Mat_Derivs;
disp('Preprocessing Parametric Sensitivity Dependencies... Finished!');
fprintf('\n');
end

