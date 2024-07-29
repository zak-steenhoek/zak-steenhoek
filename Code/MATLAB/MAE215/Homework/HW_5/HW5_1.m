%Zakary Steenhoek
%HW 5.1
%MAE215
%3.31.23

%Formatting, clearing memory and workspace
clc;
clear;
format compact;

%Declaring variables
x = -2*pi:0.01:2*pi;
g = -1*(x < -pi) + cos(x).*(x >= -pi).*(x <= pi) + -1*(x > pi);

%Plotting the graph of g(x) 
plot(x,g);
title('Graph of g(x) from -2pi to 2pi');
xlabel("x");
ylabel("g(x)");