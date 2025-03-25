%% Header
% Author: Zakary Steenhoek
% Date: 19 September 2024
% AEE360::LAB01

clc; clear; close all;                          % Reset

%% Global 

% Constants
R_AIR = 287.0;                                  % gas constant [J/kg*K]
MANO_BIAS = abs(-0.048);                        % manometer bias [inH2O]
ERR_ABS_TRANSDUCER = 100;                       % machine error [Pa] 
ERR_THERMO = 1;                                 % machine error [deg C]
ERR_TRANSDUCER = 0.01;                          % machine error [Volt]
ERR_SCANNIVALVE = 0.005;                        % machine error [Volt]
ERR_MANOMETER = 0.005;                          % machine error [inH2O]
RATIO_A1A2 = 6.25;                              % dimensionless
RATIO_A2A1 = 1/RATIO_A1A2;                      % dimensionless

% Measurements
p_measured_kpa = 96.29;                         % ambient atmospheric pressure [kPa]
p_abs_pa = 96290;                               % ambient atmospheric pressure [Pa]
t_measured_cel = 32.7;                          % ambient air temperature [degrees celcius]
t_air_kel = 305.85;                             % ambient air temperature [Kelvin]

% Symbolic variables
syms P T MM RHO

%% Data

% Import files
allData_2 = importdata("Lab1_ThuB600_2.txt");
allData_3 = importdata("Lab1_ThuB600_3.txt");

% Data needed for pt. 2 
manometer_2 = allData_2.data(:, 3);             % manometer pressure differential [inH2O]
transducer_2 = allData_2.data(:, 4);            % transducer reading [Volts]
scannivalve_2 = abs(allData_2.data(:, 5));      % scannivalve reading [Volts]

% Data needed for pt. 3 
hz_3 = allData_3.data(:, 1);                    % frequency [Hz]
manometer_3 = allData_3.data(:, 3);             % manometer pressure differential [inH2O]
transducer_3 = allData_3.data(:, 4);            % transducer reading [Volts]
scannivalve_3 = allData_3.data(:, 5);           % scannivalve reading [Volts]
velocity_3 = allData_3.data(:, 7);              % flow velocity [m/s]

%% Equations & Functions

% Ideal Gas Law -> rearranged for rho
gasLaw_rho = @(P,T) P./(R_AIR*T);               % Ideal Gas Law [Pa, deg C]

% Partial derivitives of RHO -> error calculations
gasLaw_dP = diff(gasLaw_rho(P,T),P);            % ptl rho w.r.t pressure
gasLaw_dT = diff(gasLaw_rho(P,T),T);            % ptl rho w.r.t temp

% Dynamic pressure -> rearranged for velocity
vDyn = @(P,RHO) sqrt((2.*P)./RHO);              % dynamic pressure [Pa, kg/m^3]

% Partial derivitives of Vdyn -> error calculations
vDyn_dP = diff(vDyn(P,RHO),P);                  % ptl velocity w.r.t pressure
vDyn_dRHO = diff(vDyn(P,RHO),RHO);              % ptl velocity w.r.t. density 

% Bernoulli's Equation -> rearranged with mass conservation
V2 = @(MM,RHO) sqrt((2*MM)./(RHO*(1-RATIO_A2A1^2)));

% Partial derivitives of V2 -> error calculations
V2_dMM = diff(V2(MM,RHO),MM);                   % ptl velocity w.r.t pressure differential
V2_dRHO = diff(V2(MM,RHO),RHO);                 % ptl velocity w.r.t density

% inH2O to Pa -> from internet
inH2OToPa = @(inH2O) inH2O*249.089;             % pressure conversion

% Mass conservation -> incompressible flow
V1 = @(V2) RATIO_A2A1*V2;                       % velocity conversion

%% Misc

% Convert manometer values from inH2O to Pa & factor in bias
manometer_2 = manometer_2+MANO_BIAS;
manometer_3 = manometer_3+MANO_BIAS;
mm_2 = inH2OToPa(manometer_2);
mm_3 = inH2OToPa(manometer_3);

% Convert manometer machine error to Pa
ERR_MANOMETER_PA = ERR_MANOMETER*249.089;

%% Part 1: Density & Uncertainty

% Air density
rho = gasLaw_rho(p_abs_pa, t_air_kel);

% Air density uncertainty due to machine error
dP_rho = 1/(R_AIR*t_air_kel);
dT_rho = (p_abs_pa)/(R_AIR*t_air_kel^2);
err_rho = sqrt((ERR_ABS_TRANSDUCER*dP_rho).^2+(ERR_THERMO*dT_rho).^2);

%% Part 2: Instrument Calibration

% Manometer reading vs. scannivalve & transducer -> LSQ fit
[coeff_sv_2, S_sv_2] = polyfit(scannivalve_2, mm_2, 1);
[coeff_td_2, S_td_2] = polyfit(transducer_2, mm_2, 1);
m_sv = coeff_sv_2(1); m_td = coeff_td_2(1); 
p_sv_2 = m_sv*scannivalve_2;
p_td_2 = m_td*transducer_2;


% Pressure uncertainty due to machine error & R^2
err_p_sv = m_sv*ERR_SCANNIVALVE;
err_p_td = m_td*ERR_TRANSDUCER;
R_sq_sv_2 = 1 - (S_sv_2.normr/norm(mm_2-mean(mm_2)))^2;
R_sq_td_2 = 1 - (S_td_2.normr/norm(mm_2-mean(mm_2)))^2;

%% Part 3: Wind Tunnel Calibration

% Scannivalve air flow velocity vs. fan speed -> LSQ fit
p_sv = m_sv.*scannivalve_3;
v_sv = vDyn(p_sv, rho);
coeff_v_sv_3 = polyfit(hz_3, v_sv, 1);
v_hz_sv = coeff_v_sv_3(1);

% Scannivalve velocity error
dP_sv = 2^(1/2)/(2*rho*(p_sv/rho).^(1/2));
dRHO_sv = -(2^(1/2)*p_sv)./(2*rho.^2*(p_sv./rho).^(1/2)); 
err_v_sv = sqrt((err_p_sv*dP_sv).^2+(err_rho*dRHO_sv).^2);

% Transducer air flow velocity vs. fan speed -> LSQ fit
p_td = m_td*transducer_3; 
v_td = vDyn(p_td, rho);
coeff_v_td_3 = polyfit(hz_3, v_td, 1);
v_hz_td = coeff_v_td_3(1);

% Transducer velocity error
dP_td = 2^(1/2)/(2*rho*(p_td./rho).^(1/2));
dRHO_td = -(2^(1/2)*p_td)./(2*rho.^2*(p_td./rho).^(1/2)); 
err_v_td = sqrt((err_p_td*dP_td).^2+(err_rho*dRHO_td).^2);

% Manometer air flow velocity vs. fan speed -> LSQ fit
v2_ca = V2(mm_3,rho); v1_ca = V1(v2_ca);
coeff_v_ca = polyfit(hz_3, v2_ca, 1);
v_hz_ca = coeff_v_ca(1);

% Manometer velocity error
dMM_ca = 625./(609*rho*((1250*mm_3)./(609*rho)).^(1/2));
dRHO_ca = -(625*mm_3)./(609*rho.^2*((1250*mm_3)./(609*rho)).^(1/2));
err_v_ca = sqrt((ERR_MANOMETER_PA*dMM_ca).^2+(err_rho*dRHO_ca).^2);

% True air flow velocity vs. fan speed -> LSQ fit
coeff_v_real = polyfit(hz_3, velocity_3, 1);
v_hz_real = coeff_v_real(1);

%% Plots

% Figure 1 config
figure(1); %tiledlayout(2,1);

% Manometer reading vs. scannivalve reading
%sv_2 = nexttile; 
hold on; grid on; 
fplot(poly2sym(coeff_sv_2), 'k-');
errorbar(scannivalve_2, mm_2, err_p_sv, 'k.');
title('Manometer Pressure (Pa) vs. Absolute Scannivalve Voltage (|E|)');
xlabel('Volts (|E|)'); ylabel('Pressure (Pa)');
legend('Conversion factor (V -> Pa)', 'Pressure uncertainty', ...
    'Location', 'southeast'); %fontsize('scale', 1.5);
xlim([0,2.25]); ylim([-150,1300]); 
hold off;

% Manometer reading vs. transducer reading
%td_2 = nexttile; 
figure(2); hold on; grid on;
fplot(poly2sym(coeff_td_2), 'k-');
errorbar(transducer_2, mm_2, err_p_td, 'k.');
title('Manometer Pressure (Pa) vs. Transducer Voltage (E)');
xlabel('Volts (E)'); ylabel('Pressure (Pa)');
legend('Conversion factor (V -> Pa)', 'Pressure uncertainty', ...
    'Location', 'southeast'); %fontsize('scale', 1.5);
xlim([0,0.83]); ylim([-150,1300]); 
hold off;

% Figure 2 config
figure(3); %tiledlayout(3,1);

% Scannivalve velocity vs. fan speed
%sv_3 = nexttile; 
grid on; hold on;
fplot(poly2sym(coeff_v_sv_3), 'k-');
errorbar(hz_3, v_sv, err_v_sv, 'k.');
title('Scannivalve Velocity (m/s) vs. Fan Speed (Hz)');
xlabel('Fan Speed (Hz)'); ylabel('Velocity (m/s)');
legend('Flow velocity', 'Velocity Uncertainty', ...
    'Location', 'southeast'); %fontsize('scale', 1.5);
xlim([13,52]); ylim([0,60]); hold off;

% Transducer velocity vs. fan speed
%td_3 = nexttile; 
figure(4); grid on; hold on;
fplot(poly2sym(coeff_v_td_3), 'k-');
errorbar(hz_3, v_td, err_v_td, 'k.');
title('Transducer Velocity (m/s) vs. Fan Speed (Hz)');
xlabel('Fan Speed (Hz)'); ylabel('Velocity (m/s)');
legend('Flow velocity', 'Velocity Uncertainty', ...
    'Location', 'southeast'); %fontsize('scale', 1.5);
xlim([13,52]); ylim([0,60]); hold off;

% Manometer velocity vs. fan speed
%ca_3 = nexttile; 
figure(5); grid on; hold on;
fplot(poly2sym(coeff_v_ca), 'k-');
errorbar(hz_3, v2_ca, err_v_ca, 'k.');
title('Manometer Velocity (m/s) vs. Fan Speed (Hz)');
xlabel('Fan Speed (Hz)'); ylabel('Velocity (m/s)');
legend('Flow velocity', 'Velocity Uncertainty', ...
    'Location', 'southeast'); %fontsize('scale', 1.5);
xlim([13,52]); ylim([0,60]); hold off;

% Velocity from all three instruments against true velocity
figure(6); grid on; hold on;
fplot(poly2sym(coeff_v_real), 'k.--', 'LineWidth',2);
fplot(poly2sym(coeff_v_sv_3), 'k.-', 'LineWidth',1); 
fplot(poly2sym(coeff_v_td_3), 'b.-', 'LineWidth',1);
fplot(poly2sym(coeff_v_ca), 'r.-', 'LineWidth',1); 
title('Flow Velocity (m/s) vs. Fan Speed (Hz)');
xlabel('Fan Speed (Hz)'); ylabel('Velocity (m/s)');
legend('True velocity', 'Scannivalve velocity', ...
    'Transducer velocity', 'Manometer velocity',  ...
    'Location', 'southeast'); %fontsize('scale', 1.5);
xlim([13,52]); ylim([0,60]); hold off;
