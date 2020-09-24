%% Load Visual Studio folder
addpath('FF_UWP_Visual_Studio');

file_location = fullfile(pwd,'FF_UWP_Visual_Studio');
destination = pwd;
files = dir(file_location);
files([files.isdir]) = [];

for k = 1:numel(files)
    sourceFile = fullfile(file_location, files(k).name);
    destFile   = fullfile(destination, files(k).name);
    copyfile(sourceFile, destFile, 'f');
end

%% Open Simulink-Model
open('sfunction_builder_model.slx');

%% BUILD THE S-FUNCTION
% Open the s-function-block in the simulink file and press build!

%% MOVE THE FILES
for k = 1:numel(files)
    destFile   = fullfile(destination, files(k).name);
    delete(destFile);
end

% Build folder
build_folder = 'FF_UWP_WIN32_dll';
destination = fullfile(pwd,'build_folder');

if ~exist(destination, 'dir')
   mkdir(destination);
end

file_location = fullfile(pwd,'FF_UWP_Visual_Studio');
files = dir(file_location);
files([files.isdir]) = [];

for k = 1:numel(files)
    sourceFile = fullfile(file_location, files(k).name);
    destFile   = fullfile(destination, files(k).name);
    copyfile(sourceFile, destFile, 'f');
end

sourceFile = fullfile(pwd, 'RacingWheel.mexw64');
destFile   = fullfile(destination, 'RacingWheel.mexw64');
copyfile(sourceFile, destFile, 'f');

sourceFile = fullfile(pwd, 'icon.png');
destFile   = fullfile(destination, 'icon.png');
copyfile(sourceFile, destFile, 'f');