%% Header
% Author: Zakary Steenhoek
% Created: January 2025
% Updated: February 2025

function [q] = dynamicPressure(density,velocity)
%DYNAMICPRESSURE Calculates the dynamic pressure
%   [Q] = DYNAMICPRESSURE(DENSITY,VELOCITY) returns the dynamic pressure Q
%   as a function of density and velocity according to:
%       Q=0.5*DENSITY*VELOCITY^2
%
% Input:
%   Air density, DENSITY
%   Freestream velocity, VELOCITY
%
% Output:
%   dynamic pressure, Q
%

rho = density;
v = velocity;
q = 0.5*rho*v^2;
end