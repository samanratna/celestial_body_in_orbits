function rel_state_lvlh = eci_to_lvlh_relative_state(r_chief, v_chief, r_deputy, v_deputy)
%ECI_TO_LVLH_RELATIVE_STATE Convert deputy/chief ECI states to LVLH relative state
%
% Inputs:
%   r_chief   : 3x1 chief position in ECI [km]
%   v_chief   : 3x1 chief velocity in ECI [km/s]
%   r_deputy  : 3x1 deputy position in ECI [km]
%   v_deputy  : 3x1 deputy velocity in ECI [km/s]
%
% Output:
%   rel_state_lvlh : 6x1 relative state in chief LVLH frame
%                    [x; y; z; xdot; ydot; zdot]
%
% Notes:
%   x = radial
%   y = along-track
%   z = cross-track

    % Force column vectors
    r_chief  = r_chief(:);
    v_chief  = v_chief(:);
    r_deputy = r_deputy(:);
    v_deputy = v_deputy(:);

    % Relative position/velocity in ECI
    rho_eci     = r_deputy - r_chief;
    rho_dot_eci = v_deputy - v_chief;

    % Chief LVLH basis
    r_hat = r_chief / norm(r_chief);                #i

    h_vec = cross(r_chief, v_chief);
    h_hat = h_vec / norm(h_vec);                    #k

    y_hat = cross(h_hat, r_hat);   % along-track    #j

    % Rotation matrix: ECI -> LVLH
    C = [r_hat.'; y_hat.'; h_hat.'];

    % Angular velocity of LVLH frame relative to inertial
    omega_lvlh_eci = h_vec / norm(r_chief)^2;

    % Relative state in LVLH
    rho_lvlh = C * rho_eci;
    rho_dot_lvlh = C * (rho_dot_eci - cross(omega_lvlh_eci, rho_eci));

    rel_state_lvlh = [rho_lvlh; rho_dot_lvlh];
    # rel_state_lvlh = [rho_eci; rho_dot_eci];
end