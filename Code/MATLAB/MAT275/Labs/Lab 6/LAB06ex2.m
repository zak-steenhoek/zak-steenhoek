clear; clc; %this deletes all variables 
omega0 = 4; c = 1;
OMEGA =2:0.01:5;
C = zeros(size(OMEGA));
Ctheory = zeros(size(OMEGA)); 
t0 = 0; y0 = 0; v0 = 0; Y0 = [y0;v0]; tf =60; t1 = 25;
for k = 1:length(OMEGA)
   omega = OMEGA(k);
   param = [omega0,c,omega];
   [t,Y] = ode45(@f,[t0,tf],Y0,[],param); 
   i = find(t>t1); 
   C(k) = (max(Y(i,1))-min(Y(i,1)))/2; 
   Ctheory(k) = 1/sqrt((omega0^2-omega^2)^2+(c*omega)^2); 
end 
figure(4); clf; 
plot(OMEGA, C, OMEGA, Ctheory); grid on; % FILL-IN to plot C and Ctheory as a function of OMEGA 
xlabel('\omega'); ylabel('C'); 
legend('computed numerically','theoretical') 
%---------------------------------------------------------
function dYdt = f(t,Y,param) 
y = Y(1); v = Y(2); 
omega0 = param(1); c = param(2); omega = param(3);
dYdt = [ v ; cos(omega*t)-omega0^2*y-c*v ]; 
end