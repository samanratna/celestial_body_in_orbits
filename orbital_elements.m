%% main.m
clc;
clear;
close all;

% Add folders to MATLAB path
addpath('data');
addpath('utils');

%% ==========================================
% Select the two orbiting bodies
% body1 = chief
% body2 = deputy
% ==========================================
body1 = get_body_data('moon');
body2 = get_body_data('moon_like');
% body2 = get_body_data('ISS');

%% ==========================================
% Convert orbital elements to ECI state
% ==========================================
[r1_eci, v1_eci] = oe_to_state(body1.a, body1.e, body1.i, body1.Omega, body1.omega, body1.theta, body1.mu); % moon
[r2_eci, v2_eci] = oe_to_state(body2.a, body2.e, body2.i, body2.Omega, body2.omega, body2.theta, body2.mu); % moon_like

% Initial state vectors
z0_1 = [r1_eci; v1_eci];    % moon
z0_2 = [r2_eci; v2_eci];    % moon_like

%% ==========================================
% Time settings
% Use a common time vector so relative motion is computed
% at matching times for both bodies
% ==========================================
T1 = orbital_period(body1.a, body1.mu); % moon
T2 = orbital_period(body2.a, body2.mu); % moon_like

n_periods = 5;
Tf = n_periods * min(T1, T2);
tspan = linspace(0, Tf, 1000);

% ODE solver options
options = odeset('RelTol', 1e-8, 'AbsTol', 1e-9);

%% ==========================================
% Propagate both bodies
% ==========================================
[t1, states1] = ode45(@(t,z) two_body_ode(t, z, body1.mu), tspan, z0_1, options);   % moon

# % get parameters of chief
# n = 1;  % evaluate at initial time
# _r_chief  = states1(n,1:3).';
# _v_chief  = states1(n,4:6).';



[t2, states2] = ode45(@(t,z) two_body_ode_with_thrust(t, z, body2.mu), tspan, z0_2, options);   % moon_like

%% ==========================================
% Plot absolute trajectories in ECI
% ==========================================
figure;
hold on;
grid on;
axis equal;
view(3);

model('Earth');

plot3(states1(:,1), states1(:,2), states1(:,3), 'b', 'LineWidth', 1.5); % blue is moon
plot3(states2(:,1), states2(:,2), states2(:,3), 'r', 'LineWidth', 1.5); % red is moon_like (thrust applied to red)
plot3(states1(1,1), states1(1,2), states1(1,3), 'bo', 'MarkerFaceColor', 'b', 'MarkerSize', 10);
plot3(states2(1,1), states2(1,2), states2(1,3), 'ro', 'MarkerFaceColor', 'r', 'MarkerSize', 5);

xlabel('x (km)');
ylabel('y (km)');
zlabel('z (km)');
title('Two Bodies Orbiting Earth');

# legend(body1.name, body2.name, [body1.name ' Chief'], [body2.name ' Deputy'], 'Location', 'best');

hold off;

%% ==========================================
% ROE of body2 with respect to body1 at initial time
% chief = body1
% deputy = body2
% ==========================================
mu = body1.mu;   % both should orbit the same central body

k = 1;  % evaluate at initial time

r_chief  = states1(k,1:3).';
v_chief  = states1(k,4:6).';
r_deputy = states2(k,1:3).';
v_deputy = states2(k,4:6).';

# roe = chief_deputy_to_ROE(r_chief, v_chief, r_deputy, v_deputy, mu);

# disp('ROE of body2 with respect to body1 at initial time:')
# disp(roe)

%% ==========================================
% Relative motion of body2 with respect to body1
% rel21 = [x y z xdot ydot zdot] in LVLH of body1
% ==========================================
N = min(size(states1,1), size(states2,1));
rel21 = zeros(N, 6);

for k = 1:N

    % chief
    r1 = states1(k,1:3).';
    v1 = states1(k,4:6).';

    % deputy
    r2 = states2(k,1:3).';
    v2 = states2(k,4:6).';

    % position of deputy relative to chief in chief LVLH frame
    rel21(k,:) = eci_to_lvlh_relative_state(r1, v1, r2, v2).';
end

disp('Size of rel21:')
disp(size(rel21))

disp('Size of r1 states1:')
disp(size(states1(:,1:3)))

%% ==========================================
% ROE history of body2 with respect to body1
% ==========================================
roe_hist.xr  = zeros(N,1);
roe_hist.yr  = zeros(N,1);
roe_hist.ar  = zeros(N,1);
roe_hist.Er  = zeros(N,1);
roe_hist.Az  = zeros(N,1);
roe_hist.psi = zeros(N,1);

for k = 1:N
    roe_k = chief_deputy_to_ROE( ...
        states1(k,1:3).', states1(k,4:6).', ...
        states2(k,1:3).', states2(k,4:6).', ...
        mu);

    roe_hist.xr(k)  = roe_k.xr;
    roe_hist.yr(k)  = roe_k.yr;
    roe_hist.ar(k)  = roe_k.ar;
    roe_hist.Er(k)  = roe_k.Er;
    roe_hist.Az(k)  = roe_k.Az;
    roe_hist.psi(k) = roe_k.psi;
end

%% ==========================================
% Diagnostics
% ==========================================
disp('Initial difference in ECI position [km]:')
disp(r2_eci - r1_eci)

disp('Initial difference in ECI velocity [km/s]:')
disp(v2_eci - v1_eci)

disp('Max absolute relative state values:')
disp(max(abs(rel21), [], 1))

disp('Any NaNs in rel21?')
disp(any(isnan(rel21), 'all'))

%% ==========================================
% 3D Relative motion plot
% Convention used for plotting:
% x-axis = along-track y
% y-axis = radial x
% z-axis = cross-track z
% ==========================================
figure;
hold on;
grid on;
axis equal;
view(3);

plot3(rel21(:,2), rel21(:,1), rel21(:,3), 'm-', 'LineWidth', 2);
plot3(rel21(1,2), rel21(1,1), rel21(1,3), 'ko', 'MarkerFaceColor', 'k', 'MarkerSize', 8);

xlabel('Along-track y (km)');
ylabel('Radial x (km)');
zlabel('Cross-track z (km)');
title('Relative Motion of Body 2 with Respect to Body 1');

legend('Body 2 wrt Body 1', 'Start', 'Location', 'best');
hold off;

disp("Size of rel21:")
disp(size(rel21))

%% ==========================================
% ROE plots
% ==========================================
figure;

subplot(3,2,1);
plot(t1(1:N), roe_hist.xr, 'LineWidth', 1.5);
grid on;
# axis equal;
xlabel('Time (s)');
ylabel('x_r (km)');
title('ROE History: x_r');

subplot(3,2,2);
plot(t1(1:N), roe_hist.yr, 'LineWidth', 1.5);
grid on;
# axis equal;
xlabel('Time (s)');
ylabel('y_r (km)');
title('ROE History: y_r');

subplot(3,2,3);
plot(t1(1:N), roe_hist.ar, 'LineWidth', 1.5);
grid on;
# axis equal;
xlabel('Time (s)');
ylabel('a_r (km)');
title('ROE History: a_r');

subplot(3,2,4);
plot(t1(1:N), unwrap(roe_hist.Er), 'LineWidth', 1.5);
grid on;
# axis equal;
xlabel('Time (s)');
ylabel('E_r (rad)');
title('ROE History: E_r');

subplot(3,2,5);
plot(t1(1:N), (roe_hist.Az)', 'LineWidth', 1.5);
grid on;
# axis equal;
xlabel('Time (s)');
ylabel('A_z (km)');
title('ROE History: A_z');

subplot(3,2,6);
plot(t1(1:N), unwrap(roe_hist.psi), 'LineWidth', 1.5);
grid on;
# axis equal;
xlabel('Time (s)');
ylabel('\psi (rad)');
title('ROE History: \psi');
