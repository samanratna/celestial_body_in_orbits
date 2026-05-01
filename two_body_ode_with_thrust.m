# # -------------------------------------------------------------------------------
# # ODE45 Function Definition for Two-Body Problem
# # -------------------------------------------------------------------------------
function dzdt = two_body_ode_with_thrust(t, z, mu)

    r_vec = z(1:3);
    v_vec = z(4:6);

    r = norm(r_vec);            # magnitude of postition vector

    dzdt = zeros(6,1);
    dzdt(1:3) = v_vec;
    
    # a_thrust = [0; 0; 0.0000002];
    # a_thrust = [0.00000012; 0; 0];
    # a_thrust = [0; 0.00000002; 0];
    # a_thrust = [0; 0; 9e-8];
    # a_thrust = [0; 0.000000015; 9e-8];
    a_thrust = [0; 0; 0];


    % Force column vectors
    r_chief  = r_vec(:);
    v_chief  = v_vec(:);

    % Relative position/velocity in ECI
    rho_lvlh     = r_vec;

    % Chief LVLH basis
    r_hat = r_chief / norm(r_chief);                #i

    h_vec = cross(r_chief, v_chief);
    h_hat = h_vec / norm(h_vec);                    #k


    y_hat = cross(h_hat, r_hat);   % along-track    #j

    % Rotation matrix: ECI -> LVLH
    C = [r_hat.'; y_hat.'; h_hat.'];

    % Relative state in LVLH
    rho_eci = inv(C) * a_thrust;



    

    dzdt(4:6) = rho_eci + (-mu * r_vec / r^3);
    # dzdt(4:6) = a_thrust + (-mu * r_vec / r^3);
end