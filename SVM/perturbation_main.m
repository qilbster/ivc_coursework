function [perturb] = perturbation_main(test_paths)
%PERTURBATION_MAIN Run all perturbations for all level for one set of
%dataset
%   The function take nx1 cell array containing all file path for the
%   dataset and return struct n X level X #of perturbations. 
perturb = struct;

% perturb.gaussian_pixel_noise = gaussian_pixel_noise(test_paths);
% perturb.gaussian_blurring = gaussian_blurring(test_paths);
% perturb.image_contrast_increase = image_contrast_increase(test_paths);
% perturb.image_contrast_decrease = image_contrast_decrease(test_paths);
% perturb.image_brightness_increase = image_brightness_increase(test_paths);
% perturb.image_brightness_decrease = image_brightness_decrease(test_paths);
perturb.hsv_hue_noise_increase = hsv_hue_noise_increase(test_paths);
% perturb.hsv_saturation_noise_increase = hsv_saturation_noise_increase(test_paths);
% perturb.occlusion_image_increase = occlusion_image_increase(test_paths);
end

