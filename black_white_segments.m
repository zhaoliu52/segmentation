
%n=0 but the start image is slice 56

% while n<0
%
% figure(n+56); imagesc(endo(:,:,56+n,1)); colormap gray
%
% figure(n+57); imagesc(endo(:,:,56+n,1)); colormap gray
% n=n+2
% end

load('st2015_164_endo_m.mat')
load('st2015_164_epi_m.mat')
load('bmode.mat')

n=1;
myo_outline=epi(:,:,55+n,1)-endo(:,:,55+n,1);%starting at slide 56
figure(1); imagesc(myo_outline); colormap gray
X=cell2mat(bwboundaries(myo_outline));
X(:,3)=n;
size(X);

Y=X;
Y(:,3)=n+1;
Z=[X;Y];
tot=Z;
n=n+2;

while n<22
    
    myo_outline=epi(:,:,55+n,1)-endo(:,:,55+n,1);%starting at slide 56
    %figure(1); imagesc(myo_outline); colormap gray
    X=cell2mat(bwboundaries(myo_outline));
    X(:,3)=n;
    size(X);
    
    Y=X;
    Y(:,3)=n+1;
    J=[X;Y];
    tot=[tot;J];
    n=n+2;
end
rotate3d on
size(tot)
figure(2); scatter3(tot(:,1),tot(:,2),tot(:,3))



%patch= [tot(1,1)-6:tot(1,1)+6;tot(1,2)-6:tot(1,2)+6;tot(1,3)-6:tot(1,3)+6]

%figure(3); scatter3(patch(1,:),patch(2,:),patch(3,:))--ignore this
sz = 6;%so the dimensions of patch are 13
clear X_patch Y_patch
X_patch = zeros(size(tot, 1), sz*2+1, sz*2+1, sz*2+1);
Y_patch = zeros(size(tot, 1), sz*2+1, sz*2+1, sz*2+1);
myo_mask = epi-endo;
for i = 1:size(tot, 1)
    patchX = bMode(tot(i,1)-sz:tot(i,1)+sz,tot(i,2)-sz:tot(i,2)+sz,tot(i,3)-sz+55:tot(i,3)+sz+55, 1);%plus 56- starting at slide 56
    X_patch(i, :, :, :) = patchX;
    
    patchY = myo_mask(tot(i,1)-sz:tot(i,1)+sz,tot(i,2)-sz:tot(i,2)+sz,tot(i,3)-sz+55:tot(i,3)+sz+55, 1);%plus 56- starting at slide 56
    Y_patch(i, :, :, :) = patchY;
    
end

%example patch
rand_i = randsample(length(X_patch), 1);
figure(3); imagesc(squeeze(X_patch(rand_i,:,:,7))); colormap gray
figure(4); imagesc(squeeze(Y_patch(rand_i,:,:,7))); colormap gray

% X_p(:, 1, :, :, :) = X_patch;
% Y_p(:, 1, :, :, :) = Y_patch;
% X_patch = X_p;
% Y_patch = Y_p;
% save('data_patches_1', 'X_patch', 'Y_patch')
