
%Sinha Laboratory for Vision Research at BCS MIT, Directed Search Experiment, Stimuli Design, Ege Ozgirin

%Equalizing the HSV value of images with the selection below:

%Selection:

img1 = imread('images/{sample_image_here}.jpg');
hsvImage1 = rgb2hsv(img1);
V1 = hsvImage1(:,:,3); 
opaque_idx_img1 = V1 <= 0.98;
mean_V1 = mean2(V1);

%Match:

for k = 1:400
    
	% Create an image filename, and read it in to a variable called imageData.
	jpgFileName = strcat('new_400/ds_batch1_', num2str(k), '.jpg');
	if exist(jpgFileName, 'file')
		img2 = imread(jpgFileName);
        
        hsvImage2 = rgb2hsv(img2);
        
        V2 = hsvImage2(:,:,3);
        
        opaque_idx_img2 = V2 <= 0.98;
        
        img_opaque = ones([size(V2)]);
        
        opaque_V2 = V2(opaque_idx_img2);
        
        mean_V2 = mean2(V2);
        
        img_opaque(opaque_idx_img2) = opaque_V2*im2double(mean_V1/mean_V2);
        
        hsvImage2(:,:,3) = im2uint8(img_opaque);
        
        rgb_newImage2 = hsv2rgb(hsvImage2);
        
        newFileName = strcat('processed/ds_batch1_', num2str(k), '.jpg');
        
        imwrite(uint8(rgb_newImage2), newFileName);
        
	else
		fprintf('File %s does not exist.\n', jpgFileName);
	end
	
end



