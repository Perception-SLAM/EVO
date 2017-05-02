function [KF_DSI] =  UpdateDSI(KF_DSI, event_image, T_kf, T_i, KF_depths, calib)
 
% Transformation_to_KF should transform an event_image in to th keyframe
% event_image is 180x240(original) or 231x309 (corrected)

cx = calib.cx; cy = calib.cy;
fx = calib.fx; fy = calib.fy;
K = [fx,  0, cx;
      0, fy, cy;
      0,  0,  1];

n_planes = size(KF_DSI,3);

T_i_in_kf = T_kf \ T_i;
R = T_i_in_kf(1:3,1:3);
t = T_i_in_kf(1:3,4);

n = [0, 0, -1]';

imref_obj = imref2d([size(KF_DSI,1),size(KF_DSI,2)]);

for i=1:n_planes
    H_z2i = K * (R' + (R'*t*n')./KF_depths(i)) / K;
    H = inv(H_z2i);

    tform = projective2d(H');
    event_im_KF = imwarp(double(event_image), tform, 'nearest', 'OutputView', imref_obj);   
    KF_DSI(:,:,i) = KF_DSI(:,:,i) + event_im_KF;
end


end