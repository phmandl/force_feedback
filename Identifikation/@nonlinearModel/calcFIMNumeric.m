function [FIM,d_y_d_theta] = calcFIMNumeric(obj,x0,u,thetaSpecific,t_vec)

FreeParamsForOptIdx = obj.freeParamsForOptIdx;
nrOfParams = length(FreeParamsForOptIdx);
N = length(t_vec);


d_y_d_theta=zeros(obj.nrOfOutputs,nrOfParams,N);
FIM = zeros(nrOfParams,nrOfParams);

Yn = diag(obj.y_normFac); 


y_nom = obj.nonlinearSimulation(x0,u,thetaSpecific,t_vec);


disp('Starting numeric calculation of FIM');
for p = 1:nrOfParams
    

    currParamIdx = FreeParamsForOptIdx(p);
    
    delta_theta_rel = 1e-5;
    delta_theta_vec = zeros(size(thetaSpecific));
    
    delta_theta_vec(currParamIdx) = delta_theta_rel*thetaSpecific(currParamIdx);
    
    y_delta_theta = obj.nonlinearSimulation(x0,u,thetaSpecific + delta_theta_vec,t_vec);
    
    %%% simple Euler discretization / normalized with nominal theta value
    d_y_d_theta(:,p,:) = Yn \ (y_delta_theta - y_nom) / delta_theta_vec(currParamIdx) .*thetaSpecific(currParamIdx);
    disp(['Param: ',num2str(p),' of ',num2str(nrOfParams)])

end

for k = 2:N
   FIM=FIM+1/N*d_y_d_theta(:,:,k)'*d_y_d_theta(:,:,k);
end

disp('Numeric calculation of FIM ... Finished!');
end

