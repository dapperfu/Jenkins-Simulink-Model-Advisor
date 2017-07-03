model = 'embedded_coder_fixedstep_multirate';
open_system(model);
ma = Simulink.ModelAdvisor.getModelAdvisor(model);
ma.run;
mkdir('report');
ma.exportReport('report/report.html');
ma.ResultGUI;
