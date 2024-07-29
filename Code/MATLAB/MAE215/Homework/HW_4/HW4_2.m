%Zakary Steenhoek
%HW 4.2
%MAE215
%3.16.23

%Formatting, clearing memory and workspace
clc;
clear;
format compact;

%Declaring variables
g=9.8;
Vo=100;
theta=pi/4;
t=0:0.01:20;
ang1=pi/2;
ang2=pi/4;
ang3=pi/6;
h=t*Vo*cos(theta);
v=t*Vo*sin(theta)-0.5*g*t.^2;

%Tiling for the 3 future graphs
tiledlayout(3,1);
p1=nexttile;
p2=nexttile;
p3=nexttile;

%Plotting the first two graphs
plot(p1,t,h);
title(p1,'Horizontal Distance Vs. Time');
xlabel(p1,'Time (Seconds)');
ylabel(p1,'Horizontal Distance (Meters)');
plot(p2,t,v);
title(p2,'Vertical Distance Vs. Time');
xlabel(p2, 'Time (seconds)');
ylabel(p2,'Vertical Distance (Meters)');

%Declaring and re-declaring variables for the second part
t=[0.01, 0.1, 0.5, 1, 5, 10];
horizontal = @(a) t*Vo*cos(a);
vertical = @(angle) t*Vo*sin(angle)-0.5*g*t.^2;

%Creting vectors and printing the data to the console
vecH1=horizontal(ang1);
vecV1=vertical(ang1);
fprintf(['The following are both the horizontal and vertical values for the angle pi/2 (90 deg).\n' ...
    'Times: 0.01s, 0.1s, 0.5s, 1s, 5s, 10s\nHorizontal (m): %3.1f, %3.1f, %3.1f, %3.1f, %3.1f, %3.1f\nVertical (m): %3.1f, %3.1f, %3.1f, %3.1f, %3.1f, %3.1f\n\n'],vecH1, vecV1);
vecH2=horizontal(ang2);
vecV2=vertical(ang2);
fprintf(['The following are both the horizontal and vertical values for the angle pi/4 (45 deg).\n' ...
    'Times: 0.01s, 0.1s, 0.5s, 1s, 5s, 10s\nHorizontal (m): %3.1f, %3.1f, %3.1f, %3.1f, %3.1f, %3.1f\nVertical (m): %3.1f, %3.1f, %3.1f, %3.1f, %3.1f, %3.1f\n\n'],vecH2, vecV2);
vecH3=horizontal(ang3);
vecV3=vertical(ang3);
fprintf(['The following are both the horizontal and vertical values for the angle pi/6 (30 deg).\n' ...
    'Times: 0.01s, 0.1s, 0.5s, 1s, 5s, 10s\nHorizontal (m): %3.1f, %3.1f, %3.1f, %3.1f, %3.1f, %3.1f\nVertical (m): %3.1f, %3.1f, %3.1f, %3.1f, %3.1f, %3.1f\n\n'],vecH3, vecV3);

%Plotting and formatting the last graph using the vectors we just made
plot(p3,vecH1, vecV1,'m', vecH2, vecV2,'--', vecH3, vecV3,':b');
title(p3, 'Vertical Distance Vs. Horizontal Distance');
xlabel(p3,'Horizontal Distane');
ylabel(p3,'Vertical Distance');
legend(p3,'Angle pi/2', 'Angle pi/4', 'Angle pi/6');
