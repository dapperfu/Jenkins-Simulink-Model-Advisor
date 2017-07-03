function junit_xml(checks)

%%
tests = numel(checks);
successes = sum(cellfun(@(check) check.Success, checks));
failures  = tests - successes;
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

% properties = docNode.createElement('properties'); 
% property = docNode.createElement('property'); 
% property.setAttribute('name', 'java.vendor'); 
% property.setAttribute('value', 'Sun MicroSystems Inc.');
% properties.appendChild(property)
% testsuite.appendChild(properties)

testcases = cell(1, tests);
for i = 1:tests
    testcase = docNode.createElement('testcase'); 
    
    test = checks{i};
    testcase.setAttribute('classname', test.ID);
    testcase.setAttribute('name', test.Title);   
    
    result_str = resultstr(test.Result);
    result_node = docNode.createTextNode(result_str);
    if test.Success
        sysout = docNode.createElement('system-out');
        sysout.appendChild(result_node);
        testcase.appendChild(sysout);
    else
        failure = docNode.createElement('failure');
        failure.setAttribute('type', 'VerificationFailure');
        failure.appendChild(result_node);
        testcase.appendChild(failure);
    end
    %%
    testcases{i} = testcase;
end


for i = 1:tests
    testsuite.appendChild(testcases{i});
end
%     testcase.setAttribute('classname', test.ID);
%     
% 
%     testcase.setAttribute('time', '0.1');
% 
%     testcase.setAttribute('classname', 'ExampleTest');
%     testcase.setAttribute('name', 'testOne');
%        
%     if true
%         failure = docNode.createElement('failure');
%         failure.setAttribute('type', 'VerificationFailure');
%         failure.appendChild(docNode.createTextNode('Failure Reason'));
%     end
%     testcase.appendChild(failure);
% 
%     sysout = docNode.createElement('system-out');
%     sysout.appendChild(docNode.createTextNode(''));
%     testcase.appendChild(sysout);
% 
%     syserr = docNode.createElement('system-err'); 
%     syserr.appendChild(docNode.createTextNode(''));
%     testcase.appendChild(syserr);
% 
%     testsuite.appendChild(testcase);
% end

docRootNode.appendChild(testsuite);

xmlFileName = [tempname,'.xml'];
xmlwrite(xmlFileName,docNode);
type(xmlFileName);
