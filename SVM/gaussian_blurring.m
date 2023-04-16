function [perturbed_path] = gaussian_blurring(img_paths)
%This function take file path for image and returned path of perturbed
%image
%   The function will load one image, apply perturbation for all level and
%   save img path in one row. Repeat for all image.

%%Set parameter
pert = 'gaussian_blurring';
perturbed_path = {};
mask_level = 0:1:9; %range of perturbation level
filter = 1/16*[1,2,1;2,4,2;1,2,1];

display_progress(pert);

for img_post = 1:1:size(img_paths,1)
    %read image file
    img_path = img_paths{img_post};
    img = imread(img_path);
    oriMax = max (img,[],"all");
    oriMin = min (img,[],"all");
    
    %initialize imgNew for 0 masking
    imgNew = img;
    
    %create empty cell array for perturbed image path for ONE image
    perturbed_path_level = {};
    
    %Apply perturbation at all level for one image and save image and path
    for level = 1:1:10
        %apply perturbation
        for x = 1:1:mask_level(level)
            imgNew = imfilter(img,filter,"conv");
            img = imgNew;
        end 
        
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