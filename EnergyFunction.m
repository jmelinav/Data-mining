eating_file = 'Data/EatingAction/EA.csv';
non_eating_file = 'Data/NonEatingAction/NEA.csv'

energy = getEnergy([1 2 3 4 5]);
fprintf("Energy - %d", energy);
pause;

[ea_mean_mat] = applyMeanAndStandardDeviation(eating_file);
[nea_mean_mat] = applyMeanAndStandardDeviation(non_eating_file);

%Plot the data of the mean of the features
for idx = 1:18
    name =  sprintf('Mean of Feature %d', idx);
    %plot([transpose(ea_mean_mat(:,idx)); transpose(nea_mean_mat(:,idx))].');
    %title(name)
    h1 = plot(1:2569, transpose(ea_mean_mat(1:2569, idx))', 'b');     %first_y has 4 columns so h1 is length 4
    hold on
    h2 = plot(1:2569, transpose(nea_mean_mat(:, idx)), 'r');    %second_y has 3 columns so h2 is length 3
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
function [result_mean_matrix]  = applyMeanAndStandardDeviation(file)
fid = fopen(file);

thisLine = fgetl(fid);

mean_matrix = [];
std_matrix = [];
count = 0

while ischar(thisLine)
    Z = textscan(thisLine,'%f','Delimiter',',')';
    count = count +1;
    %mean_matrix = [mean_matrix; mean(abs(diff(sign(cell2mat(Z)))))];
    mean_matrix = [mean_matrix; getEnergy(cell2mat(Z))];
 
    thisLine= fgetl(fid);
end

fclose(fid);
result_mean_matrix = reshape(mean_matrix, [count/18,18]);
result_std_matrix = reshape(std_matrix, [count/18,18]);
end


function [energy] = getEnergy(time_series)

calc_energy = 0;

for i = 1: size(time_series,2)
    fprintf("Val : %d\n" , time_series(i));
    calc_energy = calc_energy + time_series(i).^2;
end 
energy = calc_energy;
end