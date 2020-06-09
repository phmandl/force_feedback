% Comments missing
clibgen.generateLibraryDefinition("FF_UWP_WIN32_dll.h","Libraries","FF_UWP_WIN32_dll.lib")

% Only build if the LibraryDefinition has no Problems
build(defineFF_UWP_WIN32_dll)

%% NOTE AND MODIFY
% ------------------------------------------------------------------------
% Modify .mlx file and add struct size to 1 for readingButtons and
% readWheelStatus
% defineArgument(readingButtonDefinition, "bValues", "clib.FF_UWP_WIN32_dll.buttonReadings", "input", <SHAPE>);
% TO
% defineArgument(readingButtonDefinition, "bValues", "clib.FF_UWP_WIN32_dll.buttonReadings", "input", 1);

% defineArgument(readWheelStatusDefinition, "wheelValues", "clib.FF_UWP_WIN32_dll.WheelReadings", "input", <SHAPE>);
% TO
% defineArgument(readWheelStatusDefinition, "wheelValues", "clib.FF_UWP_WIN32_dll.WheelReadings", "input", 1);