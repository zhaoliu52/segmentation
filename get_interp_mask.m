function mask_interp = get_interp_mask(mask_slice_1, mask_slice_2, wts)


mask_slice_1_dil = imdilate(mask_slice_1, strel('disk', 1));
mask_slice_2_dil = imdilate(mask_slice_2, strel('disk', 1));
mask_1_dist_map = bwdist(mask_slice_1) - bwdist(~mask_slice_1_dil);
mask_2_dist_map = bwdist(mask_slice_2) - bwdist(~mask_slice_2_dil);

% first check if reverse mapping exists
DIST_THRESH = 1;

[xx, yy] = meshgrid(1:size(mask_1_dist_map, 2), 1:size(mask_1_dist_map, 1));

%% now try interpolating

mask_interp_dist_map = wts(1)*mask_1_dist_map + wts(2)*mask_2_dist_map;
mask_interp_inds = find(abs(mask_interp_dist_map) < DIST_THRESH);
mask_interp_pts = [yy(mask_interp_inds) xx(mask_interp_inds)];

K = convhull(mask_interp_pts(:, 1), mask_interp_pts(:, 2));
mask_interp_hull = mask_interp_pts(K, :);
mask_interp = poly2mask(mask_interp_hull(:, 2), mask_interp_hull(:, 1), size(xx, 1), size(xx, 2));

show_figs = 0;
if show_figs
    mask_1_zero_inds = find(abs(mask_1_dist_map) < DIST_THRESH);
    mask_2_zero_inds = find(abs(mask_2_dist_map) < DIST_THRESH);
    
    mask_1_zero_pts = [yy(mask_1_zero_inds) xx(mask_1_zero_inds)];
    mask_2_zero_pts = [yy(mask_2_zero_inds) xx(mask_2_zero_inds)];
    
    figure(1); imagesc(mask_slice_1)
    figure(2); imagesc(mask_slice_2)
    figure(5); plot(mask_1_zero_pts(:, 1), mask_1_zero_pts(:, 2), 'r.'); hold on
    plot(mask_2_zero_pts(:, 1), mask_2_zero_pts(:, 2), 'g.'); hold off
    figure(6); imagesc(mask_interp_dist_map)
    figure(7); plot(mask_1_zero_pts(:, 1), mask_1_zero_pts(:, 2), 'r.'); hold on
    plot(mask_2_zero_pts(:, 1), mask_2_zero_pts(:, 2), 'g.');
    plot(mask_interp_pts(:, 1), mask_interp_pts(:, 2), 'b.');  hold off
    figure(8); imagesc(mask_interp)
end

end