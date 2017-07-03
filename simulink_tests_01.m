model = 'embedded_coder_fixedstep_multirate';
open_system(model);
ma = Simulink.ModelAdvisor.getModelAdvisor(model);
ma.run;
%%
checks =  ma.CheckCellArray;
for i=1:numel(checks)
    check = checks{i};
    results = check.Result;
    if ~check.Success
        switch class(results)
            case 'cell'
                for j = 1:numel(results)
                    result = results{j};
                    switch class(result)
                        case 'ModelAdvisor.FormatTemplate'
                            fprintf('%s\n',result.SubResultStatusText.Content)
                        case 'cell'
                            if ~isempty(result{1})
                                pat = '<[^>]*>';
                                str = regexprep(result{1}, pat, '');
                                fprintf('%s\n',str);
                            end
                        otherwise
                            fprintf('Unknown Result Class: %s\n',class(results));
                            break
                    end
                    
                end
            case 'char'
                fprintf('%s\n',results)
            case 'ModelAdvisor.FormatTemplate'
                fprintf('%s\n',results.SubResultStatusText.Content)
            otherwise
                fprintf('Unknown Results Class: %s\n',class(results));
                break
        end
    end
end
