%% Header
% Author: Zakary Steenhoek
% Date: 12 February 2025
% Title: AEE325 LAB01: Steel

% Reset
clc; clear;

%% Setup

% Variables (m typ.)
D0 = 0.5503E-2;
L0 = 1.27E-2;
L1 = 4.9E-2;
L2 = 0.7267E-2;
L3 = 0.6406E-2;
Df = 0.53E-2;
Lf = 5.4E-2;
Pf = 1.87800E3;
A0 = 0.25*D0^2;
Af = 0.25*Df^2;
syms PI DLI

% Equations
SI = PI./A0;
EI = DLI./L0;
AI = A0./(1+EI);
SIGMAI = PI./AI;
EPSILONI = log(1+EI);

% Functions
engStress = matlabFunction(SI);
engStrain = matlabFunction(EI);
instantArea = matlabFunction(AI);
trueStress = matlabFunction(SIGMAI);
trueStrain = matlabFunction(EPSILONI);

%% Data

% Import steel specimin data
dataFileST = importdata(buildPath('AEE325\Lab-1\data\ST_cdl.txt'));
[~, uniqueIdx] = unique(dataFileST.data(:,2), 'stable');
cleanData = dataFileST.data(uniqueIdx,:);
dLi = cleanData(:,2)./1000;
Pi = cleanData(:,3).*1000;

%% Math

% Compute stress and strain
sigma_eng = engStress(Pi);
epsilon_eng = engStrain(dLi);
sigma_t = trueStress(dLi,Pi);
epsilon_t = trueStrain(dLi);
Ai = instantArea(dLi);

% Postprocess engineering curve data
validIdx = sigma_eng > 0.015*max(sigma_eng);
sigma_eng = sigma_eng(validIdx);
epsilon_eng = epsilon_eng(validIdx);
windowSize = 5;
sigma_eng = movmean(sigma_eng, windowSize);
epsilon_eng = movmean(epsilon_eng, windowSize);
shiftX = epsilon_eng(1); shiftY = sigma_eng(1);
sigma_eng = sigma_eng - shiftY;
epsilon_eng = epsilon_eng - shiftX;

% Postprocess true curve data
validIdx = sigma_t > 0.05*max(sigma_t);
sigma_t = sigma_t(validIdx);
epsilon_t = epsilon_t(validIdx);
windowSize = 5;
sigma_t = movmean(sigma_t, windowSize);
epsilon_t = movmean(epsilon_t, windowSize);
shiftX = epsilon_t(1); shiftY = sigma_t(1);
sigma_t = sigma_t - shiftY;
epsilon_t = epsilon_t - shiftX;

% Determine engineering curve elastic region
nSlope_eng = (diff(sigma_eng)./diff(epsilon_eng));
elasticIdx_eng = find(nSlope_eng > 0.25E11, 1, "last");
epsilone_eng = epsilon_eng(1:elasticIdx_eng);
sigmae_eng = sigma_eng(1:elasticIdx_eng);

% Determine true curve elastic region
nSlope_t = (diff(sigma_t)./diff(epsilon_t));
elasticIdx_t = find(nSlope_t > 0.25E11, 1, "last");
epsilone_t = epsilon_t(1:elasticIdx_t);
sigmae_t = sigma_t(1:elasticIdx_t);

% Find engineering curve ultimate strength
Su_eng = max(sigma_eng);
eu_eng = epsilon_eng(sigma_eng == Su_eng);

% Find true curve ultimate strength
Su_t = max(sigma_t);
eu_t = epsilon_t(sigma_t == Su_t);

% Find engineering curve fracture strength
Sf_eng = Pf/A0;
ef_eng = epsilon_eng(find(sigma_eng - Sf_eng > 0, 1, 'last'));

% Find true curve fracture strength
Sf_t = Pf/A0;
ef_t = epsilon_t(find(sigma_t - Sf_t > 0, 1, 'last'));

% Estimate Young's modulus
offset = polyfit(epsilone_eng, sigmae_eng, 1);
E = offset(1);

% Determine the offset line
epsiloni_o = epsilon_eng + 0.002;
sigmai_o = (E * epsiloni_o);
shiftY = sigmai_o(1);
sigmai_o = sigmai_o - shiftY;

% Find engineering curve yield strength
[ey_eng, Sy_eng] = discreteIntersections([epsilon_eng,sigma_eng],...
    [epsiloni_o,sigmai_o]);

% Find engineering curve yield strength
[epsilony_t, sigmay_t] = discreteIntersections([epsilon_t,sigma_t],...
    [epsiloni_o,sigmai_o]);

% Determine log-log relationship
logRange_min = find(epsilon_t == eu_t);
logRange_max = find(epsilon_t(epsilon_t-epsilony_t < 0.0001), 1, "last");
log_e_t = log(epsilon_t(logRange_min:logRange_max));
log_S_t = log(sigma_t(logRange_min:logRange_max));

% Estimate power law plasticity coefficients
plastic = polyfit(log_e_t, log_S_t, 1);
n = plastic(1);
K = exp(plastic(2));

% Elongation and area reduction
enlongation = 100*ef_t;
areaReduction = 100*(A0-Af)/A0;

%% Plots

% Engineering diagram
figure(11); clf; hold on; grid on;
title('Engineering Stress-Strain Diagram', '1018 Carbon Steel')
xlabel('Strain, e_i (m/m)');
ylabel('Stress, S_i (GPa)');
plot(epsilon_eng, sigma_eng./10E8, 'k.-');
plot(epsilone_eng, sigmae_eng./10E8, 'r.-');
plot(epsiloni_o, sigmai_o./10E8, 'g--');
plot(ey_eng, Sy_eng/10E8, 'ko', 'MarkerFaceColor', 'g');
plot(eu_eng, Su_eng/10E8, 'ko', 'MarkerFaceColor', 'r');
plot(ef_eng, Sf_eng/10E8, 'ko', 'MarkerFaceColor', 'k');
legend('Eng. stress-strain curve', ...
    'Elastic region', ...
    '0.2% Offset line', ...
    'Yield strength', ...
    'Ultimate strength', ...
    'Fracture strength', ...
    'Location','best');
xlim([0 0.05]);
ylim([0 .35]);
hold off;

q = findobj('type','figure');
% autosave(q, 'Eng_SS_ST', 'AEE325\Lab-1\figs');

% True diagram
figure(12); clf; hold on; grid on;
title('True Stress-Strain Diagram', '1018 Carbon Steel')
xlabel('Strain, e_i (m/m)');
ylabel('Stress, S_i (GPa)');
plot(epsilon_t, sigma_t./10E8, 'k.-');
plot(epsilone_t, sigmae_t./10E8, 'r.-');
plot(epsiloni_o, sigmai_o./10E8, 'g--');
plot(epsilony_t, sigmay_t/10E8, 'ko', 'MarkerFaceColor', 'g');
plot(eu_t, Su_t/10E8, 'ko', 'MarkerFaceColor', 'r');
plot(ef_t, Sf_t/10E8, 'ko', 'MarkerFaceColor', 'k');
legend('True stress-strain curve', ...
    'Elastic region', ...
    '0.2% Offset line', ...
    'Yield strength', ...
    'Ultimate strength', ...
    'Fracture strength', ...
    'Location','best');
xlim([0 0.05]); ylim([0 .35]);
hold off;

q = findobj('type','figure');
% autosave(q, 'True_SS_ST', 'AEE325\Lab-1\figs');

% Log plot
figure(13); clf; hold on; grid on;
title('True Stress-Strain Log-Log Plot', '1018 Carbon Steel')
xlabel('Strain, e_i (m/m)');
ylabel('Stress, S_i (GPa)');
plot(log_e_t, log_S_t, 'k.-');
fplot(poly2sym(plastic), 'r--');
legend('Log-log relationship of true stress-strain curve', ...
    'Linear regression of log-log relationship', ...
    'Location','best');
xlim([log_e_t(1), log_e_t(end)]);
ylim([log_S_t(end), log_S_t(1)]);
hold off;

q = findobj('type','figure');
% autosave(q, 'LL_ST', 'AEE325\Lab-1\figs');

%%
% 
% figure(111); clf; hold on; grid on;
% title('dogshit')
% xlabel('strain'); ylabel('stress');
% plot(engStrain(dLi), engStress(Pi), 'k.-')
% legend('dogshit');
% % xlim([]); ylim([]);
% hold off;

