clear all;     % clear all variables 
m = 1;  % mass [kg]
k = 16;  % spring constant [N/m]
c = 8;  % friction coefficient [Ns/m]
omega0 = sqrt(k/m); p = c/(2*m);
y0 =0.9;  v0 = 0; % initial conditions
[t,Y] = ode45(@f,[0, 5],[y0,v0],[],omega0, p); % solve for 0<t<5
y = Y(:,1); v = Y(:,2); % retrieve y, v from Y 
E = (0.5*m*v.^2) + (0.5*k*y.^2); % Equation for total energy of the system
figure(9); clf; plot(t,y,'ro-',t,E,'gx-'); % time series for y and E
legend('y(t)', 'E(t)'); title('Position Plot and Total Energy plot for m=1, c=2, k=16'); xlabel('Time (t), measured in seconds');
grid on; axis tight;
%---------------------------------------------------
function dYdt = f(t,Y,omega0, p); % function defining the DE 
y = Y(1); v = Y(2); 
dYdt=[v; -2*p*v - omega0^2*y];
end