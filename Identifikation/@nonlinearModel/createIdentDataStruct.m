function createIdentDataStruct(obj,nrOfExperiments)
    %This function generates the required data structure for the subsequent
    %optimization considered cases: 
    %   data.dataDomain = 'linear' || 'nonlinear'
    %   data.timeDomain = 'transient' || 'static'
    SingleData.dataDomain = [];
    SingleData.timeDomain = [];
    SingleData.inputData =[];
    SingleData.outputData =[];
    SingleData.timeVec = [];
    SingleData.dt = [];
    SingleData.u0 = [];
    SingleData.x0_initGuess = [];
    SingleData.weight = 1;
    SingleData.description = [];
        

    identData = repelem(SingleData,nrOfExperiments);
    obj.identData = identData;
end
