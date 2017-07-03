%% Create a test suite from the ExampleTest class. Create a silent test runner.

import matlab.unittest.TestRunner
import matlab.unittest.TestSuite
import matlab.unittest.plugins.XMLPlugin

suite = TestSuite.fromClass(?ExampleTest);
runner = TestRunner.withNoPlugins;

%% Create an XMLPlugin that writes test results to the file myTestResults.xml.

xmlFile = 'myTestResults.xml';
p = XMLPlugin.producingJUnitFormat(xmlFile);

%% Add the plugin to the test runner and run the suite.

runner.addPlugin(p)
results = runner.run(suite);

exit(any([results.Failed]));
