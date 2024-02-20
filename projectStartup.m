% startUp.m sets up the project settings
% Configured to run at project startup

% Clear the workspace.
evalin('base', 'clear;');

% Close all figures.
close('all');

% Close all models.
bdclose('all');

% Get current project
myProject = matlab.project.currentProject;
projectRoot = myProject.RootFolder;

% Define folder paths
myCodeFolder = fullfile(projectRoot, 'Code');
myCodeGenFolder = fullfile(myCodeFolder, 'codegen');
myCacheFolder = fullfile(myCodeFolder, 'cache');

% Set project properties
myProject.SimulinkCacheFolder = myCacheFolder;
myProject.SimulinkCodeGenFolder = myCodeGenFolder;

% Create necessary folders
if ~exist(myCodeFolder, 'dir')
    mkdir(myCodeFolder);
end

if ~exist(myCodeGenFolder, 'dir')
    mkdir(myCodeGenFolder);
end

% Add folders to MATLAB path
addpath(myCodeFolder);
addpath(fullfile(projectRoot, 'Design', 'crs_controller', 'pipeline', 'analyze'));
addpath(fullfile(projectRoot, 'Design', 'CruiseControlMode', 'pipeline', 'analyze'));
addpath(fullfile(projectRoot, 'Design', 'DriverSwRequest', 'pipeline', 'analyze'));
addpath(fullfile(projectRoot, 'Design', 'TargetSpeedThrottle', 'pipeline', 'analyze'));

% Set Simulink file generation control options
Simulink.fileGenControl('set',...
    'CacheFolder', myCacheFolder,...
    'CodeGenFolder', myCodeGenFolder,...
    'createDir', true);

% Set path for logs
logsPath = fullfile(projectRoot, 'Code', 'logs');
save(fullfile('Code', 'logsPath.mat'), 'logsPath');

% Create logs directory if it doesn't exist
if ~exist(logsPath, 'dir')
    mkdir(logsPath);
end

pauseTime = 1.5;
clc
fprintf('Opening project ''%s''...\n', myProject.Name)
pause(pauseTime)
clc

clear myProject projectRoot myCodeFolder myCodeGenFolder myCacheFolder pauseTime