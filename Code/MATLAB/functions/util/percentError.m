%% Header
% Author: Zakary Steenhoek
% Created: February 2025
% Updated: February 2025

function [delta] = percentError(expected, observed)
%PERCENTERROR calcualtes the percent error between two values
%   [DELTA] = PERCENTERROR(EXPECTED, OBSERVED) returns the error between
%   OBSERVED and EXPECTED as a percent, XX.XX%
%
% Input:
%   The expected or more precise value, EXPECTED
%   The observed or comparison value, OBSERVED
%
% Output:
%   The percentage error: DELTA
%

% Set function vars
ve = expected;
va = observed;

% Compute error in percentage format, i.e. XX.XX%
delta = abs((va-ve)/ve)*100;
end