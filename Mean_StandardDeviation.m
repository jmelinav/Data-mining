eating_file = 'Vinoth/spoon/EatingAction/EA.csv';
non_eating_file = 'Vinoth/spoon/NonEatingAction/NEA.csv'

[ea_mean_mat, ea_std_mat] = applyMeanAndStandardDeviation(eating_file);
[nea_mean_mat, nea_std_mat] = applyMeanAndStandardDeviation(non_eating_file);

%Plot the data of the mean of the features
for idx = 1:18
    name =  sprintf('Mean of Feature %d', idx);
    plot([transpose(ea_mean_mat(:,idx)); transpose(nea_mean_mat(:,idx))].');
    title(name)
    pause;
end

%Plot the data of the standard deviation of the features
for idx = 1:18
    name =  sprintf('Standard Deviation of Feature %d', idx);
    plot([transpose(ea_std_mat(:,idx)); transpose(nea_std_mat(:,idx))].');
    title(name)
    pause;
end

% Function which reads the csv file and performs mean and standard
% deviation of the data and returns result as matrix (40x18) dimension
function [result_mean_matrix, result_std_matrix]  = applyMeanAndStandardDeviation(file)
fid = fopen(file);

thisLine = fgetl(fid);

mean_matrix = [];
std_matrix = [];

while ischar(thisLine)
    Z = textscan(thisLine,'%f','Delimiter',',')';
    thisLine= fgetl(fid);
    mean_matrix = [mean_matrix; mean(cell2mat(Z))];
    std_matrix = [std_matrix; std(cell2mat(Z))];
end

fclose(fid);
result_mean_matrix = reshape(mean_matrix, [40,18]);
result_std_matrix = reshape(std_matrix, [40,18]);
end