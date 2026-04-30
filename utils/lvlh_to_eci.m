function thrust_in_eci = lvlh_to_eci(_r_chief, _v_chief, a_thrust)
%ECI_TO_LVLH_RELATIVE_STATE Convert deputy/chief ECI states to LVLH relative state

    % Force column vectors
    r_chief  = r_chief(:);
    v_chief  = v_chief(:);

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
    rho_eci = inv(C) * a_thrust;

    thrust_in_eci = [rho_eci];
end