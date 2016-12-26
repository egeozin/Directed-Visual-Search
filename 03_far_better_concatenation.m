
%% Script for importing data from the Directed Search experiment participants data folders:
 % This is an extension to the matlab script generated to import data from 
 % text files.
 
 % Ege Ozgirin, Directed Search Experiment at Sinha Lab, utility code_02a

%% Useful parameters and variables

numSets = 6;
numIDs = 100;

Timestamp = [];
Fixation = [];
GazepointX = [];
GazepointY = [];
StimuliID = [];
 
%% Open the data points from mat file and concatenate

for k = 1:numSets
    
    fileName = strcat('/Users/egeozin/Desktop/Sinha_Lab/Analysis/8_{name_here}/{name_here}', num2str(k), 'CMD.txt');
    
    scalaro = (k-1)*numIDs;
	
    if exist(fileName, 'file')
        
        % Initialize variables.
        delimiter = '\t';
        startRow = 20;
        
        % Read columns of data as strings:
        % For more information, see the TEXTSCAN documentation.
        formatSpec = '%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%[^\n\r]';
        
        % Open the text file.
        fileID = fopen(fileName,'r');
        
        
        % Read columns of data according to format string.
        % This call is based on the structure of the file used to generate this
        % code. If an error occurs for a different file, try regenerating the code
        % from the Import Tool.
        dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'HeaderLines' ,startRow-1, 'ReturnOnError', false);
        
 
        % Close the text file.
        fclose(fileID);
        
        % Convert the contents of columns containing numeric strings to numbers.
        % Replace non-numeric strings with NaN.
        raw = repmat({''},length(dataArray{1}),length(dataArray)-1);
        for col=1:length(dataArray)-1
            raw(1:length(dataArray{col}),col) = dataArray{col};
        end
        numericData = NaN(size(dataArray{1},1),size(dataArray,2));

        for col=[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,21,22,23,24,26]
            % Converts strings in the input cell array to numbers. Replaced non-numeric
            % strings with NaN.
            rawData = dataArray{col};
            for row=1:size(rawData, 1);
                % Create a regular expression to detect and remove non-numeric prefixes and
                % suffixes.
                regexstr = '(?<prefix>.*?)(?<numbers>([-]*(\d+[\,]*)+[\.]{0,1}\d*[eEdD]{0,1}[-+]*\d*[i]{0,1})|([-]*(\d+[\,]*)*[\.]{1,1}\d+[eEdD]{0,1}[-+]*\d*[i]{0,1}))(?<suffix>.*)';
                try
                    result = regexp(rawData{row}, regexstr, 'names');
                    numbers = result.numbers;
            
                    % Detected commas in non-thousand locations.
                    invalidThousandsSeparator = false;
                    if any(numbers==',');
                        thousandsRegExp = '^\d+?(\,\d{3})*\.{0,1}\d*$';
                        if isempty(regexp(numbers, thousandsRegExp, 'once'));
                            numbers = NaN;
                            invalidThousandsSeparator = true;
                        end
                    end
                    % Convert numeric strings to numbers.
                    if ~invalidThousandsSeparator;
                        numbers = textscan(strrep(numbers, ',', ''), '%f');
                        numericData(row, col) = numbers{1};
                        raw{row, col} = numbers{1};
                    end
                catch me
                end
            end
        end
        
        
        % Split data into numeric and cell columns.
        rawNumericColumns = raw(:, [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,21,22,23,24,26]);
        rawCellColumns = raw(:, [20,25]);
        
        % Replace non-numeric cells with NaN
        R = cellfun(@(x) ~isnumeric(x) && ~islogical(x),rawNumericColumns); % Find non-numeric cells
        rawNumericColumns(R) = {NaN}; % Replace non-numeric cells
        
        % Allocate imported array to column variable names
        Timestamp1 = cell2mat(rawNumericColumns(:, 1));
        Fixation1 = cell2mat(rawNumericColumns(:, 17));
        GazepointX1 = cell2mat(rawNumericColumns(:, 18));
        GazepointY1 = cell2mat(rawNumericColumns(:, 19));
        StimuliID1 = cell2mat(rawNumericColumns(:, 24));
        
        % Concatenate 
        
        StimuliID1 = scalaro+StimuliID1;
        disp(StimuliID1);
        
        Timestamp = [Timestamp; Timestamp1];
        Fixation = [Fixation; Fixation1];
        GazepointX = [GazepointX; GazepointX1];
        GazepointY = [GazepointY; GazepointY1];
        StimuliID = [StimuliID; StimuliID1];
        
        % Clear temporary variables
        clearvars filename delimiter startRow formatSpec fileID dataArray ans raw col numericData rawData row regexstr result numbers invalidThousandsSeparator thousandsRegExp me rawNumericColumns rawCellColumns R;
        
    else
        fprintf('File %s does not exist.\n', fileName);
        
    end
    
end


 % Write some variables into a .mat file.
        
 myVars = {'Timestamp', 'Fixation', 'GazepointX', 'GazepointY', 'StimuliID'};
 
 matFileName = '{name_here}_selected.mat';
 
 save(matFileName, myVars{:});
