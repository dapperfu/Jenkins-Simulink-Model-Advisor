classdef ExampleTest < matlab.unittest.TestCase
    methods(Test)
        function testOne(testCase)  % Test passes
            testCase.verifyEqual(4,4,'Testing 4==4')
        end
        function testTwo(testCase)  % Test passes
            testCase.verifyEqual(5,5,'Testing 5==5')
        end
        function testThree(testCase) % Test passes
            testCase.assumeTrue(true)
        end
    end
end
