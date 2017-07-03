docNode = com.mathworks.xml.XMLUtils.createDocument('testsuites');
docRootNode = docNode.getDocumentElement;

testsuite = docNode.createElement('testsuite'); 
testsuite.setAttribute('errors','0');
testsuite.setAttribute('failures','1');
testsuite.setAttribute('skipped','1');
testsuite.setAttribute('tests','1');
testsuite.setAttribute('time','0.1');

testcase = docNode.createElement('testcase'); 
testcase.setAttribute('classname', 'ExampleTest');
testcase.setAttribute('name', 'testOne');
testcase.setAttribute('time', '0.1');



testsuite.appendChild(testcase);


docRootNode.appendChild(testsuite);

xmlFileName = [tempname,'.xml'];
xmlwrite(xmlFileName,docNode);
type(xmlFileName);
