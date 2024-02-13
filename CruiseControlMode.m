%% Build Process
bdclose('all');
model = 'CruiseControlMode';
% Open the system
open_system(model);

% Build the model
slbuild(model);

% Save the system and close it.
% Saves are not pushed back to the version control but it eliminates a
% dialog prompt that pauses the build process.
save_system(model);
close_system(model, 1);
% Close out Models.
bdclose('all');
