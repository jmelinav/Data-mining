data_path = './Data/'
output_path = './output_user_independent/'
number_of_actions_csv_path = strcat(data_path , 'number_of_actions.csv');
[filename,ea,nea] = textread(number_of_actions_csv_path,'%s %d %d','delimiter', ',');
eating_file_path = strcat(data_path ,'EA.csv')
neating_file_path = strcat(data_path ,'NEA.csv')
eating_file = csvread(eating_file_path);
neating_file = csvread(neating_file_path);
eating_start =1 ;
neating_start =1;
eatraining = 0;
neatraining = 0;
for i = 1: 10
    user_file = strcat("user",num2str(floor((i-1)/2)))
    eatraining = eatraining+ea(i);
    neatraining = neatraining + nea(i);
end
create_training_data(eatraining,neatraining,eating_file,neating_file,output_path)

eating_start =1 ;
neating_start =1;
for i = 11: size(filename)
    user_file = strcat("user",num2str(floor((i-1)/2)))
    eatesting = ea(i)
    neatesting = nea(i)
    create_data_for_each_user(eatesting,neatesting,eating_start,neating_start,user_file,eating_file,neating_file,output_path);
    eating_start = eating_start+int16(ea(i));
    neating_start = neating_start+int16(nea(i));
end

function create_training_data(eatraining,neatraining,eating_file,neating_file,output_path)
    eatrain = eating_file(1:eatraining,:);
    neatrain = neating_file(1:neatraining,:);
    eatrain = [eatrain ones(size(eatrain,1),1)];
    neatrain = [neatrain zeros(size(neatrain,1),1)];
    train_file = strcat(output_path ,"all_train.csv");
    dlmwrite(train_file,eatrain,'delimiter',',','-append');
    dlmwrite(train_file,neatrain,'delimiter',',','-append');
            
end

function create_data_for_each_user(eatesting,neatesting,eating_start,neating_start,user_file,eating_file,neating_file,output_path);
            a = eating_start+eatesting
            b = neating_start+neatesting
            
            row_count = size(eating_file,1)
            row_count_nea = size(neating_file,1)
            if row_count>=a
                eatest =  eating_file(eating_start:a,:);
            else
                eatest = eating_file(eating_start:end,:);
            end
            
            if row_count_nea>=b
                neatest = neating_file(neating_start:b,:);
            else
                neatest = neating_file(neating_start:end,:);
            end
            
            eatest = [eatest ones(size(eatest,1),1)];
            neatest = [neatest zeros(size(neatest,1),1)];
            test_file = strcat(output_path ,user_file);
            test_file = strcat(test_file,"_test.csv")
            dlmwrite(test_file,eatest,'delimiter',',','-append');
            dlmwrite(test_file,neatest,'delimiter',',','-append');
end