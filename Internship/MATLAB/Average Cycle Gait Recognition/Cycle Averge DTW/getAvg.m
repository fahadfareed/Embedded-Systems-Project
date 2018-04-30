%% Calculates the average gait cycle of the csv file passed
 %Operations Performed: 1. Filter
 
 function avgGaitCycle = getAvg(FileName);
%% Read data from file
%storing the whole csv data in arr
arr = csvread(strcat(FileName));

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

%declaring the array that will hold all the cycles
cycles{length(locs)-1} = [];

%extracting individual cycles
for i=1:length(locs)-1
    cycles{i} = (nfSignal(locs(i):locs(i+1)-1))';
end


%% Calculate distance of each gait cycle with everyone else using dtw
distances = zeros(length(locs)-1, length(locs)-1);

for i=1:length(locs)-1
    for j=1:length(locs)-1
        [distances(i,j), ~, ~, ~] = dtw(cycles{i}, cycles{j});
    end
end

%% Calculate the average of rows
rowAvgs = sum(distances)' ./(length(distances(1, :)));
[~, minIndex] = min(rowAvgs);
avgGaitCycle = cycles{minIndex};

%% Plot all the individual cycles 

%finding the longest gait length
len = [locs; 0]-[0; locs];
len(1) = 0;
len(length(len)) = 0;
largestLen = max(len);

%declaring the 2d array that will hold all the cycles
plotCycles = zeros(length(locs)-1, largestLen);

figure;
subplot(2, 1, 1);
%extracting individual cycles
for i=1:length(locs)-1
    plotCycles(i,:) = [(nfSignal(locs(i):locs(i+1)-1))', zeros(1, largestLen-(locs(i+1)-locs(i)))];
    hold on
    plot((1:largestLen), plotCycles(i,:));
end
title('Individual Gait Cycles');


%% Plot the avg gait cycle
subplot(2, 1, 2);
plot(avgGaitCycle);
title('Average Cycle');

 end

    
