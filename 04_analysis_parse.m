%% Code for the analysis of Tobii eye-tracker data.
 % Ege Ozgirin, Directed Search Experiment at Sinha Lab

%% Replace the filename here for each trial set for each person


filename = 'selected/1_{name_selected}.mat';
myVars = {'Timestamp', 'Fixation', 'GazepointX', 'GazepointY', 'StimuliID'};
loadVars = load(filename, myVars{:});

filename2 = 'target_object_positions.mat';
targetObjectPositions = load(filename2);

target_obj_posx = targetObjectPositions.TargetObjectPosition;
target_obj_posx(isnan(target_obj_posx)) = [];

%% Extract the double arrays (indices start from 1 to 5333)

timestamp = loadVars.Timestamp;
fixation = loadVars.Fixation;
Xs = loadVars.GazepointX;
Ys = loadVars.GazepointY;
ID = loadVars.StimuliID;

%% Useful Parameters and Variables

numStimuli = 100;
numSets = 6;
numTrials = 25;
stimuliPerTrial=4;
maxNumOfFix = 30;

% Change this depending on your criteria of success(landing on target
% object)
tRadius = 80; %72.5;

% look up table of Center of the location of Target Objects
centers = [638 102.5;781.5 131;902.5 213;984.5 334;1013 477.5;
           984.5 622;903.5 744;782 826;637.5 854.5;493 826;
           371 745;290 622;260.3 478;289.5 334;372 212;493.5 131];


%% Features to extract
 % 1)Number of fixations to target array for each trial (an array)
 % 1a) Compute the average for each participant 
 % 2)Distance between successive fixation points for each trial (a matrix)
 % 2a) Compute the average distance for each trial per person
 % (a matrix and a number: all distances for each trial, avg per person)
 % 3) Remaining distance to target over the course of each trial (a matrix)
 % 3a) Compute the average 

 
 numFixations = zeros(150, 1);
 successiveFix = zeros(150, 29); %numSets*numTrials, maxNumOfFix-1 
 avgSuccessiveFix = zeros(150, 1);
 % First fixation is also not counted in the below case. There might not be
 % an argument pointing to whether the first fixation is omittable.
 remDistToTarget = zeros(150, 29); %numSets*numTrials, maxNumOfFix-1 
 successTime = zeros(150, 1);
 
 

%% Splitting
 % 1. Fixation Cross (1.5 seconds), 2. Target Object (400 milliseconds), 
 % 3. Fixation Cross (1 second), 4.Array (on key-press)
 
 [IDs,ids] = findgroups(ID);
 
 for i = 1:numSets
     
     for k = 1:numTrials
     
        specificID = (i-1)*(stimuliPerTrial*numTrials) + k*stimuliPerTrial;
        targetID = (i-1)*numTrials + k;
        
        idx = find(IDs==specificID);
     
        newXs = Xs(idx); 
        newYs = Ys(idx);  
        fixs = fixation(idx);
        timestamps = timestamp(idx);
        timestamps = [timestamp(idx(1)-1); timestamps];
     
        clearXs = newXs;
        clearYs = newYs;
        clearFixs = fixs;
     
        newXs(isnan(newXs)) = [];
        newYs(isnan(newYs)) = [];
        fixs(isnan(fixs)) = [];
        
        [gazepointsX, ix, igx]= unique(newXs,'stable');
        [gazepointsY, iy, igy]= unique(newYs,'stable');
        [fixations, ifx, igf] = unique(fixs, 'stable');
        
        % A conditional checking whether two fixation have the same X
        % or Y value!! If that is the case, use fixation IDs
        
        if size(gazepointsX, 1) == size(gazepointsY, 1)
            
            nodes = [gazepointsX(:) gazepointsY(:)];
            
        else
            
            nodes = [newXs(ifx) newYs(ifx)];
            
        end
        
        % Check whether trial is success:
        
        target_posx = target_obj_posx(targetID);
        target_XY = centers(target_posx,:);     
       
        successTargets = [];
        
        for j = 1:size(nodes, 1)
            if (((nodes(j,1) - target_XY(1))^2 + (nodes(j,2) - target_XY(2))^2) < tRadius^2)
                successTargets = [successTargets; nodes(j,:)];
            end
        end
        
        % Another condition to check for success
        % Details will be provided
        
        if ~isempty(successTargets)
            
            [~, idk] = ismember(successTargets(end,:), nodes, 'rows');
        
            successNodes = nodes(1:idk,:);
            
            if ~(size(nodes, 1) - size(successNodes,1) < 3)
                
                continue
                
            end
        
        else
            
            continue
            
        end 
         
        % Append the number of fixations in a successful trial to the numFixation array
        
        numFixations(targetID) = size(successNodes, 1)-1; %First fixation is not counted
        
        dists = zeros(1, maxNumOfFix-1);
        distsToTarget = zeros(1, maxNumOfFix-1);
        
        flag = 0;
        
        for l = 1:size(successNodes, 1)
            
            if flag == 1
     
                dists(l-1) = sqrt((successNodes(l, 1)-successNodes(l-1, 1))^2 + (successNodes(l, 2)-successNodes(l-1, 2))^2);
                
                % Calculation of the remaining distance to the target over the
                % course of the trial.
                
                distsToTarget(l-1) = sqrt((successNodes(l,1)-target_XY(1))^2 + (successNodes(l, 2) - target_XY(2))^2);
            
            end      
            
            % Duration for each fixation
            
            %nidx = find(clearXs == gazepointsX(l));
            %nidy = find(clearYs == gazepointsY(l));
         
            %ts_idx_start = idx + nidx(1);
            %ts_idx_end = idx + nidx(end);
         
            %timestamp_start = timestamp(ts_idx_start);
            %timestamp_end = timestamp(ts_idx_end);
            
            flag = 1; 
            
        end
        
        ide = find(clearXs == successNodes(end, 1));
        
        % Manipulate the fields
        
        successiveFix(targetID,1:size(dists, 2)) = dists;
        
        remDistToTarget(targetID,1:size(distsToTarget,2)) = distsToTarget;
        
        avgSuccessiveFix(targetID) = mean(dists);
        
        successTime(targetID) = timestamps(ide(end)+1) - timestamps(1);
        
     end
        
 end
 

%% Save the feature into a mat file

save('{selected_name}_analysis_2.mat','numFixations','successiveFix','avgSuccessiveFix', 'remDistToTarget', 'successTime');


