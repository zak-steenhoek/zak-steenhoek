function y = nozzleshock2(x,p0pe,AeAt)
% Find location of a normal shock inside a nozzle given pressure ratio p0/pe
% and area ratio Ae/At
global M2 p2p1 AIaStar AeA2

% unknowns are M1 (Mach number before the shock) and Me (exit Mach number)
M1 = x(1); Me = x(2);
gamma = 1.4;

% shock jump conditions
M2 = sqrt((2+(gamma-1)*M1^2)/(2*gamma*M1^2-(gamma-1)));
p2p1 = 1+2*gamma/(gamma+1)*(M1^2-1);

% isentropic flow relations
p0p1 = (1+(gamma-1)/2*M1^2)^(gamma/(gamma-1));
p2pe = ((1+(gamma-1)/2*Me^2)/(1+(gamma-1)/2*M2^2))^(gamma/(gamma-1));

% area-Mach number relations
AIaStar = 1/M1*((2/(gamma+1)*(1+(gamma-1)/2*M1^2))^((gamma+1)/(2*(gamma-1))));
AeA2 = M2/Me*((1+(gamma-1)/2*Me^2)/(1+(gamma-1)/2*M2^2))^((gamma+1)/(2*(gamma-1)));

y(1) = -p0pe + p0p1*p2pe/p2p1;
y(2) = -AeAt + AeA2*AIaStar;

end
