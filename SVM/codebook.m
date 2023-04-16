
function dictionary = codebook(image_paths,num_of_words)
fprintf('\nvocabulary\n');
num = size(image_paths,1);
container = [];
step_p = 30;
binSize = 20;
for i = 1:num
    img = single(im2gray(imread(image_paths{i})));
    input_img = vl_imsmooth(img, 0.5);
    [~, sift_features] = vl_dsift(input_img,'Step',step_p,'size', binSize,'fast');
    % NOTE THE TRANSPOSE
    container =[container;(single(sift_features'))];
end


fprintf('\nstart to building vocaulary\n')
% ONLY TAKE THE FIRST OUTPUT OF V1_KMEANS
dictionary = vl_kmeans(container',num_of_words);
fprintf('\nfinish building vocaulary\n')

