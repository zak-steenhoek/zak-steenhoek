%% Header
% Author: Zakary Steenhoek
% Created: January 2025
% Updated: March 2025

function [ratios] = isentropicRelations(M,opts)
%ISENTROPICRELATIONS calculates total flow properties
%   [RATIOS] = ISENTROPICRELATIONS(M,OPTS) returns total property ratios 
%   in an isentropic, compressible flow regime. Total properties are those
%   of the fluid if it were isentropically reduced to stagnation, and give 
%   an idea of the total fluid energy. These relations are necessary as 
%   the flow approaches or exceeds the upper limit of incompressibility 
%   and property changes are no longer negligible.
%
% Input:
%   M: double - Local Mach number
% 
% Options:
%   gamma: double - Ratio of specific heats. Default = 1.4 (air)
%   verbose: logical - Display results in command window. Default = false
%   single: int in [0,1,2,3] - If 1: T0/T, 2: p0/p, 3: rho0/rho. Default = 0
%
% Output:
%   output : struct OR scalar depending on opts.single
%       If opts.single == 0:
%           temperatureRatio: T0/T
%           pressureRatio: p0/p
%           densityRatio: rho0/rho
%       Else: Selected scalar ratio
%

%% Argument validation
arguments (Input)
    M double {mustBeNumeric, mustBeFinite, mustBeNonnegative}
    opts.gamma double {mustBePositive} = 1.4
    opts.verbose logical = false
    opts.single {mustBeMember(opts.single, 0:3)} = 0
end

% Assign options
gamma = opts.gamma;
verbose = opts.verbose;
select = opts.single;

%% Body

% Compute ratios
T0_T = (1+((gamma-1)./2).*M.^2);
p0_p = (1+((gamma-1)./2).*M.^2).^(gamma./(gamma-1));
rho0_rho = (1+((gamma-1)./2).*M.^2).^(1/(gamma-1));

%% Display
if verbose
    fprintf('Isentropic Property Ratios for M = %.3f, gamma = %.3f\n', M, gamma);
    fprintf('  Total Temperature Ratio (T0/T) : %.4f\n', T0_T);
    fprintf('  Total Pressure Ratio (p0/p)    : %.4f\n', p0_p);
    fprintf('  Total Density Ratio (rho0/rho) : %.4f\n', rho0_rho);
end

%% Output
if select == 1
    ratios = T0_T;
elseif select == 2
    ratios = p0_p;
elseif select == 3
    ratios = rho0_rho;
else
    ratios = struct( ...
        'temperatureRatio', T0_T, ...
        'pressureRatio', p0_p, ...
        'densityRatio', rho0_rho ...
    );
end

end
