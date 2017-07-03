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
    str_cell = {};
    for i = 1:numel(result)
        str_cell = [str_cell resultstr(result{i})];
    end
    str = strjoin(str_cell, '\n');
    return;
end

str = result{1};

%------------- END CODE ----------------
end
