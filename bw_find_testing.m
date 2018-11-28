
for i = 52:72
    a1  = epi_a(:,:,i,1);
    
    cent_n = 15;
    smoothness = 5;
    samp_cont_pts = mask2ContourPts(a1, cent_n, smoothness);
    %
    % figure(1); imagesc(a1);
    % plot(samp_cont_pts(:,1), samp_cont_pts(:,2), 'm*');
    waitforbuttonpress
end


%% saving the epi/endo masks properly

for z = z_range(1):z_range(2)
    for t = 2:23
        if endo_update_flag(z, t)
            [z t]
            endo_a_updated(:,:,z,t) = endo_a(:,:,z,t);
        end
        if epi_update_flag(z, t)
            [z t 0000]
            epi_a_updated(:,:,z,t) = epi_a(:,:,z,t);
        end
    end
end