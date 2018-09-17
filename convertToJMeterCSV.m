function convertToJMeterCSV(Results)
% CONVERTMEASUREMENTRESULTTOJMETERCSV converts and writes
% the MeasurementResult RESULT to a comma-delimited text CSV file
% in JMeter output format.

activityTable = vertcat(Results.TestActivity);
samplesTable = activityTable(activityTable.Objective == categorical({'sample'}),:);
nrows = size(samplesTable, 1);

% Trim the table and change variable names to comply with JMeter CSV format
measuredVariableName = Results.MeasuredVariableName;
samplesTable = samplesTable(:, {'Timestamp', measuredVariableName, 'Name', 'Passed'});
samplesTable.Properties.VariableNames = {'timeStamp', 'elapsed', 'label', 'success'};

% Convert timestamp to unix format, and fill NaT with previous available time
samplesTable.timeStamp = fillmissing(samplesTable.timeStamp,'previous');
samplesTable.timeStamp = posixtime(samplesTable.timeStamp)*1000;

% Convert MeasuredTime to millisecond, and fill NaN with 0
samplesTable.elapsed = fillmissing(samplesTable.elapsed,'constant',0);
samplesTable.elapsed = floor(samplesTable.elapsed*1000);

% Convert pass/fail logical to string
samplesTable.success = string(samplesTable.success);

% Generate additional columns required in JMeter CSV format
responseCode = zeros(nrows, 1);
responseMessage = strings(nrows, 1);
threadName = strings(nrows, 1);
dataType = strings(nrows, 1);
failureMessage = strings(nrows, 1);
bytes = zeros(nrows, 1);
sentBytes = zeros(nrows, 1);
grpThreads = ones(nrows, 1);
allThreads = ones(nrows, 1);
latency = zeros(nrows, 1);
idleTime = zeros(nrows, 1);
connect = zeros(nrows, 1);

auxTable = table(responseCode, responseMessage, threadName, dataType, ...
    failureMessage, bytes, sentBytes, grpThreads, allThreads, ...
    latency, idleTime, connect);

% Append additional columns to the original table
JMeterTable = [samplesTable, auxTable];

% Write the full table to a CSV file
writetable(JMeterTable, 'PerformanceTestResult.csv','QuoteStrings',true);
