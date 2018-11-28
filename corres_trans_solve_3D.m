function [ x_trans, match] = corres_trans_solve_3D( x, y, t, iter_no, display_flag, dist_lambda, curv_lambda,...
    smooth_lambda, sigma)
%CORRES_TRANS_SOLVE_3D solves the correspondance and transformation problem
% for two given point sets. 
%
% ------------------------------------------------------------------
% This algorithm uses fuzzy correspondence based matching to solve for
% correspondance. A matrix optimization routine is called to solve for a
% stochastic correspondence matrix. Radial basis functions are
% used for the transformation.
% ------------------------------------------------------------------
%
%   date: (8/1/2014)
%   author: Nripesh Parajuli (nripesh.parajuli@yale.edu)
%           (adapted from Haili Chui, Anand Rangarajan cmix.m)
%   --------------------
%   inputs: 
%   --------------------
%         x - set of points that we want to transform to y.
%         y - set of points x warps to
%         t - 'annealing temperature', the regularization term for the
%               entropy component of the optimization 
%               high t -> fuzzier?   low t > less fuzzy?
%         display_flag - set 1 to display images     
%         dist_lambda - weight on the distance match metric
%         curv_lambda - weight on the curvature match metric
%         smooth_lambda - transformation smoothness control parameter
%
%   --------------------
%   outputs: 
%   --------------------
%         x_trans - transformed x values, that should closely match y.  
%         k_x, k_y - curvatures
%

%% first thing the points ought to be normalized
x_scale = max(x) - min(x);
y_scale = max(y) - min(y);
x_mean = mean(x);
y_mean = mean(y);
x = bsxfun(@minus, x, x_mean);
y = bsxfun(@minus, y, y_mean);
x = bsxfun(@rdivide, x, x_scale);
y = bsxfun(@rdivide, y, y_scale);


% this is to allow some flexibility on the one-to-one constraint
MATCH_FLEX = .95; % 1 means no flexibility

counter = 0;
x_trans = x;

if display_flag
    figure(2); plot3(x(:, 1), x(:, 2), x(:, 3), 'g.'); hold on
    plot3(y(:, 1), y(:, 2), y(:, 3), 'r.'); hold off
    legend('x norm', 'y norm');
end

% loop until a number of iterations or a good match obtained
while (1) 
    fx = x_trans;
    
    % distance matrix
    point_dist  = zeros(size(fx, 1), size(y,1));
    dim         = 3;
    for i=1:dim
        point_dist = point_dist + ...
            (fx(:,i)*ones(1, size(y,1)) - ones(size(fx,1), 1) * y(:,i)').^2;
    end
    
    % just as placeholder for the future
    curv_diff = zeros(size(point_dist));

    
    %% entropy based correspondance solving using convex optimization 
    cvx_begin quiet
    %         cvx_solver mosek
        variable match(size(fx, 1), size(y, 1))
        minimize (sum(match(:).*(dist_lambda*point_dist(:))) + t*sum(entr_fake(match(:))))
        subject to
            match >= 0
            MATCH_FLEX*size(x,1)/size(y,1) <= sum(match, 1) <= (1/MATCH_FLEX)*size(y,1)/size(x,1)
            sum(match, 2) == 1
    cvx_end  
        
    fprintf('distance times match sum: %f \n', sum(match(:).*(dist_lambda*point_dist(:))))  
    fprintf('t times sum entropy: %f \n', t*sum(entr_fake(match(:))))
    fprintf('sum entropy: %f \n', sum(entr_fake(match(:))))
    
     if display_flag
         %         figure(11); imagesc(shape_dist); title('shape dist')
        figure(12); imagesc(point_dist); title('euclid dist')
        figure(13); imagesc(match)
    end


    %% warp points based on the current match matrix
    if ~strcmp(cvx_status, 'Failed')
        trans_x = match*y;
        x_trans = warp_points(x, trans_x, sigma, smooth_lambda);
        if display_flag
            figure(4); plot3(x(:, 1), x(:, 2), x(:, 3), 'r.'); hold on
            plot3(x_trans(:, 1), x_trans(:, 2), x_trans(:, 3), 'g.');
            %             plot3(trans_x(:, 1), trans_x(:, 2), trans_x(:, 3), 'k.');
            plot3(y(:, 1), y(:, 2), y(:, 3), 'b.'); hold off
            legend('orig x', 'moved x smooth', 'fixed y')
            
            pause(.1)
            display('press button to continue')
            %             figure(5); waitforbuttonpress
        end
        t = t/5;
        fprintf ('refining\n')
        counter = counter + 1;
    else
        fprintf ('failed at this level, trying with smaller t')
        t = t/5;
        x_trans = x;
    end
    
    % if error low or certain number of iterations have been done
    % ,terminate
    if counter == iter_no 
        display('done')
        break
    end
end

x_trans = bsxfun(@times, x_trans, y_scale);
x_trans = bsxfun(@plus, x_trans, y_mean);

end

     
%% transforming the given points towards target according to the match matrix
function [x_trans] = warp_points(X, Y, sigma, lambda)
HH = get_design_matrix_3d(X', X', sigma);
disp = Y-X;
PP = HH'*HH;
x_trans(:,1) = X(:, 1) + HH*((PP + lambda*eye(size(PP, 1)))\HH'*disp(:, 1));
x_trans(:,2) = X(:, 2) + HH*((PP + lambda*eye(size(PP, 1)))\HH'*disp(:, 2));
x_trans(:,3) = X(:, 3) + HH*((PP + lambda*eye(size(PP, 1)))\HH'*disp(:, 3));
end



%%  GET_DESIGN_MATRIX returns the radial basis design matrix when the basis
% centers, sample locations and the basis width are provided.
function P = get_design_matrix_3d( x_samp, x_cent, sig)

if(numel(sig) == 1)
    sig = zeros(size(x_cent, 2), 1) + sig;
end


P = zeros(size(x_samp, 2), size(x_cent, 2));
x_samp_x = x_samp(1, :);
x_samp_y = x_samp(2, :);
x_samp_z = x_samp(3, :);

x_cent_x = x_cent(1, :);
x_cent_y = x_cent(2, :);
x_cent_z = x_cent(3, :);

% penalize the z distances more?
for j = 1:size(x_cent, 2)
    r = (x_cent_x(j) - x_samp_x).^2/(sig(j)^2) +...
        (x_cent_y(j) - x_samp_y).^2/(sig(j)^2) + ...
        (x_cent_z(j) - x_samp_z).^2/(sig(j)^2*.1);
    P(:, j) = .25*max(1-r,0).^4.*(3*r.^3 + 12*r.^2 + 16*r + 4);
end

end

%% the replacement function of the entropy term
function y = entr_fake(x)
    y = 2*x.*(x-1);
end
