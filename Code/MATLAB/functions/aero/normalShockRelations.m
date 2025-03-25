%% Header
% Author: Zakary Steenhoek
% Created: January 2025
% Updated: March 2025

function results = normalShockRelations(M1, opts)
%NORMALSHOCKRELATIONS calculates flow properties across a normal shock
%   RESULTS = NORMALSHOCKRELATIONS(M1, OPTS) returns properties across a
%   normal shock according to the normal shock relations, which are derived
%   from the more general oblique shock relations for the specific case of
%   extreme flow bending or an abrupt change in flow conditions.
%
% Input:
%   M1: double - Upstream Mach number (must be > 1)
% 
% Options:
%   gamma: double - ratio of specific heats. Default = 1.4 (air)
%   verbose: logical - Print output to command wondow. Default = false
% 
% Output:
%   results: struct with fields:
%       pressureRatio: p2 / p1
%       densityRatio: rho2 / rho1
%       temperatureRatio: T2 / T1
%       M2: Downstream Mach number
%

%% Argument validation
arguments (Input)
    M1 double {mustBeNumeric, mustBeFinite, mustBeGreaterThanOrEqual(M1, 1)}
    opts.gamma double {mustBePositive} = 1.4
    opts.verbose logical = false
end

% Options assignment
gamma = opts.gamma;
verbose = opts.verbose;

%% Body

% Compute ratios
pressureRatio = 1+((2*gamma)./(gamma+1)).*(M1.^2-1);
densityRatio = ((gamma+1).*M1.^2)./(2+(gamma-1).*M1.^2);
temperatureRatio = pressureRatio.*densityRatio.^(-1);
M2 = sqrt((1+((gamma-1)./2).*M1.^2)./(gamma.*M1.^2-(gamma-1)./2));

%% Display (optional)
if verbose
    fprintf('Normal Shock Properties for M1 = %.3f, gamma = %.3f\n', M1, gamma);
    fprintf('  Pressure Ratio     (p2/p1): %.4f\n', pressureRatio);
    fprintf('  Density Ratio     (rho2/rho1): %.4f\n', densityRatio);
    fprintf('  Temperature Ratio (T2/T1): %.4f\n', temperatureRatio);
    fprintf('  Downstream Mach   (M2):     %.4f\n', M2);
end

%% Output
results = struct( ...
    'pressureRatio', pressureRatio, ...
    'densityRatio', densityRatio, ...
    'temperatureRatio', temperatureRatio, ...
    'M2', M2 ...
);

end

