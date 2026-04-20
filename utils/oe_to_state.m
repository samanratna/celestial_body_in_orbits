function [r_eci, v_eci] = oe_to_state(a, e, i, Omega, omega, theta, mu)

    h = sqrt(mu * a * (1 - e^2));

    r_pf = (h^2/mu) * (1/(1 + e*cos(theta))) * ...
           [cos(theta); sin(theta); 0];

    v_pf = (mu/h) * ...
           [-sin(theta); e + cos(theta); 0];

    R3_Omega = [cos(Omega)  sin(Omega) 0;
               -sin(Omega)  cos(Omega) 0;
                0           0          1];

    R1_i = [1 0 0;
            0 cos(i) sin(i);
            0 -sin(i) cos(i)];

    R3_omega = [cos(omega)  sin(omega) 0;
               -sin(omega)  cos(omega) 0;
                0           0          1];

    Q = R3_Omega * R1_i * R3_omega;

    r_eci = Q * r_pf;
    v_eci = Q * v_pf;
end