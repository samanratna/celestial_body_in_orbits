% clear everything
clear; clc; close all;

% define constants here
% Constants
G = 6.667*10^(-20);
mass_of_earth   = 5.9722*10^24;
mass_of_moon    = 7.3458*10^22;
mass_of_iss     = 450000;

% % ===============================
% ISS Orbital Elements (around Earth)
% ===============================
a = 6780;                 % km  (~400 km altitude average)
e = 0.0006;               % nearly circular

i = deg2rad(45);                        % inclination angle
right_ascension = deg2rad(30);          % right ascension of ascending node
argument_of_perigee = deg2rad(10);      % argument of perigee

theta = deg2rad(0);      % chosen position of the satellite in orbit

mu = GravitationalParameter(G, mass_of_earth, mass_of_iss);

bodyInPerifocalFrame(theta, e, mu, a);


% Co-ordinate Transformation
Q = [ ...
    (-sin(right_ascension)*cos(i)*sin(argument_of_perigee) + cos(right_ascension)*cos(argument_of_perigee)),  (cos(right_ascension)*cos(i)*sin(argument_of_perigee) + sin(right_ascension)*cos(argument_of_perigee)),  (sin(i)*sin(argument_of_perigee));
    (-sin(right_ascension)*cos(i)*cos(argument_of_perigee) - cos(right_ascension)*sin(argument_of_perigee)),  (cos(right_ascension)*cos(i)*cos(argument_of_perigee) - sin(right_ascension)*sin(argument_of_perigee)),  (sin(i)*cos(argument_of_perigee));
    (sin(right_ascension)*sin(i)),                                     (-cos(right_ascension)*sin(i)),                                     (cos(i)) ...
];

% Position and Velocity in reference of earth
r_vector = Q * r_pf;
v_vector = Q * v_pf;

% define functions here
function miu = GravitationalParameter(G, mass_1, mass_2)
    miu = G * (mass_1 + mass_2);
    % disp("miu is " + miu);
end

% define position of a satellite in an orbit (in perifocal frame)
function bodyInPerifocalFrame(theta, e, mu, a)

    % Angular momentum
    h = sqrt(mu * a * (1 - e^2));
    
    % Position in Perifocal Frame (pf)    
    r_pf = (h^2/mu) * (1/(1 + e*cos(theta))) * ...
           [cos(theta);
            sin(theta);
            0];
    
    % Magnitude of position vector (gives distance from the center)
    r = sqrt(r_pf(1)^2 + r_pf(2)^2 + r_pf(3)^2);
    
    % Velocity in Perifocal Frame (pf)
    v_pf = (mu/h) * ...
           [-sin(theta);
            e + cos(theta);
            0];
end
    

% define Earth Planet
function EarthModel()
    R_earth = 6371;                                                                     % 1. Define Earth's Radius(kms)
    [sx, sy, sz] = sphere(30);                                                          % 2. Scaling a little larger
    earth_surface = surf(sx* R_earth, sy* R_earth, sz* R_earth);                        % 3. Plot the surface at the origin
    set(earth_surface, 'FaceColor', 'blue', 'EdgeColor', 'none', 'FaceAlpha', 0.5);     % 4. Simple formatting
end


% create ode function here
function dzdt = two_body_ode(t, z)

    global mu r;
    
    % define the state vectors:
    X = z(1);
    Y = z(2);
    Z = z(3);
    VX = z(4);
    VY = z(5);
    VZ = z(6);

    % initialize the output variable i.e. the derivative vector
    dzdt = zeros(6,1);

    % put values on the derivative vector
    dzdt(1) = z(4);
    dzdt(2) = z(5);
    dzdt(3) = z(6);
    dzdt(4) = (-mu/(r^3)) * X;
    dzdt(5) = (-mu/(r^3)) * Y;
    dzdt(6) = (-mu/(r^3)) * Z;
end


% specific calculations here
EarthModel;
hold on;

% initial conditions
z0 = [
    r_vector(1);
    r_vector(2);
    r_vector(3);
    v_vector(1);
    v_vector(2);
    v_vector(3);
   ]

% tspan
a_day_in_seconds = 86400;
number_of_days = 1;
tspan = [0 a_day_in_seconds*number_of_days];

% options
options = odeset('RelTol',1e-10);

% call ode45 function here
[t, states] = ode45(@two_body_ode, tspan, z0, options);

% plot 3d graph here
plot3(states(:,1), states(:,2), states(:,3), 'Color', [0, 0.5, 0]);
axis equal;
grid on;
xlabel("X axis (kms)");
ylabel("Y axis (kms)");
zlabel("Z axis (kms)");
title("Two body Problem through Orbital Elements");
