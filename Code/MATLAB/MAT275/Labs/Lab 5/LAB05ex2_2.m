clear all; % clear all variables
m = 1; % mass [kg]
k = 16; % spring constant [N/m]
omega0 = sqrt(k/m);
y0 =0.9;  v0 = 0; % initial conditions
[t,Y] = ode45(@f,[0, 5],[y0,v0],[],omega0); % solve for 0<t<5
y = Y(:,1); v = Y(:,2);         % retrieve y, v from Y 
figure(4); clf; plot(y,v,'ro-'); % Phase plot v vs. y
legend('Phase Plot'); title('Phase plot of v vs. y for m=1, k=16'); xlabel('y(t)'); ylabel('v(t)');
grid on; axis tight;
%---------------------------------------------------
function dYdt = f(t,Y,omega0); % function defining the DE 
y = Y(1); v = Y(2); 
dYdt=[v; -omega0^2*y];
end