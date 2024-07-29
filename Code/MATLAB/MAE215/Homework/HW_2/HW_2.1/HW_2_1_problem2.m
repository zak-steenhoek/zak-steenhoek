%Zakary Steenhoek
%HW_2.1
%MAE215
%2.9.23

%Clearing memory and workspace
clc; 
clear;
    
%Defining x and y as symbolic variables and declaring the function as a
%string and variable
syms x y;
eStr = 'x^2 + sin(x*y)+ 3*x*y';
eVar = x^2 + sin(x*y)+ 3*x*y;

%Calculate the 1st derivative of x
Df1 = diff(x.^2 + sin(x*y)+3*x*y,x,1);
fprintf('\n\nThe first derivative of the expression, \n%s\nis,\n%s\n',eStr,Df1);

%Calculate the 2nd derivative of x
Df2 = diff(x.^2 + sin(x*y)+3*x*y,x,2);
fprintf('\nThe second derivative of the expression, \n    %s\nis,\n    %s\n',eStr,Df2);

%aCreating an anonymous function to take a parameter eq to find the derivitive 
func = @(eq) diff(eVar);
ptC = func(eVar);
fprintf('Using the anonomous function to find the first derivitive, we get the equation %s.',ptC);

%Defining the given vector and finding the 
vec = [2 4 9 16 25 36 56 64 81 100 121 144 169 196];
delta = diff(vec);

fprintf('\n\nGiven the vector, \n   '); disp(vec);

fprintf('The differences between adjacent elements is, \n   '); disp(delta); fprintf('\n');