function [test_labels, W, B] = svm(train_image, train_labels, test_image, LAMBDA)


target = strcmp('cat', train_labels);
target = double(target);
target(target~=1)= -1;
[W, B] = vl_svmtrain(train_image', target', LAMBDA);
    

label_emtpy = zeros(1,size(test_image,1));
[~,~,~, scores] = vl_svmtrain(...
                    test_image', label_emtpy, 0, 'model', W, 'bias', B, 'solver', 'none');

test_labels = cell(size(test_image,1),1);
for i = 1:size(test_image,1)
    if scores(i) > 0
        test_labels{i} = 'cat';
    else
        test_labels{i} = 'dog';
    end
end

fprintf('\nsvm finished\n');





