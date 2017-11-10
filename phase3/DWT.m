% Function which reads the csv file and perform moving average of the data
% We reduce the number of features to the arbitary number of features M.

time_series = [1 2 3 4 5 6 7 8 9]
disp(time_series)
% paa(time_series, 3)
pause;

eating_file = 'Data/EatingAction/EA.csv';
non_eating_file = 'Data/NonEatingAction/NEA.csv'

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
    plot([transpose(ea_paa_mat(1:2569, idx)); transpose(nea_paa_mat(:, idx))].')
    
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
    
    if length(thisLine) >10
    idx = idx+1;
        Z = textscan(thisLine,'%f','Delimiter',',')';
        if(size(cell2mat(Z), 1) <8)
            disp(cell2mat(Z));
        end
        
    paa_values = [paa_values; ];
    end
    thisLine= fgetl(fid);
end

fclose(fid);
result_paa_matrix = reshape(paa_values, [idx/18,18*6]);
end


% function [result] = paa(time_series, paa_size)
% N = size(time_series, 2);
% 
% if N== paa_size
%     % if the length of the time series is same as the number of features
%     % desired
%   result = time_series
% else
%    %{
%    segments = reshape(time_series, segLen, paa_size)
%    average = mean(segments)
%    data = repmat(avg, segLen, 1)
%    data = data(:)'
%    %}
%    
%     paa_values = size(paa_size);
%  
%    segLen = ceil(N/ paa_size);
%    
%    for i =1:paa_size
%        left = segLen*(i-1) +1;
%        right = segLen * i;
%        if(right>N)
%            right = N;
%        end   
%        paa_values(i) = mean(time_series(left:right));
%        
%    end
%    result = paa_values;
% end
% end