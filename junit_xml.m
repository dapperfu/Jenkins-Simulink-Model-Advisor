docNode = com.mathworks.xml.XMLUtils.createDocument('testsuites');
docRootNode = docNode.getDocumentElement;

testsuite = docNode.createElement('testsuite'); 
testsuite.setAttribute('errors','0');
testsuite.setAttribute('failures','1');
testsuite.setAttribute('package','This Package');
testsuite.setAttribute('tests','1');
testsuite.setAttribute('time','0.1');
testsuite.setAttribute('id','0');
testsuite.setAttribute('name','ts_name');
testsuite.setAttribute('hostname','THISHOST');
testsuite.setAttribute('timestamp','2013-05-24T10:23:58');

testcase = docNode.createElement('testcase'); 
testcase.setAttribute('classname', 'ExampleTest');
testcase.setAttribute('name', 'testOne');
testcase.setAttribute('time', '0.1');

failure = docNode.createElement('failure'); 
failure.setAttribute('type', 'VerificationFailure');
failure.appendChild(docNode.createTextNode('Failure Reason'))

testcase.appendChild(failure);
testsuite.appendChild(testcase);

docRootNode.appendChild(testsuite);

xmlFileName = [tempname,'.xml'];
xmlwrite(xmlFileName,docNode);
type(xmlFileName);
