% Jenkins Set Environment Variables
% Define environment variables relevant for Jenkins builds
jenkinsEnvVariables = {'BUILD_NUMBER', 'BUILD_ID', 'BUILD_URL', 'NODE_NAME', 'JOB_NAME', 'BUILD_TAG', 'JENKINS_URL', 'EXECUTOR_NUMBER', 'WORKSPACE'};

% Alphabetically sort the environmental variables
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

% Pause for 5 seconds to ensure the model is fully loaded
pause(5);

% Get the Model Advisor object for the model
ma = Simulink.ModelAdvisor.getModelAdvisor(model);

% Pause for 5 seconds to ensure Model Advisor initialization
pause(5);

% Run Model Advisor checks
ma.run;

% Get the Model Advisor checks
checks = ma.CheckCellArray;
n_checks = numel(checks);

% Initialize counters for successes, failures, and skipped checks
successes = 0;
failures = 0;
skipped = 0;

% Create XML document for test results
docNode = com.mathworks.xml.XMLUtils.createDocument('testsuites');
docRootNode = docNode.getDocumentElement;

% Create testsuite element
testsuite = docNode.createElement('testsuite'); 
testsuite.setAttribute('tests', sprintf('%d', n_checks));
testsuite.setAttribute('failures', sprintf('%d', failures));
testsuite.setAttribute('errors', '0');
testsuite.setAttribute('id', '0');
testsuite.setAttribute('time', '0.1');
testsuite.setAttribute('package', 'Simulink Model Advisor');
testsuite.setAttribute('name', 'Simulink Model Advisor');
testsuite.setAttribute('hostname', getenv('COMPUTERNAME'));
testsuite.setAttribute('timestamp', strrep(datestr(now, 31), ' ', 'T'));

% Add properties element to testsuite
properties = docNode.createElement('properties'); 
property = docNode.createElement('property'); 
property.setAttribute('name', 'ModelName'); 
property.setAttribute('value', ma.ModelName);
properties.appendChild(property);
testsuite.appendChild(properties);

% Create testcases for each Model Advisor check
testcases = cell(1, n_checks);
for i = 1:n_checks
    testcase = docNode.createElement('testcase'); 
    check = checks{i};
    testcase.setAttribute('classname', check.ID);
    testcase.setAttribute('name', check.Title);
    testcase.setAttribute('time', '0.1');

    % Check if the check was successful, failed, or skipped
    if check.Success
        successes = successes + 1;
    elseif isempty(check.Result)
        skipped = skipped + 1;
    else
        failures = failures + 1;
        failure = docNode.createElement('failure');
        failure.setAttribute('type', 'VerificationFailure');
        failure.appendChild(docNode.createTextNode(resultstr(check.Result)));
        testcase.appendChild(failure);
    end

    testcases{i} = testcase;
end

% Add testcases to testsuite
for i = 1:n_checks
    testsuite.appendChild(testcases{i});
end

% Add testsuite to document root
docRootNode.appendChild(testsuite);

% Write XML file with test results
xmlFileName = [model, '.xml'];
xmlwrite(xmlFileName, docNode);

% Exit MATLAB with success status code if running in Jenkins environment
if ~isempty(getenv('BUILD_NUMBER'))
    exit(0);
end
