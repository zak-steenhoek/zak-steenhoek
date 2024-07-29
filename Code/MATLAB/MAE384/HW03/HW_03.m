clear; clc;
x = [0; 0.1; 0.2; 0.3; 0.4; 0.5; 0.6; 0.7];
y = [-1; -0.5; 0.8; 2.2; 2.66; 3.68; 3.1; 2.68];
n = length(x); % Defining Length of x vector
m = 3; % Degree of Polynomial
% Defining vector xsum to build A matrix
for i = 1:2*m
    xsum(i) = sum(x.^(i));
end
% Substituting (1,1) entry in A matrix
A(1,1) = n;
% Substituting (1,1) entry in b vector
b(1,1) = sum(y);
% Populating 1st row of A matrix
for j = 2:m+1
    A(1,j) = xsum(j-1);
end
for i = 2:m+1
    for j = 1:(m + 1)
        A(i,j) = xsum(j + i - 2); % Populating all other values of A
    end
    b(i,1) = sum(x.^(i-1).*y); % Populating all other values of b
end
A % Displaying A Matrix
b % Displaying b vector
a = A\b % Calculating 'a' vector having coefficient values
% Plotting polynomial with data points
poly_x = linspace(0,0.7, 100);
for i = 1:length(poly_x)
    poly_y(i) = a(1) + a(2)*poly_x(i) + a(3)*(poly_x(i))^2 + a(4)*(poly_x(i))^3; % Regression polynomial
end
plot(poly_x, poly_y,'k','LineWidth',2)
hold on
plot(x,y,'ro',LineWidth=2)
hold off
% Finding approximate values using polynomial at xi
for i = 1:n
    p_y(i) = a(1) + a(2)*x(i) + a(3)*(x(i)).^2 + a(4)*(x(i)).^3;
end
% Calculating Sum of Square errors
for i = 1:n
    E(i) = (y(i) - p_y(i)).^2; % Making a vector of Squared errors for each data point
end
E; % Checking the values of errors for each data point
Er = sum(E); % Sum of error square = sum of all squared errors for all the data points
fprintf('Sum of Error Square Er: %2.4f\n', Er);