%% Header
% Author: Zakary Steenhoek
% Created: January 2025
% Updated: February 2025

function [pressureRatio,densityRatio,temperatureRatio,M2] = ...
    normalShockRelations(M1,gamma,disp)
%NORMALSHOCKRELATIONS calculates flow properties across a normal shock
%   [PRESSURERATIO,DENSITYRATIO,TEMPERATURERATIO,M2] = ...
%       NORMALSHOCKRELATIONS(M1,GAMMA,DISP) returns properties across a
%   normal shock according to the normal shock relations, which are derived
%   from the more general oblique shock relations for the specific case of
%   extreme flow bending or an abrupt change in flow conditions.
%
% Input:
%   Upstream Mach number: M1
%   Ratio of specific heats: gamma
%   OPT: display in command window? DISP
%
% Output:
%   Ratio of down & upstream pressure: p2/p1,
%   Ratio of down & upstream density: rho2/rho1
%   Ratio of down & upstream temperature: T2/T1
%   Downstream Mach number: M2
%

% Detect optional DISP or default to false
if (~exist('disp', 'var'))
    disp = false;
end

% Compute ratios
pressureRatio = 1+((2*gamma)./(gamma+1)).*(M1.^2-1);
densityRatio = ((gamma+1).*M1.^2)./(2+(gamma-1).*M1.^2);
temperatureRatio = pressureRatio.*densityRatio.^(-1);
M2 = sqrt((1+((gamma-1)./2).*M1.^2)./(gamma.*M1.^2-(gamma-1)./2));

% Display
if disp
    fprintf('For M1 = %2.2f and gamma = %2.3f:\n', M1, gamma);
    fprintf('Pressure Ratio (p2/p1): %.4f\n', pressureRatio);
    fprintf('Density Ratio (rho2/rho1): %.4f\n', densityRatio);
    fprintf('Temperature Ratio (T2/T1): %.4f\n', temperatureRatio);
    fprintf('Downstream Mach number (M2): %.4f\n', M2);
end
end

