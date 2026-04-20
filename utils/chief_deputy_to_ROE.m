function roe = chief_deputy_to_ROE(r_chief, v_chief, r_deputy, v_deputy, mu)
%CHIEF_DEPUTY_TO_ROE Compute deputy ROE with respect to chief
%
% Inputs:
%   r_chief   : 3x1 chief position in ECI [km]
%   v_chief   : 3x1 chief velocity in ECI [km/s]
%   r_deputy  : 3x1 deputy position in ECI [km]
%   v_deputy  : 3x1 deputy velocity in ECI [km/s]
%   mu        : gravitational parameter of central body [km^3/s^2]
%
% Output:
%   roe       : struct with fields xr, yr, ar, Er, Az, psi

    % Convert to LVLH relative state
    rel_state_lvlh = eci_to_lvlh_relative_state(r_chief, v_chief, r_deputy, v_deputy);

    % Mean motion of chief
    r = norm(r_chief);
    v = norm(v_chief);
    a_chief = 1 / (2/r - v^2/mu);
    n = sqrt(mu / a_chief^3);

    % ROE from LVLH state
    roe = state_to_ROE(rel_state_lvlh, n);
end