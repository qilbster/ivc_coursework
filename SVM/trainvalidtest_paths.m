
function [train_image_paths, val_image_paths, test_image_paths, ...
    train_labels, val_labels, test_labels] = trainvalidtest_paths(data_path, val_ratio, fold)


cat_dir = dir(fullfile(data_path, 'CATS/*.png'));
dog_dir = dir(fullfile(data_path, 'DOGS/*.png'));
sample_paths = cell(size(cat_dir,1) + size(dog_dir,1), 3);


idx = 1;
for i = 1:size(cat_dir,1)
    file = fullfile(data_path, 'CATS', cat_dir(i).name);
    sample_paths{idx,1} = file;
    species = regexp(file, 'cat_\d+', 'match');
    sample_paths{idx,2} = species{:};
    sample_paths{idx,3} = 'cat';
    idx = idx + 1;
end
 for i = 1:size(dog_dir,1)
    file = fullfile(data_path, 'DOGS', dog_dir(i).name);
    sample_paths{idx,1} = file;
    species = regexp(file, 'dog_\d+', 'match');
    sample_paths{idx,2} = species{:};
    sample_paths{idx,3} = 'dog';
    idx = idx + 1;
 end


group = sample_paths(:,2);
rng(1000);
cv = cvpartition(group, 'KFold', 3, 'Stratify', true);

train_group = sample_paths(cv.training(fold), :);
rng(1000);
hpartition = cvpartition(train_group(:,2), 'holdout', val_ratio, 'Stratify', true);
train_idx = training(hpartition);
val_idx = test(hpartition);

train_image_paths = train_group(train_idx, 1);
train_labels = train_group(train_idx, 3);
val_image_paths = train_group(val_idx, 1);
val_labels = train_group(val_idx, 3);
test_image_paths = sample_paths(cv.test(fold), 1);
test_labels = sample_paths(cv.test(fold), 3);

