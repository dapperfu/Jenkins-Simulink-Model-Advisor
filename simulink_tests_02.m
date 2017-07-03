model = 'embedded_coder_fixedstep_multirate';
open_system(model);
ma = Simulink.ModelAdvisor.getModelAdvisor(model);
ma.run;

checks = ma.CheckCellArray;
n_checks = numel(checks);

% 
% 
% 
%%
tests = (n_checks);
successes = sum(cellfun(@(check) check.Success, checks));
skipped  =  sum(cellfun(@(check) isempty(check.Result), checks));
failures  = tests - successes - skipped;

%%
docNode = com.mathworks.xml.XMLUtils.createDocument('testsuites');
docRootNode = docNode.getDocumentElement;
%%
testsuite = docNode.createElement('testsuite'); 

testsuite.setAttribute('tests', sprintf('%d', tests));
testsuite.setAttribute('failures', sprintf('%d', failures));
testsuite.setAttribute('errors','0');

testsuite.setAttribute('id','0');
testsuite.setAttribute('time','0.1');
testsuite.setAttribute('package','Simulink Model Advisor');
testsuite.setAttribute('name','Simulink Model Advisor');

testsuite.setAttribute('hostname', getenv('COMPUTERNAME'));
testsuite.setAttribute('timestamp',strrep(datestr(now, 31), ' ', 'T'));

properties = docNode.createElement('properties'); 
property = docNode.createElement('property'); 
property.setAttribute('name', 'ModelName'); 
property.setAttribute('value', ma.ModelName);
properties.appendChild(property)
testsuite.appendChild(properties)

testcases = cell(1, tests);
for i = 1:tests
    testcase = docNode.createElement('testcase'); 
    
    check = checks{i};
    
    testcase.setAttribute('id', sprintf('%d',i));
    testcase.setAttribute('classname', check.ID);
    testcase.setAttribute('name', check.Title);
    
    result_str = resultstr(check.result);
    result_node = docNode.createTextNode(result_str);
    if check.Success
        sysout = docNode.createElement('system-out');
        sysout.appendChild(result_node);
        testcase.appendChild(sysout);
    elseif isempty(check.Result)
        skipped = docNode.createElement('skipped');
        testcase.appendChild(skipped);        
    else
        failure = docNode.createElement('failure');
        failure.setAttribute('type', 'VerificationFailure');
        failure.appendChild(result_node);
        testcase.appendChild(failure);
    end
    
    testcases{i} = testcase;
end

for i = 1:tests
    testsuite.appendChild(testcases{i});
end

docRootNode.appendChild(testsuite);

xmlFileName = [model,'.xml'];
xmlwrite(xmlFileName,docNode);

if ~isempty(getenv('BUILD_NUMBER'))
    exit(failures>0);
end
