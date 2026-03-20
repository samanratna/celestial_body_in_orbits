% clear everything
clear; clc; close all;

%% ===============================
% Constants
% ===============================
G = 6.667e-20;                 % km^3/kg/s^2
mass_of_earth = 5.9722e24;     

mu = G * mass_of_earth;        % standard gravitational parameter

%% ===============================
% ISS Orbital Elements
% ===============================
a = 6780;                      % km
e = 0.0006;

i = deg2rad(45);               
RAAN = deg2rad(30);            
omega = deg2rad(10);           
theta = deg2rad(0);            

%% ===============================
% Perifocal Frame Function
% ===============================
function [r_pf, v_pf] = bodyInPerifocalFrame(theta, e, mu, a)

    h = sqrt(mu * a * (1 - e^2));
    
    r_pf = (h^2/mu) * (1/(1 + e*cos(theta))) * ...
           [cos(theta); sin(theta); 0];
    
    v_pf = (mu/h) * ...
           [-sin(theta); e + cos(theta); 0];
end

[r_pf, v_pf] = bodyInPerifocalFrame(theta, e, mu, a);

%% ===============================
% Rotation Matrix (Perifocal → ECI)
% ===============================
Q = [ ...
    -sin(RAAN)*cos(i)*sin(omega) + cos(RAAN)*cos(omega), ...
     cos(RAAN)*cos(i)*sin(omega) + sin(RAAN)*cos(omega), ...
     sin(i)*sin(omega);

    -sin(RAAN)*cos(i)*cos(omega) - cos(RAAN)*sin(omega), ...
     cos(RAAN)*cos(i)*cos(omega) - sin(RAAN)*sin(omega), ...
     sin(i)*cos(omega);

     sin(RAAN)*sin(i), ...
    -cos(RAAN)*sin(i), ...
     cos(i)
];

r0 = Q * r_pf;
v0 = Q * v_pf;

%% ===============================
% ODE Function (Two-body dynamics)
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
% Initial State
% ===============================
z0 = [r0; v0];

%% ===============================
% Time Span
% ===============================
tspan = [0 86400];   % 1 day

options = odeset('RelTol',1e-10);

%% ===============================
% Solve ODE
% ===============================
[t, states] = ode45(@(t,z) two_body_ode(t,z,mu), tspan, z0, options);

%% ===============================
% Plot Earth
% ===============================
R_earth = 6371;
[sx, sy, sz] = sphere(40);

figure;
surf(sx*R_earth, sy*R_earth, sz*R_earth, ...
    'FaceColor', 'blue', 'EdgeColor', 'none', 'FaceAlpha', 0.3);
hold on;

%% ===============================
% Plot Orbit
% ===============================
plot3(states(:,1), states(:,2), states(:,3), 'g', 'LineWidth', 1.5);

axis equal;
grid on;

xlabel('X (km)');
ylabel('Y (km)');
zlabel('Z (km)');
title('Two-Body Orbit Simulation (ISS-like Orbit)');