% Jenkins Set Environment Variables
% https://wiki.jenkins-ci.org/display/JENKINS/Building+a+software+project#Buildingasoftwareproject-below
envs = {'BUILD_NUMBER', 'BUILD_ID', 'BUILD_URL', 'NODE_NAME', 'JOB_NAME', 'BUILD_TAG', 'JENKINS_URL', 'EXECUTOR_NUMBER', 'WORKSPACE'};
% Alphabetically sort the environmental variables to print.
envs = sort(envs);
% Loop through the variables and print their result to the diary.
for env = envs
    env = env{1};
    fprintf('%s: %s\n', env, getenv(env))
end

model = 'embedded_coder_fixedstep_multirate';
open_system(model);
ma = Simulink.ModelAdvisor.getModelAdvisor(model);
ma.run;
mkdir('report');
ma.exportReport('report/report.html');
ma.ResultGUI;

if ~isempty(getenv('BUILD_NUMBER'))
    exit(0);
end
