function [f, Power_average, Power_baseline, Power_target, Power_normalized] = TreDet_fft(X,srate, fq_target)
% Grammar: HSW_fft(mat,srate,fq_baseline,fq_target)
% Adapt fft function to the input data formed as vectors,srate as inner
% sampling rate, in which baseline frequency field and target frequency field are required.This function ffts each raw which represents one time-window data from
% DAQ device and based on each fft results ouput the average power of target frequency normalized to baseline. 
%% 输入处理
% 如果未指定采样频率，则默认使用1000Hz
if nargin ==1
    srate = 1000;
end

% 如果未指定目标频段，则默认统计9~12Hz的目标数值，使用3~6Hz的数值进行归一化
if nargin <= 2
    fq_target = {6 10};
end


%T = 1/srate;             % Sampling period       
L = length(X);             % Length of signal, size(Y,1)返回行数
time_window = 2; %build a time window of 3 seconds
points = time_window*srate; %duration of time window at points
%t = (0:L-1)*T;        % Time vector
X_matrix = reshape(X,points,L/points);
[a, b] = deal(fq_target{:}) ;

Y = fft(X_matrix-mean(X_matrix));
P2=abs(Y/points);
for i = (1:size(P2,2))
    x = P2(:,i);
    P1(:,i) = x(1:points/2+1);
    y = P1(:,i);
    y(2:end-1)=2*y(2:end-1);
end


f = srate*(0:(points/2))/points;
Power_average = mean(P1,2)';%求平均
Power_baseline = trapz(f(1*2:a*2), Power_average(1*2:a*2));  %trapz函数计算曲线积分
Power_target= trapz(f(a*2:b*2), Power_average(a*2:b*2)); %计算目标区域的曲线积分
Power_normalized = (Power_target/Power_baseline); %/(Power_target-Power_baseline); % 归一化处理


end

