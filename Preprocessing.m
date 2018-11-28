%% DSEC8 Echo Load and 

% cd 'C:\Users\cjswo\Desktop\Duncan Lab\auto_segmentation\DSEC9'

load('endo_1_temp.mat');
load('epi_1_temp.mat');

dd = 0.1928;  %distance in mm in x direction
dh = 0.5799;  %distance in mm in y direction
dw = 0.5784;  %distance in mm in z direction

lv_contour = epi_1_temp - endo_1_temp;  %Outline the left ventricle using endo and epi contours

contour_ind = [];  %determine which slices the masks are located
for i=1:260
    sm = sum(sum(lv_contour(:,:,i)));
    i
    if sm>0
        contour_ind(end+1) = i;
    end
end

% Scale to mm
% shift to postmortem short axis view
shift = permute(lv_contour,[3 2 1]);
scaled_lv_contour = imresize(shift, [dh*size(shift,1) dw*size(shift,2)]);

scaled_lv_contour_dwnsample = scaled_lv_contour(:, :, 1:1/dd:(size(scaled_lv_contour,3)) );

figure(1);
h = contourslice(scaled_lv_contour_dwnsample,[],[],[40 45 50 55 60 65 70 75])
view(3);
axis tight

%% Segment manually on the short axis view....
bw1_epi = roipoly(scaled_lv_contour_dwnsample(:,:,40));
bw1_endo = roipoly(scaled_lv_contour_dwnsample(:,:,40));
bw2_epi = roipoly(scaled_lv_contour_dwnsample(:,:,45));
bw2_endo = roipoly(scaled_lv_contour_dwnsample(:,:,45));
bw3_epi = roipoly(scaled_lv_contour_dwnsample(:,:,50));
bw3_endo = roipoly(scaled_lv_contour_dwnsample(:,:,50));
bw4_epi = roipoly(scaled_lv_contour_dwnsample(:,:,55));
bw4_endo = roipoly(scaled_lv_contour_dwnsample(:,:,55));
bw5_epi = roipoly(scaled_lv_contour_dwnsample(:,:,60));
bw5_endo = roipoly(scaled_lv_contour_dwnsample(:,:,60));
bw6_epi = roipoly(scaled_lv_contour_dwnsample(:,:,65));
bw6_endo = roipoly(scaled_lv_contour_dwnsample(:,:,65));
bw7_epi = roipoly(scaled_lv_contour_dwnsample(:,:,70));
bw7_endo = roipoly(scaled_lv_contour_dwnsample(:,:,70));
bw8_epi = roipoly(scaled_lv_contour_dwnsample(:,:,75));
bw8_endo = roipoly(scaled_lv_contour_dwnsample(:,:,75));

bw_endo = cat(3, bw1_endo,bw2_endo,bw3_endo,bw4_endo,bw5_endo,bw6_endo,bw7_endo,bw8_endo);
bw_epi = cat(3, bw1_epi,bw2_epi,bw3_epi,bw4_epi,bw5_epi,bw6_epi,bw7_epi,bw8_epi);

bw_endo = bw_endo(:,:,1:1/5:size(bw_endo,3));
bw_epi = bw_epi(:,:,1:1/5:size(bw_epi,3));
bw_lv_contour = bw_epi - bw_endo;

save bw_endo
save bw_epi
save bw_lv_contour

%% Make bw_lv_contour same size as bMode
bw_lv_epi_shortaxis = zeros(260,239,541);
bw_lv_epi_upsample = imresize(bw_epi,[260 239]);

bw_lv_epi_shortaxis(:,:,40*round(1/dd)) = bw_lv_epi_upsample(:,:,1);
bw_lv_epi_shortaxis(:,:,45*round(1/dd)) = bw_lv_epi_upsample(:,:,6);
bw_lv_epi_shortaxis(:,:,50*round(1/dd)) = bw_lv_epi_upsample(:,:,11);
bw_lv_epi_shortaxis(:,:,55*round(1/dd)) = bw_lv_epi_upsample(:,:,16);
bw_lv_epi_shortaxis(:,:,60*round(1/dd)) = bw_lv_epi_upsample(:,:,21);
bw_lv_epi_shortaxis(:,:,65*round(1/dd)) = bw_lv_epi_upsample(:,:,26);
bw_lv_epi_shortaxis(:,:,70*round(1/dd)) = bw_lv_epi_upsample(:,:,31);
bw_lv_epi_shortaxis(:,:,75*round(1/dd)) = bw_lv_epi_upsample(:,:,36);

save bw_lv_epi_shortaxis

%% DSEC9 Postmortem
cd 'C:\Users\cjswo\Desktop\Duncan Lab\DSEC9_PM\Inf contours mat'
postmortem_lv = zeros(1400,1400,9);
postmortem_infarct = zeros(1400,1400,9);
layer=1;
for i=1992:2:2008
    i
    depth = num2str(i);
    load(strcat(depth,'.mat'));
    postmortem_lv(:,:,layer) = seg_heart;
    postmortem_infarct(:,:,layer) = seg_infarct;
    layer=layer+1;
end

postmortem_lv = imresize(postmortem_lv,0.0638);
postmortem_lv = postmortem_lv(:,:,1:1/4:size(postmortem_lv,3));
postmortem_infarct = imresize(postmortem_infarct,0.0638);
postmortem_infarct = postmortem_infarct(:,:,1:1/4:size(postmortem_infarct,3));

bw_postmortem_lv = zeros(90,90,33);
bw_postmortem_infarct = zeros(90,90,33);
for i=1:33
    bw_postmortem_lv(:,:,i) = imbinarize(postmortem_lv(:,:,i));
    bw_postmortem_infarct(:,:,i) = imbinarize(postmortem_infarct(:,:,i));
end

%% Plot
figure(1);
subplot(1,2,1);
h = contourslice(bw_lv_contour,[],[],[1 5 10 15 20 25 30 35 40]);
set(h,'EdgeColor','red');
view(3);
title('Echo 3D');
xlabel('mm');
ylabel('mm');
zlabel('mm');
xlim([0 100]);
ylim([0 100]);
axis tight

subplot(1,2,2);
l = contourslice(bw_postmortem_lv,[],[],[1 5 10 15 20 25 30 35 40]);
set(l,'EdgeColor','red');
title('LAD Infarction Post-mortem 3D');
xlabel('mm');
ylabel('mm');
zlabel('mm');
hold on
view(3);
infarct = contourslice(bw_postmortem_infarct,[],[],[1 5 10 15 20 25 30 35 40]);
set(infarct,'EdgeColor','black');
axis tight
hold off
