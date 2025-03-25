%% Header
% Author: Zakary Steenhoek
% Date: 6 November 2024
% AEE361::LAB03

clc; clear; clf; %close all;                                                % Reset

%% Global 

% Constants
R_AIR = 287.0;                                                              % gas constant [J/kg*K]
FAN_SPD = 40;                                                               % fan speed [Hz]
MANO_BIAS = abs(-0.048);                                                    % manometer bias [inH2O]
ERR_ABS_TRANSDUCER = 100;                                                   % machine error [Pa] 
ERR_THERMO = 1;                                                             % machine error [deg C]
ERR_TRANSDUCER = 0.01;                                                      % machine error [Volt]
ERR_SCANNIVALVE = 0.005;                                                    % machine error [Volt]
ERR_MANOMETER = 0.005;                                                      % machine error [inH2O]
RATIO_A1A2 = 6.25;                                                          % dimensionless
RATIO_A2A1 = 1/RATIO_A1A2;                                                  % dimensionless
M_PT = 1335.041;                                                            % conversion factor [pa/Volt]
M_VEL_PT = 0.9551;                                                          % conversion factor [m/s/Hz]

% Measurements
% p_measured_kpa = 96.29;                                                   % ambient atmospheric pressure [kPa]
% p_abs_pa = 96290;                                                         % ambient atmospheric pressure [Pa]
% t_measured_cel = 32.7;                                                    % ambient air temperature [degrees celcius]
% t_air_kel = 305.85;                                                       % ambient air temperature [Kelvin]

% Symbolic variables
syms P T RHO V

%% Data

% Import alternate files 
allData_cal = importdata("FriA_730/Lab3_FriA730_Cal.txt");
allData_0012 = importdata("FriA_730/Lab3_FriA730_0012.txt");
allData_4412 = importdata("FriA_730/Lab3_FriA730_4412.txt");

% Import files (depreciated data as it breaks thermodynamics laws)
% allData_cal = importdata("MonB_600/Lab3_MonB600_Cal.txt");
% allData_0012 = importdata("MonB_600/Lab3_MonB600_0012.txt");
% allData_4412 = importdata("MonB_600/Lab3_MonB600_4412.txt");

% Data needed for HWA calibration curve
air_temp_cal = allData_cal.data(:, 1);                                      % air temp reading [deg C]
air_pressure_cal = allData_cal.data(:, 2);                                  % air pressure reading [Pa]
hotwire_voltage_cal = allData_cal.data(:, 3);                               % HWA voltage reading [volts]
air_velocity_cal = allData_cal.data(:, 4);                                  % air velocity reading [m/s]

% Data for NACA 0012
air_temp_0012 = allData_0012.data(:, 1);                                    % air temp reading [deg C]
ustr_dynamic_pressure_0012 = allData_0012.data(:, 2);                       % dynamic pressure reading [Pa]
hotwire_voltage_0012 = allData_0012.data(:, 3);                             % HWA voltage reading [volts]
static_drop_0012 = allData_0012.data(:, 4);                                 % static pressure drop [Pa]
ustr_velocity_0012 = allData_0012.data(:, 5);                               % air velocity reading [m/s]
hwa_steps_0012 = allData_0012.data(:, 6);                                   % HWA steps [n]

% Data for NACA 4412
air_temp_4412 = allData_4412.data(:, 1);                                    % air temp reading [deg C]
ustr_dynamic_pressure_4412 = allData_4412.data(:, 2);                       % dynamic pressure reading [Pa]
hotwire_voltage_4412 = allData_4412.data(:, 3);                             % HWA voltage reading [volts]
static_drop_4412 = allData_4412.data(:, 4);                                 % static pressure drop [Pa]
ustr_velocity_4412 = allData_4412.data(:, 5);                               % air velocity reading [m/s]
hwa_steps_4412 = allData_4412.data(:, 6);                                   % HWA steps [n]

%% Equations & Functions

% Ideal Gas Law
gasLaw = @(RHO,T) RHO.*R_AIR.*T;                                            % Ideal Gas Law [Pa, deg C]

% Partial derivitives of P -> error calculations
gasLaw_dRHO = diff(gasLaw(RHO,T),RHO);                                      % ptl p w.r.t rho
gasLaw_dT = diff(gasLaw(RHO,T),T);                                          % ptl p w.r.t temp

% Ideal Gas Law -> rearranged for rho
gasLaw_rho = @(P,T) P./(R_AIR*T);                                           % Ideal Gas Law [Pa, deg C]

% Partial derivitives of RHO -> error calculations
gasLawRho_dP = diff(gasLaw_rho(P,T),P);                                     % ptl rho w.r.t pressure
gasLawRho_dT = diff(gasLaw_rho(P,T),T);                                     % ptl rho w.r.t temp

% Celcius to Kelvin
CtoK = @(C) C + 273.15;                                                     % Celcius to Kelvin 

% Voltage to velocity
hwa_vol_to_vel = @(vol, m, b) vol.^m.*exp(b);

% Normalize data
norm_data = @(X, max_x) X./max_x;

% Motor steps to m
step_to_m = @(s) (s./400./16).*0.0254;

% Dynamic pressure
pDyn = @(V,RHO) 0.5.*RHO.*V.^2;                                             % dynamic pressure [m/s, kg/m^3]

% Partial derivitives of Vdyn -> error calculations
pDyn_dV = diff(pDyn(V,RHO),V);                                              % ptl velocity w.r.t velocity
pDyn_dRHO = diff(pDyn(V,RHO),RHO);                                          % ptl velocity w.r.t. density 

% Dynamic pressure -> rearranged for density
rhoDyn = @(P,V) (2*P)./V.^2;                                                % density [Pa, m/s]

% Partial derivitives of rhoDyn -> error calculations
rhoDyn_dP = diff(rhoDyn(P,V),P);                                            % ptl density w.r.t pressure
rhoDyn_dV = diff(rhoDyn(P,V),V);                                            % ptl density w.r.t. velocity

% Dynamic pressure -> rearranged for velocity
vDyn = @(P,RHO) sqrt((2.*P)./RHO);                                          % velocity [Pa, kg/m^3]

% Partial derivitives of Vdyn -> error calculations
vDyn_dP = diff(vDyn(P,RHO),P);                                              % ptl velocity w.r.t pressure
vDyn_dRHO = diff(vDyn(P,RHO),RHO);                                          % ptl velocity w.r.t. density 

% inH2O to Pa -> from internet
inH2OToPa = @(inH2O) inH2O*249.089;                                         % pressure conversion

%% Misc

% Convert manometer values from inH2O to Pa & factor in bias
static_drop_0012 = inH2OToPa(static_drop_0012);
static_drop_4412 = inH2OToPa(static_drop_4412);

%% Part 1: Density & Uncertainty

% Extract density from dynamic pressure
rho_0012 = rhoDyn(ustr_dynamic_pressure_0012, ustr_velocity_0012);
rho_4412 = rhoDyn(ustr_dynamic_pressure_4412, ustr_velocity_4412);

% Determine absolute pressure 
abs_press_0012 = gasLaw(rho_0012, CtoK(air_temp_0012));
abs_press_4412 = gasLaw(rho_4412, CtoK(air_temp_4412));

% Convert machine errors
ERR_P_PT = ERR_TRANSDUCER*M_PT;
ERR_V_PT = 0.060;

% Air density uncertainty due to machine error
dP_rho_0012 = 2./ustr_velocity_0012.^2;
dV_rho_0012 = -(4.*ustr_dynamic_pressure_0012)./ustr_velocity_0012.^3;
err_rho_0012 = sqrt((ERR_P_PT.*dP_rho_0012).^2+(ERR_V_PT.*dV_rho_0012).^2);

% Air density uncertainty due to machine error
dP_rho_4412 = 2./ustr_velocity_4412.^2;
dV_rho_4412 = -(4.*ustr_dynamic_pressure_4412)./ustr_velocity_4412.^3;
err_rho_4412 = sqrt((ERR_P_PT.*dP_rho_4412).^2+(ERR_V_PT.*dV_rho_4412).^2);

% Pressure uncertainty due to machine error
dRHO_p_0012 = 287.*CtoK(air_temp_0012);
dT_p_0012 = 287.*rho_0012;
err_p_0012 = sqrt((err_rho_0012.*dRHO_p_0012).^2+(ERR_THERMO.*dT_p_0012).^2);

% Pressure uncertainty due to machine error
dRHO_p_4412 = 287.*CtoK(air_temp_4412);
dT_p_4412 = 287.*rho_4412;
err_p_4412 = sqrt((err_rho_4412.*dRHO_p_4412).^2+(ERR_THERMO.*dT_p_4412).^2);

%% HWA Calibration

% Plot raw data
tiledlayout(figure(1), 'flow'); clf;
raw = nexttile; hold on; grid on;
title('Air velocity vs. Hotwire voltage');
xlabel('Hotwire Voltage (Volts)'); ylabel('Air Velocity (m/s)');
% xlimit([]); ylimit([]);
plot(hotwire_voltage_cal, air_velocity_cal, 'k.-');
hold off;

% Extract coefficients
hwa_coeffs = polyfit(log(hotwire_voltage_cal), log(air_velocity_cal), 1);

% Plot log data
linear = nexttile; hold on; grid on;
title('Linearized Air velocity vs. Hotwire voltage');
xlabel('Nat. Log Hotwire Voltage (ln(Volts))'); ylabel('Nat. Log Air Velocity (ln(m/s))');
xlim([1.1,1.28]); ylim([1.8,4]);
scatter(log(hotwire_voltage_cal), log(air_velocity_cal), 'k*');
fplot(poly2sym(hwa_coeffs), 'k-');
hold off;

%% 0012 Velocity Plot

% Convert data
max_y_0012 = hwa_steps_0012(end);
norm_y_0012 = norm_data(hwa_steps_0012, max_y_0012);
dim_y_0012 = step_to_m(hwa_steps_0012);
dstr_vel_0012 = hwa_vol_to_vel(hotwire_voltage_0012, hwa_coeffs(1), hwa_coeffs(2));
norm_dst_vel_0012 = norm_data(dstr_vel_0012, ustr_velocity_0012);
norm_upstr_vel_0012 = norm_data(ustr_velocity_0012, ustr_velocity_0012);

% Plot norm 0012 stream data
tiledlayout(figure(2), 'flow'); clf;
norm_0012 = nexttile; hold on; grid on;
title('Y-location vs. Velocity for NACA 0012');
xlabel('Normalized Velocity'); ylabel('Normalized Y-location');
xlim([0,1]); ylim([0,1]);
plot(norm_dst_vel_0012, norm_y_0012, 'k-');
plot(norm_upstr_vel_0012, norm_y_0012, 'k--');
hold off;

% Plot dim 0012 stream data
dim_0012 = nexttile; hold on; grid on;
title('Y-location vs. Velocity for NACA 0012');
xlabel('Velocity (m/s)'); ylabel('Y-location (m)');
xlim([20,36]); ylim([0,dim_y_0012(end)]);
plot(dstr_vel_0012, dim_y_0012, 'k-');
plot(ustr_velocity_0012, dim_y_0012, 'k--');
hold off;

%% 4412 Velocity Plot

% Convert data
max_y_4412 = hwa_steps_4412(end);
norm_y_4412 = norm_data(hwa_steps_4412, max_y_4412);
dim_y_4412 = step_to_m(hwa_steps_4412);
dstr_vel_4412 = hwa_vol_to_vel(hotwire_voltage_4412, hwa_coeffs(1), hwa_coeffs(2));
norm_dst_vel_4412 = norm_data(dstr_vel_4412, ustr_velocity_4412);
norm_upstr_vel_4412 = norm_data(ustr_velocity_4412, ustr_velocity_4412);

% Plot norm 4412 stream data
tiledlayout(figure(3), 'flow'); clf;
norm_4412 = nexttile; hold on; grid on;
title('Y-location vs. Velocity for NACA 4412');
xlabel('Normalized Velocity'); ylabel('Normalized Y-location');
xlim([0,1]); ylim([0,1]);
plot(norm_dst_vel_4412, norm_y_4412, 'k-');
plot(norm_upstr_vel_4412, norm_y_4412, 'k--');
hold off;

% Plot dim 4412 stream data
dim_4412 = nexttile; hold on; grid on;
title('Y-location vs. Velocity for NACA 4412');
xlabel('Velocity (m/s)'); ylabel('Y-location (m)');
xlim([20,36]); ylim([0,dim_y_4412(end)]);
plot(dstr_vel_4412, dim_y_4412, 'k-');
plot(ustr_velocity_4412, dim_y_4412, 'k--');
hold off;

%% 0012 Drag Calculations

% Mass conservation integration at the exit
exit_mass_0012 = trapz(dim_y_0012, dstr_vel_0012.*rho_0012);

% Assume steady inlet flow to compute entrance height
rho_avg_0012 = sum(rho_0012)/length(rho_0012);
ustr_vel_avg_0012 = sum(ustr_velocity_0012)/length(ustr_velocity_0012);
inlet_y_0012 = exit_mass_0012/(rho_avg_0012*ustr_vel_avg_0012);

% Momentum conservation to find external force
f_ext_0012 = -rho_avg_0012*ustr_vel_avg_0012^2*inlet_y_0012+rho_avg_0012*trapz(dim_y_0012, dstr_vel_0012.^2);
pDyn_avg_0012 = sum(ustr_dynamic_pressure_0012)/length(ustr_dynamic_pressure_0012);
cd_0012 = -f_ext_0012/(.1*pDyn_avg_0012);

%% 4412 Drag Calculations

% Mass conservation integration at the exit
exit_mass_4412 = trapz(dim_y_4412, dstr_vel_4412.*rho_4412);

% Assume steady inlet flow to compute entrance height
rho_avg_4412 = sum(rho_4412)/length(rho_4412);
ustr_vel_avg_4412 = sum(ustr_velocity_4412)/length(ustr_velocity_4412);
inlet_y_4412 = exit_mass_4412/(rho_avg_4412*ustr_vel_avg_4412);

% Momentum conservation to find external force
f_ext_4412 = -rho_avg_4412*ustr_vel_avg_4412^2*inlet_y_4412+rho_avg_4412*trapz(dim_y_4412, dstr_vel_4412.^2);
pDyn_avg_4412 = sum(ustr_dynamic_pressure_4412)/length(ustr_dynamic_pressure_4412);
cd_4412 = -f_ext_4412/(.1*pDyn_avg_4412);

