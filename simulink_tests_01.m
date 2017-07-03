model = 'embedded_coder_fixedstep_multirate';
open_system(model);
ma = Simulink.ModelAdvisor.getModelAdvisor(model);
ma.run;
%%
checks =  ma.CheckCellArray;
for i=1:numel(checks)
    check = checks{i};
    result = check.Result;
    if ~check.Success
        switch class(result)
            case 'cell'
            for j = 1:numel(result)
                if ~isempty(result{j}{1}
                    fprintf('%02d: %s\n',j,result{j}{1}); 
                end
            end
            case 'char'
            fprintf('%s\n',result)
            otherwise
                fprintf('Unknown Result Class: %s\n',class(result));
                break
        end
    end
end
