
%Sinha Lab, Directed Search Experiment, Stimuli Design, Ege Ozgirin, Oscar
%Li, Shreyas Gupta

%Creating Permutations from processed images

%Permute

%Useful variables
num_images = 400;
num_folders = 25;
perm_size = num_images/num_folders;

%disp(perm_size);
num_array = [];
done = [];

for k = 1:num_images
    
    num_array = [num_array k];

end

%size(num_array)

%Creating permutations

for j = 1:num_folders
    
    folderName = strcat('processed_',num2str(j));
    
    mkdir(folderName);
    
    permutation = randperm(length(num_array), perm_size);
    
    %disp(permutation);
    
    for l = 1:perm_size
        
        p = num_array(permutation(l));
        
        %disp(p);
        
        jpgFileName = strcat('processed/ds_batch1_', num2str(p), '.jpg');
        if exist(jpgFileName, 'file')
            imageData = imread(jpgFileName);
            
            newName = strcat('ds_batch2_', num2str(p), '.jpg');
            
            finalName = strcat(folderName,'/', newName);
            
            imwrite(imageData, finalName);
        else
            fprintf('File %s does not exist.\n', jpgFileName);
        end
    end
    
    num_array(permutation) = [];
    
end




