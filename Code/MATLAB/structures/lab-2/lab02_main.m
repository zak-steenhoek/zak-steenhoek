%% Header
% Author: Zakary Steenhoek
% Date: 19 February 2025
% Title: AEE325 Lab02

% Reset
clc; clear; 

%% Setup

% Variables (m typ.)
PR_L = 0.26;
PR_W = 0.02544;
PR_T = 0.00631;
DS_L = [0.26 0.184 0.108];
DS_W = 0.02544;
DS_T = 0.00631;
CS_L = [0.251 0.201 0.15 0.099];
CS_W = [0.02171 0.01679 0.02364 0.01385];
CS_T = .00634;
localPath = 'AEE325\Lab-2\figs';
syms F X Y I C1 eA C B H MX YM

% Equations
M = F.*X;
SA1 = (MX.*Y)./(I);
SA2 = C1.*eA;
SA3 = YM.*eA;
P = solve(SA1 == SA2, F);
EP = (C.*Y.*X)./I;
I = 1/12.*(B.*H.^3);

% Functions
moment = matlabFunction(M);
axialStress1 = matlabFunction(SA1);
axialStress2 = matlabFunction(SA2);
axialStress3 = matlabFunction(SA3);
load = matlabFunction(P);
youngsMod = matlabFunction(EP);
rectInertia = matlabFunction(I);

%% Data

% Poissons ratio beam
dataFilePR = importdata(buildPath('AEE325\Lab-2\data\PoissonsRatio.txt'));
PR_F = dataFilePR.data(:,2);
PR_us = dataFilePR.data(:,3:4);

% Distributed stress beam
dataFileDS = importdata(buildPath('AEE325\Lab-2\data\DistStress_data.txt'));
DS_F = dataFileDS.data(:,2);
DS_us = dataFileDS.data(:,3:5);

% Constant stress beam
dataFileCS = importdata(buildPath('AEE325\Lab-2\data\ConstStress_data.txt'));
CS_F = dataFileCS.data(:,2);
CS_us = dataFileCS.data(:,3:6);

%% Math

% Linear regression of load-strain
loadStrain = polyfit(PR_us(:,1),PR_F,1);

% Coefficient of the load-strain data -> E
C1 = loadStrain(1)*10^6;
PR_I = rectInertia(PR_W,PR_T);
E = youngsMod(C1,PR_I,PR_L,PR_T/2);

% Linear regression of strain-strain
strainStrain = polyfit(PR_us(:,1),PR_us(:,2),1);

% Coefficient of the strain-strain data -> Posson's ratio
C2 = strainStrain(1);
PR_ratio = C2;

% Intertia for both beams
DS_I = rectInertia(DS_W,DS_T);
CS_I = rectInertia(CS_W,CS_T);

% Moments for both beams
DS_M = moment(DS_F,DS_L);
CS_M = moment(CS_F,CS_L);

% Exp axial stress for both beams
DS_S_exp = axialStress1(DS_I,DS_M,DS_T/2);
CS_S_exp = axialStress1(CS_I,CS_M,CS_T/2);

% Analytical axial stress for both beams
DS_S_ana = axialStress3(E,DS_us.*10^-6);
CS_S_ana = axialStress3(E,CS_us.*10^-6);


%% Plots

% Diagrams for constant cross section beam
simpcantSM(max(DS_L), max(DS_F),max(DS_L),{'m', 'N'},1);
% autosave('shear-moment', localPath, 1);

% Load-strain plot
figure(1); clf; hold on; grid on;
title('Load-strain diagram')
xlabel('Axial microstrain, \epsilon*10^{-6}'); ylabel('Load, P (N)');
plot(PR_us(:,1),PR_F,'rx')
fplot(poly2sym(loadStrain),'k-')
legend('Force-strain data', 'Regression curve', Location='best');
xlim([min(PR_us(:,1)) max(PR_us(:,1))]); ylim([min(PR_F) max(PR_F)]); 
hold off;
% autosave('load-strain', localPath);

% Strain-strain plot
figure(2); clf; hold on; grid on;
title('Strain-strain diagram')
xlabel('Axial microstrain, \epsilon*10^{-6}'); 
ylabel('Transverse microstrain, \epsilon*10^{-6}');
plot(PR_us(:,1),PR_us(:,2),'rx')
fplot(poly2sym(strainStrain),'k-')
legend('Strain-strain data', 'Regression curve', Location='best');
xlim([min(PR_us(:,1)) max(PR_us(:,1))]); 
ylim([min(PR_us(:,2)) max(PR_us(:,2))]); 
hold off;
% autosave('strain-strain', localPath);

% Distributed stress plots
figure(31); clf; hold on; grid on;
subtitle = 'Constant cross-section beam, P = ' + string(DS_F(1)) + ' N';
title('Axial stress vs. x-distance', subtitle)
xlabel('Distance, x (m)'); ylabel('Stress, \sigma (Pa)');
plot(DS_L, DS_S_exp(1,:),'k.-')
plot(DS_L, DS_S_ana(1,:),'rx--')
legend('Experimental stress', 'Theoretical stress', Location='best');
xlim([min(DS_L) max(DS_L)]); 
ylim([min(DS_S_ana(1,:)) max(DS_S_exp(1,:))]);
hold off;

figure(32); clf; hold on; grid on;
subtitle = 'Constant cross-section beam, P = ' + string(DS_F(2)) + ' N';
title('Axial stress vs. x-distance', subtitle)
xlabel('Distance, x (m)'); ylabel('Stress, \sigma (Pa)');
plot(DS_L, DS_S_exp(2,:),'k.-')
plot(DS_L, DS_S_ana(2,:),'rx--')
legend('Experimental stress', 'Theoretical stress', Location='best');
xlim([min(DS_L) max(DS_L)]); 
ylim([min(DS_S_ana(2,:)) max(DS_S_exp(2,:))]);
hold off;

figure(33); clf; hold on; grid on;
subtitle = 'Constant cross-section beam, P = ' + string(DS_F(3)) + ' N';
title('Axial stress vs. x-distance', subtitle)
xlabel('Distance, x (m)'); ylabel('Stress, \sigma (Pa)');
plot(DS_L, DS_S_exp(3,:),'k.-')
plot(DS_L, DS_S_ana(3,:),'rx--')
legend('Experimental stress', 'Theoretical stress', Location='best');
xlim([min(DS_L) max(DS_L)]); 
ylim([min(DS_S_ana(3,:)) max(DS_S_exp(3,:))]);
hold off;

figure(34); clf; hold on; grid on;
subtitle = 'Constant cross-section beam, P = ' + string(DS_F(4)) + ' N';
title('Axial stress vs. x-distance', subtitle)
xlabel('Distance, x (m)'); ylabel('Stress, \sigma (Pa)');
plot(DS_L, DS_S_exp(4,:),'k.-')
plot(DS_L, DS_S_ana(4,:),'rx--')
legend('Experimental stress', 'Theoretical stress', Location='best');
xlim([min(DS_L) max(DS_L)]); 
ylim([min(DS_S_ana(4,:)) max(DS_S_exp(4,:))]);
hold off;

figure(35); clf; hold on; grid on;
subtitle = 'Constant cross-section beam, P = ' + string(DS_F(5)) + ' N';
title('Axial stress vs. x-distance', subtitle)
xlabel('Distance, x (m)'); ylabel('Stress, \sigma (Pa)');
plot(DS_L, DS_S_exp(5,:),'k.-')
plot(DS_L, DS_S_ana(5,:),'rx--')
legend('Experimental stress', 'Theoretical stress', Location='best');
xlim([min(DS_L) max(DS_L)]); 
ylim([min(DS_S_ana(5,:)) max(DS_S_exp(5,:))]);
hold off;
% autosave('DistStress', localPath, 1);

% Constant stress plots
figure(41); clf; hold on; grid on;
subtitle = 'Variable cross-section beam, P = ' + string(CS_F(1)) + ' N';
title('Axial stress vs. x-distance', subtitle)
xlabel('Distance, x (m)'); ylabel('Stress, \sigma (Pa)');
plot(CS_L, CS_S_exp(1,:),'k.-')
plot(CS_L, CS_S_ana(1,:),'rx--')
legend('Experimental stress', 'Theoretical stress', Location='best');
xlim([min(CS_L) max(CS_L)]); 
ylim([min(CS_S_exp(1,:)) max(CS_S_ana(1,:))]);
hold off;

figure(42); clf; hold on; grid on;
subtitle = 'Variable cross-section beam, P = ' + string(CS_F(2)) + ' N';
title('Axial stress vs. x-distance', subtitle)
xlabel('Distance, x (m)'); ylabel('Stress, \sigma (Pa)');
plot(CS_L, CS_S_exp(2,:),'k.-')
plot(CS_L, CS_S_ana(2,:),'rx--')
legend('Experimental stress', 'Theoretical stress', Location='best');
xlim([min(CS_L) max(CS_L)]); 
ylim([min(CS_S_exp(2,:)) max(CS_S_ana(2,:))]);
hold off;

figure(43); clf; hold on; grid on;
subtitle = 'Variable cross-section beam, P = ' + string(CS_F(3)) + ' N';
title('Axial stress vs. x-distance', subtitle)
xlabel('Distance, x (m)'); ylabel('Stress, \sigma (Pa)');
plot(CS_L, CS_S_exp(3,:),'k.-')
plot(CS_L, CS_S_ana(3,:),'rx--')
legend('Experimental stress', 'Theoretical stress', Location='best');
xlim([min(CS_L) max(CS_L)]); 
ylim([min(CS_S_exp(3,:)) max(CS_S_ana(3,:))]);
hold off;

figure(44); clf; hold on; grid on;
subtitle = 'Variable cross-section beam, P = ' + string(CS_F(4)) + ' N';
title('Axial stress vs. x-distance', subtitle)
xlabel('Distance, x (m)'); ylabel('Stress, \sigma (Pa)');
plot(CS_L, CS_S_exp(4,:),'k.-')
plot(CS_L, CS_S_ana(4,:),'rx--')
legend('Experimental stress', 'Theoretical stress', Location='best');
xlim([min(CS_L) max(CS_L)]); 
ylim([min(CS_S_exp(4,:)) max(CS_S_ana(4,:))]);
hold off;

figure(45); clf; hold on; grid on;
subtitle = 'Variable cross-section beam, P = ' + string(CS_F(5)) + ' N';
title('Axial stress vs. x-distance', subtitle)
xlabel('Distance, x (m)'); ylabel('Stress, \sigma (Pa)');
plot(CS_L, CS_S_exp(5,:),'k.-')
plot(CS_L, CS_S_ana(5,:),'rx--')
legend('Experimental stress', 'Theoretical stress', Location='best');
xlim([min(CS_L) max(CS_L)]); 
ylim([min(CS_S_exp(5,:)) max(CS_S_exp(5,:))]);
hold off;
% autosave('ConstStress', localPath, 1);
