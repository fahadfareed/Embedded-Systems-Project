%Main driver script

while(1)
    %% Show Interface
    clc
    disp('1: Add a template to the templates library');
    disp('2: Recognize a test gait signal');
    disp('3: Exit');
    
    in = input('Please enter your choice: ', 's');
    
    %% Add a template to the templates library
    if(in == '1')
       %Select the file
       [FileName,PathName] = uigetfile('*.csv','Select the csv file');
       %Get the average gait cycles
       avgCycle = getAvg(strcat(PathName, FileName));
       %Get the name of the person
       subjectName = input('Please enter the name of the test subject: ', 's');
       disp(strcat('Saving the template of:\t', subjectName));
       %create the struct to house both: name and avg cycle
       gaitStruct = struct('name', subjectName, 'accX', avgCycle{1}, 'accY', avgCycle{2}, 'accZ', avgCycle{3}, 'gyroX', avgCycle{4}, 'gyroY', avgCycle{5}, 'gyroZ', avgCycle{6});
       %select the filename
       i = 0;
       fileName = strcat(pwd, '\templates\', date, '_', int2str(i), '.mat');
       %checking if the name already exists
       while exist(fileName, 'file')
           i = i+1;
           fileName = strcat(pwd, '\templates\', date, '_', int2str(i), '.mat');
       end
       
       %save
       save(fileName, 'gaitStruct');
       disp('Save complete');
       dummy = input('Press any key to continue', 's');
    end
    
    %% Recognize a test signal
    if(in == '2')
        %get the test gait signal
        [FileName,PathName] = uigetfile('*.csv','Select the csv file');
        %Get the average gait cycles {accX, accY, accX, gyroX, gyroY, gyroZ}
        testCycles = getAvg(strcat(PathName, FileName));
               
        %get all the template file names
        files = dir( fullfile(strcat(pwd, '\templates\'), '*.mat') );
        fileNames = {files.name};
        
        %in case the templates folder is empty
        if(isempty(fileNames))
            disp('No templates found');
            break
        end
        
        %initialize the distances variables
        distances = zeros(6,1); %individual channel distances
        minDist = Inf;          %threshold distance
        subjectName = 'No Match';
        
        %load all the template files and compare
        for i=1:length(fileNames)
            load( fullfile(strcat(pwd, '\templates\'), fileNames{i}) );
            templateCycles = {gaitStruct.accX; gaitStruct.accY; gaitStruct.accZ; gaitStruct.gyroX; gaitStruct.gyroY; gaitStruct.gyroZ};
            
            dist = zeros(6, 1); %Place holder for the individual distances
            dist(1,1) = dtw(testCycles{1}, templateCycles{1});  %accX
            dist(2,1) = dtw(testCycles{2}, templateCycles{2});  %accY
            dist(3,1) = dtw(testCycles{3}, templateCycles{3});  %accZ
            dist(4,1) = dtw(testCycles{4}, templateCycles{4});  %gyroX
            dist(5,1) = dtw(testCycles{5}, templateCycles{5});  %gyroY
            dist(6,1) = dtw(testCycles{6}, templateCycles{6});  %gyroZ
            
            if(sum(dist)<minDist)
                minDist = sum(dist);
                distances = dist;
                subjectName = gaitStruct.name;
            end
        end
        
        disp('Best match found:');
        disp(subjectName);
        disp('DTW Distance: ');
        disp(minDist);
        disp('Individual Distances:');
        disp(distances);
        
        dummy = input('Press any key to continue', 's');
        
    end
    
    %% Exit
    if(in == '3')
        return
    end
end

