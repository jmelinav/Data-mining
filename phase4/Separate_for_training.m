data_path = './Data/'
output_path = './output/'
number_of_actions_csv_path = strcat(data_path , 'number_of_actions.csv');
[filename,ea,nea] = textread(number_of_actions_csv_path,'%s %d %d','delimiter', ',');
eating_file_path = strcat(data_path ,'EA.csv')
neating_file_path = strcat(data_path ,'NEA.csv')
eating_file = csvread(eating_file_path);
neating_file = csvread(neating_file_path);
eating_start =1 
neating_start =1 
for i = 1: size(filename)
    user_file = strcat("user",num2str(floor((i-1)/2)))
    eatraining = floor(ea(i)*0.6)
    eatesting = int16(ea(i)-eatraining)
    neatraining = floor(nea(i)*0.6)
    neatesting = int16(nea(i)-neatraining)
    create_data_for_each_user(eatraining,eatesting,neatraining,neatesting,eating_start,neating_start, user_file,eating_file,neating_file,output_path);
    eating_start = eating_start+int16(ea(i));
    neating_start = neating_start+int16(nea(i));
end

function create_data_for_each_user(eatraining,eatesting,neatraining,neatesting,eating_start,non_eating_start,user_file,eating_file,neating_file,output_path)
            a = eating_start+eatraining
            b = eating_start+eatraining+eatesting
            c = non_eating_start+neatraining
            d = non_eating_start+neatraining+neatesting
            row_count = size(eating_file,1)
            row_count_nea = size(neating_file,1)
            eatrain = eating_file(eating_start:a,:);
            if row_count>=b
                eatest = eating_file(a:b,:);
            else
                eatest = eating_file(a:end,:);
            end
            neatrain = neating_file(non_eating_start:c,:);
            
            if row_count_nea>=d
                neatest = neating_file(c:d,:);
            else
                neatest = neating_file(c:end,:);
            end
            
            eatrain = [eatrain ones(size(eatrain,1),1)];
            eatest = [eatest ones(size(eatest,1),1)];
            neatrain = [neatrain zeros(size(neatrain,1),1)];
            neatest = [neatest zeros(size(neatest,1),1)];
            train_file = strcat(output_path ,"all");
            train_file = strcat(train_file,"_train.csv")
            test_file = strcat(output_path ,user_file);
            test_file = strcat(test_file,"_test.csv")
            dlmwrite(train_file,eatrain,'delimiter',',','-append');
            dlmwrite(train_file,neatrain,'delimiter',',','-append');
            dlmwrite(test_file,eatest,'delimiter',',','-append');
            dlmwrite(test_file,neatest,'delimiter',',','-append');
end