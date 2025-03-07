%% Header
% Author: Zakary Steenhoek
% Created: February 2025
% Updated: February 2025

function simpfreeSM(L,P,a,units,sep)
%SHEARMOMENT plots the shear and moment diagrams 
%   SIMPFREESM(L,P,A,SEP) plots the shear and moment diagrams of a simply
%   supported beam of length L with force P acting at A
%
% Input:
%   Beam length, L
%   Load, P
%   OPT: Load application point: if ~exist A, a == L/2
%   OPT: Plot on seperate figures: if ~exist SEP, sep == 0
%
% Output:
%   figure
%

% Display options
XBuff = 0.1;
yBuff = 0.2;

% Determine a
if (~exist('a', 'var'))
    a = L/2;
end

% Determine units
if (~exist('units', 'var'))
    units = {'m', 'N'};
end

% Determine layout
if (~exist('sep', 'var'))
    sep = 0;
end

% Discretize the Beam
x = linspace(0, L, 1000);

% Initialize Shear Force and Bending Moment Arrays
V = zeros(size(x));
M = zeros(size(x));

%% Math

% Find indices for x before and after the load position
idx1 = x < a;
idx2 = x >= a;

V(idx1) = -P/2;
V(idx2) = P/2;

M(idx1) = fliplr(P * (a - x(idx1)));
M(idx2) = P * (a - x(idx1));

%% Plots

% Help
Xmax = L+L*XBuff;
Vylim = max(abs(V))+max(abs(V))*yBuff;
Mylim = max(abs(M))+max(abs(M))*yBuff;
subtitle = 'P = ' + string(P) + units{2};
xLabSt = ['Beam Length, x (' units{1} ')'];
shLabSt = ['Shear Force, V_{x} (' units{2} ')'];
momLabSt = ['Bending Moment, M_{x} (' strcat(units{2},units{1}) ')'];


if sep
    % Plot shear diagram
    figure(999998); clf; hold on; grid on;
    title('Shear Force Diagram', subtitle)
    xlabel(xLabSt); ylabel(shLabSt);
    plot(x, V, 'b-');
    ylin(0,0,Xmax,'k-');
    xlin(0,min(V),0,'b-');
    xlin(L,0,max(V),'b-');
    xlim([0 Xmax]); ylim([-Vylim, Vylim]);
    hold off;

    % Plot bending diagram
    figure(999999); clf; hold on; grid on;
    title('Bending Moment Diagram', subtitle)
    xlabel(xLabSt); ylabel(momLabSt)
    plot(x, M, 'r-');
    ylin(0,0,Xmax,'k-');
    xlim([0 Xmax]); ylim([-Mylim, Mylim]);
    hold off;
else
    % Figure
    figure(9999); clf;

    % Plot shear diagram
    subplot(2,1,1); hold on; grid on;
    title('Shear Force Diagram', subtitle)
    xlabel(xLabSt); ylabel(shLabSt);
    plot(x, V, 'b-');
    ylin(0,0,Xmax,'k-');
    xlin(0,min(V),0,'b-');
    xlin(L,0,max(V),'b-');
    xlim([0 Xmax]); ylim([-Vylim, Vylim]);
    hold off;

    % Plot bending diagram
    subplot(2,1,2); hold on; grid on;
    title('Bending Moment Diagram', subtitle)
    xlabel(xLabSt); ylabel(momLabSt)
    plot(x, M, 'r-');
    ylin(0,0,Xmax,'k-');
    xlim([0 Xmax]); ylim([-Mylim, Mylim]);
    hold off;
end


