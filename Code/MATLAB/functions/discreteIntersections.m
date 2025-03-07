%% Header
% Author: Zakary Steenhoek
% Created: February 2025
% Updated: February 2025

function [intX,intY] = discreteIntersections(L1,L2)
%DISCRETEINTERSECTIONS finds intersection of discrete curves
%   [INTX,INTY] = DISCRETEINTERSECTIONS(L1,L2) returns the intersection
%   points of two curves L1 and L2. The curves L1,L2 are described
%   by two-row-matrices, where each row contains its x- and y- coordinates.
%
% Input:
%   Curve 1, L1 = [x1,y1]
%   Curve 2, L2 = [x2,y2]
%
% Output:
%   the intersection point, I1 = [xi,yi]
%

% Isolate data
x1 = L1(:,1);
y1 = L1(:,2);
x2 = L2(:,1);
y2 = L2(:,2);

% Find intersection point
y2i = interp1(x2, y2, x1, 'pchip', 'extrap');
intX = interp1(y1-y2i, x1, 0);
intY = interp1(x1, y1, intX);
end