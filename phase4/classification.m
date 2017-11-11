dataset = load("Iris.csv");

train_data = [dataset(1:30, 2: 5); dataset(51:80, 2:5)];
train_label = [dataset(1:30, 6);dataset(51:80, 6)];

test_data = [dataset(31:50, 2:5); dataset(81:100, 2:5)];
test_label = [dataset(31:50,6); dataset(81:100, 6)];


model = train_model(train_data, train_label);
view(model);
predict_out = predict_output(model, test_data);
[precision, recall, f1] = calcualte_metrics(test_label, predict_out);
fprintf("\nTest out : precision=%f  recall=%f f1-score = %f\n\n", precision, recall, f1);

neural_net(train_data, train_label, test_data, test_label);

function [net] = neural_net(train_data, train_label, test_data, test_label)
    % feedforward net with 1 hidden layer with 10 nodes
    net = feedforwardnet(10);
    fprintf("Training neural networks...\n");
    
    [trained_net, tr] = train(net, train_data', train_label');
    
    %Use the trained net to classify data
    predict_out = trained_net(test_data');
    
    predict_out = predict_out';
    %TODO: Decide whether the ouput is single value or two (using softmax)
    for idx = 1: size(predict_out,1)
        if(predict_out(idx)>0.5)
            predict_out(idx) = 1;
        else
            predict_out(idx) = 0;
        end
    end
    
    [precision, recall, f1] = calcualte_metrics(test_label, predict_out);
    fprintf("\nNeural network - Test out : precision=%f  recall=%f f1-score = %f", precision, recall, f1);
end

function  [model] = train_model(train_data, label)
  model = fitctree(train_data, label);
end



function test_for_user(trained_model)
    % Test the accuracy metrics for each user data
    for user  = 1: 33
        test_set = load(sprintf("user%d_test_set.csv", user));
        [precision, reacall, f1] = test_output(trained_model, test_set(:, 1:feature_count), test_set(:, feature_count+1));
        fprintf("User %d : precision=%f  recall=%f f1-score = %f", user, precision, recall, f1);
    end
end

function [pred_out] = predict_output(trained_model, test_data)
   pred_out = zeros(1, size(test_data,1));
   
for idx= 1: size(test_data, 1)
    out = predict(trained_model, test_data(idx, :));
    pred_out(idx) = out;
end
end

function [precision, recall, f1] = calcualte_metrics(test_label, predict_out)

%Initialize the metrics value to zero
tp = 0;
fn = 0;
fp = 0;
tn = 0;

for idx= 1: size(test_label, 1)

    out = predict_out(idx);
    
    % Yes class
    if test_label(idx) == 1
        % Yes class predicted as Yes
        if out ==1
            tp = tp + 1;
         % Yes class predicted as No
        else
            fn = fn +1 ;
        end
    % No class    
    else
        % No class predicted as Yes
        if out == 1
            fp = fp +1;
        % No class predicted as No
        else
            tn = tn +1;
        end
    end
end

fprintf("TP = %d  FN = %d  FP = %d  TN = %d", tp, fn, fp, tn);

precision = tp / (tp + fp);
recall = tp / (tp + fn);

f1 = 2 * precision * recall / (precision + recall);

end

