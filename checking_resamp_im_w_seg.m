%% 


for i = round(40*z_step):round(70*z_step)
    figure(1); imagesc(Img_rsp(:,:,i)); hold on
    colormap gray
    endo_ctr = contour(endo_a(:,:,round(i/z_step)), 1); 
    endo_ctr = [endo_ctr(2, :)'*x_step endo_ctr(1, :)'*y_step];
    plot(endo_ctr(:, 2), endo_ctr(:, 1), 'bo'); 
    
    epi_ctr = contour(epi_a(:,:,round(i/z_step)), 1); 
    epi_ctr = [epi_ctr(2, :)'*x_step epi_ctr(1, :)'*y_step];
    plot(epi_ctr(:, 2), epi_ctr(:, 1), 'go'); hold off
    waitforbuttonpress
end