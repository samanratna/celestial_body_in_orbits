function roe = state_to_ROE(state, n)
%STATE_TO_ROE Convert LVLH Cartesian relative state to Relative Orbital Elements
%
% Inputs:
%   state : 6x1 vector [x; y; z; xdot; ydot; zdot] (LVLH frame)
%   n     : mean motion of chief [rad/s]
%
% Output:
%   roe   : struct with fields xr, yr, ar, Er, Az, psi

    state = state(:);

    x    = state(1);
    y    = state(2);
    z    = state(3);
    xdot = state(4);
    ydot = state(5);
    zdot = state(6);

    % ROEs
    roe.xr  = 4*x + 2*ydot/n;
    roe.yr  = y - 2*xdot/n;

    roe.ar  = sqrt((6*x + 4*ydot/n)^2 + (2*xdot/n)^2);
    roe.Er  = atan2(2*xdot/n, 6*x + 4*ydot/n);

    roe.Az  = sqrt(z^2 + (zdot/n)^2);
    roe.psi = atan2(z, zdot/n);
end