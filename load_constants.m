%% ===============================
% Constants
% ===============================
G = 6.667e-20;
mass_of_earth = 5.9722e24;
mu = G * mass_of_earth;

%% ===============================
% Moon Orbital Elements (about Earth)
% ===============================

a = 384400;               % km
e = 0.01;
# e = 0.0549;
i = deg2rad(0);        % inclination (equatorial frame)
Omega = deg2rad(0.0);  % RAAN
omega = deg2rad(0.0);  % argument of perigee
theta = deg2rad(0.0);     % chosen true anomaly

mu = 398600;              % Earth gravitational parameter (km^3/s^2)

% %% ===============================
% % Earth Orbital Elements (around Sun)
% % ===============================
# a = 149597870;            % km (1 AU)
# e = 0.0167;
# i = deg2rad(0.00005);     % nearly zero inclination
# Omega = deg2rad(-11.26064);
# omega = deg2rad(102.94719);
# theta = deg2rad(100);     % chosen example true anomaly

# mu = 1.32712440018e11;    % Sun gravitational parameter (km^3/s^2)

# % % ===============================
# % ISS Orbital Elements (around Earth)
# % ===============================
# a = 6780;                 % km  (~400 km altitude)
# e = 0.0006;               % nearly circular
# i = deg2rad(51.64);       % ISS inclination
# Omega = deg2rad(0);       % choose reference
# omega = deg2rad(0);       % undefined for circular orbit
# theta = deg2rad(45);      % chosen position

# mu = 398600;              % Earth gravitational parameter (km^3/s^2)