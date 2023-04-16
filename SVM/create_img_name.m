function [img_name] = create_img_name(img_path)
%CREATE_IMG_NAME Convert image path to image name
%   Create image name from image path by taking out the location folder and
%   file typ in the path
img_name = replace(img_path(16:end),'.png','');
end

