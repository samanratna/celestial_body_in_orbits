# # -------------------------------------------------------------------------------
# # ODE45 Function Definition for Two-Body Problem
# # -------------------------------------------------------------------------------
function dzdt = two_body_ode(t, z, mu)

    r_vec = z(1:3);
    v_vec = z(4:6);

    r = norm(r_vec);            # magnitude of postition vector

    dzdt = zeros(6,1);
    dzdt(1:3) = v_vec;
    dzdt(4:6) = -mu * r_vec / r^3;
end