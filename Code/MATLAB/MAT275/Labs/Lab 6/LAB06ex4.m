clear; clc; %this deletes all variables 
omega0 = 4; c = 0; omega = 3.8;
if omega0 > omega
    alpha = atan((c*omega)/(omega0.^2-omega.^2));
else
    alpha = pi + atan((c*omega)/(omega0.^2-omega.^2));
end
param = [omega0,c,omega]; 
t0 = 0; y0 = 0; v0 = 0; Y0 = [y0;v0]; tf = 80;
options = odeset('AbsTol',1e-10,'relTol',1e-10); 
[t,Y] = ode45(@f,[t0,tf],Y0,options,param);  
t1 = 25; i = find(t>t1);
C = (max(Y(i,1))-min(Y(i,1)))/2;
y = Y(:,1)-C*cos(omega*t-alpha); v = Y(:,2);
figure(6); clf;
plot(t,y,'b-'); ylabel('y'); grid on; hold on;
C=1/abs(omega0^2-omega^2);
A=2*C*cos((omega0-omega)*t/2);
plot(t,A,'r-',t,-A,'g-');

disp(['computed amplitude of forced oscillation = ', num2str(C)]);
Ctheory = 1/sqrt((omega0^2-omega^2)^2+(c*omega)^2); 
disp(['theoretical amplitude = ', num2str(Ctheory)]);
%----------------------------------------------------------------
function dYdt = f(t,Y,param) 
y = Y(1); v = Y(2); 
omega0 = param(1); c = param(2); omega = param(3);
dYdt = [ v ; cos(omega*t)-omega0^2*y-c*v ];
end