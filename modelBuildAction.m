classdef modelBuildAction
    % MODELBUILDACTION Assists in building models and managing artifacts

    properties
        prj
        cfg
        modelName
    end

    methods
        function obj = modelBuildAction(modelName)
            % Constructor
            if nargin < 1
                error('Please provide a model name.');
            end
            obj.modelName = modelName;
            obj.prj = matlab.project.currentProject;
            obj.cfg = Simulink.fileGenControl('getConfig');
        end

        function build(obj)
            % Build method

            % Change directory to code generation folder
            cd(obj.cfg.CodeGenFolder);

            try
                % Load the model
                load_system(obj.modelName)

                % Build based on the system target file
                cs = getActiveConfigSet(obj.modelName);
                sysTarg = get_param(cs, 'SystemTargetFile');
                switch sysTarg
                    case {'grt.tlc', 'rsim.tlc'}
                        slbuild(obj.modelName);
                    case 'ert.tlc'
                        rtwbuild(obj.modelName);
                    otherwise
                        error("Target not supported. Please change to 'ert' or 'grt'.")
                end

                % Clean up
                bdclose('all');
                cd(obj.prj.RootFolder)

                % Move generated reports to analyze folder
                srcReportPath = fullfile(obj.cfg.CodeGenFolder,[obj.modelName '_ert_rtw'], 'html');
                parentFolder = fullfile(char(obj.prj.RootFolder), 'Design', obj.modelName, 'pipeline', 'analyze');
                if ~exist(fullfile(parentFolder, 'build'), 'dir')
                    mkdir(fullfile(parentFolder, 'build'));
                end
                destReportPath = fullfile(char(obj.prj.RootFolder), 'Design', obj.modelName, 'pipeline', 'analyze', 'build');

                copyfile(srcReportPath, destReportPath);

                % Log the build result
                logFilePath = fullfile(obj.prj.RootFolder, 'Design', 'logs', [obj.modelName 'BuildLog.json']);
                fileID = fopen(logFilePath, 'w');
                s = struct('Result','Passed','Path', strrep(fullfile('..', 'build', [obj.modelName '_codegen_rpt.html']), filesep,[filesep filesep]));
                fprintf(fileID, jsonencode(s));
                fclose(fileID);

                disp('Model build successful.');
            catch ME
                % Log any errors
                logFilePath = fullfile(obj.prj.RootFolder, 'Design', 'logs', [obj.modelName 'BuildLog.json']);
                fileID = fopen(logFilePath, 'w');
                s = struct('Result','Failed','Path', 'No CodeGen report generated');
                fprintf(fileID, jsonencode(s));
                fclose(fileID);

                % Re-throw the error
                rethrow(ME);
            end
        end
    end
end