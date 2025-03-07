%% Header
% Author: Zakary Steenhoek
% Created: January 2025
% Updated: February 2025

function [ratios] = isentropicRelations(M,opts)
%ISENTROPICRELATIONS calculates total flow properties
%   [T0RATIO,P0RATIO,D0RATIO] = ISENTROPICRELATIONS(M,OPTS)
%   Returns total property ratios in an isentropic, compressible flow
%   regime. Total properties are those of the fluid if it were
%   isentropically reduced to stagnation, and give an idea of the total
%   fluid energy. These relations are necessary as the flow approaches
%   or exceeds the upper limit of incompressibility and property changes
%   are no longer negligible.
%
% Options:
%   Unless otherwise specified: GAMMA defaults to calorically perfect air.
%   The ratios are not displayed in the command window. All three ratios
%   are returned as [TR,PR,DR] = [1,2,3]
%
% Input:
%   Local Mach number: M
%   OPT: Ratio of specific heats: gamma; DEF: 1.4
%   OPT: Display in command window: disp; DEF: logical 0
%   OPT: Single relation: onlyOne; DEF: 0
%
% Output:
%   Total temperature ratio: T0/T
%   Total pressure ratio: p0/p
%   Total density ratio: rho0/rho
%

% Check valid call
arguments
    % Must be numeric
    M double

    % Must be numeric; Def = 1.4
    opts.gamma double = 1.4

    % Must be logical; Def = 0
    opts.disp logical = 0

    % Must be +int [0 3]; Def = 0
    opts.single {mustBeInRange(opts.single,0,3)} = 0
end

% Set args
gamma = opts.gamma;

% Compute ratios
T0R = (1+((gamma-1)./2).*M.^2);
P0R = (1+((gamma-1)./2).*M.^2).^(gamma./(gamma-1));
D0R = (1+((gamma-1)./2).*M.^2).^(1/(gamma-1));

% Return condition
if (opts.single ~= 0)
    if (opts.single == 1)
        ratios = T0R;
    elseif (opts.single == 2)
        ratios = P0R;
    else
        ratios = D0R;
    end
else
    ratios = [T0R, P0R, D0R];
end

% Display
if opts.disp
    fprintf('For M = %2.2f and gamma = %2.3f:\n', M, gamma);
    fprintf('Total temperature ratio: %.4f\n', T0Ratio);
    fprintf('Total pressure ratio: %.4f\n', P0Ratio);
    fprintf('Total density ratio: %.4f\n', D0Ratio);
end
end
