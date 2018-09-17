classdef tMatrixLibrary < matlab.perftest.TestCase
    
    properties(TestParameter)
        TestMatrix = struct('smallSize', magic(100), 'midSize', magic(600),...
            'largeSize', magic(1000), 'NonSquare', reshape(magic(600), [300, 1200]));
    end
    
    methods(Test)
        function testSum(testCase, TestMatrix)
            while testCase.keepMeasuring
                matrix_sum(TestMatrix);
            end
        end
        
        function testMean(testCase, TestMatrix)
            while testCase.keepMeasuring
                matrix_mean(TestMatrix);
            end
        end
        
        function testEig(testCase, TestMatrix)
            % Eig only works on square matrix
            testCase.assumeTrue(size(TestMatrix,1) == size(TestMatrix,2));
            while testCase.keepMeasuring
                matrix_eig(TestMatrix);
            end
        end
    end
end