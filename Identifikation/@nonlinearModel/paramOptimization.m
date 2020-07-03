function thetaOpt = paramOptimization(obj,method,plotflag)


%%% Objective Function for Otimization
optFun = @(thetaParamsRel) obj.objFuncOptimization(thetaParamsRel,plotflag);
nrOfFreeParams = length(obj.freeParamsForOptIdx);

if strcmp(obj.paramOptBase,'log')
    thetaParamsRelInit = zeros(1,nrOfFreeParams);
else
    thetaParamsRelInit = ones(1,nrOfFreeParams);
end

if ~isempty(obj.OPTOpt)
    options = obj.OPTOpt;
end

%%% Select Solver
if strcmp(method,'ga')
        
    %   Disable warnings in parallelpool:  pctRunOnAll warning off
    p = gcp('nocreate');
    if isempty(p)
        parpool;
        pctRunOnAll warning off
    end
    
    if isempty(obj.OPTOpt)
        %Use some Standard options
        options = optimoptions(method);
        options.Display = 'iter';
        options.PlotFcns = @gaplotbestf;
        options.UseParallel = true;
        options.PopulationSize = 100;
        options.MaxGenerations = Inf;
        %     options.TolX = 1e-7;
        options.FunctionTolerance = 1e-8;
        
        if strcmp(obj.paramOptBase,'log')
            options.InitialPopulationRange=[-0.5*ones(1,nrOfFreeParams);0.5*ones(1,nrOfFreeParams);];
        else
            options.InitialPopulationRange=[0.5*ones(1,nrOfFreeParams);1.5*ones(1,nrOfFreeParams);];
        end
    end
    

    
    thetaParamsOptRel = ga(optFun,nrOfFreeParams,options);
    
    
elseif strcmp(method,'fmincon')
    if isempty(obj.OPTOpt)
        %Use some Standard options
        options = optimset(method);
        options.Display = 'iter';
        %     options.Algorithm = 'sqp';
        %     options.Algorithm = 'active-set';
        %     options.UseParallel = 1;
        options.TolX = 1e-12;
        options.TolFun = 1e-12;
        options.StepTolerance = 1e-12;
        %     options.DiffMaxChange = 1e-5;
            options.FiniteDifferenceType = 'central';
        options.PlotFcns = {@optimplotfval,@optimplotx};
    end
    
    thetaParamsOptRel = fmincon(optFun,thetaParamsRelInit,[],[],[],[],[],[],[],options);  
    
elseif strcmp(method,'fsolve')
    if isempty(obj.OPTOpt)
        %Use some Standard options
        options = optimset(method);
        options.Display = 'iter';
        options.Algorithm = 'levenberg-marquardt';
        options.PlotFcns = {@optimplotfval,@optimplotx};
        options.TolX = 1e-12;
        options.TolFun = 1e-12;
    end
    thetaParamsOptRel = fsolve(optFun,thetaParamsRelInit,options);

elseif strcmp(method,'fminsearch')
    if isempty(obj.OPTOpt)
        %Use some Standard options
        options = optimset(method);
        options.Display = 'iter';
        options.PlotFcns = {@optimplotfval,@optimplotx};
        options.TolX = 1e-12;
        options.TolFun = 1e-12;
    end
    thetaParamsOptRel = fminsearch(optFun,thetaParamsRelInit,options);

elseif strcmp(method,'fminunc')
    
    if isempty(obj.OPTOpt)
        %Use some Standard options
        options = optimoptions(method);
        options.Display = 'iter';
        options.PlotFcns = {@optimplotfval,@optimplotx};
        options.OptimalityTolerance = 1e-10;
        options.MaxIterations = 5000;
        options.MaxFunctionEvaluations = 1e8;
    end
    thetaParamsOptRel = fminunc(optFun,thetaParamsRelInit,options);
    
else
    error('Optimization method not specified / supported');
end

thetaOpt = obj.theta;
if strcmp(obj.paramOptBase,'log')
    if(size(thetaParamsOptRel,2))==1
        thetaParamsOptRel = thetaParamsOptRel';
    end
    thetaOpt(obj.freeParamsForOptIdx) = thetaOpt(obj.freeParamsForOptIdx) .* 10.^(thetaParamsOptRel');
else

    if(size(thetaParamsOptRel,2))==1
        thetaParamsOptRel = thetaParamsOptRel';
    end
    thetaOpt(obj.freeParamsForOptIdx) = thetaOpt(obj.freeParamsForOptIdx) .*thetaParamsOptRel';
end




% options = optimoptions('particleswarm');
% options.Display='iter';
% options.PlotFcn = 'pswplotbestf';
% options.HybridFcn='fminsearch';
% options.InitialSwarmMatrix = ones(100,NrThetaOpt);
% options.UseParallel = true;
% [x,fval,exitflag,output] = particleswarm(optFun,NrThetaOpt,[],[],options);








end

