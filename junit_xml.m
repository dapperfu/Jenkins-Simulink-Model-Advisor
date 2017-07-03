function junit_xml(ma)

narginchk(0, 1);
if nargin == 0
   ma = Simulink.ModelAdvisor.getModelAdvisor(bdroot); 
end

checks = ma.getCheckAll;

n_checks = numel(checks);
checks_data=cell(1, n_checks);
for i = 1:n_checks
    check_data=struct();
    check_data.id = checks{i};
    fprintf('Running Check: %s\n',check_data.id);
    tic
    ma.runCheck(check_data.id);
    check_data.duration=toc;
    check_data.obj = ma.getCheckObj(check_data.id);
    check_data.result = ma.getCheckResult(check_data.id);
    check_data.result_data = ma.getCheckResultData(check_data.id);
    check_data.status = ma.getCheckResultStatus(check_data.id);
    
    checks_data{1, i} = check_data;
end

% 
% 
% 
%%
tests = (n_checks);
successes = sum(cellfun(@(check) check.status, checks_data));
failures  = tests - successes;

duration = sprintf('%.2f', sum(cellfun(@(check) check.duration, checks_data)));

%%
docNode = com.mathworks.xml.XMLUtils.createDocument('testsuites');
docRootNode = docNode.getDocumentElement;
%%
testsuite = docNode.createElement('testsuite'); 

testsuite.setAttribute('tests', sprintf('%d', tests));
testsuite.setAttribute('failures', sprintf('%d', failures));
testsuite.setAttribute('errors','0');

testsuite.setAttribute('id','0');
testsuite.setAttribute('time',duration);
testsuite.setAttribute('package','Simulink Model Advisor');
testsuite.setAttribute('name','Simulink Model Advisor');

testsuite.setAttribute('hostname', getenv('COMPUTERNAME'));
testsuite.setAttribute('timestamp',strrep(datestr(now, 31), ' ', 'T'));

properties = docNode.createElement('properties'); 
property = docNode.createElement('property'); 
property.setAttribute('ModelName', ma.ModelName);
properties.appendChild(property)
testsuite.appendChild(properties)

testcases = cell(1, tests);
for i = 1:tests
    testcase = docNode.createElement('testcase'); 
    
    check = checks_data{i};
    
    testcase.setAttribute('id', sprintf('%d',i));
    testcase.setAttribute('classname', check.obj.ID);
    testcase.setAttribute('name', check.obj.Title);
    
    result_str = resultstr(check.result);
    result_node = docNode.createTextNode(result_str);
    if check.status
        sysout = docNode.createElement('system-out');
        sysout.appendChild(result_node);
        testcase.appendChild(sysout);
    else
        failure = docNode.createElement('failure');
        failure.setAttribute('type', 'VerificationFailure');
        if isempty(result_str)
           disp('empty string'); 
        end
        failure.appendChild(result_node);
        testcase.appendChild(failure);
    end
    
    if ~isempty(check.result_data)
       disp('Non Empty Result Data'); 
    end
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
