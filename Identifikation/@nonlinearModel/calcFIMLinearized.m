function [FIM,d_y_d_theta,d_x_d_theta] = calcFIMLinearized(obj,x0,u0,u,theta_specific,dt)
% This function calculates the (normalized) State space matrices.
% Normalization is done to the inputs, outputs and parameters.
% (CARFEUL IF A PARAMETER IS 0)

%%% Note: Required are the calculations of the parametric derivatives
%%% of the discrete system  matrices, e.g., the differentiation of the
%%% matrix exponential. The first variant (essentially the basis of the
%%% function expMatPartialDiff is taken from "A note on parameter
%%% differentiation of matrix exponentials, with applications to
%%% continuous-time modelling". However, it has been found to be
%%% numerically sensitive with respect to stiff systems (due to the
%%% required eigenvalue decomposition!). The Second variant to obtain
%%% the parametric differentiated discrete matrices is by the use of an
%%% augmented system matrix. The derivation thereof is found in
%%% "Maximum Likelihood Estimation of LTI Continuous-Time Grey-box
%%% Models". It is found to be less susceptible to numerical problems,
%%% additionally non regular system matrix (integrating behaviour!)
%%% works as well (it does not for the first variant)


%%% Check for Prerequisites
if isempty(obj.SS_Mat_Derivs)
    disp('State space derivatives not found: Starting preprocessing')
    obj.preProcessingSSDerivatives();
end

Sigma = obj.Sigma;

if isempty(Sigma) % check if covariance matrix is empty
    
    % assign identity matrix to covariance matrix
    Sigma = eye(obj.nrOfOutputs);
    
end

u_lin = u-u0; %Detrend excitation with steady state input vector

%Unloading of Object
SS_Mat_Derivs = obj.SS_Mat_Derivs;
FreeParamsForOptIdx = obj.freeParamsForOptIdx;


% Current Continuous Time Numeric State-Space Matrices
% Normalized due to numerical reasons / conditioning of inverse
% Output normalization influences the parametric sensitivity (as it is obvious
% e.g. during optimization)

if obj.FimNormFlag == 0
    
    Yn = eye(length(obj.y_normFac));
    
else
    
    Yn = diag(obj.y_normFac);
    
end

A=obj.A_func(x0,u0,theta_specific);
B=obj.B_func(x0,u0,theta_specific);
C=Yn\obj.C_func(x0,u0,theta_specific);
D=Yn\obj.D_func(x0,u0,theta_specific);



%%% KILL UNSTABLE EIGENMODES
[V,D] = eig(A);
D(D>0)=0;
A=V*D/V;



N=length(u_lin);
N_params=length(FreeParamsForOptIdx);
N_states=SS_Mat_Derivs.N_states;
N_outputs = size(C,1);

%Discretization
% Ak=expm(A*dt);
% Bk=A\(expm(A*dt)-eye(size(A)))*B;
ContMatrix = [A,B;zeros(obj.nrOfInputs,obj.nrOfStates+obj.nrOfInputs)];
matExpOfContMatrix = expm(ContMatrix*dt);
Ak = matExpOfContMatrix(1:obj.nrOfStates,1:obj.nrOfStates);
Bk = matExpOfContMatrix(1:obj.nrOfStates,obj.nrOfStates+1:obj.nrOfStates+obj.nrOfInputs);

%Building Partial derivative Matrices and Calculating
%Parameter sensitivity

d_y_d_theta=zeros(N_outputs,N_params,N);
y0 = obj.outputFunction(x0,u0,theta_specific);


FIM = zeros(N_params,N_params);

for p = 1:N_params
    d_A_d_theta=SS_Mat_Derivs.A_diff_func{FreeParamsForOptIdx(p)}(x0,u0,theta_specific);
    d_B_d_theta=SS_Mat_Derivs.B_diff_func{FreeParamsForOptIdx(p)}(x0,u0,theta_specific);
    d_C_d_theta=Yn\SS_Mat_Derivs.C_diff_func{FreeParamsForOptIdx(p)}(x0,u0,theta_specific);
    d_D_d_theta=Yn\SS_Mat_Derivs.D_diff_func{FreeParamsForOptIdx(p)}(x0,u0,theta_specific);
    
    
    %%% Discrete Matrix Parametric Differentiation, See: "Maximum
    %%% Likelihood Estimation of LTI Continuous-Time Grey-box Models, Jiri
    %%% Rehor"
    AugmentedMatrix = [A zeros(obj.nrOfStates,obj.nrOfStates) B;...
        d_A_d_theta A d_B_d_theta;...
        zeros(obj.nrOfInputs,2*obj.nrOfStates+obj.nrOfInputs)];
    matExpOfAugmentedMatrix = expm(AugmentedMatrix*dt);
    %     Ak_test = dAugmentedMatrix(1:obj.nrOfStates,1:obj.nrOfStates);
    %     Bk_test = dAugmentedMatrix(1:obj.nrOfStates,2*obj.nrOfStates+1:2*obj.nrOfStates+obj.nrOfInputs);
    d_Ak_d_theta = matExpOfAugmentedMatrix(obj.nrOfStates+1:2*obj.nrOfStates,1:obj.nrOfStates);
    d_Bk_d_theta = matExpOfAugmentedMatrix(obj.nrOfStates+1:2*obj.nrOfStates,2*obj.nrOfStates+1:2*obj.nrOfStates+obj.nrOfInputs);
    
    
    x_sim=zeros(N_states,N);
    d_x_d_theta=zeros(N_states,N);
    
    for k = 2:N
        
        %Calculate Shift in linear dynamic solution
        x_sim(:,k)=Ak*x_sim(:,k-1)+Bk*u_lin(:,k-1);
        d_x_d_theta(:,k)=d_Ak_d_theta*x_sim(:,k-1)+Ak*d_x_d_theta(:,k-1)+d_Bk_d_theta*u_lin(:,k-1);
        
        
        d_y_d_theta(:,p,k)=d_C_d_theta*x_sim(:,k)+C*d_x_d_theta(:,k)+d_D_d_theta*u_lin(:,k);
        
    end
    
    %calculate shift in steady state output
    delta_theta_rel = 1e-3;
    delta_theta_vec = zeros(size(theta_specific));
    delta_theta_vec(FreeParamsForOptIdx(p)) = delta_theta_rel*theta_specific(FreeParamsForOptIdx(p));
    
    
    [x0_delta_theta] = obj.solveForSteadyState(x0,u0,theta_specific+delta_theta_vec);
    y0_delta_theta = obj.outputFunction(x0_delta_theta,u0,theta_specific+delta_theta_vec);
    
    [x0_2delta_theta] = obj.solveForSteadyState(x0,u0,theta_specific+2*delta_theta_vec);
    y0_2delta_theta = obj.outputFunction(x0_2delta_theta,u0,theta_specific+2*delta_theta_vec);
    
    [x0_mdelta_theta] = obj.solveForSteadyState(x0,u0,theta_specific-delta_theta_vec);
    y0_mdelta_theta = obj.outputFunction(x0_mdelta_theta,u0,theta_specific-delta_theta_vec);
    
    [x0_2mdelta_theta] = obj.solveForSteadyState(x0,u0,theta_specific-2*delta_theta_vec);
    y0_2mdelta_theta = obj.outputFunction(x0_2mdelta_theta,u0,theta_specific-2*delta_theta_vec);
    
    % 4th order Order Central Approximation
    d_y0_d_theta = Yn \ (-1/12*y0_2delta_theta +2/3*y0_delta_theta - 2/3*y0_mdelta_theta + 1/12*y0_2mdelta_theta) / (delta_theta_vec(FreeParamsForOptIdx(p)));
    
    d_y_d_theta(:,p,:) = 2 * ( (1-obj.weightOnStatError)*d_y_d_theta(:,p,:) + obj.weightOnStatError*d_y0_d_theta );

    if obj.FimNormFlag == 1

        %NORMALIZATION WITH RESPECT TO NOMINAL PARAMETER VALUE: CARE FOR
        %ZERO
        d_y_d_theta(:,p,:) = d_y_d_theta(:,p,:) * theta_specific(FreeParamsForOptIdx(p));
        
    end

% keyboard;
end

for k = 2:N
    
    FIM = FIM + d_y_d_theta(:,:,k)' * (Sigma \ d_y_d_theta(:,:,k));
    
end


end

