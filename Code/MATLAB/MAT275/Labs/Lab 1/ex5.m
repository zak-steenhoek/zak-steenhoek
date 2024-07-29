clear;
clc;
x = 0:0.01:9; % define the vector x in the interval [0 ,9]
y1 = f(x,270); % compute the solution with C = 270
y2 = f(x,440); % compute the solution with C = 440
y3 = f(x,660); % compute the solution with C = 660
plot(x,y1,'g--',x,y2,'b:',x,y3,'c-.'); % plot the three solutions with different line - styles
title('Solutions to dy/dx = −21x − 2x2 + 20 cos(x)'); % add a title
legend('270','440','660'); % add a legend

function y = f(x,C)
y = -(21/2)*x.^2-(2/3)*x.^3+20*sin(x)+C;% fill - in with the expression for the general solution
end