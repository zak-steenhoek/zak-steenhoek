
%% Instructions to use this code for Homework 2 Problem 2
% Write original function 1
f1 = @(x,y) x^2 + 2*cos(x)+y-1;
% Write original function 2
f2 = @(x,y) 2*x^3-sin(y)-8;
% Write partial derivative of function 1 w.r.t. x
f1x = @(x) 2*x-2*sin(x);
% Write partial derivative of function 1 w.r.t. y
f1y = 1;
% Write partial derivative of function 2 w.r.t. x
f2x = @(x) 6*x^2;
% Write partial derivative of function 2 w.r.t. y
f2y = @(y) -1*cos(y);
% Take determinant of Jacobian matrix
jacob = @(x,y) -((exp(x/2)-exp(-x/2))*50*y/4)-18*x; % Jacobian
% Provide first guesses of x and y as per given in problem statement
xi = 1.0;
yi = 2.0;
% Define reference approximate relative errors as per problem statement
Err = 0.005; % minimum error
% Define a suitable maximum number of iterations
n = 5; % number of iteration
% Loop to calculate Intersection points for given set of functions
for i=1:n
    jac = jacob(xi,yi); % Substituting x & y values in Jacobian
    delx = (-f1(xi,yi) * f2y(yi) + f2(xi,yi) * f1y) / jac; % Calculating Delta x using Cramer's rule
    dely = (-f2(xi,yi) * f1x(xi) + f1(xi,yi) * f2x(xi)) / jac; % Calculating Delta y using Cramer's rule
    xn = xi + delx; % Updating value as X_i+1 = X_i + delx_i
    yn = yi + dely; % Updating value as Y_i+1 = Y_i + dely_i
    Ex = abs((xn-xi)/xi); % Defining approximate relative error for x
    Ey = abs((yn-yi)/yi); % Defining approximate relative error for y
    fprintf('iteration = %2.0f x = %-7.4f and y = %-7.4f error in x = %-7.4f error in y = %-7.4f\n',i,xn,yn,Ex,Ey)
    if Ex < Err && Ey < Err % Error condition
        fprintf('solution is converged for x = %-7.4f and y = %-7.4f\n' ,xn,yn)
        break
    else
        xi = xn; % Updating x value to use in next iteration
        yi = yn; % Updating x value to use in next iteration
    end
end
