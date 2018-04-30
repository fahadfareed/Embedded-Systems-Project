%% Calculates the average gait cycles of the csv file passed
 %Operations Performed: 1. Filter
 
 function avgGaitCycles = getAvg(FileName)
 %Returns a 2d cell array of the average gait cycles in the following order:
 % ax
 % ay
 % az
 % gx
 % gy
 % gz
 
 
%% Read data from file
%storing the whole csv data in arr
arr = csvread(strcat(FileName));

%seperating individual channels
% ax = arr(:, 1);
% ay = arr(:, 2);
% az = arr(:, 3);
% gx = arr(:, 4);
% gy = arr(:, 5);
% gz = arr(:, 6);

%Reserve a 2d cell array for the average individual gait cycles
avgGaitCycles{6,1} = [];

for index = 1:6
    signal = arr(:, index);



        %% Make and Apply the Butterworth filter 
        [B,A] = butter(1,[.8/25,3/25]);
        filtered = filter(B,A,signal);
        %plot(filtered);
        %title('Filtered Signal');


        %% Normalize the filtered signal. Values between -1 and 1
        if (abs(max(filtered))>abs(min(filtered)))    
        nfSignal = filtered./(max(filtered));
        else
        nfSignal = filtered./abs(min(filtered));
        end
        %figure 
        %plot(nfSignal);
        %title('Normalized Filtered Signal with TruePeaks highlighted');



        %% Locate Peaks
        [peaks,locs] = findpeaks(nfSignal);
        %figure;
        %plot(locs,pks);

        sigma = std(peaks);   %standard deviation
        mu = mean(peaks);     %mean
        thresh = mu + sigma/2;   %threshold of true peaks

        truePeaks = (peaks>thresh).*peaks;
        truePeaks(truePeaks==0) = [];   %removing the zeros

        locs = (peaks>thresh).*locs;
        locs(locs==0) = [];   %removing the zeris

        % hold on 
        % stem(locs, truePeaks, 'red');


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
                [distances(i,j),D,k,w] = dtw(cycles{i}, cycles{j});
            end
        end

        %% Calculate the average of rows
        rowAvgs = sum(distances)' ./(length(distances(1, :)));
        [~, minIndex] = min(rowAvgs);
        avgGaitCycle = cycles{minIndex};

  %% End of for loop
  avgGaitCycles{index} = avgGaitCycle;
 end

end

    
