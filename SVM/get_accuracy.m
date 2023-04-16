function [accuracy] = get_accuracy(predicted,ground_truth)

correct = 0;
for i = 1:numel(predicted)
    correct = correct + strcmp(predicted(i), ground_truth(i));
end
accuracy = correct/numel(predicted);
end

