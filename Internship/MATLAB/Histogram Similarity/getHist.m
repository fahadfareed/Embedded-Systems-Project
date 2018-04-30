function [acc_bins, countsA, gyr_bins, countsG] = getHist(fileName) 

%%Histogram Similarity Technique
% Inputs: fileName

acc_lower_limit = -2;
acc_upper_limit = 2;
gyr_lower_limit = -2;
gyr_upper_limit = 2;

%storing the whole csv data in arr
arr = csvread(fileName);



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
%%Acceleromter

%seperating individual channels
ax = arr(:, 1);
ay = arr(:, 2);
az = arr(:, 3);

%Combined accelerometer data
accR = asin(  (az)  ./    sqrt ((ay.^2)+(ax.^2)+(az.^2)) );

%histogram intervals
acc_bins= (acc_lower_limit:0.1:acc_upper_limit);

%histogram
[countsA, centersA] = hist(accR, acc_bins);

%normalizing counts
countsA = countsA ./ sum(countsA);

%plotting the hist
bar(acc_bins, countsA);
title('Accelerometer');

%plotting accR
figure;
plot(accR);
title('Accelerometer R');





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
%%Gyrometer

gx = arr(:, 4);
gy = arr(:, 5);
gz = arr(:, 6);

%Combined accelerometer data
gyrR = asin((gz)./sqrt((gy.^2)+(gx.^2)+(gz.^2)));

%histogram intervals
gyr_bins = (gyr_lower_limit:0.1:gyr_upper_limit);

%histogram
[countsG, centersG] = hist(gyrR, gyr_bins);

%normalizing counts
countsG = countsG ./ sum(countsG);

%plotting the hist
figure;
bar(gyr_bins, countsG);
title('Gyrometer');

%plotting gyrR
figure;
plot(gyrR);
title('Gyrometer R');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5







