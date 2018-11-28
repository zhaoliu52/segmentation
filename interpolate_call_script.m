%% endo 
clear
load bw_lv_endo_shortaxis

z_range = [125 300];
z_available = 125:25:300;
echo_endo_filled = mask_fill( bw_lv_endo_shortaxis, z_range, z_available );
save echo_endo_filled echo_endo_filled


%% epi
clear 
load bw_lv_epi_shortaxis

z_range = [200 375];
z_available = 200:25:375;
echo_epi_filled = mask_fill( bw_lv_epi_shortaxis, z_range, z_available );
save epi_filled echo_epi_filled


%% mask is epi - endo

load epi_filled
load endo_filled
load bw_lv_shortaxis

echo_mask_filled = echo_epi_filled - echo_endo_filled;

for i = 100:5:300
    figure(1); imagesc(echo_mask_filled(:, :, i)); 
    figure(2); imagesc(bw_lv_shortaxis(:, :, i));
    figure(3); waitforbuttonpress
end

save echo_mask_filled echo_mask_filled 

%% postmortem epi

z_range = [1 33];
z_available = [1 5 10 15 20 25 30 33];

postmortem_epi = zeros(90,90,33);
for i=1:size(bw_postmortem_lv,3)
    postmortem_epi(:,:,i) = imfill(bw_postmortem_lv(:,:,i),'holes');
end

epi_postmortem = mask_fill(postmortem_epi, z_range, z_available );

save epi_postmortem_mask epi_postmortem
%% postmortem infarct
z_range = [1 33];
z_available = [1 3 8 11 15 19 23 27 31];

postmortem_infarct = zeros(90,90,33);
for i=1:size(bw_postmortem_infarct,3)
    postmortem_infarct(:,:,i) = imfill(bw_postmortem_infarct(:,:,i),'holes');
end

infarct_postmortem = mask_fill(postmortem_infarct, z_range, z_available );

save postmortem_infarct_mask infarct_postmortem