%% Program to solve pipe flow problems
clc; clear;

D = 0.04;           % m - Diameter
L = 12;            % m - Pipe length
h = 5;             % m - Delta height
v = 6.63146;          % m/s - Flow velocity
P = 5000;         % W - Pump/Turbine power
e = 0.000008;        % m - Roughness
hm = 0;             % m - Sum of minor loss coeffs
g = 9.8;            % m/s^2 - Gravity
rho = 1000;         % kg/m^3 - Density
mu = 1.003e-3;      % kg/ms - Viscocity
eD = e/D;           % Relative Roughness
f = 0.01;           % Friction factor

%% Finding friction factor (f)
g0 = f;                         % Guess f
clear f;                        % Reset
Vdot = v*pi*D^2/4;              % Volume flow rate
Re = rho*v*D/mu;                % Reynold's Number
f = fzero(@ffactor,g0,[],eD, Re);
fprintf('Friction factor = %f \n',f);
fprintf('Volume flow rate = %f m^3/s, Reynold number = %f\n',Vdot, Re);
%% Finding power (P)
g0 = P;                         % Guess P
clear P;                        % Reset
Vdot = v*pi*D^2/4;              % Volume flow rate
Re = rho*v*D/mu;                % Reynold's Number
P = fsolve(@power,g0,[],D,L,h,v,hm,g,rho,f);
fprintf('\nPower = %f W, Friction factor = %f\n',P, f);
fprintf('Volume flow rate = %f m^3/s, Reynold number = %f\n',Vdot, Re);
%% Finding velocity (v) and friction factor (f)
g0 = [v f];                     % Guess [v, f]
clear v; clear f;               % Reset
x = fsolve(@pumpturb1,g0,[],D,L,h,P,hm,g,rho,mu,eD);
Vdot = x(1)*pi*D^2/4;           % Volume flow rate
Re = rho*x(1)*D/mu;             % Reynold's Number
fprintf('\nVelocity = %f m/s, Friction factor = %f\n',x(1), x(2));
fprintf('Volume flow rate = %f m^3/s, Reynold number = %f\n',Vdot, Re);
%%
function y = ffactor(x,eD,Re)
    y = x^(-1/2)+2*log10(eD/3.7 + 2.51/(Re*x^(1/2)));
end
function y = power(x,D,L,h,v,hm,g,rho,f)
    Vdot = v*pi*D^2/4;   % Volume flow rate
    y = h-v^2/(2*g)*(f*L/D+hm)+x/(Vdot*rho*g);
end
function y = pumpturb1(x,D,L,h,P,hm,g,rho,mu,eD)
    Vdot = x(1)*pi*D^2/4;   % Volume flow rate
    Re = rho*x(1)*D/mu;     % Reynold's Number
    y(1) = h-x(1)^2/(2*g)*(x(2)*L/D+hm)+P/(Vdot*rho*g);
    y(2) = x(2)^(-1/2)+2*log10(eD/3.7+2.51/(Re*x(2)^(1/2)));
end