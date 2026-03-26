%% ===============================================
% Plot Earth
% ===============================
R_earth = 6371;
[sx, sy, sz] = sphere(40);

figure;
surf(sx*R_earth, sy*R_earth, sz*R_earth, ...
    'FaceColor','blue','EdgeColor','none','FaceAlpha',0.3);
hold on;