model = 'embedded_coder_fixedstep_multirate';
open_system(model);
ma = Simulink.ModelAdvisor.getModelAdvisor(model);
ma.run;
%%
checks =  ma.CheckCellArray;
for i=1:numel(checks)
    check = checks{i};
    if ~check.Success
        if iscell(check.Result)
            for j = 1:numel(check.Result)
               fprintf('%02d: %s\n',j,check.Result{j}); 
            end
        else
            fprintf('%s\n',check.Result)
            
        end
    end
end
