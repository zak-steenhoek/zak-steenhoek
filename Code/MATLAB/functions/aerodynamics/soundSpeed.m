%% Header
% Author: Zakary Steenhoek
% Created: February 2025
% Updated: February 2025

function [a] = soundSpeed(temperature,opts)
%SOUNDSPEED computes the speed of sound from isentropic relations
%   [A] = SOUNDSPEED(TEMPERATURE,GAMMA, R)
%       = sqrt(gamma*R*T)
%   Returns local speed of sound A in a fluid as a function of static
%   temperature, and thermodynamic properties of the fluid in question.
%   The speed of sound relation is derived from isentropic relations, and
%   assumes an ideal calorically perfect gas with some constant ratio of
%   specific heats, gamma, and some specific gas constant R.
% 
% Options: 
%   Unless otherwide provided, GAMMA and R default to the values for 
%   calorically perfect air.
%
% Input:
%   Local absolute static temperature: temperature (K)
%   OPT: Ratio of specific heats: gamma; DEF: 1.4
%   OPT: Specific gas constant: sgr; DEF: 287 (J/(kg*K))
%
% Output:
%   Speed of sound: a (m/s)
%

% Check valid call
arguments
    % Must be numeric
    temperature double

    % Must be numeric; Def = 1.4
    opts.gamma double = 1.4

    % Must be numeric; Def = 287
    opts.sgr double = 287
end

% Set options
G = opts.gamma; R = opts.sgr;

% Compute speed of sound
a = sqrt(G.*R.*temperature);
end
