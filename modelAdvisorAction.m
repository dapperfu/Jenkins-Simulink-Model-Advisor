classdef modelAdvisorAction
    % ModelBuildAction - Assists in building models and managing artifacts

    properties
        modelName;
        prj;
        prjRootFolder;
        rptPath;
        mdlPath;
        rptCfg;
        configFile;
        checkResult;
        result;
    end

    methods
        function obj = modelAdvisorAction(modelName)
            % Constructor - Initializes the ModelAdvisorAction object
            obj.modelName = modelName;
            obj.prj = matlab.project.currentProject;
            obj.prjRootFolder = char(obj.prj.RootFolder);
            obj.mdlPath = fullfile(obj.prjRootFolder, 'Design', obj.modelName, 'specification');
            % Creates specific subfolder for report
            parentFolder = fullfile(obj.prjRootFolder, 'Design', obj.modelName, 'pipeline', 'analyze');
            if ~exist(fullfile(parentFolder, 'verify'), 'dir')
                mkdir(fullfile(parentFolder, 'verify'));
            end
            obj.rptPath = fullfile(obj.prjRootFolder, 'Design', obj.modelName, 'pipeline', 'analyze', 'verify');
            obj.configFile = Simulink.fileGenControl('getConfig');
        end

        function run(obj)
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

            % Open the Simulink model
            open_system(obj.modelName);

            % Pause for 5 seconds to ensure the model is fully loaded
            pause(5);

            % Get the Model Advisor object for the model
            ma = Simulink.ModelAdvisor.getModelAdvisor(obj.modelName);

            % Pause for 5 seconds to ensure Model Advisor initialization
            pause(5);

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

            % Move the Model Advisor report to the destination
            %srcReportPath = fullfile(char(obj.prjRootFolder), 'Code', 'cache', 'slprj', 'modeladvisor', char(obj.modelName), 'report.html');
            %destReportPath = fullfile(char(obj.rptPath), [obj.modelName 'ModelAdvisorReport.html']);
            
            % Check if the source file exists before attempting to move it
            %if exist(srcReportPath, 'file')
                %movefile(srcReportPath, destReportPath);
            %else
                %error('Source file does not exist: %s', srcReportPath);
            %end
        end

        function buildModel(obj)
            % Jenkins Set Environment Variables
            % Define environment variables relevant for Jenkins builds
            jenkinsEnvVariables = {'BUILD_NUMBER', 'BUILD_ID', 'BUILD_URL', 'NODE_NAME', 'JOB_NAME', 'BUILD_TAG', 'JENKINS_URL', 'EXECUTOR_NUMBER', 'WORKSPACE'};

            % Sort environment variables alphabetically
            jenkinsEnvVariables = sort(jenkinsEnvVariables);

            % Loop through the variables and print their values to the diary
            for idx = 1:numel(jenkinsEnvVariables)
                envVar = jenkinsEnvVariables{idx};
                fprintf('%s: %s\n', envVar, getenv(envVar))
            end

            % Open the Simulink model
            open_system(obj.modelName);

            % Pause for 5 seconds to ensure the model is fully loaded
            pause(5);

            % Get the Model Advisor object for the model
            ma = Simulink.ModelAdvisor.getModelAdvisor(obj.modelName);

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
            xmlFileName = [obj.modelName, '.xml'];
            xmlwrite(xmlFileName, docNode);

            % Exit MATLAB with success status code if running in Jenkins environment
            if ~isempty(getenv('BUILD_NUMBER'))
                exit(0);
            end
        end
    end
end
