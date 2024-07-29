clear all;     % clear all variables 
m = 8;  % mass [kg]
k = 16;  % spring constant [N/m]
omega0 = sqrt(k/m); 
y0 =0.9;  v0 = 0; % initial conditions
[t,Y] = ode45(@f,[0,5],[y0,v0],[],omega0); % solve for 0<t<5
y = Y(:,1); v = Y(:,2);  % retrieve y, v from Y 
figure(1); clf; plot(t,y,'ro-',t,v,'b+-'); % time series for y and v
legend('y(t)', 'v(t)'); title('Ex. 1: y(t) and v(t) for m=8, k=16'); xlabel('Time (t), measured in seconds');
grid on; axis tight; 
%---------------------------------------------------
function dYdt = f(t,Y,omega0); % function defining the DE 
y = Y(1); v = Y(2); 
dYdt=[ v ; - omega0^2*y ];
end