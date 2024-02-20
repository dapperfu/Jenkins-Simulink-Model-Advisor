% Create an instance of ModelBuildAction with the model name
mb = modelAdvisorAction('CruiseControlMode');

% Call the method to run Model Advisor checks
mb.run();

% Call the method to build the model
mb.buildModel();

% Close a specific Simulink model
bdclose('CruiseControlMode');
