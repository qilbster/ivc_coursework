function plot_test_results(av_accuracy,std_accuracy, ptypes)
%PLOT_TEST_RESULTS Summary of this function goes here
%   Detailed explanation goes here

figure
hold on;
linespec = {'r', '--r', 'b', '--b', 'g', '--g', 'c', 'm', 'k'};
for i = 1:size(av_accuracy,1)
    x = 1:10;
    y = av_accuracy(i,:);
    err = std_accuracy(i,:);
    errorbar(x,y,err, linespec{i})
    
end
xlabel('Level of perturbation');
ylabel('Mean test accuracy');
legends = ptypes;
for i = 1:numel(ptypes)
    legends{i} = strrep(ptypes{i}, '_', ' ');
end
legend(legends)
end

