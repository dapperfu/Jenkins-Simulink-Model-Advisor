model = 'embedded_coder_fixedstep_multirate';
open_system(model);
ma = Simulink.ModelAdvisor.getModelAdvisor(model);
ma.run;
%%
checks =  ma.CheckCellArray;
for i=1:numel(checks)
    check = checks{i};
    if ~check.Success
        fprintf('%s\n',check.Result)
    end
end
