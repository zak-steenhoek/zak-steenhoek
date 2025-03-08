%% Header
% Author: Zakary Steenhoek | Matthew Herdegen
% Date: 1 March 2025
% Title: P01_main.m

% Reset
clc; clear; 

%% Make Data

% Only if needed!!
% makeProjectData();

%% Setup

% Load data
madeDataFiles = buildPath('AEE325\Project-1\data\bin\');
load(strcat(madeDataFiles, 'projectConstants.mat'));
load(strcat(madeDataFiles, 'beamAnalysisResults.mat'));

%% Analysis

% Get max magnitudes for convergence
beamNormalStress = [results.maxNormB; results.minNormB];
beamShearStress = [results.maxShearB; results.minShearB];
beamMaxNorm = max(abs(beamNormalStress),[],1);
beamMaxShear = max(abs(beamShearStress),[],1);

% Variation of max stresses
beamMaxStressRatio = beamMaxShear(5:10)./beamMaxNorm(5:10);
beamLengths = [1 0.75 0.5 0.375 0.25 0.125]; beamHeight = 0.1;
heightLengthRatio = beamHeight./beamLengths;

%% Plots

% Convergence diagram
% figure(1); clf; hold on; grid on;
% title('Convergence')
% xlabel('Iteration'); ylabel('Max Stress (GPa)');
% plot(1:5, beamMaxNorm(1:5), 'k.-')
% plot(1:5, beamMaxShear(1:5), 'k.-')
% legend('max norm', 'max shear');
% hold off;
% autosave('convergence', 'AEE325\Project-1\figs');

% Last part plot
figure(2); clf; hold on; grid on;
title('Ratio of Max Stresses vs. Height-Length Aspect Ratio')
xlabel('Height-Length Ratio'); ylabel('Ratio of maximum stresses');
plot(heightLengthRatio, beamMaxStressRatio, 'k.-')
legend('Stress ratio vs. height-length aspect ratio');
% xlim([]); ylim([]);
hold off;
autosave('stress_aspect_ratio', 'AEE325\Project-1\figs');

% Path variations
% plotPathData(1);
% plotPathData(1:5);
% plotPathData(6);
% plotPathData(7);
% plotPathData(8);
% plotPathData(9);
% plotPathData(10);



