clear
data_path = './Data/';
ea_file_path = strcat(data_path,'EA.csv')
nea_file_path = strcat(data_path,'NEA.csv')
mean_features = [1 2 4 5 6 7 8 9 10 13 18];
ea_fft_path = strcat(data_path , 'EatingAction/ea_fft_feature.csv');
nea_fft_path = strcat(data_path , 'NonEatingAction/nea_fft_feature.csv');
ea_fft = importdata(ea_fft_path);
nea_fft = importdata(nea_fft_path);


fft_features = [1 2 4 8 9 10 11 12 14 15 16 17 19 20 22 27 28 29 30 32 33 34 35 37 38 40 45 46 47 48 50 51 52 53 54 53 55 56 58 63 64 65 66 68 69 70 71 72 73 74 76 81 82 83 84 86 87 88 89 90];
final_ea = [];

ea_ftt = ea_fft(:,fft_features);
nea_fft = nea_fft(:,fft_features);

all_data = vertcat(ea_ftt,nea_fft)
coeff = executePCA(all_data);
ea_pca = ea_ftt*coeff;
nea_pca = nea_fft*coeff;
dlmwrite(ea_file_path,ea_pca,'delimiter',',','-append');
dlmwrite(nea_file_path,nea_pca,'delimiter',',','-append');
fprintf('%d\n',size(all_data));
figure(1); clf;
[v,d] = eig(all_data'*all_data);
plot(ea_pca(:,1),ea_pca(:,2),'b.');   
hold on;
plot(nea_pca(:,1),nea_pca(:,2),'g*');
fprintf('\n%d\n',size(coeff(:,1)))
z = zeros(1,71);
plot([0 v(1,2)],[0 v(2,2)],'r-');   % first eigenvector
plot([0 v(1,1)],[0 v(2,1)],'g-');   % second eigenvector
axis equal
hold off;


%C = horzcat(A1,...,AN)
for idx = 1:12
    name =  sprintf('After Pca:Feature %d', idx);
    figure
    pd = fitdist(ea_pca(1:2569, idx),'Normal')
    x_values = -100:500;
    y = pdf(pd,x_values);
    plot(x_values,y,'LineWidth',2)
    hold on
    pd = fitdist(nea_pca(:, idx),'Normal')
    x_values = -100:500;
    y = pdf(pd,x_values);
    plot(x_values,y,'LineWidth',2)
    %h2 = plot(1:2569, transpose(nea_paa_mat(:, idx)), 'r');    %second_y has 3 columns so h2 is length 3
    legend('Eating Action', 'Non eating action')
    title(name)
    pause;
    hold off
    pause;
 end

function [result] = executePCA(matrix)
    [coeff,score,latent] = pca(matrix);
    fprintf('%f\n',latent)
    result = coeff(:,1:12);
end


