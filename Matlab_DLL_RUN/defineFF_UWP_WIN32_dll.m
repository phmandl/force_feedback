%% About defineFF_UWP_WIN32_dll.mlx
% This file defines the MATLAB interface to the library |FF_UWP_WIN32_dll|.
%
% Commented sections represent C++ functionality that MATLAB cannot automatically define. To include
% functionality, uncomment a section and provide values for &lt;SHAPE&gt;, &lt;DIRECTION&gt;, etc. For more
% information, see <matlab:helpview(fullfile(docroot,'matlab','helptargets.map'),'cpp_define_interface') Define MATLAB Interface for C++ Library>.



%% Setup. Do not edit this section.
function libDef = defineFF_UWP_WIN32_dll()
libDef = clibgen.LibraryDefinition("FF_UWP_WIN32_dllData.xml");
%% OutputFolder and Libraries 
libDef.OutputFolder = "D:\Philipp\repos\uwp_force_feedback\Matlab_DLL_RUN";
libDef.Libraries = "FF_UWP_WIN32_dll.lib";

%% C++ class |wheelreadings| with MATLAB name |clib.FF_UWP_WIN32_dll.WheelReadings| 
WheelReadingsDefinition = addClass(libDef, "wheelreadings", "MATLABName", "clib.FF_UWP_WIN32_dll.WheelReadings", ...
    "Description", "clib.FF_UWP_WIN32_dll.WheelReadings    Representation of C++ class wheelreadings"); % This description is shown as help to user. Modify it to appropriate description.

%% C++ class constructor for C++ class |wheelreadings| 
% C++ Signature: wheelreadings::wheelreadings()
WheelReadingsConstructor1Definition = addConstructor(WheelReadingsDefinition, ...
    "wheelreadings::wheelreadings()", ...
    "Description", "clib.FF_UWP_WIN32_dll.WheelReadings    Constructor of C++ class wheelreadings"); % This description is shown as help to user. Modify it to appropriate description.
validate(WheelReadingsConstructor1Definition);

%% C++ class constructor for C++ class |wheelreadings| 
% C++ Signature: wheelreadings::wheelreadings(wheelreadings const & input1)
WheelReadingsConstructor2Definition = addConstructor(WheelReadingsDefinition, ...
    "wheelreadings::wheelreadings(wheelreadings const & input1)", ...
    "Description", "clib.FF_UWP_WIN32_dll.WheelReadings    Constructor of C++ class wheelreadings"); % This description is shown as help to user. Modify it to appropriate description.
defineArgument(WheelReadingsConstructor2Definition, "input1", "clib.FF_UWP_WIN32_dll.WheelReadings", "input");
validate(WheelReadingsConstructor2Definition);

%% C++ class public data member |throttle| for C++ class |wheelreadings| 
% C++ Signature: double wheelreadings::throttle
addProperty(WheelReadingsDefinition, "throttle", "double", ...
    "Description", "double    Data member of C++ class wheelreadings"); % This description is shown as help to user. Modify it to appropriate description.

%% C++ class public data member |brake| for C++ class |wheelreadings| 
% C++ Signature: double wheelreadings::brake
addProperty(WheelReadingsDefinition, "brake", "double", ...
    "Description", "double    Data member of C++ class wheelreadings"); % This description is shown as help to user. Modify it to appropriate description.

%% C++ class public data member |clutch| for C++ class |wheelreadings| 
% C++ Signature: double wheelreadings::clutch
addProperty(WheelReadingsDefinition, "clutch", "double", ...
    "Description", "double    Data member of C++ class wheelreadings"); % This description is shown as help to user. Modify it to appropriate description.

%% C++ class public data member |angle| for C++ class |wheelreadings| 
% C++ Signature: double wheelreadings::angle
addProperty(WheelReadingsDefinition, "angle", "double", ...
    "Description", "double    Data member of C++ class wheelreadings"); % This description is shown as help to user. Modify it to appropriate description.

%% C++ class public data member |mastergain| for C++ class |wheelreadings| 
% C++ Signature: double wheelreadings::mastergain
addProperty(WheelReadingsDefinition, "mastergain", "double", ...
    "Description", "double    Data member of C++ class wheelreadings"); % This description is shown as help to user. Modify it to appropriate description.

%% C++ class |buttonReadings| with MATLAB name |clib.FF_UWP_WIN32_dll.buttonReadings| 
buttonReadingsDefinition = addClass(libDef, "buttonReadings", "MATLABName", "clib.FF_UWP_WIN32_dll.buttonReadings", ...
    "Description", "clib.FF_UWP_WIN32_dll.buttonReadings    Representation of C++ class buttonReadings"); % This description is shown as help to user. Modify it to appropriate description.

%% C++ class constructor for C++ class |buttonReadings| 
% C++ Signature: buttonReadings::buttonReadings()
buttonReadingsConstructor1Definition = addConstructor(buttonReadingsDefinition, ...
    "buttonReadings::buttonReadings()", ...
    "Description", "clib.FF_UWP_WIN32_dll.buttonReadings    Constructor of C++ class buttonReadings"); % This description is shown as help to user. Modify it to appropriate description.
validate(buttonReadingsConstructor1Definition);

%% C++ class constructor for C++ class |buttonReadings| 
% C++ Signature: buttonReadings::buttonReadings(buttonReadings const & input1)
buttonReadingsConstructor2Definition = addConstructor(buttonReadingsDefinition, ...
    "buttonReadings::buttonReadings(buttonReadings const & input1)", ...
    "Description", "clib.FF_UWP_WIN32_dll.buttonReadings    Constructor of C++ class buttonReadings"); % This description is shown as help to user. Modify it to appropriate description.
defineArgument(buttonReadingsConstructor2Definition, "input1", "clib.FF_UWP_WIN32_dll.buttonReadings", "input");
validate(buttonReadingsConstructor2Definition);

%% C++ class public data member |gearup| for C++ class |buttonReadings| 
% C++ Signature: bool buttonReadings::gearup
addProperty(buttonReadingsDefinition, "gearup", "logical", ...
    "Description", "logical    Data member of C++ class buttonReadings"); % This description is shown as help to user. Modify it to appropriate description.

%% C++ class public data member |geardown| for C++ class |buttonReadings| 
% C++ Signature: bool buttonReadings::geardown
addProperty(buttonReadingsDefinition, "geardown", "logical", ...
    "Description", "logical    Data member of C++ class buttonReadings"); % This description is shown as help to user. Modify it to appropriate description.

%% C++ class public data member |ST| for C++ class |buttonReadings| 
% C++ Signature: bool buttonReadings::ST
addProperty(buttonReadingsDefinition, "ST", "logical", ...
    "Description", "logical    Data member of C++ class buttonReadings"); % This description is shown as help to user. Modify it to appropriate description.

%% C++ class public data member |SE| for C++ class |buttonReadings| 
% C++ Signature: bool buttonReadings::SE
addProperty(buttonReadingsDefinition, "SE", "logical", ...
    "Description", "logical    Data member of C++ class buttonReadings"); % This description is shown as help to user. Modify it to appropriate description.

%% C++ class public data member |X| for C++ class |buttonReadings| 
% C++ Signature: bool buttonReadings::X
addProperty(buttonReadingsDefinition, "X", "logical", ...
    "Description", "logical    Data member of C++ class buttonReadings"); % This description is shown as help to user. Modify it to appropriate description.

%% C++ class public data member |O| for C++ class |buttonReadings| 
% C++ Signature: bool buttonReadings::O
addProperty(buttonReadingsDefinition, "O", "logical", ...
    "Description", "logical    Data member of C++ class buttonReadings"); % This description is shown as help to user. Modify it to appropriate description.

%% C++ class public data member |Square| for C++ class |buttonReadings| 
% C++ Signature: bool buttonReadings::Square
addProperty(buttonReadingsDefinition, "Square", "logical", ...
    "Description", "logical    Data member of C++ class buttonReadings"); % This description is shown as help to user. Modify it to appropriate description.

%% C++ class public data member |Triangle| for C++ class |buttonReadings| 
% C++ Signature: bool buttonReadings::Triangle
addProperty(buttonReadingsDefinition, "Triangle", "logical", ...
    "Description", "logical    Data member of C++ class buttonReadings"); % This description is shown as help to user. Modify it to appropriate description.

%% C++ class public data member |L2| for C++ class |buttonReadings| 
% C++ Signature: bool buttonReadings::L2
addProperty(buttonReadingsDefinition, "L2", "logical", ...
    "Description", "logical    Data member of C++ class buttonReadings"); % This description is shown as help to user. Modify it to appropriate description.

%% C++ class public data member |R2| for C++ class |buttonReadings| 
% C++ Signature: bool buttonReadings::R2
addProperty(buttonReadingsDefinition, "R2", "logical", ...
    "Description", "logical    Data member of C++ class buttonReadings"); % This description is shown as help to user. Modify it to appropriate description.

%% C++ class public data member |L3| for C++ class |buttonReadings| 
% C++ Signature: bool buttonReadings::L3
addProperty(buttonReadingsDefinition, "L3", "logical", ...
    "Description", "logical    Data member of C++ class buttonReadings"); % This description is shown as help to user. Modify it to appropriate description.

%% C++ class public data member |R3| for C++ class |buttonReadings| 
% C++ Signature: bool buttonReadings::R3
addProperty(buttonReadingsDefinition, "R3", "logical", ...
    "Description", "logical    Data member of C++ class buttonReadings"); % This description is shown as help to user. Modify it to appropriate description.

%% C++ class public data member |DPadDown| for C++ class |buttonReadings| 
% C++ Signature: bool buttonReadings::DPadDown
addProperty(buttonReadingsDefinition, "DPadDown", "logical", ...
    "Description", "logical    Data member of C++ class buttonReadings"); % This description is shown as help to user. Modify it to appropriate description.

%% C++ class public data member |DPadUp| for C++ class |buttonReadings| 
% C++ Signature: bool buttonReadings::DPadUp
addProperty(buttonReadingsDefinition, "DPadUp", "logical", ...
    "Description", "logical    Data member of C++ class buttonReadings"); % This description is shown as help to user. Modify it to appropriate description.

%% C++ class public data member |DPadLeft| for C++ class |buttonReadings| 
% C++ Signature: bool buttonReadings::DPadLeft
addProperty(buttonReadingsDefinition, "DPadLeft", "logical", ...
    "Description", "logical    Data member of C++ class buttonReadings"); % This description is shown as help to user. Modify it to appropriate description.

%% C++ class public data member |DPadRight| for C++ class |buttonReadings| 
% C++ Signature: bool buttonReadings::DPadRight
addProperty(buttonReadingsDefinition, "DPadRight", "logical", ...
    "Description", "logical    Data member of C++ class buttonReadings"); % This description is shown as help to user. Modify it to appropriate description.

%% C++ function |initRacingWheel| with MATLAB name |clib.FF_UWP_WIN32_dll.initRacingWheel|
% C++ Signature: void initRacingWheel()
initRacingWheelDefinition = addFunction(libDef, ...
    "void initRacingWheel()", ...
    "MATLABName", "clib.FF_UWP_WIN32_dll.initRacingWheel", ...
    "Description", "clib.FF_UWP_WIN32_dll.initRacingWheel    Representation of C++ function initRacingWheel"); % This description is shown as help to user. Modify it to appropriate description.
validate(initRacingWheelDefinition);

%% C++ function |initForceFeedback| with MATLAB name |clib.FF_UWP_WIN32_dll.initForceFeedback|
% C++ Signature: int initForceFeedback(int samplingTime)
initForceFeedbackDefinition = addFunction(libDef, ...
    "int initForceFeedback(int samplingTime)", ...
    "MATLABName", "clib.FF_UWP_WIN32_dll.initForceFeedback", ...
    "Description", "clib.FF_UWP_WIN32_dll.initForceFeedback    Representation of C++ function initForceFeedback"); % This description is shown as help to user. Modify it to appropriate description.
defineArgument(initForceFeedbackDefinition, "samplingTime", "int32");
defineOutput(initForceFeedbackDefinition, "RetVal", "int32");
validate(initForceFeedbackDefinition);

%% C++ function |readWheelStatus| with MATLAB name |clib.FF_UWP_WIN32_dll.readWheelStatus|
% C++ Signature: void readWheelStatus(WheelReadings * wheelValues)
%readWheelStatusDefinition = addFunction(libDef, ...
%    "void readWheelStatus(WheelReadings * wheelValues)", ...
%    "MATLABName", "clib.FF_UWP_WIN32_dll.readWheelStatus", ...
%    "Description", "clib.FF_UWP_WIN32_dll.readWheelStatus    Representation of C++ function readWheelStatus"); % This description is shown as help to user. Modify it to appropriate description.
%defineArgument(readWheelStatusDefinition, "wheelValues", "clib.FF_UWP_WIN32_dll.WheelReadings", "input", <SHAPE>);
%validate(readWheelStatusDefinition);

%% C++ function |FF_minus| with MATLAB name |clib.FF_UWP_WIN32_dll.FF_minus|
% C++ Signature: void FF_minus(double gain)
FF_minusDefinition = addFunction(libDef, ...
    "void FF_minus(double gain)", ...
    "MATLABName", "clib.FF_UWP_WIN32_dll.FF_minus", ...
    "Description", "clib.FF_UWP_WIN32_dll.FF_minus    Representation of C++ function FF_minus"); % This description is shown as help to user. Modify it to appropriate description.
defineArgument(FF_minusDefinition, "gain", "double");
validate(FF_minusDefinition);

%% C++ function |FF_plus| with MATLAB name |clib.FF_UWP_WIN32_dll.FF_plus|
% C++ Signature: void FF_plus(double gain)
FF_plusDefinition = addFunction(libDef, ...
    "void FF_plus(double gain)", ...
    "MATLABName", "clib.FF_UWP_WIN32_dll.FF_plus", ...
    "Description", "clib.FF_UWP_WIN32_dll.FF_plus    Representation of C++ function FF_plus"); % This description is shown as help to user. Modify it to appropriate description.
defineArgument(FF_plusDefinition, "gain", "double");
validate(FF_plusDefinition);

%% C++ function |readingButton| with MATLAB name |clib.FF_UWP_WIN32_dll.readingButton|
% C++ Signature: void readingButton(buttonReadings * bValues)
%readingButtonDefinition = addFunction(libDef, ...
%    "void readingButton(buttonReadings * bValues)", ...
%    "MATLABName", "clib.FF_UWP_WIN32_dll.readingButton", ...
%    "Description", "clib.FF_UWP_WIN32_dll.readingButton    Representation of C++ function readingButton"); % This description is shown as help to user. Modify it to appropriate description.
%defineArgument(readingButtonDefinition, "bValues", "clib.FF_UWP_WIN32_dll.buttonReadings", "input", <SHAPE>);
%validate(readingButtonDefinition);

%% Validate the library definition
validate(libDef);

end
