%% Sample use of yuvRead

pkg load image

clc; clear; close all;


% Set the video information
folderPathImage ='./Image/';
mkdir([folderPathImage,'/png/']);
width  = 176;
height = 144;
nFrame = 300;
output_width = 256;
output_height = 256;


% Show sample frames

c = 0;  % counter
files = dir([folderPathImage,'*.txt']);
for file = files'
    disp(file.name);
    [pathstr,name,ext] = fileparts(file.name);
    %subplot(4,5,c), imshow(Y(:,:,iFrame));
    %title(['frame #', num2str(iFrame)]);
    %inputName = [folderPathImage,yuvName,'_frame_',num2str(c),'_gray','.txt'];
    % New txt file creation
    disp(file.name);
    fid = fopen([folderPathImage,file.name], 'r');
    disp(fid);
    %s = dir([folderPathImage,file.name]);
    %disp(s.bytes);
   % if s.bytes < 10
    %  continue;
    %end
    %if fseek(fid, 1, 'bof') == -1
    %    continue;
    %end
    % Hex value write to the txt file
    i = 0;
    A = [];
    %readFailed = 0;
   while i < output_height 
      
      X = fscanf(fid, '%d',output_width);
      if size(X') < output_width 
        diff = output_width - length(X);
        %disp(diff);
        help = ones(diff,1);
        %disp(help);
        X = vertcat(X,help); 
        %disp(size(X));
      end     
      %disp(X);
      
        if i == 0
          A = X';
          %disp(size(X'));
          %disp(A);
        else
          %A = [A;X'];
          %disp(size(A));
          %disp(size(X));
          A = vertcat(A,X');
        end
        i = i +1;
        
     % else 
       % disp(X');
        %disp(i);
       % readFailed = 1;
        
      %end
   end
   
   %if readFailed == 0
    %disp(A);
    fclose(fid);
    outputNamePng = [folderPathImage,'png/',name,'.png'];
    disp(outputNamePng);
    %Y = imread([folderPathImage,'gray2.png']);
    %disp(Y);
    %disp(A);
    %rot90(A,1);
    
    A = mat2gray(A);
    A = imresize(A,[output_width output_height]);
    A = imrotate(A,0)
    %rot90(A,1);
    imwrite(A,outputNamePng,'png');
   %end
end
