%% Header
% Author: Zakary Steenhoek
% Created: February 2025
% Updated: March 2025

function [f] = plotPathData(analysisNumber)
%PLOTPATHDATA
%   [] = PLOTPATHDATA()
%
% Options:
%   Unless otherwise specified:
%
% Input:
%
%
% Output:
%
%

% Check valid call
arguments
    % Must be +int [1 10]
    analysisNumber double {mustBeInRange(analysisNumber,0,10)}
end

%% Extract data

% Figures object
f = [];

% Load results locally
load("data\bin\beamAnalysisResults.mat", "results");
theseResults = results(analysisNumber);

for i = 1:numel(theseResults)
    % Y path
    yCoords{i} = theseResults(i).pathYData.yCoords;
    yNormStress{i} = theseResults(i).pathYData.normStress;
    yShearStress{i} = theseResults(i).pathYData.shearStress;

    % Z path
    zCoords{i} = theseResults(i).pathZData.zCoords;
    zNormStress{i} = theseResults(i).pathZData.normStress;
    zShearStress{i} = theseResults(i).pathZData.shearStress;
end


%% Plots

% For multiple
spec = [{'k.-'} {'r.-'} {'b.-'} {'g.-'} {'m.-'}];
iteration = [{'Iteration 1'} {'Iteration 2'} {'Iteration 3'} ...
    {'Iteration 4'} {'Iteration 5'}];

% Plot Bending Stress for Path 1 (Vertical)
f(1) = figure; clf;
subplot(2,1,1); hold on; grid on;
title('Bending Stress Variation Along Y (Path 1)');
xlabel('Y Position (mm)');
ylabel('Bending Stress (MPa)');
for i = 1:numel(analysisNumber)
    plot(yCoords{i}, yNormStress{i}, spec{i});
end
legend(iteration{1:numel(analysisNumber)});
% xlim([]); ylim([]);
hold off;

% Plot Shear Stress for Path 1 (Vertical)
subplot(2,1,2); hold on; grid on;
title('Shear Stress Variation Along Y (Path 1)');
xlabel('Y Position (mm)');
ylabel('Shear Stress (MPa)');
for i = 1:numel(analysisNumber)
    plot(yCoords{i}, yShearStress{i}, spec{i});
end
legend(iteration{1:numel(analysisNumber)});
% xlim([]); ylim([]);
hold off;

% Plot Bending and Shear Stress for Path 2 (Horizontal)
f(2) = figure; clf;
subplot(2,1,1); hold on; grid on;
title('Bending Stress Variation Along Z (Path 2)');
xlabel('Z Position (mm)');
ylabel('Bending Stress (MPa)');
for i = 1:numel(analysisNumber)
    plot(zCoords{i}, zNormStress{i}, spec{i});
end
legend(iteration{1:numel(analysisNumber)});
% xlim([]); ylim([]);
hold off;

subplot(2,1,2); hold on; grid on;
title('Shear Stress Variation Along Z (Path 2)');
xlabel('Z Position (mm)');
ylabel('Shear Stress (MPa)');
for i = 1:numel(analysisNumber)
    plot(zCoords{i}, zShearStress{i}, spec{i});
end
legend(iteration{1:numel(analysisNumber)});
% xlim([]); ylim([]);
hold off;

end