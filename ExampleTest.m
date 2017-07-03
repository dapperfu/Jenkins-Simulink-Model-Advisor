classdef ExampleTest < matlab.unittest.TestCase
    methods(Test)
        function testOne(testCase)  % Test fails
            testCase.verifyEqual(5,4,'Testing 5==4')
        end
        function testTwo(testCase)  % Test passes
            testCase.verifyEqual(5,5,'Testing 5==5')
        end
        function testThree(testCase) % Test fails
            testCase.assumeTrue(false)
        end
    end
end