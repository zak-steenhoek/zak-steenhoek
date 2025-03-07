%% Header
% Author: Zakary Steenhoek
% Created: February 2025
% Updated: February 2025

function seeEq(equation)
%SEEEQ visualize symbolic equation
%   SEEEQ(EQUATION) takes symbolic EQUATION and displays it on a figure in
%   professional math notation using a LaTeX conversion and interpreter.
%
% Input:
%   Symbolic equation: EQUATION
%
% Output:
%   NONE

figure(); clf; hold on;
set(gca, 'Visible', 'off');
axis([0 10 0 10])
L = "$" + latex(equation) + "$";
text(2.5, 5, L, 'interpreter', 'latex', 'FontSize', 25)
end