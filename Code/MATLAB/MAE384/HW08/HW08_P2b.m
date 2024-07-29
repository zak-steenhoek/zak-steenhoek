clc; clear; 

% Define variables initial x, final x, and step size
xi = 0.0; 
xf = 2.0; 
h = 0.1; 

% Initialize vectors for manipulation
x = xi:h:xf;
y = zeros(length(x), 1);
y(1) = 2;

% Define diff. eq
dy = @(x,y) (x^2)/y;

% Perform midpoint mtd. evaluation
for i = 1:length(x)-1
    xm = x(i) + (h/2);
    ym = y(i) + dy(x(i), y(i))*(h/2);
    y(i+1) = y(i) + dy(xm, ym)*h;
end

% Define true soln.
yt = sqrt(2*x.^3/3+4);

% Calculate & disp true error percentage
et = abs((yt(end)-y(end))/yt(end))*100;
fprintf("The true percentage error is %f%%.", et);