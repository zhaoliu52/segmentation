load('/home/nripesh/xiaojie_code_data/DAM_3D/images/st2015_410/BMode/bMode_dicom.mat');
load('/home/nripesh/xiaojie_code_data/DAM_3D/images/st2015_410/BMode/bMode_RF.mat');


for i = 20:size(bMode_dicom, 3)-20
    figure(1); imagesc(bMode_dicom(:,:,i,2)); colormap(gray);
    figure(2); imagesc(bMode_RF(:,:,i,2)); colormap(gray);
    waitforbuttonpress
end

%% checking which frame I've draw

for i = 46:76
    imagesc(bMode(:,:,i,1)); colormap(gray); hold on
    contour_endo = contourc(endo(:,:,i,8));
    plot(contour_endo(1,:), contour_endo(2,:)); 
        contour_epi = contourc(epi(:,:,i,8));
    plot(contour_epi(1,:), contour_epi(2,:)); hold off
    waitforbuttonpress
end
    
    
