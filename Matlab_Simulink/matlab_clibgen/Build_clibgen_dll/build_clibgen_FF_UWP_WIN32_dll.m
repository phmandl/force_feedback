%% Note
% The folder with the visual studio files is required!
%
% Delte following files, if the already exits
% Files:
%   defineFF_UWP_WIN32_dll.m
%   defineFF_UWP_WIN32_dll.mlx
%   FF_UWP_WIN32_dllData.xml
%
% Folder:
%   FF_UWP_WIN32_dll

%% Create Library Definition
file_location = fullfile(pwd,'FF_UWP_Visual_Studio');
destination = pwd;
files = dir(file_location);
files([files.isdir]) = [];

for k = 1:numel(files)
    sourceFile = fullfile(file_location, files(k).name);
    destFile   = fullfile(destination, files(k).name);
    copyfile(sourceFile, destFile, 'f');
end

% IMPORTANT STUFF
clibgen.generateLibraryDefinition("FF_UWP_WIN32_dll.h","Libraries","FF_UWP_WIN32_dll.lib")

%% MinGW64 Compiler gives following info:
% Generated definition file defineFF_UWP_WIN32_dll.mlx and data file 'FF_UWP_WIN32_dllData.xml' contain definitions for 36 constructs supported by MATLAB.
% 2 constructs require additional definition.?To include these constructs in the interface, edit the definitions in defineFF_UWP_WIN32_dll.mlx.
% Build using build(defineFF_UWP_WIN32_dll).
%
% The error is a problme of the user-defined structures --> Matlab does not
% know the size.
% 
% To solve:
% 1) Open defineFF_UWP_WIN32_dll.mlx
% 2) modify
%   2.1) C++ function readWheelStatus with MATLAB name clib.FF_UWP_WIN32_dll.readWheelStatus
%        -----------------------------------------------------------------------------------
%        change
%        defineArgument(readWheelStatusDefinition, "wheelValues", "clib.FF_UWP_WIN32_dll.WheelReadings", "input", <SHAPE>);
%        TO
%        defineArgument(readWheelStatusDefinition, "wheelValues", "clib.FF_UWP_WIN32_dll.WheelReadings", "input", 1);
%   2.2) C++ function readWheelStatus with MATLAB name clib.FF_UWP_WIN32_dll.readWheelStatus
%        -----------------------------------------------------------------------------------
%        change
%        defineArgument(readingButtonDefinition, "bValues", "clib.FF_UWP_WIN32_dll.buttonReadings", "input", <SHAPE>);
%        TO
%        defineArgument(readingButtonDefinition, "bValues", "clib.FF_UWP_WIN32_dll.buttonReadings", "input", 1);
% 3) Save it!
%

%% Only build if the LibraryDefinition has no Problems
build(defineFF_UWP_WIN32_dll)

for k = 1:numel(files)
    destFile   = fullfile(destination, files(k).name);
    delete(destFile);
end

file_location = fullfile(pwd,'FF_UWP_Visual_Studio');
destination = fullfile(pwd,'FF_UWP_WIN32_dll');
files = dir(file_location);
files([files.isdir]) = [];

for k = 1:numel(files)
    sourceFile = fullfile(file_location, files(k).name);
    destFile   = fullfile(destination, files(k).name);
    copyfile(sourceFile, destFile, 'f');
end

%% After build a folder is created with the new matlab readable .dll
