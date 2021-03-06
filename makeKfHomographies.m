function [KF_homographies] = makeKfHomographies(N_planes, KF_image, KF_depths, fx, fy)


KF_homographies = cell(N_planes,1);

h_image = size(KF_image,1);
w_image = size(KF_image,2);

cone_angle_x = atan((w_image/2)/fx);  % half of FOV
cone_angle_y = atan((h_image/2)/fy);  % half of FOV

% Assuming uniform WxH
% output KF_homographies should be changed to KF_scales
for i = 1:N_planes
    d = KF_depths(i);
    frustumHeight = 2 * d * tan(cone_angle_y);
    frustumWidth  = 2 * d * tan(cone_angle_x);

    % "pixels" to meters. d_pixels*scale = d_world
    scale_x = frustumHeight/h_image;   
    scale_y = frustumWidth/w_image;
    if i==1
        scale_x0 = scale_x;
        scale_y0 = scale_y;
    end
%     KF_scaling(i,:) = [scale_x, scale_y];

%         KF_dsi(:,:, i) = KF_image;
    KF_homographies{i} = [scale_x/scale_x0, 0, 0;
                          0, scale_y/scale_y0, 0;
                          0, 0, 1];
end