clear all;
clc;
filename={dir('*.xlsx').name, dir('*.txt').name}; %读取xlsx文件名

%% 参数设定
Fs=1000; %采样率
RowName = {'FileName';'Mean';'Power of baseline';'Power of  target';'Normalized target Power'}; %设置导出文件的行名
ParentFileName = strsplit(pwd,'\');%取当前文件夹的名字作为导出文件的文件名
SaveDataName = strcat(cell2mat(ParentFileName(end)),'.xls');
SaveSpaceName = strcat(cell2mat(ParentFileName(end)));
writecell(RowName,SaveDataName,'Sheet',1,'Range','A1:A5');

%Duration=1; % in seconds 窗时间长
%L=Duration*Fs;%窗内的采样点数
%t=(0:L-1)/Fs;%每个采样点对应的时间点
%f=Fs*(0:(L/2))/L;
%no_of_minutes=1; %选取的数据段的时间长度

FileName_set = {};
RawData_set = {};
Power_set = {};
NormalizedTargetPower_set = {};
f_set = {};



for fileNum = 1:length(filename)
    fileName=filename{fileNum};
    %RawData=HSW_importfile(fileName,startRow, endRow);
   %Data_win=enframe(RawData,boxcar(L))';%以每个时间窗做一行\
    %Data_win = reshape(Raw_Data, L, ceil(length(Raw_Data)/L));
    %Y=fft(Data_win);%对每个窗做FFT，得到每个频率的幅值
    if contains(fileName, 'txt')
        [A,B] = textread(fileName, '%s %n', 'delimiter', '|', 'headerlines',1);
        Raw_Data = B;
    else
        Raw_Data = readtable(fileName);
        Raw_Data = Raw_Data(:,2);
        Raw_Data = table2array(Raw_Data);
    end

    Mean = mean(Raw_Data);
    %matRawData = reshape(Raw_Data, [length(Raw_Data)/L, L])';
    [f, Power, Power_baseline, Power_target, Power_normalized] = TreDet_fft(Raw_Data,Fs,{5 12});
    split_str = strsplit(fileName,'.');
    matname=split_str{1}; % 去掉文件名中的文件格式后缀以方便可视化
    %save(matname,'Raw_Data','Power','Power_baseline','Power_target')
    saved = {strcat(matname);Mean;Power_baseline;Power_target;Power_normalized};
    
    %fft_Figure = figure;
    %plot(f,Power);
    %xlim([0 50]);
    %ylim([0 0.006]);
    %title(matname);
    %xlabel('Frequency (Hz)');
    %ylabel('Amplitude');
    %print(gcf,'-dpng',strcat(matname,'.png')) ;
    %set(fft_Figure, 'visible', 'off');
    
    
    abcValue = TreDet_num2abc2(fileNum+1);
    writing_range = strcat(abcValue,'1',':',abcValue,'5');
    writecell(saved,SaveDataName,'Sheet',1,'Range',writing_range);
  
    FileName_set{fileNum} = matname;
    RawData_set{fileNum} = Raw_Data;
    Power_set{fileNum} = Power;
    f_set{fileNum} = f;
    NormalizedTargetPower_set{fileNum} = Power_normalized;
    
end


save(SaveSpaceName,'*_set');
disp("Processing Finished without Error!!!")


%% plot each data on one figure
figure
for i = 1:length(FileName_set)
    plot(f_set{i}, Power_set{i})
    hold on
end
legend(FileName_set, 'Location','northeast','NumColumns',1)
xlim([0 50])
ylim([0 0.004]) 


 
   