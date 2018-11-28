function [ filled_mask ] = mask_fill( mask_orig, z_range, z_available )
%MASK_FILL Summary of this function goes here
%   Detailed explanation goes here

filled_mask = zeros(size(mask_orig));
show_figs = 0;
for i = z_range(1):z_range(2)
    z_dist = abs(z_available - i);
    [val, idx] = sort(z_dist);
    
    % get linear wts
    wt_1 = val(2)/sum(val(1:2));
    wt_2 = val(1)/sum(val(1:2));
    
    % now average masks
    mask_averaged = get_interp_mask(mask_orig(:,:,z_available(idx(1))), ...
        mask_orig(:,:,z_available(idx(2))), [wt_1 wt_2]);
    filled_mask(:, :, i) = mask_averaged;
    if show_figs
        figure(11); imagesc(mask_orig(:,:,z_available(idx(1)))); title('nearest')
        figure(12); imagesc(mask_orig(:,:,z_available(idx(2)))); title('2nd nearest')
        figure(13); imagesc(mask_averaged); title('average')
        figure(14); waitforbuttonpress
    end
end

end

