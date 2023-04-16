function [perturbed_path] = hsv_hue_noise_increase(img_paths)
%This function take file path for image and returned path of perturbed
%image
%   The function will load one image, apply perturbation for all level and
%   save img path in one row. Repeat for all image.

%%Set parameter
pert = 'hsv_hue_noise_increase';
perturbed_path = {};
noise_level = 0.00:0.02:0.18; %range of perturbation level

display_progress(pert);

for img_post = 1:1:size(img_paths,1)
    %read image file
    img_path = img_paths{img_post};
    imgrgb = (imread(img_path));
    imghsv = rgb2hsv(imgrgb);
    
    %create empty cell array for perturbed image path for ONE image
    perturbed_path_level = {};
    
    %Apply perturbation at all level for one image and save image and path
    for level = 1:1:10
        %apply perturbation
        [x,y,~] = size (imghsv);
        num = noise_level(level).*randn(x,y);
        imghsv(:,:,1) = imghsv(:,:,1) + num;
        imgNew = imghsv;
        %Set hsv value between 0 and 1
        imgNew(imgNew > 1) = imgNew(imgNew > 1) - 1; 
        imgNew (imgNew <0) = 0;
        %convert hsv to rgb
        imgNew = hsv2rgb(imgNew);
        
        %Create filename to save new image and path
        img_name = create_img_name(img_path);
        [fullFilename,img_perturbed_path] = create_img_path(img_name,pert,level);
        
        %save file using new file name
        imwrite(imgNew,img_perturbed_path);
        
        %save path of new image for all level for ONE image
        perturbed_path_level= [perturbed_path_level,img_perturbed_path];
    end
    
    %save path of all perturbed image to overall cell
    perturbed_path = [perturbed_path;perturbed_path_level];
end