clc;
clear;
close all;

%% ===============================
% Moon Orbital Elements (about Earth)
% ===============================

a = 384400;               % km
e = 0.0549;
i = deg2rad(18.3);        % inclination (equatorial frame)
Omega = deg2rad(10.08);  % RAAN
omega = deg2rad(318.15);  % argument of perigee
theta = deg2rad(135);     % chosen true anomaly

mu = 398600;              % Earth gravitational parameter (km^3/s^2)

% %% ===============================
% % Earth Orbital Elements (around Sun)
% % ===============================
% 
% a = 149597870;            % km (1 AU)
% e = 0.0167;
% i = deg2rad(0.00005);     % nearly zero inclination
% Omega = deg2rad(-11.26064);
% omega = deg2rad(102.94719);
% theta = deg2rad(100);     % chosen example true anomaly
% 
% mu = 1.32712440018e11;    % Sun gravitational parameter (km^3/s^2)

% % ===============================
% ISS Orbital Elements (around Earth)
% ===============================
% 
% a = 6780;                 % km  (~400 km altitude)
% e = 0.0006;               % nearly circular
% i = deg2rad(51.64);       % ISS inclination
% Omega = deg2rad(0);       % choose reference
% omega = deg2rad(0);       % undefined for circular orbit
% theta = deg2rad(45);      % chosen position
% 
% mu = 398600;              % Earth gravitational parameter (km^3/s^2)

% Compute angular momentum
h = sqrt(mu * a * (1 - e^2));

%% ===============================
% Step 1: Position in Perifocal Frame (PQW)
% ===============================

r_pf = (h^2/mu) * (1/(1 + e*cos(theta))) * ...
       [cos(theta);
        sin(theta);
        0];

%% ===============================
% Step 2: Velocity in Perifocal Frame
% ===============================

v_pf = (mu/h) * ...
       [-sin(theta);
        e + cos(theta);
        0];

%% ===============================
% Step 3: Rotation Matrix PQW → ECI
% ===============================

R3_Omega = [ cos(Omega)  sin(Omega) 0;
            -sin(Omega)  cos(Omega) 0;
             0           0          1];

R1_i = [1 0 0;
        0 cos(i) sin(i);
        0 -sin(i) cos(i)];

R3_omega = [ cos(omega)  sin(omega) 0;
            -sin(omega)  cos(omega) 0;
             0           0          1];

Q_pqw_to_eci = R3_Omega * R1_i * R3_omega;

%% ===============================
% Step 4: Convert to ECI
% ===============================

r_eci = Q_pqw_to_eci * r_pf;
v_eci = Q_pqw_to_eci * v_pf;

% disp('Moon Position Vector in ECI (km):')
% disp(r_eci)
% 
% disp('Moon Velocity Vector in ECI (km/s):')
% disp(v_eci)~

%% ===============================
% Step 5: Generate Full Orbit
% ===============================

theta_vals = linspace(0, 2*pi, 800);
r_pf_all = zeros(3,length(theta_vals));

for k = 1:length(theta_vals)

    theta_k = theta_vals(k);
    r_scalar = (h^2/mu) * (1/(1 + e*cos(theta_k)));

    r_pf_all(:,k) = r_scalar * [cos(theta_k);
                                sin(theta_k);
                                0];
end

r_eci_all = Q_pqw_to_eci * r_pf_all;

%% ===============================
% Step 6: 3D Visualization
% ===============================

figure
hold on
grid on
axis equal

% Plot Moon orbit
plot3(r_eci_all(1,:), r_eci_all(2,:), r_eci_all(3,:), ...
      'b','LineWidth',1.5)

% Plot Earth
Re = 6378;  % km
[X,Y,Z] = sphere(50);
surf(Re*X, Re*Y, Re*Z, ...
     'FaceAlpha',0.3, ...
     'EdgeColor','none')

% % Plot current Moon position
% quiver3(0,0,0, r_eci(1), r_eci(2), r_eci(3), ...
%         'r','LineWidth',2)

xlabel('X (km)')
ylabel('Y (km)')
zlabel('Z (km)')
title('Orbital Elements Visualization (ECI Frame)')

view(3)

# figure_handle = figure();
# set(figure_handle, 'units', 'normalized', 'outerposition', [0 0 1 1]);