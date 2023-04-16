%% Initialise ResNet & Replace Learnable/Output layer
clear
clc

net = resnet18;
inputSize = net.Layers(1).InputSize;
lgraph = layerGraph(net);
[learnableLayer,classLayer] = findLayersToReplace(lgraph);

newLearnableLayer = fullyConnectedLayer(2, ...
        'Name','new_fc', ...
        'WeightLearnRateFactor',5, ...
        'BiasLearnRateFactor',5);
    
lgraph = replaceLayer(lgraph,learnableLayer.Name,newLearnableLayer);
newClassLayer = classificationLayer('Name','new_classoutput');
lgraph = replaceLayer(lgraph,classLayer.Name,newClassLayer);

figure('Units','normalized','Position',[0.3 0.3 0.4 0.4]);
plot(lgraph)
ylim([0,10])

layers = lgraph.Layers;
connections = lgraph.Connections;
layers(1:68) = freezeWeights(layers(1:68));
mod_lgraph = createLgraphUsingConnections(layers,connections);

data_path = '../catdog/'; 
test_accuracy = zeros(9,10,3);

%% Extracting fold and train/val split

fold = 1;
valid_ratio = 0.25;
fprintf('Getting paths and labels for all train, val & test data\n')
[train_paths, val_paths, test_paths, train_labels,...
    val_labels, test_labels] = trainvalidtest_paths(data_path, valid_ratio, fold);

validation_logs = [];

%% Perform Hold-out Hyperparameter Tuning

% Set Hyperparameters
miniBatchSize = 40;
initial_lr = 8e-4;
% Initialising Optimiser
options = trainingOptions('sgdm', ...
    'MiniBatchSize',miniBatchSize, ...
    'MaxEpochs',3, ...
    'InitialLearnRate',initial_lr, ...
    'Shuffle','every-epoch', ...
    'Plots','training-progress');

% Choose to validate while training optional (for illustration at cost of performance)
validate_while_train = false;

%--------------------------------------------------------------------------
% Train & evaluate network
fprintf('Fold: %d\n', fold);

% Augmenting data
fprintf('Augmenting training data\n')
augtrain_imds = create_augment_datastores(train_paths, train_labels, true, inputSize(1:2));
augval_imds = create_augment_datastores(val_paths, val_labels, false, inputSize(1:2));

% Input validation data
if (validate_while_train)
    options.ValidationData = augval_imds;
    valFrequency = floor(numel(augtrain_imds.Files)/miniBatchSize);
    options.ValidationFrequency = valFrequency;
end

% Training network
mod_net = trainNetwork(augtrain_imds,mod_lgraph,options);

% Evaluating validation accuracy
fprintf('Evaluating network on validation data\n')
[YPred,probs] = classify(mod_net,augval_imds);
val_accuracy = mean(YPred == val_labels); 
validation_logs = [validation_logs; miniBatchSize, initial_lr, val_accuracy];

%% Evaluating Fold Test Results

% REMEMBER TO USE OPTIMAL MOD_NET
fprintf('Fold: %d\n', fold)

%Performing Perturbations
% perturbations = perturbation_main(test_paths);

% Or load
load('../Perturbation_fold1.mat');
perturbations = Perturbation_fold1;

% Evaluating validation accuracy
ptypes = fieldnames(perturbations);
% Loop through perturbations
for i = 1:numel(ptypes)
    % Loop through levels
    for j = 1:10
        perturbation = perturbations.(ptypes{i});
        pert_paths = perturbation(:,j);

        pert_imds = create_augment_datastores(pert_paths, ...
            test_labels, false, inputSize(1:2));
        [YPred,~] = classify(mod_net,pert_imds, 'Acceleration', 'none');
        test_accuracy(i,j,fold) = mean(YPred == test_labels);
        fprintf('Completed perturbation %s with level %d\n', ptypes{i}, j)
    end
end


%% Test result analysis

av_test_accuracy = mean(test_accuracy,3);
std_test_accuracy = std(test_accuracy,0,3);

plot_test_results(av_test_accuracy, std_test_accuracy, ptypes);
