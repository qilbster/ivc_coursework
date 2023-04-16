%% Preparation
clear
clc

warning('off','MATLAB:imagesci:png:libraryWarning')
run('vlfeat/toolbox/vl_setup')
data_path = '../catdog/'; 

test_accuracy = zeros(9,10,3);
%% Extracting fold and train/val split

fold = 1;
valid_ratio = 0.25;
fprintf('Getting paths and labels for all train, val & test data\n')
[train_paths, val_paths, test_paths, train_labels,...
    val_labels, test_labels] = trainvalidtest_paths(data_path, valid_ratio, fold);

validation_logs = [];

%% Hold-out hyperparameter tuning

% Hyperparameters
space_numwords = [400,500,600,700];
space_lambda = [2.2e-5,1.8e-4,2.2e-4,3.7e-4,2.2e-3];
for i = 1:size(space_numwords, 2)
    for j = 1:size(space_lambda, 2)
        num_words = space_numwords(i);
        LAMBDA = space_lambda(j);

        %--------------------------------------------------------------------------
        fprintf('Fold: %d \n',fold);

        % Step 1: Represent each image with bag of words
        fprintf('Using Bag of words representation for images\n') 
        vocab = codebook(train_paths, num_words);

        train_image = bags_of_words(train_paths,vocab);
        val_image = bags_of_words(val_paths,vocab);

        % Step 2: Classify each test image by training and using the appropriate classifier
        fprintf('Using SVM classifier to predict test set categories\n');
        [predicted_val_labels, W, B] = svm(train_image, train_labels, val_image, LAMBDA);

        % validation result
        val_accuracy = get_accuracy(predicted_val_labels, val_labels);
        validation_logs = [validation_logs; num_words, LAMBDA, val_accuracy];
    end
end

%% Evaluate perturbation & testing

% REMEMBER TO SET OPTIMAL W & B

fprintf('Fold: %d\n', fold)

%Performing Perturbations
%perturbations = perturbation_main(test_paths);

% Or load existing
load('../Perturbation_fold3.mat');
perturbations = perturbation_fold3;

% Evaluating validation accuracy
ptypes = fieldnames(perturbations);
% Loop through perturbations
for i = 1:numel(ptypes)
    % Loop through levels
    for j = 1:10
        perturbation = perturbations.(ptypes{i});
        pert_paths = perturbation(:,j);
        pert_image = bags_of_words(pert_paths,vocab);
        label_emtpy = zeros(1,size(pert_image,1));
        [~,~,~, scores] = vl_svmtrain(...
                            pert_image', label_emtpy, 0, 'model', W, 'bias', B, 'solver', 'none');

        pred_labels = cell(size(pert_image,1),1);
        for k = 1:size(pert_image,1)
            if scores(k) > 0
                pred_labels{k} = 'cat';
            else
                pred_labels{k} = 'dog';
            end
        end
        cur_accuracy = get_accuracy(pred_labels, test_labels);
        fprintf('\nCurrent test accuracy:%4.2f\n',cur_accuracy)
        test_accuracy(i,j,fold) = cur_accuracy;
        fprintf('Completed perturbation %s with level %d\n', ptypes{i}, j)
    end
end


%% Test result analysis

save('test_accuracy.mat', 'test_accuracy');
%load('test_accuracy.mat');
av_test_accuracy = mean(test_accuracy,3);
std_test_accuracy = std(test_accuracy,0,3);

plot_test_results(av_test_accuracy, std_test_accuracy, ptypes);


   