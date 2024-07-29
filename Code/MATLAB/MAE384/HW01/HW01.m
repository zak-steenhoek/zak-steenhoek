clc; clear;

f = @(x) cos(2*x)-x;
x1 = 0.1;
x2 = 1.3;
n = 100; % No. of iterations
f1 = f(x1);
f2 = f(x2);
Er = 0.001; % Reference error
% Checking sign of functions between initial points
if f1*f2 > 0
    disp('Error, Function has same sign at x1 & x2')
else
    x_old = x2;
    disp('  i       x1          x2         x_new     f(x_new)      Error');

    for i = 1:n
        x_new = (x1 + x2)/2; % Defining new point using bisection method
        f_new = f(x_new);
        Ea = abs((x_new - x_old)/x_old); % Approximate relative Error
        fprintf('%3i %11.6f %11.6f %11.6f %11.6f %11.6f\n', i,x1,x2,x_new,f_new,Ea)
        if f1*f_new < 0 % Updating X1 and X2 values in Bisection
            x2 = x_new;
            x_old = x2;
        else
            x1 = x_new;
            x_old = x1;
        end
        if f_new == 0 % Checking if exact solution is reached
            fprintf('Exact solution is fount at x = %11.6f', x_new)
            break
        end
        if Ea < Er % Stopping iterations when Reference error is reached
            fprintf(['Solution within acceptable error is reached within ' ...
                '%i iterations'], i)
            break
        end
        if i == n % Stopping iterations when n is reached
            fprintf('Solution could not be found within %i iterations', n)
            break
        end
    end
end