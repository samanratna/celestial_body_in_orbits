% clean start
clc;
clear;
close all;

% get values of constant parameters
load_constants;

# -------------------------------------------------------------------------------
# Get position and velocity using orbital elements (e, a, i, Omega, omega, theta)
# -------------------------------------------------------------------------------
% Compute angular momentum
h = sqrt(mu * a * (1 - e^2));

% Position in Perifocal Frame
r_pf = (h^2/mu) * (1/(1 + e*cos(theta))) * ...
       [cos(theta);
        sin(theta);
        0];

% Velocity in Perifocal Frame
v_pf = (mu/h) * ...
       [-sin(theta);
        e + cos(theta);
        0];

% Rotation Matrix from Perifocal to ECI
Q_argument_of_perigee = [ 
        cos(Omega)  sin(Omega) 0;
        -sin(Omega)  cos(Omega) 0;
        0           0          1];

Q_inclination = [
        1 0 0;
        0 cos(i) sin(i);
        0 -sin(i) cos(i)];

Q_right_ascension_of_ascending_node = [
        cos(omega)  sin(omega) 0;
        -sin(omega)  cos(omega) 0;
        0           0          1];

Q = Q_argument_of_perigee * Q_inclination * Q_right_ascension_of_ascending_node;

% Represent the position and velocity in ECI frame
r_eci = Q * r_pf;
v_eci = Q * v_pf;

# -------------------------------------------------------------------------------
# ODE45 Function Definition for Two-Body Problem
# -------------------------------------------------------------------------------
function dzdt = two_body_ode(t, z, mu)

    r_vec = z(1:3);
    v_vec = z(4:6);

    r = norm(r_vec);            # magnitude of postition vector

    dzdt = zeros(6,1);
    dzdt(1:3) = v_vec;
    dzdt(4:6) = -mu * r_vec / r^3;
end

# -------------------------------------------------------------------------------
# ODE45 Function Parameters
# -------------------------------------------------------------------------------
initial_condition = [r_eci; v_eci];                     # initial state vector (position and velocity)
T = 2 * pi * sqrt(a^3/mu);                              # orbital period (in seconds)
tspan = [0 T];                                          # time span for one full orbit
options = odeset('RelTol',1e-8,'AbsTol',1e-9);          # tolerance settings for ODE solver

# Call ODE45 function
[t, states] = ode45(@(t,z) two_body_ode(t,z,mu), tspan, initial_condition, options);

# configure figures and graphs
configure_figures;

# plots
# earth_model;
model('Earth');
plot3(states(:,1), states(:,2), states(:,3), 'r', 'LineWidth', 2); % transfer

