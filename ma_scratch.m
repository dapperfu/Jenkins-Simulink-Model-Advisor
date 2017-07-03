model = 'embedded_coder_fixedstep_multirate';
open_system(model);
ma = Simulink.ModelAdvisor.getModelAdvisor(model);
%%
checks = ma.getCheckAll;
groups = ma.getGroupAll;
group_checks = cellfun(@(group) ma.getCheckForGroup(group), groups, 'UniformOutput', false);

tasks  = ma.getTaskAll;
task_checks = cellfun(@(task) ma.getCheckForTask(task), tasks, 'UniformOutput', false);

n_group_checks = cellfun(@(checks) numel(checks), group_checks);
n_task_checks = cellfun(@(checks) numel(checks), task_checks);
n_checks = numel(checks);
%%
checks_out=cell(1, n_checks);
for i = 1:n_checks
    check=struct();
   
    check.id = checks{i};
    tic
    ma.runCheck(check.id);
    check_data.duration=toc;
    check_data.obj = ma.getCheckObj(check.id);
    check_data.result = ma.getCheckResult(check.id);
    check_data.result_data = ma.getCheckResultData(check.id);
    check_data.status = ma.getCheckResultStatus(check.id);
    
    checks_out{1, i} = check_data;
    break
end
