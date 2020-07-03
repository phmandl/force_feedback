function EKFModelSimulinkAPI(block)
%MSFUNTMPL_BASIC A Template for a Level-2 MATLAB S-Function
%   The MATLAB S-function is written as a MATLAB function with the
%   same name as the S-function. Replace 'msfuntmpl_basic' with the 
%   name of your S-function.
%
%   It should be noted that the MATLAB S-function is very similar
%   to Level-2 C-Mex S-functions. You should be able to get more
%   information for each of the block methods by referring to the
%   documentation for C-Mex S-functions.
%
%   Copyright 2003-2010 The MathWorks, Inc.

%%
%% The setup method is used to set up the basic attributes of the
%% S-function such as ports, parameters, etc. Do not add any other
%% calls to the main body of the function.
%%
setup(block);

%endfunction

%% Function: setup ===================================================
%% Abstract:
%%   Set up the basic characteristics of the S-function block such as:
%%   - Input ports
%%   - Output ports
%%   - Dialog parameters
%%   - Options
%%
%%   Required         : Yes
%%   C-Mex counterpart: mdlInitializeSizes
%%
function setup(block)

% Register number of ports
block.NumInputPorts  = 2;
block.NumOutputPorts = 3;

specificNonlinearModel = block.DialogPrm(5).Data;

% Setup port properties to be inherited or dynamic
block.SetPreCompInpPortInfoToDynamic;
block.SetPreCompOutPortInfoToDynamic;

% Override input port properties
block.InputPort(1).Dimensions  = specificNonlinearModel.nrOfInputs;
block.InputPort(1).DatatypeID  = 0;  % double
block.InputPort(1).Complexity  = 'Real';
block.InputPort(1).DirectFeedthrough = true;
block.InputPort(1).SamplingMode = 'Sample';

block.InputPort(2).Dimensions        = specificNonlinearModel.nrOfOutputs;
block.InputPort(2).DatatypeID  = 0;  % double
block.InputPort(2).Complexity  = 'Real';
block.InputPort(2).DirectFeedthrough = true;
block.InputPort(2).SamplingMode = 'Sample';

% Override output port properties
block.OutputPort(1).Dimensions       = specificNonlinearModel.nrOfStates;
block.OutputPort(1).DatatypeID  = 0; % double
block.OutputPort(1).Complexity  = 'Real';
block.OutputPort(1).SamplingMode = 'Sample';

block.OutputPort(2).Dimensions       = specificNonlinearModel.nrOfOutputs;
block.OutputPort(2).DatatypeID  = 0; % double
block.OutputPort(2).Complexity  = 'Real';
block.OutputPort(2).SamplingMode = 'Sample';

block.OutputPort(3).Dimensions       = [specificNonlinearModel.nrOfStates specificNonlinearModel.nrOfStates];
block.OutputPort(3).DatatypeID  = 0; % double
block.OutputPort(3).Complexity  = 'Real';
block.OutputPort(3).SamplingMode = 'Sample';

% Register parameters
block.NumDialogPrms     = 5;

% Register continuous state
block.NumContStates = specificNonlinearModel.nrOfStates + specificNonlinearModel.nrOfStates^2;

% Register sample times
%  [0 offset]            : Continuous sample time
%  [positive_num offset] : Discrete sample time
%
%  [-1, 0]               : Inherited sample time
%  [-2, 0]               : Variable sample time
block.SampleTimes = [-1 0];

% Specify the block simStateCompliance. The allowed values are:
%    'UnknownSimState', < The default setting; warn and assume DefaultSimState
%    'DefaultSimState', < Same sim state as a built-in block
%    'HasNoSimState',   < No sim state
%    'CustomSimState',  < Has GetSimState and SetSimState methods
%    'DisallowSimState' < Error out when saving or restoring the model sim state
block.SimStateCompliance = 'DefaultSimState';

%% -----------------------------------------------------------------
%% The MATLAB S-function uses an internal registry for all
%% block methods. You should register all relevant methods
%% (optional and required) as illustrated below. You may choose
%% any suitable name for the methods and implement these methods
%% as local functions within the same file. See comments
%% provided for each function for more information.
%% -----------------------------------------------------------------

% block.RegBlockMethod('PostPropagationSetup',    @DoPostPropSetup);
block.RegBlockMethod('InitializeConditions', @InitializeConditions);
block.RegBlockMethod('Start', @Start);
block.RegBlockMethod('Outputs', @Outputs);     % Required
% block.RegBlockMethod('Update', @Update);
block.RegBlockMethod('Derivatives', @Derivatives);
block.RegBlockMethod('Terminate', @Terminate); % Required

%end setup

%%
%% PostPropagationSetup:
%%   Functionality    : Setup work areas and state variables. Can
%%                      also register run-time methods here
%%   Required         : No
%%   C-Mex counterpart: mdlSetWorkWidths
%%
% function DoPostPropSetup(block)
% block.NumDworks = 1;
% 
%   block.Dwork(1).Name            = 'x_vec';
%   block.Dwork(1).Dimensions      = 1;
%   block.Dwork(1).DatatypeID      = 0;      % double
%   block.Dwork(1).Complexity      = 'Real'; % real
%   block.Dwork(1).UsedAsDiscState = false;




%%
%% InitializeConditions:
%%   Functionality    : Called at the start of simulation and if it is 
%%                      present in an enabled subsystem configured to reset 
%%                      states, it will be called when the enabled subsystem
%%                      restarts execution to reset the states.
%%   Required         : No
%%   C-MEX counterpart: mdlInitializeConditions
%%
function InitializeConditions(block)


specificNonlinearModel = block.DialogPrm(5).Data;

% Set initial states
block.ContStates.Data(1:specificNonlinearModel.nrOfStates) = block.DialogPrm(1).Data;
% Set initial P Matrix (stored as Column-major vector in ContStates)
block.ContStates.Data(specificNonlinearModel.nrOfStates+1:end) = reshape(block.DialogPrm(2).Data,[specificNonlinearModel.nrOfStates^2,1]);

%end InitializeConditions


%%
%% Start:
%%   Functionality    : Called once at start of model execution. If you
%%                      have states that should be initialized once, this 
%%                      is the place to do it.
%%   Required         : No
%%   C-MEX counterpart: mdlStart
%%
function Start(block)




%end Start

%%
%% Outputs:
%%   Functionality    : Called to generate block outputs in
%%                      simulation step
%%   Required         : Yes
%%   C-MEX counterpart: mdlOutputs
%%
function Outputs(block)

specificNonlinearModel = block.DialogPrm(5).Data;

x_hat = block.ContStates.Data(1:specificNonlinearModel.nrOfStates);
u = block.InputPort(1).Data;
y_hat = specificNonlinearModel.outputFunction(x_hat,u,specificNonlinearModel.theta);
block.OutputPort(1).Data = x_hat;
block.OutputPort(2).Data = y_hat;
block.OutputPort(3).Data = reshape(block.ContStates.Data(specificNonlinearModel.nrOfStates+1:end),[specificNonlinearModel.nrOfStates,specificNonlinearModel.nrOfStates]);

%end Outputs

%%
%% Update:
%%   Functionality    : Called to update discrete states
%%                      during simulation step
%%   Required         : No
%%   C-MEX counterpart: mdlUpdate
%%
function Update(block)


%end Update

%%
%% Derivatives:
%%   Functionality    : Called to update derivatives of
%%                      continuous states during simulation step
%%   Required         : No
%%   C-MEX counterpart: mdlDerivatives
%%
function Derivatives(block)

specificNonlinearModel = block.DialogPrm(5).Data;

R = block.DialogPrm(3).Data;
Q = block.DialogPrm(4).Data;

x_hat = block.ContStates.Data(1:specificNonlinearModel.nrOfStates);
u = block.InputPort(1).Data;
z = block.InputPort(2).Data;

P = reshape(block.ContStates.Data(specificNonlinearModel.nrOfStates+1:end),[specificNonlinearModel.nrOfStates,specificNonlinearModel.nrOfStates]);

F = specificNonlinearModel.A_func(x_hat,u,specificNonlinearModel.theta);
H = specificNonlinearModel.C_func(x_hat,u,specificNonlinearModel.theta);

K = P * H' / R; 

x_hat_dot = specificNonlinearModel.derivativeFunction(x_hat,u,specificNonlinearModel.theta) + K*(z-specificNonlinearModel.outputFunction(x_hat,u,specificNonlinearModel.theta));
P_dot = F*P + P*F' - K*H*P + Q; 

block.Derivatives.Data(1:specificNonlinearModel.nrOfStates) = x_hat_dot;
block.Derivatives.Data(specificNonlinearModel.nrOfStates+1:end) = reshape(P_dot,[specificNonlinearModel.nrOfStates^2 1]);

%end Derivatives

%%
%% Terminate:
%%   Functionality    : Called at the end of simulation for cleanup
%%   Required         : Yes
%%   C-MEX counterpart: mdlTerminate
%%
function Terminate(block)

%end Terminate

