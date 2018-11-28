%% Find points on the surface of epicardium
dd = 0.1928;  %distance in mm in x direction
dh = 0.5799;  %distance in mm in y direction
dw = 0.5784;  %distance in mm in z direction

load('epi_postmortem_mask.mat')
load('epi_filled.mat')

temp = echo_epi_filled;
echo_epi_filled = imresize(temp, [dh*size(temp,1) dw*size(temp,2)]);
scaled_echo_epi_filled = echo_epi_filled(:, :, 1:1/dd:(size(echo_epi_filled,3)) );

% epi_echo = zeros(151,139,9);
% for i=100:25:300
%     epi_echo(:,:,i/25 - 3) = echo_epi_filled(:,:,i);
% end

[pm_face pm_vert] = isosurface(epi_postmortem,0);

[echo_face echo_vert] = isosurface(scaled_echo_epi_filled,0);

%% Randomly select points on surface to match

pm_lim = size(pm_vert,1);
echo_lim = size(echo_vert,1);

pm_origin = pm_vert;
echo_origin = echo_vert;

pm_vert = zeros(1000,3);
echo_vert = zeros(1000,3);

for i=1:1000
    r1 = randi(pm_lim);
    r2 = randi(echo_lim);
    
    pm_vert(i,:) = pm_origin(r1,:);
    echo_vert(i,:) = echo_origin(r2,:);
end
    
%% Nripesh RPM

x = pm_vert;
y = echo_vert;
t = .1;
iter_no = 3;
display_flag = 1;
dist_lambda = 1;
curv_lambda = 0;
smooth_lambda = .1;
sigma = .1;
[ x_trans, match] = corres_trans_solve_3D( x, y, t, iter_no, display_flag, dist_lambda, curv_lambda,...
    smooth_lambda, sigma);
