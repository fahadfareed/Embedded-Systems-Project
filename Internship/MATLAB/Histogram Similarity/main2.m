%choose the template file
[FileName,PathName] = uigetfile('*.csv','Select the template csv file');
[binsA_temp, countsA_temp, binsG_temp, countsG_temp] = getHist([PathName FileName]);
       
%choose the first test file
[FileName,PathName] = uigetfile('*.csv','Select the first test csv file');
[binsA1, countsA1, binsG1, countsG1] = getHist([PathName FileName]);
 
%choose the second test file
[FileName,PathName] = uigetfile('*.csv','Select the second test csv file');
[binsA2, countsA2, binsG2, countsG2] = getHist([PathName FileName]);

%distance of template and first test file
disp('Distance of template and testFile-1');
disp('Accelerometer: ');
sum(abs(countsA_temp-countsA1))
disp('Gyro: ');
sum(abs(countsG_temp-countsG1))

%distance of template and second test file
disp('Distance of template and testFile-2');
disp('Accelerometer: ');
sum(abs(countsA_temp-countsA2))
disp('Gyro: ');
sum(abs(countsG_temp-countsG2))
