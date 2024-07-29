% Create an x-vector with N evenly-spaced points over interval [a,b], 
% where a = 0, b = 3, and N = 11.
a = 0;
b = 3;
N = 11;
x = linspace(a,b,N);

% Define f(x) as var y and create vector with values at each x
y = (x.^2).*sqrt(9-x.^2);

% Define a vector S that will contain the value to sum for each iteration,
% and initialize the vector with all 0's
S = zeros(length(x),1);

% Setting the step size h
h = (x(length(x)) - x(1))/(length(x)-1);

% The first and last value of sum vector S are the values of eqn. y at 1
% and N+1, respectivley, per eqn. 9.19
S(1) = y(1);
S(length(x)) = y(length(x));

% for every term, if it is even, the value to sum passed into S is
% multiplied by 4, and if the term is odd, the value to sum passed into S
% is multiplied by 2, per eqn. 9.19
for i = 2:length(x)-1
    if mod(i,2) == 0
        S(i) = 4*y(i);
    else
        S(i) = 2*y(i);
    end
end
% Summing vector S and multiplying by h/3, then multiplying by 10/3, gives
% ans, per HW question
Int = (h/3)*sum(S);
Int = (10/3)*Int;
disp(Int)

% True value from calculator is 53.014376, while outputted value is
% 51.9933. Increasing N gives more accurate result.
