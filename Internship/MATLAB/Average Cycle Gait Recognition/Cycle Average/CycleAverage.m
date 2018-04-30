%% Calculates the average gait cycle of the csv file present in the
 % same directory
 
 %Operations Performed: 1. Filter
 
 

%% Read data from file
[FileName,PathName] = uigetfile('*.csv','Select the csv file');

%storing the whole csv data in arr
arr = csvread(strcat(PathName, FileName));

%seperating individual channels
ax = arr(:, 1);
ay = arr(:, 2);
az = arr(:, 3);
gx = arr(:, 4);
gy = arr(:, 5);
gz = arr(:, 6);


%% Make and Apply the Butterworth filter 
[B,A] = butter(1,[.8/25,3/25]);
filtered = filter(B,A,az);

%plot(filtered);
%title('Filtered Signal');



%% Normalize the filtered signal. Values between -1 and 1
if (abs(max(filtered))>abs(min(filtered)))    
nfSignal = filtered./(max(filtered));
else
nfSignal = filtered./abs(min(filtered));
end
figure 
plot(nfSignal);
title('Normalized Filtered Signal with TruePeaks highlighted');



%% Locate Peaks
[peaks,locs] = findpeaks(nfSignal);
%figure;
%plot(locs,pks);

sigma = std(peaks);   %standard devication
mu = mean(peaks);     %mean
thresh = mu + sigma/3;   %threshold of true peaks

truePeaks = (peaks>thresh).*peaks;
truePeaks(truePeaks==0) = [];   %removing the zeros

locs = (peaks>thresh).*locs;
locs(locs==0) = [];   %removing the zeris

hold on 
stem(locs, truePeaks, 'red');



%% Identify Gait Cycles

%finding the longest gait length
len = [locs; 0]-[0; locs];
len(1) = 0;
len(length(len)) = 0;
largestLen = max(len);

%declaring the 2d array that will hold all the cycles
cycles = zeros(length(locs)-1, largestLen);

figure;
subplot(2, 1, 1);
%extracting individual cycles
for i=1:length(locs)-1
    cycles(i,:) = [(nfSignal(locs(i):locs(i+1)-1))', zeros(1, largestLen-(locs(i+1)-locs(i)))];
    hold on
    plot((1:largestLen), cycles(i,:));
end
title('Individual Gait Cycles');

%% Calculate average
averageCycle = sum(cycles)./(length(locs)-1);
subplot(2, 1, 2);
plot((1:largestLen), averageCycle, 'red');
title('Average Gait Cycle');


    
