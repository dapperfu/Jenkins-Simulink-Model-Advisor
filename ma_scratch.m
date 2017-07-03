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
