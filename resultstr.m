function str = resultstr(result)
% RESULTSTR - Convert Model Advisor CheckCellArray.Result to string.
%   Strips combines result(s) into a single string and strips HTML.
%
% Syntax:
%	str = resultstr(ma.CheckCellArray{1}.Result)
%
% Inputs:
%	result - Model Advisor Check Cell Array Result.
%
% Outputs:
%	str - string.
%
% Example:
%   ma = Simulink.ModelAdvisor.getModelAdvisor(bdroot);
%   ma.run;
%   str = resultstr(ma.CheckCellArray{1}.Result)
%
% See also:

% Author: Jed Frey
% Email :
% July 2017

%------------- BEGIN CODE --------------
str = '';
if iscell(result)
    n = numel(result);
    str_cell = cell(1,n);
    for i = 1:n
        str_cell{i} = feval(mfilename, result{i});
    end
    str = strjoin(str_cell, '\n');
    str = strtrim(str);
    return;
end

switch class(result)
    case 'ModelAdvisor.FormatTemplate'
        switch class(result.SubResultStatusText)
            case 'char'
                str = sprintf('%s: %s', result.SubResultStatus, result.SubResultStatusText);
            case 'ModelAdvisor.Text'
                str = sprintf('%s: %s', result.SubResultStatus, result.SubResultStatusText.Content);
            otherwise
                error(class(result.SubResultStatusText))
        end
    case 'ModelAdvisor.Text'
        str = result.Content;
    case 'cell'
        str = result{1};
        if isnumeric(str) && isempty(str)
            str = '';
        end
    case 'char'
        str = result;
    case 'double'
        if isempty(result)
            str = '';
        else
            error('Non Empty Double')
        end
    otherwise
        error(class(result))
end
str = striphtml(str);
str = strtrim(str);
%------------- END CODE ----------------
end

function str = striphtml(str)
pat = '<[^>]*>';
str = regexprep(str, pat, '');
end
