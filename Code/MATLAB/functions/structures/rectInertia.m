%% Header
% Author: Zakary Steenhoek
% Created: February 2025
% Updated: February 2025

function [I] = rectInertia(b,h)
%RECTINERTIA Inertia of rectangular x-section
%   [I] = RECTINERTIA(B,H) returns the second moment of area I for a
%   rectangular x-section according to:
% 
% I = 1/12 * B * H^3
%
% Input:
%   Beam base, B
%   Beam height, H
%
% Output:
%   X-section inertia, I
%

I = 1/12.*b.*h.^3;
end


