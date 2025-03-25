%% Header
% Author: Zakary Steenhoek
% Created: February 2025
% Updated: February 2025

function [delta] = percentDiff(value1, value2)
%PERCENTDIFF calcualtes the percent difference between two values
%   [DELTA] = PERCENTDIFF(VALUE1, VALUE2) returns the difference between
%   VALUE1 and VALUE2 as a percent, XX.XX%
%
% Input:
%   The first value, value1
%   The second value, value2
%
% Output:
%   The percentage difference: delta
%

% Set function vars
v1 = value1;
v2 = value2;

% Compute difference in percentage format, i.e. XX.XX%
delta = abs(v1-v2)/mean([v1 v2])*100;
end