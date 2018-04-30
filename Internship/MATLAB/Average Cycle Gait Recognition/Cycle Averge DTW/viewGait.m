%% View one gait

%Select File
[FileName,PathName] = uigetfile('*.csv','Select the csv file');
getAvg(strcat(PathName, FileName));
