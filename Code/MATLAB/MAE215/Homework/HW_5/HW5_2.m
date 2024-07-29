%Zakary Steenhoek
%HW 5.2
%MAE215
%3.31.23

%Formatting, clearing memory and workspace
clc;
clear;
format compact;

%Declaring variables
n1=294;
n2=584;
n3=160;

%Deimal to binary
binVal1 = dec2bin(n1);
binVal2 = dec2bin(n2);
binVal3 = dec2bin(n3);

%Displying output
fprintf('The binary value of %f is %s.\n',n1, binVal1, n2, binVal2, n3, binVal3);