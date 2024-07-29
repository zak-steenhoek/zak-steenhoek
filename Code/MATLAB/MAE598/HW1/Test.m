D = load('x.mat');
x = D.x;
v = 1:numel(x);
ve = 1:2225570;

x_extended = interp1(v, x, ve, 'linear','extrap');
numel()