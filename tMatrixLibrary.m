classdef tMatrixLibrary < matlab.perftest.TestCase
    
    properties(TestParameter)
        TestMatrix = struct('midSize', magic(500),...
            'largeSize', magic(1000));
    end
    
    methods(Test)
        function testSum(~, TestMatrix)
            matrix_sum(TestMatrix);
        end
        
        function testMean(~, TestMatrix)
            matrix_mean(TestMatrix);
        end
        
        function testEig(testCase, TestMatrix)
            % Eig only works on square matrix
            testCase.assertTrue(size(TestMatrix,1) == size(TestMatrix,2));
            testCase.startMeasuring;
            matrix_eig(TestMatrix);
            testCase.stopMeasuring;
        end
    end
end