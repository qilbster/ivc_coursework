function [fullFilename,img_perturbed_path] = create_img_path(img_name,pert,level)
%CREATE_IMG_PATH Create fullFilename to save file and path 
%   Create full file name by including pertubation type and level in.
%   Create full path by including folder location in file. 
baseFilename = img_name+"_" + pert+"_"+ "level"+level + ".png";
fullFilename = fullfile(pert,baseFilename);
img_perturbed_path = char(fullfile('..','perturbation',fullFilename));
end

