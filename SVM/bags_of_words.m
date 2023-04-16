
function image_feats = bags_of_words(image_paths,codebook)
vocab_size = size(codebook, 2);
fprintf('\nbags of words\n')

num = size(image_paths,1);
step_p = 30;
binSize = 20;
image_feats = zeros(num,vocab_size);
for i = 1:num
    img = single(im2gray(imread(image_paths{i})));
    input_img = vl_imsmooth(img,0.5);
    [~, sift_features] = vl_dsift(input_img,'Step',step_p,'size', binSize,'fast');
    sift_features = single(sift_features);
    dist = vl_alldist2(sift_features,codebook);
    
    [~,index]=min(dist, [], 2);
    hist_v =histc(index,[1:1:vocab_size]);
    image_feats(i,:) = do_normalize(hist_v);
end




