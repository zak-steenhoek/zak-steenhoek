clear;
funcODE = @(t, y) -1.6*y;
N=5;

figure
t = 0:0.5:8; y = -11:1.8:7; % define a grid in t & y directions
[T, Y] = meshgrid(t, y); % create 2 d matrices of points in ty - plane
dT = ones(size(T)); % dt =1 for all points
dY = -1.6*Y; % dy = -1.6* y ; this is the ODE
quiver (T, Y, dT, dY) % draw arrows (t , y ) - >( t + dt , t + dy )
axis tight % adjust look
hold on
t_exact = linspace(0,8,100);
y_exact = exp(-1.6*t_exact);
plot(t_exact, y_exact, 'k', 'linewidth', 2)
[t_approximate, y_approximate] = impeuler(funcODE, [0,8], 1, N);
[t_approximate, y_approximate]
plot(t_approximate, y_approximate, 'ro-', 'linewidth', 2)
legend('Slope Field', 'Exact Soln', 'Approx. Soln (N=5)', 'location', 'northwest');
hold off;
