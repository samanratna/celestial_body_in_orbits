clear; clc; close all;

%% ===============================
% Constants
% ===============================
G = 6.667e-20;
mass_of_earth = 5.9722e24;
mu = G * mass_of_earth;

%% ===============================
% Orbit Radii
% ===============================
r1 = 6780;      % initial orbit (km)
r2 = 12000;     % target orbit (km)

%% ===============================
% Initial Circular Orbit State
% ===============================
r0 = [r1; 0; 0];
v_circ_1 = sqrt(mu/r1);
v0 = [0; v_circ_1; 0];

z0 = [r0; v0];

%% ===============================
% Hohmann Transfer ΔV
% ===============================
dv1 = sqrt(mu/r1) * (sqrt(2*r2/(r1+r2)) - 1);
dv2 = sqrt(mu/r2) * (1 - sqrt(2*r1/(r1+r2)));

fprintf("Delta-V1: %.4f km/s\n", dv1);
fprintf("Delta-V2: %.4f km/s\n", dv2);

%% ===============================
% ODE Function
% ===============================
function dzdt = two_body_ode(t, z, mu)

    r_vec = z(1:3);
    v_vec = z(4:6);

    r = norm(r_vec);

    dzdt = zeros(6,1);
    dzdt(1:3) = v_vec;
    dzdt(4:6) = -mu * r_vec / r^3;
end

%% ===============================
% Burn 1 (at t = 0)
% ===============================
v0_transfer = v0 + [0; dv1; 0];   % tangential burn
z0_transfer = [r0; v0_transfer];

%% ===============================
% Transfer Time (half ellipse)
% ===============================
a_transfer = (r1 + r2)/2;
T_transfer = pi * sqrt(a_transfer^3 / mu);

%% ===============================
% Simulate Transfer Orbit
% ===============================
tspan1 = [0 T_transfer];
[t1, states1] = ode45(@(t,z) two_body_ode(t,z,mu), tspan1, z0_transfer);

%% ===============================
% Burn 2 (at apoapsis)
% ===============================
z_apogee = states1(end,:)';

r_vec2 = z_apogee(1:3);
v_vec2 = z_apogee(4:6);

v_hat = v_vec2 / norm(v_vec2);

v_new = v_vec2 + dv2 * v_hat;

z0_final = [r_vec2; v_new];

options = odeset('RelTol',1e-10);


%% ===============================
% Final Circular Orbit Simulation
% ===============================
tspan2 = [0 20000];
[t2, states2] = ode45(@(t,z) two_body_ode(t,z,mu), tspan2, z0_final, options);

%% ===============================
% Plot Earth
% ===============================
R_earth = 6371;
[sx, sy, sz] = sphere(40);

figure;
surf(sx*R_earth, sy*R_earth, sz*R_earth, ...
    'FaceColor','blue','EdgeColor','none','FaceAlpha',0.3);
hold on;

%% ===============================
% Plot Orbits
% ===============================
plot3(states1(:,1), states1(:,2), states1(:,3), 'r', 'LineWidth', 2); % transfer
plot3(states2(:,1), states2(:,2), states2(:,3), 'g', 'LineWidth', 2); % final

% initial circular orbit (reference)
theta = linspace(0,2*pi,200);
plot3(r1*cos(theta), r1*sin(theta), zeros(size(theta)), 'k--');

axis equal;
grid on;

xlabel('X (km)');
ylabel('Y (km)');
zlabel('Z (km)');
title('Hohmann Transfer Orbit');

legend('Earth','Transfer Orbit','Final Orbit','Initial Orbit');