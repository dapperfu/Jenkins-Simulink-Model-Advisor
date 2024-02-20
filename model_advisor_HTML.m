% Jenkins Set Environment Variables
% Define environment variables relevant for Jenkins builds
jenkinsEnvVariables = {'BUILD_NUMBER', 'BUILD_ID', 'BUILD_URL', 'NODE_NAME', 'JOB_NAME', 'BUILD_TAG', 'JENKINS_URL', 'EXECUTOR_NUMBER', 'WORKSPACE'};

% Sort environment variables alphabetically
jenkinsEnvVariables = sort(jenkinsEnvVariables);

% Loop through the variables and print their values to the diary
for envVar = jenkinsEnvVariables
    envVar = envVar{1};
    fprintf('%s: %s\n', envVar, getenv(envVar))
end

% Model Advisor
model = 'CruiseControlMode';

% Open the Simulink model
open_system(model);

% Get the Model Advisor object for the model
ma = Simulink.ModelAdvisor.getModelAdvisor(model);

% Run Model Advisor checks
ma.run;

% Create a directory to store the report
mkdir('report');

% Export the Model Advisor report to HTML format
ma.exportReport('docs/index.html');

% Open the Model Advisor Result GUI for further analysis
ma.ResultGUI;

% Check if BUILD_NUMBER is set
% This prevents exiting MATLAB if the script is run outside of a Jenkins environment for testing purposes
if ~isempty(getenv('BUILD_NUMBER'))
    exit(0); % Exit MATLAB with success status code
end

