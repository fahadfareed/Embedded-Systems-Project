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
       %Get the average gait cycle
       avgCycle = getAvg(strcat(PathName, FileName));
       %Get the name of the person
       subjectName = input('Please enter the name of the test subject: ', 's');
       disp(strcat('Saving the template of:\t', subjectName));
       %create the struct to house both: name and avg cycle
       saveStruct = struct('name', subjectName, 'signal', avgCycle);
       %select the filename
       i = 0;
       fileName = strcat(pwd, '\templates\', date, '_', int2str(i), '.mat');
       %checking if the name already exists
       while exist(fileName, 'file')
           i = i+1;
           fileName = strcat(pwd, '\templates\', date, '_', int2str(i), '.mat');
       end
       
       %save
       save(fileName, 'saveStruct');
       disp('Save complete');
       dummy = input('Press any key to continue', 's');
    end
    
    %% Recognize a test signal
    if(in == '2')
        %get the test gait signal
        [FileName,PathName] = uigetfile('*.csv','Select the csv file');
        %Get the average gait cycle
        testCycle = getAvg(strcat(PathName, FileName));
               
        %get all the template file names
        files = dir( fullfile(strcat(pwd, '\templates\'), '*.mat') );
        fileNames = {files.name};
        
        %in case the templates folder is empty
        if(isempty(fileNames))
            disp('No templates found');
            break
        end
        
        %initialize the distance variable
        minDist = Inf;
        subjectName = 'No Match';
        
        %load all the template files and compare
        for i=1:length(fileNames)
            load( fullfile(strcat(pwd, '\templates\'), fileNames{i}) );
            templateCycle = saveStruct.signal;
            dist = dtw(testCycle, templateCycle);
            
            if(dist<minDist)
                minDist = dist;
                subjectName = saveStruct.name;
            end
        end
        
        disp('Best match found:');
        disp(subjectName);
        disp('DTW Distance: ');
        disp(minDist);
        
        dummy = input('Press any key to continue', 's');
        
    end
    
    %% Exit
    if(in == '3')
        return
    end
end

