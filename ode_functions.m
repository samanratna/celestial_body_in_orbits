% % create ode function here
% function dzdt = two_body_ode(t, z)
% 
%     global mu r;
% 
%     % define the state vectors:
%     X = z(1);
%     Y = z(2);
%     Z = z(3);
%     VX = z(4);
%     VY = z(5);
%     VZ = z(6);
% 
%     % initialize the output variable i.e. the derivative vector
%     dzdt = zeros(6,1);
% 
%     % put values on the derivative vector
%     dzdt(1) = z(4);
%     dzdt(2) = z(5);
%     dzdt(3) = z(6);
%     dzdt(4) = (-mu/(r^3)) * X;
%     dzdt(5) = (-mu/(r^3)) * Y;
%     dzdt(6) = (-mu/(r^3)) * Z;
% end