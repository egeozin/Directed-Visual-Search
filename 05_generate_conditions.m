
%Sinha Lab, Directed Search Experiment, Stimuli Design, Ege Ozgirin, Sarah
%Wu, Jasmine Jin

%Equalizing the HSV value of images with the selection below:

%Selection:

shift = 45; %This could be 180

%img1 = imread('images/a_good_sample_here.jpg');
%hsvImage1 = rgb2hsv(img1);
%V1 = hsvImage1(:,:,3); 
%opaque_idx_img1 = V1 <= 0.98;
%mean_V1 = mean2(V1);

%Match:

%gray = rgb2gray(img2);


for k = 1:200
    
	% Create an image filename, and read it in to a variable called imageData.
	jpgFileName = strcat('prakash_permuted_3/ds_batch1_', num2str(k+400), '.jpg');
	if exist(jpgFileName, 'file')
		img2 = imread(jpgFileName);
        
        %gray_newImage = rgb2gray(img2);
        
        Ihsv = rgb2hsv(img2);
        hue = 360*Ihsv(:,:,1);
        Ihsv(:,:,1) = (mod(hue + shift, 360)) / 360;
        pseudo_newImage = im2uint8(hsv2rgb(Ihsv));
       
        newFileName = strcat('toPseudo3/ds_prakash_pseudo_', num2str(k), '.jpg');
        
        imwrite(uint8(pseudo_newImage), newFileName);
        %imwrite(uint8(pseudo_newImage), newFileName);
        
        
	else
		fprintf('File %s does not exist.\n', jpgFileName);
	end
	
end



