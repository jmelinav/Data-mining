fps = 30
last_ts = 1503514251691
last_frame = 6648
emg_file = './Vinoth/spoon/1503514028875_EMG.txt'
imu_file = 'Vinoth/spoon/1503514028875_IMU.txt'
eating_frames_file = 'Vinoth/spoon/1503514028875_pick.txt'
output_path = 'Vinoth/spoon/'
data_path = './Data/'
emg_folder_name = 'EMG/'
imu_folder_name = 'IMU/'
annotations_folder_name = 'Annotations_formatted/'
summary_path = strcat(data_path , 'summary.csv')
summary = importdata(summary_path)
[sl,id,no_of_frames,dur,fps_array,filename] = textread(summary_path,'%s %d %d %s %f %s','delimiter', ',')

for i = 1: size(filename)
    split_array = strsplit(char(filename(i)),'.')
    prefix = split_array(1)
    emg_file = char(strcat(data_path,emg_folder_name,prefix,'_EMG.txt'))
    imu_file = char(strcat(data_path,imu_folder_name,prefix,'_IMU.txt'))
    eating_frames_file = char(strcat(data_path,annotations_folder_name,prefix,'.csv'))
    last_frame = no_of_frames(i)
    fps = fps_array(i)
    SeperateEatingAndNonEatingAction(emg_file,imu_file,eating_frames_file,fps,last_ts,last_frame,output_path)
end
%emg_file = './Data/EMG/1503514028875_EMG.txt'
%imu_file = './Data/IMU/1503514028875_IMU.txt'
%eating_frames_file = 'Vinoth/spoon/1503514028875_pick.txt'


ea1 = importdata("Vinoth/spoon/EatingAction/EA.csv")
ea1(end,end-20:end)'

%%
function SeperateEatingAndNonEatingAction(emg_file,imu_file,eating_frames_file,fps,last_ts,last_frame,output_path)
    emg_csv = csvread(emg_file)
    imu_csv = csvread(imu_file)
    [start_frame,End_frame] = textread(eating_frames_file,'%d %d','delimiter', ',')
    last_ts = emg_csv(end,1)
    End_frame = (End_frame - start_frame)/fps
    start_frame =last_ts - ((last_frame - start_frame)/fps)*1000
    End_frame = start_frame + End_frame*1000
    len = size(start_frame)
    for i = 1 : len
        start_frame(i)<End_frame(i)
        ea_emg = emg_csv(emg_csv(:,1)>start_frame(i) & emg_csv(:,1)<End_frame(i),:)
        ea_imu = imu_csv(imu_csv(:,1)>start_frame(i) & imu_csv(:,1)<End_frame(i),:)
        size(ea_emg)
        size(ea_imu)
        dlmwrite(output_path+"EatingAction/EA.csv",(ea_emg(:,2:end))','delimiter',',','-append')
        dlmwrite(output_path+"/EatingAction/EA.csv",(ea_imu(:,2:end))','delimiter',',','-append')
        if i == 1
            nea_emg = emg_csv(emg_csv(:,1)<start_frame(i),:)
            nea_imu = imu_csv(imu_csv(:,1)<start_frame(i),:)
        elseif i==len
            nea_emg = emg_csv(emg_csv(:,1)>End_frame(i),:)
            nea_imu = imu_csv(imu_csv(:,1)>End_frame(i),:)
        else
            a = End_frame(1) - start_frame(1)
            b = start_frame(2) - End_frame(1)
            nea_emg = emg_csv(emg_csv(:,1)>End_frame(i-1) & emg_csv(:,1)<start_frame(i),:)
            nea_imu = imu_csv(imu_csv(:,1)>End_frame(i-1) & imu_csv(:,1)<start_frame(i),:)
        end
        dlmwrite(output_path+"/NonEatingAction/NEA.csv",(nea_emg(:,2:end))','delimiter',',','-append');
        dlmwrite(output_path+"/NonEatingAction/NEA.csv",(nea_imu(:,2:end))','delimiter',',','-append')
        
    end
end

%% 
%