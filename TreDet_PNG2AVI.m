function myVideo = TreDet_PNG2AVI(imgPath,imgFormat,FrameRate,VideoName)
%UNTITLED 此处显示有关此函数的摘要
%   此处显示详细说明
 cd(imgPath); %进入目标文件夹
 imagFormat = strcat('*.',imgFormat);
 imgDir  = dir(imagFormat); % 遍历所有png格式文件
 imgLen = length(imgDir);
 images = cell(imgLen,1);%创建图片集元胞数组
 %Nums = cell(imgLen,1)%创建排序号元胞数组用于debug图片排序问题
 
 
 for j = 1:imgLen        % 遍历结构体就可以一一处理图片了
     imgName = imgDir(j).name;%提取图片文件名称
     imgDigit = imgName(isstrprop(imgName,'digit'));%提取每张图片中的数字值用于排序
     imgNum = str2double(imgDigit);%图片的排序数字
     %Nums{imgNum} = imgName; %图片排序元胞数组  
     img = imread(imgName); %读取每张图片     
     images{imgNum} = im2double(img); %imread将图片数据转为unit8格式数值，matlab计算使用64位数值，需要使用im2double
 end


 % create the video writer with 1 fps
 videoName = strcat(VideoName,'.avi');
 writerObj = VideoWriter(videoName);
 writerObj.FrameRate = FrameRate;
 
 % open the video writer
 open(writerObj);
 
 % write the frames to the video
 for u=1:imgLen
     frame = im2frame(images{u}); % convert the image to a frame
     writeVideo(writerObj, frame);
 end
 
 % close the writer object
 close(writerObj);
 
 myVideo = writerObj;

end

