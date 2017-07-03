model = 'embedded_coder_fixedstep_multirate';
open_system(model);
ma = Simulink.ModelAdvisor.getModelAdvisor(model);

groups = ma.getGroupAll;
tasks  = ma.getCheckAll;
