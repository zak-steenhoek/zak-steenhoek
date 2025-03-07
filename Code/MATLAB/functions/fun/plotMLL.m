%% Header
% Author: Zakary Steenhoek
% Created: September 2024
% Updated: February 2025

function [] = plotMLL()
%PLOTMLL plots the MATLAB logo membrain
%   [] = PLOTMLL() plots the matlab logo shape in 3D space with correct
%   camera angles and color grading
%
% Input: None
%
% Output: None
%

% Generate Logo Data
L = 160*membrane(1,100);
figure(); clf; ax = axes;
s = surface(L); s.EdgeColor = 'none';
ax.XLim = [1 201];
ax.YLim = [1 201];
ax.ZLim = [-53.4 160];
view(3)

%% Camera & Lighting

ax.CameraPosition = [-145.5 -229.7 283.6];
ax.CameraTarget = [77.4 60.2 63.9];
ax.CameraUpVector = [0 0 1];
ax.CameraViewAngle = 36.7;
ax.Position = [0 0 1 1];
ax.DataAspectRatio = [1 1 .9];

l1 = light;
l1.Position = [160 400 80];
l1.Style = 'local';
l1.Color = [0 0.8 0.8];

l2 = light;
l2.Position = [.5 -1 .4];
l2.Color = [0.8 0.8 0];

%% Logo Style

s.FaceColor = [0.9 0.2 0.2];
s.FaceLighting = 'gouraud';
s.AmbientStrength = 0.3;
s.DiffuseStrength = 0.6;
s.BackFaceLighting = 'lit';
s.SpecularStrength = 1;
s.SpecularColorReflectance = 1;
s.SpecularExponent = 5;
axis off

%% Plot

s.AlphaData = 0.0;
s.FaceAlpha = 1.0;
s.EdgeAlpha = 0.0;
numLines = 50; lineWidth = 0.1;

x=s.XData; y=s.YData; z=s.ZData;
x=x(1,:); y=y(:,1);

xnumlines = numLines; ynumlines = numLines;
xspacing = round(0.8*(length(x)/xnumlines));
yspacing = round(0.8*(length(y)/ynumlines));

hold on; lineColor = '#7da7b0';
for i1 = 1:yspacing:length(y)
    Y1 = y(i1)*ones(size(x));
    Z1 = z(i1,:);
    plot3(x,Y1,Z1, 'color', lineColor, 'LineWidth', lineWidth);
end
for i = 1:xspacing:length(x)
    X2 = x(i)*ones(size(y));
    Z2 = z(:,i);
    plot3(X2,y,Z2, 'color', lineColor, 'LineWidth', lineWidth);
end
hold off;
end
