%% Compare two gaits

%Select Template File
[FileName,PathName] = uigetfile('*.csv','Select the template csv file');

%Averga gait cycle from the template file
avgTempCycle = getAvg(strcat(PathName, FileName));


%Select test File
[FileName,PathName] = uigetfile('*.csv','Select the test csv file');

%Averga gait cycle from the testfile
avgTestCycle = getAvg(strcat(PathName, FileName));



[distance, D, k, w] = dtw(avgTempCycle, avgTestCycle);
distance

