function output = TreDet_RAW2PNG(path,format)
%UNTITLED2 此处显示有关此函数的摘要
%   此处显示详细说明
 cd(path);
 imgDir = dir('*.raw'); %读取当前文件夹所有RAW文件
 imgLen = length(imgDir); %当前文件夹RAW文件总个数
 row = 1024;
 col = 1280;
 
 for i = 1:imgLen
     filename = imgDir(i).name;
     fileID = fopen(filename,'r');
     errmsg = '';
        while fileID < 0 
           disp(errmsg);
           filename = input('Open file: ', 's');
           [fileID,errmsg] = fopen(filename);
        end
     sizeA = col*row*3; 
     I = fread(fileID, sizeA,'uint8=>uint8'); %// Read in as a single byte stream
     I = reshape(I, [col, row,3]); %// Reshape so that it's a 3D matrix - Note that this is column major
     Ifinal = flip(I,2); % // The clever transpose
     imgName = strcat(filename(1:end-4),'.',format);
     %imshow(Ifinal);
     imwrite(Ifinal,imgName); %将图片储存为format指定格式
     fclose(fileID); %// Close the file
 end

 disp("Finish!");
 
end

