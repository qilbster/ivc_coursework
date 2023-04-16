function [aug_imds] = create_augment_datastores(paths, labels, train, dims)
%CREATE_AUGMENT_DATASTORES Summary of this function goes here
%   Detailed explanation goes here
imds = imageDatastore(paths,'Labels', categorical(labels));

pixelRange = [-30 30];
scaleRange = [0.9 1.1];
imageAugmenter = imageDataAugmenter( ...
    'RandXReflection',true, ...
    'RandXTranslation',pixelRange, ...
    'RandYTranslation',pixelRange, ...
    'RandXScale',scaleRange, ...
    'RandYScale',scaleRange, ...
    'RandRotation',[0 45]);

if (train)
    aug_imds = augmentedImageDatastore(dims,imds, 'DataAugmentation',imageAugmenter,...
        'ColorPreprocessing', 'gray2rgb');
else
    aug_imds = augmentedImageDatastore(dims,imds, 'ColorPreprocessing', 'gray2rgb');
end


end

