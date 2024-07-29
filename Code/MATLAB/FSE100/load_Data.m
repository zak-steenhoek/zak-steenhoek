% Made by Zakary Steenhoek on 9.29.22
close all;
clear all;
clc

%loading data from .txt file, declaring x and y, and plotting
load("data.txt");
x=data(:,1);
y=data(:,2);
z=data(:,3);
plot(x,y,x,z);
title('y vs. z');

