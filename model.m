%% ===============================================
% Plot Earth
% ===============================
# R_earth = 6371;
# [sx, sy, sz] = sphere(30);

# # figure;
# surf(sx*R_earth, sy*R_earth, sz*R_earth, ...
#     'FaceColor','blue','EdgeColor','none','FaceAlpha',0.3);
# # hold on;


# R_moon = 1737;   % km
# [sx, sy, sz] = sphere(30);

# surf(sx*R_moon, sy*R_moon, sz*R_moon, ...
#     'FaceColor',[0.6 0.6 0.6], ...   % gray
#     'EdgeColor','none','FaceAlpha',0.5);

# R_sun = 696340;   % km
# [sx, sy, sz] = sphere(30);

# surf(sx*R_sun, sy*R_sun, sz*R_sun, ...
#     'FaceColor',[1 0.7 0], ...   % yellow/orange
#     'EdgeColor','none','FaceAlpha',0.8);



function model(body)
    switch body
        case 'Earth'
            R = 6371; % km
            [sx, sy, sz] = sphere(30);
            surf(sx*R, sy*R, sz*R, ...
                'FaceColor','blue','EdgeColor','none','FaceAlpha',0.3);
        case 'Moon'
            R = 1737; % km
            [sx, sy, sz] = sphere(30);
            surf(sx*R, sy*R, sz*R, ...
                'FaceColor',[0.6 0.6 0.6], ...   % gray
                'EdgeColor','none','FaceAlpha',0.5);
        case 'Sun'
            R = 696340; % km
            [sx, sy, sz] = sphere(30);
            surf(sx*R, sy*R, sz*R, ...
                'FaceColor',[1 0.7 0], ...   % yellow/orange
                'EdgeColor','none','FaceAlpha',0.8);
        otherwise
            error('Unknown celestial body: %s', body);
    end
end