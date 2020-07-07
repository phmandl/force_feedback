function J = objFuncOptimization(obj,thetaSubsetForOptRel,plotflag)

%%% Create Specific Parameter Vector
thetaSpecific = obj.theta;


thetaSubsetForOptNormalValues = thetaSpecific(obj.freeParamsForOptIdx);

if strcmp(obj.paramOptBase,'log')
    thetaSpecific(obj.freeParamsForOptIdx) = thetaSubsetForOptNormalValues .* 10.^(thetaSubsetForOptRel');
    thetaInit = zeros(size(thetaSubsetForOptRel));
else
    thetaSpecific(obj.freeParamsForOptIdx) = thetaSubsetForOptNormalValues .* thetaSubsetForOptRel';
    thetaInit = ones(size(thetaSubsetForOptRel));
end

nDataSets = length(obj.identData);
J = 0;

try

for setNum = 1 : nDataSets
    
    currDataSet = obj.identData(setNum);
    
%     keyboard;
    if strcmp(currDataSet.dataDomain,'linear') && strcmp(currDataSet.timeDomain,'transient')
        
        u0 = currDataSet.u0;
        u = currDataSet.inputData;
        y = currDataSet.outputData;
        x0_initGuess = currDataSet.x0_initGuess;
        t_vec = currDataSet.timeVec;
        
        %%% Calculate Steady State w. respect to current parameter vector        
        [x0,~,x0_vec] = obj.solveForSteadyState(x0_initGuess,u0,thetaSpecific);
        y0 = obj.outputFunction(x0,u0,thetaSpecific);
        
        [linSys] = obj.getLinSys(x0,u0,thetaSpecific);
        
        %%% Penalize Instable Linear Systems if Defined
        stableFlag = max(eig(linSys)) <= 0;
        
        if stableFlag == 0 && obj.penalizeInstability == 1
            stabilityPenalty = 1e50;
        else
            stabilityPenalty = 0;
        end
                
        %%% Lineare Simulation
        [y_lin,~,x_lin] = lsim(linSys,(u-u0)',t_vec-t_vec(1));
        
        %%% NaN and Imag Penalty (PEMFC specific requirement)
        imagAndNaNPenalty = 0;
        
        if sum(sum(imag(y_lin))) > 0 || sum(sum(isnan(y_lin)))> 0
            imagAndNaNPenalty = 1e50;
        end
        
        %%% Form Objective Value
        Yn = diag(obj.y_normFac);
        %Overall Error with steady State
        %OutputError = Yn\(y_lin'+y0 - y)/length(y_lin);
        
        
        %Separate Static from Dynamic Error
        %y0_empiric = mean(y')';
        y0_empiric = y(:,1);

        
        DynOutputError = Yn\(y_lin'-(y-y0_empiric));
        StatOutputError = Yn\(y0-y0_empiric);
        OutputError = ((1-obj.weightOnStatError)*DynOutputError + (obj.weightOnStatError)*StatOutputError)/length(y);
        
        if ~isempty(obj.ErrorFilt)
            OutputError = filter(obj.ErrorFilt.B,obj.ErrorFilt.A,OutputError,[],2);
%             OutputError = filtfilt(obj.ErrorFilt.B,obj.ErrorFilt.A,OutputError')';
        end
        
        QuadrError = trace(OutputError*OutputError');
        
        
        
        
        J_current = QuadrError + stabilityPenalty + imagAndNaNPenalty;
%         display(['Quadr Error:', num2str(sqrt(QuadrError)),' Regularization:',num2str(Regularization)]);
        
        %%% PLOT VALUES
        if strcmp(plotflag,'on')
        for k = 1:obj.nrOfOutputs
            figure(99)
            subplot(obj.nrOfOutputs+1,nDataSets,k+(k-1)*(nDataSets-1)+(setNum-1));
            plot(y(k,:));
            hold on;
            plot(y_lin(:,k)+y0(k));
            ylim([min(y(k,:))-(mean(y(k,:))-min(y(k,:))) max(y(k,:))+(max(y(k,:))-mean(y(k,:)))]);
            hold off;
        end
        subplot(obj.nrOfOutputs+1,nDataSets,k+1+k*(nDataSets-1)+(setNum-1))
        plot((OutputError.^2)');
        end
        
    elseif strcmp(currDataSet.dataDomain,'nonlinear') && strcmp(currDataSet.timeDomain,'transient')
        
%         u0 = currDataSet.u0;
        u = currDataSet.inputData;
        u0 = currDataSet.u0;
        y = currDataSet.outputData;
        x0_initGuess = currDataSet.x0_initGuess;
        t_vec = currDataSet.timeVec;
        
        %%% Calculate Steady State w. respect to current parameter vector
        [x0,~,~] = obj.solveForSteadyState(x0_initGuess,u0,thetaSpecific);
        
        %%% Nonlinear Simulation
        [y_nonlin,x_nonlin] = obj.nonlinearSimulation(x0,u,thetaSpecific,t_vec);

        %%% Form Quadratic Output Error
        Yn = diag(obj.y_normFac);
        
        OutputError = Yn\(y_nonlin - y)/length(y_nonlin);

        if ~isempty(obj.ErrorFilt)
            OutputError = filter(obj.ErrorFilt.B,obj.ErrorFilt.A,OutputError,[],2);
        end
        
        QuadrError = trace(OutputError*OutputError');
        
        
        %%% Stability penalty (currently not supported for non-linear model)
        stabilityPenalty = 0;
        
        %%% NaN and Imag Penalty (PEMFC specific requirement)
        imagAndNaNPenalty = 0;
        

        if sum(sum(imag(y_nonlin))) > 0 || sum(sum(isnan(y_nonlin)))> 0
            imagAndNaNPenalty = 1e99;
        end

        J_current = QuadrError + stabilityPenalty + imagAndNaNPenalty;
        
        %%% PLOT VALUES
        if strcmp(plotflag,'on')
        for k = 1:obj.nrOfOutputs
            figure(99)
            subplot(obj.nrOfOutputs+1,nDataSets,k+(k-1)*(nDataSets-1)+(setNum-1));
            plot(y(k,:));
            hold on;
            plot(y_nonlin(k,:));
            hold off;
        end
        subplot(obj.nrOfOutputs+1,nDataSets,k+1+k*(nDataSets-1)+(setNum-1))
        plot((OutputError.^2)');
       
        end
        
    elseif strcmp(currDataSet.dataDomain,'linear') && strcmp(currDataSet.timeDomain,'static')
        
        
        % -- (Poke) Do Something -- %
        
        
    elseif strcmp(currDataSet.dataDomain,'nonlinear') && strcmp(currDataSet.timeDomain,'static')
        
        
        % -- (Poke) Do Something -- %
        
        
    else
        error('objFuncOptimization: dataDomain and / or timeDomain not specified and / or not correct')
    end
    
    
        
    J = J + currDataSet.weight*J_current;


    
    
    %%% Graphical Feedback During Optimization 
    
    
    
end


if strcmp(obj.regularizationFlag,'on')

    %%% NOTE: FIM based regularization is not working particularely well...
    %             FIM = obj.calcFIM(currDataSet.x0_initGuess,currDataSet.u0,currDataSet.inputData,thetaSpecific,currDataSet.dt);
    %             unscaledParamCov = diag(inv(FIM));
    
    if isscalar(obj.regularizationWeight)
    weightMatParams = obj.regularizationWeight*diag(ones(size(thetaSubsetForOptRel)));
    elseif length(obj.regularizationWeight) == length(thetaSubsetForOptRel)
    weightMatParams = diag(obj.regularizationWeight);
    else
        error('Regularization weighting mismatch: Only scalar or Vector with size of theta supported')
    end
    
    Regularization = (thetaSubsetForOptRel-thetaInit)* weightMatParams*(thetaSubsetForOptRel-thetaInit)';
else
    Regularization = 0;
end

if strcmp(plotflag,'on')
    sgtitle(['SSE: ',num2str(J),' Regularization: ',num2str(Regularization)]);
end

J = J+ Regularization;

catch
    J = 1e99;
end

end

