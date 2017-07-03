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
if numel(result)>1
    n = numel(result);
    str_cell = cell(1,n);
    for i = 1:n
        str_cell{i} = feval(mfilename, result{i});
    end
    str = strjoin(str_cell, '\n');
    return;
end

switch class(result)
    case 'ModelAdvisor.FormatTemplate'
        
   
    otherwise
        error(class(result))
end
    

str = result{1};
if isnumeric(str) && isempty(str)
   str = ''; 
end
%------------- END CODE ----------------
end
