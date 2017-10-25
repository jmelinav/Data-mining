% Function which reads the csv file and perform moving average of the data
% We reduce the number of features to the arbitary number of features M.

time_series = [1 2 3 4 5 6 7 8 9]
disp(time_series)
% paa(time_series, 3)
pause;

eating_file = 'Data/EatingAction/EAN.csv';
non_eating_file = 'Data/EatingAction/NEAN.csv'

paa_size = 5

[ea_paa_mat] = findPAA(eating_file, paa_size);
[nea_paa_mat] = findPAA(non_eating_file, paa_size);




%Plot the data of the mean of the features
for idx = 1:90
    name =  sprintf('FFT of Feature %d', idx);
   % eating_data = ea_paa_mat(:,(paa_size * (idx-1))+1:paa_size * idx);
    %eating_data = eating_data(:);
    
    %non_eating_data = nea_paa_mat(:,(paa_size * (idx-1))+1:paa_size * idx);
    %non_eating_data = non_eating_data(:);
    
    %plot([transpose(eating_data); transpose(non_eating_data)].');
    %plot([transpose(ea_paa_mat(1:2569, idx))].');
    %pause;
    %plot([].');
    pd = fitdist(ea_paa_mat(1:2569, idx),'Normal')
    x_values = -1:.1:1;
    y = pdf(pd,x_values);
    plot(x_values,y,'LineWidth',2)
    hold on
    pd = fitdist(nea_paa_mat(:, idx),'Normal')
    x_values = -1:.1:1;
    y = pdf(pd,x_values);
    plot(x_values,y,'LineWidth',2)
    %h2 = plot(1:2569, transpose(nea_paa_mat(:, idx)), 'r');    %second_y has 3 columns so h2 is length 3
    legend('Eating Action', 'Non eating action')
    
    title(name)
    pause;
end


function [result_paa_matrix]  = findPAA(file, paa_size)
fid = fopen(file);

thisLine = fgetl(fid);

paa_values = [];

idx = 0;

while ischar(thisLine)
    
    fprintf("row %d\n", idx);
    
    idx = idx+1;
        Z = textscan(thisLine,'%f','Delimiter',',')';
        if(size(cell2mat(Z), 1) <8)
            disp(cell2mat(Z));
        end
        fft_data = fft(transpose(cell2mat(Z)));
        fprintf("fft size - %d\n", size(fft_data,2));
        fftdata = dct_energy_coefficients(cell2mat(Z), 5);
       
        %fprintf("powfft %d\n", fftdatasorted);
    paa_values = [paa_values; fftdata];
    
    thisLine= fgetl(fid);
end

fclose(fid);
result_paa_matrix = reshape(paa_values, [idx/18,18*5]);
end


function [coefficients] = dct_energy_coefficients(x, limit)
X = dct(x);
[XX,ind] = sort(abs(X),'descend');
i = 1;
while norm(X(ind(1:i)))/norm(X) < 0.99
   i = i + 1;
end
needed = i;
X(ind(needed+1:end)) = 0;
xx = idct(X);
coefficients = xx(1: limit);
end