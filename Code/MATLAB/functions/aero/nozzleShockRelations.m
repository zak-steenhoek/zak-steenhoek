%% Header
% Author: Zakary Steenhoek
% Created: March 2025
% Updated: March 2025

function [results] = nozzleShockRelations(p0pe, AeAt, opts)
%NOZZLESHOCKRELATIONS Solves normal shock relations inside a nozzle
%	[RESULTS] = NOZZLESHOCKRELATIONS(P0PE, AEAT, OPTS) solves the normal shock
%	relations for a nozzle regime given a total-to-exit pressure ratio and
%	the exit-to-throat area ratio. Options to display output or modify gamma
%
% Input:
%   Total-to-exit pressure ratio: p0pe
%   Exit-to-throat area ratio: AeAt
%
% Output:
%   Results struct: results
%
% Options:
%   Display output: disp; Def: false
%   Ratio of specific heats: gamma; Def: 1.4 (air)
%

%% Argument validation
arguments (Input)
    % Must be numeric greater than 0
    p0pe double {mustBePositive}

    % Must be numeric greater than 0
    AeAt double {mustBePositive}

    % Must be logical; Def = 0
    opts.disp logical = 0

    % Must be numeric; Def = 1.4 (air)
    opts.gamma double = 1.4
end

% Options vars
displayOutput = opts.disp;
gamma = opts.gamma;

%% Body

% Objective function for fsolve
residualFcn = @(x) internalResidual(x, p0pe, AeAt, gamma);

% Reasonable initial guess for [M1, Me]
x0 = [2.5, 2.0];

opts = optimoptions('fsolve', 'Display', 'off');
[xsol, fval, exitflag] = fsolve(residualFcn, x0, opts);

% Extract solution
M1 = xsol(1);
Me = xsol(2);

% Post-shock Mach number
M2 = sqrt((2 + (gamma - 1)*M1^2)/(2*gamma*M1^2 - (gamma - 1)));

% Pressure ratios
p0p1 = (1 + (gamma - 1)/2 * M1^2)^(gamma / (gamma - 1));
p2p1 = 1 + 2*gamma / (gamma + 1) * (M1^2 - 1);
p2pe = ((1 + (gamma - 1)/2 * Me^2) / (1 + (gamma - 1)/2 * M2^2))^(gamma / (gamma - 1));
p0pe_est = p0p1 * p2pe / p2p1;

% Area ratios
AIaStar = 1/M1 * ( (2/(gamma+1)*(1 + (gamma - 1)/2 * M1^2)) )^((gamma+1)/(2*(gamma-1)));
AeA2 = M2/Me * ((1 + (gamma - 1)/2 * Me^2)/(1 + (gamma - 1)/2 * M2^2))^((gamma+1)/(2*(gamma-1)));
AeAt_est = AeA2 * AIaStar;

%% Output

% Package results
results = struct( ...
    'M1', M1, ...
    'M2', M2, ...
    'Me', Me, ...
    'p0p1', p0p1, ...
    'p2p1', p2p1, ...
    'p2pe', p2pe, ...
    'p0pe_est', p0pe_est, ...
    'AIaStar', AIaStar, ...
    'AeA2', AeA2, ...
    'AeAt_est', AeAt_est, ...
    'fval', fval, ...
    'exitflag', exitflag ...
    );

if displayOutput
    fprintf('✅ Shock Solution Found\n');
    fprintf('  M1 (pre-shock): %.4f\n', M1);
    fprintf('  M2 (post-shock): %.4f\n', M2);
    fprintf('  Me (exit Mach): %.4f\n', Me);
    fprintf('  p0/pe (target): %.4f | (est): %.4f\n', p0pe, p0pe_est);
    fprintf('  Ae/At (target): %.4f | (est): %.4f\n', AeAt, AeAt_est);
    fprintf('  fsolve exit flag: %d\n', exitflag);
end

end

%% Internal residual function (private)
function y = internalResidual(x, p0pe, AeAt, gamma)
M1 = x(1); Me = x(2);

% Shock jump
M2 = sqrt((2 + (gamma - 1)*M1^2)/(2*gamma*M1^2 - (gamma - 1)));
p2p1 = 1 + 2*gamma / (gamma + 1) * (M1^2 - 1);

% Isentropic relations
p0p1 = (1 + (gamma - 1)/2 * M1^2)^(gamma / (gamma - 1));
p2pe = ((1 + (gamma - 1)/2 * Me^2) / (1 + (gamma - 1)/2 * M2^2))^(gamma / (gamma - 1));
p0pe_est = p0p1 * p2pe / p2p1;

% Area-Mach number
AIaStar = 1/M1 * ( (2/(gamma+1)*(1 + (gamma - 1)/2 * M1^2)) )^((gamma+1)/(2*(gamma-1)));
AeA2 = M2/Me * ((1 + (gamma - 1)/2 * Me^2)/(1 + (gamma - 1)/2 * M2^2))^((gamma+1)/(2*(gamma-1)));
AeAt_est = AeA2 * AIaStar;

% Residuals
y = [p0pe_est - p0pe;
    AeAt_est - AeAt];
end