%%% Codes for reading and processing the 3D echo images from RF data
% Zhao Liu
% zhao.liu@yale.edu

clc
clearvars;
close all;
tic


%% Input parameters
Ani = 1;
filepath1 = '/Users/lchan/Documents/For Future/DR.Sinusas/Image analysis/Duncan_PSEA/Echo/PSEA1';
FName = sprintf('PSEA%d', Ani);

%%% Read a volume of data
iofun_dir = [filesep 'Users' filesep 'lchan' filesep 'Documents' filesep 'For future' filesep 'DR.Sinusas' filesep  'Image analysis' filesep];
iofun_dir_sub = [ 'Duncan_PSEA' filesep 'Echo' filesep FName filesep];
filepath = [iofun_dir,iofun_dir_sub];
% ext = ['bMode_rfPSEA1POSTGELmi2','.mat'];
ext = ['/bMode_rfPSEA1PREGELmi.mat'];
% ext = ['/bMode_rfPSEA1PREGELmiSA.mat'];
% ext = ['/bMode_rfPSEA1PREGELmiSA2.mat'];
filename = fullfile(filepath, ext);
load(filename);
Image3D = squeeze(bMode);
[m,n,j,Num] = size(Image3D);

%% Display the B-mode images
mid_frame_1  = round(size(bMode,3)/2); % XY 
figure(1);
imagesc(Image3D(:,:, mid_frame_1, 1)); colormap(gray); 

mid_frame_2  = round(size(bMode,2)/2); % XZ
figure(2);
imagesc(squeeze(bMode(:, mid_frame_2, :, 1))); colormap(gray); 

mid_frame_3  = round(size(bMode,1)/2); % YZ
figure(3);
imagesc(squeeze(bMode(mid_frame_3, :, :, 1)));  colormap(gray); 

for image_num = 1:186
filename=strcat('reconimg',num2str(image_num),'.jpg'); 
imwrite(Image3D(1:516,image_num,1:171,1),filename); 
% sprintf('Reconimg%s.tif',num2str(image_num)); %you can delete this if you   want
end

%% Segmentation
% viewer4D
manual_segmentation_gui

% day   = [1 2 3 6];
% inten = [8253 3403 1982 732];
% figure;plot(day,inten,'linewidth',2);
% set(gca,'xtick',0:7)
% xlabel('days');ylabel('Maximum intensity in the injection spot');



