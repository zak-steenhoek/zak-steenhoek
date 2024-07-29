% Program to solve pipe flow problems
clc; clear;

Re = 507727;
e = 0.00005; %m
D = 0.75; %m
eD = e/D;
V2 = 8.943; % m/s
L = 100; % m
g = 9.8; % m/s^2
f = fzero(@ffactor,.05,[],Re,eD);
fprintf('friction factor = %f \n',f);
z1 = 1/2*V2^2/g*(1+f*L/D);
fprintf('required height = %f \n',z1);
%% 
clear Re; clear V2; clear x; clear x0;
h = 50; %m
x0 = [5 .05];
x = fsolve(@ffactor2,x0,[],h,L,D,eD);
fprintf('friction factor = %f, velocity = %f \n',x(2),x(1));
Vdot = x(1)*pi*D^2/4;
fprintf('Volume flow rate = %f \n',Vdot);
%%
x0 = [3 .023 .1];
x = fsolve(@ffactor3,x0,[],h,L);
fprintf('friction factor = %f, velocity = %f, diameter = %f \n',x(2),x(1),x(3));
%%
function y = ffactor(x,Re,eD)
y = x^(-1/2)+2*log10(eD/3.7 + 2.51/(Re*x^(1/2)));
end
function y = ffactor2(x,h,L,D,eD)
rho = 1000; %kg/m^3
mu = 1.003e-3; %kg/ms
g = 9.8;
Re = rho*x(1)*D/mu;
y(1) = h-x(1)^2/(2*g)*(1+x(2)*L/D);
y(2) = x(2)^(-1/2)+2*log10(eD/3.7+2.51/(Re*x(2)^(1/2)));
end
function y = ffactor3(x,d,L)
rho = 1000; %kg/m^3
mu = 1.003e-3; %kg/ms
g = 9.8;
e = .15/1000;
Re = rho*x(1)*x(3)/mu;
eD = e/x(3);
y(1) = d-x(1)^2/(2*g)*(1+x(2)*L/x(3));
y(2) = x(2)^(-1/2)+2*log10(eD/3.7+2.51/(Re*x(2)^(1/2)));
y(3) = .03 - pi*x(3)^2/4*x(1);
end

