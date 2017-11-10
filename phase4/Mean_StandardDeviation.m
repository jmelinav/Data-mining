eating_file = 'Data/EatingAction/EA.csv';
non_eating_file = 'Data/NonEatingAction/NEA.csv'
data_path = './Data/'
[ea_mean_mat, ea_std_mat] = applyMeanAndStandardDeviation(eating_file);
[nea_mean_mat, nea_std_mat] = applyMeanAndStandardDeviation(non_eating_file);
dlmwrite(data_path+"EatingAction/ea_mean_feature.csv",ea_mean_mat,'delimiter',',');
dlmwrite(data_path+"NonEatingAction/nea_mean_feature.csv",nea_mean_mat,'delimiter',',');

%Plot the data of the mean of the features
for idx = 1:18
    name =  sprintf('Mean of Feature %d', idx);
    %plot([transpose(ea_mean_mat(:,idx)); transpose(nea_mean_mat(:,idx))].');
    %title(name)
    %h1 = plot(1:2569, transpose(ea_mean_mat(1:2569, idx))', 'b');     %first_y has 4 columns so h1 is length 4
    %hold on
    %h2 = plot(1:2569, transpose(nea_mean_mat(:, idx)), 'r');    %second_y has 3 columns so h2 is length 3
    %legend('Eating Action', 'Non eating action')
    figure
    pd = fitdist(ea_mean_mat(1:2569, idx),'Normal')
    x_values = -1:.1:1;
    y = pdf(pd,x_values);
    plot(x_values,y,'LineWidth',2)
    hold on
    pd = fitdist(nea_mean_mat(:, idx),'Normal')
    x_values = -1:.1:1;
    y = pdf(pd,x_values);
    plot(x_values,y,'LineWidth',2)
    %h2 = plot(1:2569, transpose(nea_paa_mat(:, idx)), 'r');    %second_y has 3 columns so h2 is length 3
    legend('Eating Action', 'Non eating action')
    title(name)
    pause;
    hold off
    pause;
 end
    
%Plot the data of the standard deviation of the features
for idx = 1:18
    name =  sprintf('Standard Deviation of Feature %d', idx);
    %plot([transpose(ea_std_mat(1:2569,idx)); transpose(nea_std_mat(1:2569,idx))].');
    %title(name)
    h1 = plot(1:2569, transpose(ea_std_mat(1:2569, idx))', 'b');     %first_y has 4 columns so h1 is length 4
    hold on
    h2 = plot(1:2569, transpose(nea_std_mat(1:2569, idx)), 'r');    %second_y has 3 columns so h2 is length 3
    legend('Eating Action', 'Non eating action')
    
    title(name)
    pause;
    hold off
    pause;
end

% Function which reads the csv file and performs mean and standard
% deviation of the data and returns result as matrix (40x18) dimension
function [result_mean_matrix, result_std_matrix]  = applyMeanAndStandardDeviation(file)
fid = fopen(file);

thisLine = fgetl(fid);

mean_matrix = [];
std_matrix = [];
count = 0

while ischar(thisLine)
    Z = textscan(thisLine,'%f','Delimiter',',')';
    count = count +1;
    thisLine= fgetl(fid);
    mean_matrix = [mean_matrix; mean(cell2mat(Z))];
    std_matrix = [std_matrix; std(cell2mat(Z))];
end

fclose(fid);
result_mean_matrix = reshape(mean_matrix, [count/18,18]);
result_std_matrix = reshape(std_matrix, [count/18,18]);
end