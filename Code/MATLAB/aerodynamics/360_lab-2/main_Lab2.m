%% Header
% Author: Zakary Steenhoek
% Date: 10 October 2024
% AEE360 LAB02

clc; clear; clf; %close all                                                 % Reset

%% Global

% Constants
R_AIR = 287.0;                                                              % gas constant [J/kg*K]
MANO_BIAS = abs(-0.048);                                                    % manometer bias [inH2O]
ERR_ABS_TRANSDUCER = 100;                                                   % machine error [Pa] 
ERR_THERMO = 1;                                                             % machine error [deg C]
ERR_TRANSDUCER = 0.01;                                                      % machine error [Volt]
ERR_SCANNIVALVE = 0.005;                                                    % machine error [Volt]
ERR_MANOMETER = 0.005;                                                      % machine error [inH2O]
RATIO_A1A2 = 6.25;                                                          % dimensionless
RATIO_A2A1 = 1/RATIO_A1A2;                                                  % dimensionless

% Known Data
m_sv = 496.1170;                                                            % scannivalve conversion factor [Pa/Volt] 
m_td = 1335.041;                                                            % pressure transducer conversion factor [Pa/Volt]

% Measurements
p_measured_kpa = 95.92;                                                     % ambient atmospheric pressure [kPa]
p_abs_pa = 95920;                                                           % ambient atmospheric pressure [Pa]
t_measured_cel = 31.8;                                                      % ambient air temperature [degrees celcius]
t_air_kel = 304.95;                                                         % ambient air temperature [Kelvin]

% Symbolic variables
syms P T MM RHO SC PT

%% Equations & Functions

% Ideal Gas Law -> rearranged for rho
gasLaw_rho = @(P,T) P./(R_AIR*T);                                           % Ideal Gas Law [Pa, deg C]

% Partial derivitives of RHO -> error calculations
gasLaw_dP = diff(gasLaw_rho(P,T),P);                                        % ptl rho w.r.t pressure
gasLaw_dT = diff(gasLaw_rho(P,T),T);                                        % ptl rho w.r.t temp

% Dynamic pressure -> rearranged for velocity
vDyn = @(P,RHO) sqrt((2.*P)./RHO);                                          % dynamic pressure [Pa, kg/m^3]

% Partial derivitives of Vdyn -> error calculations
vDyn_dP = diff(vDyn(P,RHO),P);                                              % ptl velocity w.r.t pressure
vDyn_dRHO = diff(vDyn(P,RHO),RHO);                                          % ptl velocity w.r.t. density 

% Bernoulli's Equation -> rearranged with mass conservation
V2 = @(MM,RHO) sqrt((2*MM)./(RHO*(1-RATIO_A2A1^2)));

% Partial derivitives of V2 -> error calculations
V2_dMM = diff(V2(MM,RHO),MM);                                               % ptl velocity w.r.t pressure differential
V2_dRHO = diff(V2(MM,RHO),RHO);                                             % ptl velocity w.r.t density

% inH2O to Pa -> from internet
inH2OToPa = @(inH2O) inH2O*249.089;                                         % pressure conversion

% Mass conservation -> incompressible flow
V1 = @(V2) RATIO_A2A1*V2;                                                   % velocity conversion

% Pressure coefficient Calculations
Cp = @(SC,PT) SC./PT;

% Partial derivitives of Cp -> error calculations
Cp_dSC = diff(Cp(SC,PT),SC);                                                % ptl Cp w.r.t pressure differential
Cp_dPT = diff(Cp(SC,PT),PT);                                                % ptl Cp w.r.t density


%% Misc

% Equation for 0012 z-location
Z_0012 = @(X,C) (0.12/0.2)*( (0.296*sqrt(X./C)) - (0.126*(X./C)) - ...
    (0.3516*(X./C).^2) + (0.2843*(X./C).^3) - (0.1015*(X./C).^4));

% Given
chord_length = 1;                                                           % airfoil chord length [mmE+2]

% 0012 Geometry
xloc_0012 = [0.02, 0.09, 0.19, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8];
zloc_0012 = Z_0012(xloc_0012, chord_length);

% 4412 Geometry
xloc_4412U = [0.05, 0.1, 0.2, 0.3, 0.4, 0.61, 0.81];
zloc_4412U = [0.0449, 0.0643, 0.0874, 0.0975, 0.0980, 0.0797, 0.0458];
xloc_4412L = [0.1, 0.2, 0.3, 0.4, 0.55, 0.7];
zloc_4412L = -1*[0.0293, 0.0274, 0.0225, 0.0180, 0.0119, 0.0063];

% Faux stagnation point pressure. 
% Note: Common values (fan speed, temperature, x-z location, and absolute 
% pressure) are hardcoded for data continuity. The dynamic pressure was set
% such that, after later manipulation, the pressure coefficient evaluates 
% to 1
stag_point_data = zeros(1,10); stag_point_data(1) = 40; 
stag_point_data(2) = t_measured_cel; stag_point_data(8) = p_measured_kpa;
stag_point_data(3) = inH2OToPa(1); stag_point_data(5) = 1;
stag_point_data(9) = 0; stag_point_data(10) = 0;


% Faux trailing edge pressure
% Note: Common values (fan speed, temperature, x-z location, and absolute 
% pressure) are hardcoded for data continuity.
trail_edge_data = zeros(1,10); trail_edge_data(1) = 40; 
trail_edge_data(2) = t_measured_cel; trail_edge_data(8) = p_measured_kpa;
trail_edge_data(3) = 1; trail_edge_data(5) = 0;
trail_edge_data(9) = 1; trail_edge_data(10) = 0;

%% Density & Uncertainty

% Air density
rho = gasLaw_rho(p_abs_pa, t_air_kel);

% Air density uncertainty due to machine error
dP_rho = 1/(R_AIR*t_air_kel);
dT_rho = (p_abs_pa)/(R_AIR*t_air_kel^2);
err_rho = sqrt((ERR_ABS_TRANSDUCER*dP_rho).^2+(ERR_THERMO*dT_rho).^2);

%% 0012 Data Manipulation

% Import 0012 files 
data_0012 = importdata("Lab2_ThuB600_0012.txt");

% Init full 0012 data struct
data_0012All = zeros(1,10);
eod_0012 = length(data_0012.data);
itr_real = 1;

% For all 5 angles of attack, rearrange data to follow convention:
% Port 9->1 on the bottom (negative AoA), Port 1->9 on the top (postitive AoA).
for itr = 0:4
    % Define starting and ending indexes for lower and upper surface data
    % at this AoA
    idxL_begin = (9*itr)+1; idxL_end = (9*itr)+9;
    idxU_begin = eod_0012 - ((9*itr)+8); idxU_end = (eod_0012 - (9*itr));

    % Grab the upper and lower surface data for this AoA
    % NOTE: Lower surface AoA is negative, converted to positive
    current_lower = flipud(data_0012.data(idxL_begin:idxL_end, :));
    current_upper = data_0012.data(idxU_begin:idxU_end, :);
    current_lower(:,4) = abs(current_lower(:,4));

    % Plant trailing edge data, and set the current AoA and velocity 
    data_0012All(itr_real, :) = trail_edge_data;
    data_0012All(itr_real, 4) = current_lower(1, 4);
    data_0012All(itr_real, 7) = data_0012All(itr_real, 2);
    itr_real = itr_real+1;
    
    % Add the lower surface data for this AoA
    data_0012All(itr_real:itr_real+8, 1:8) = current_lower(:, :);
    data_0012All(itr_real:itr_real+8, 9) = flipud(xloc_0012.');
    data_0012All(itr_real:itr_real+8, 10) = -1*flipud(zloc_0012.');
    itr_real = itr_real+9;
    
    % Plant leading edge data and set the current AoA
    data_0012All(itr_real, :) = stag_point_data;
    data_0012All(itr_real, 4) = current_lower(1, 4);
    itr_real = itr_real+1;
    data_0012All(itr_real, :) = stag_point_data;
    data_0012All(itr_real, 4) = current_lower(1, 4);
    itr_real = itr_real+1;

    % Add in the upper surface data for this AoA
    data_0012All(itr_real:itr_real+8, 1:8) = current_upper(:, :);
    data_0012All(itr_real:itr_real+8, 9) = xloc_0012.';
    data_0012All(itr_real:itr_real+8, 10) = zloc_0012.';
    itr_real = itr_real+9;

    % Plant trailing edge data, and set the current AoA and velocity 
    data_0012All(itr_real, :) = trail_edge_data;
    data_0012All(itr_real, 4) = current_lower(1, 4);
    data_0012All(itr_real, 7) = data_0012All(itr_real, 2);
    itr_real = itr_real+1;
    
end

% Extract needed data columns from full 0012 file
hz_0012 = data_0012All(:, 1);                                               % fan speed [Hz]
q_inf_0012 = data_0012All(:, 3);                                            % dynamic pressure [Pa]
alphaDeg_0012 = data_0012All(:,4);                                          % angle of attack [deg]
scannivalve_0012 = data_0012All(:, 5);                                      % scannivalve reading [inH2O]
port_0012 = data_0012All(:,6);                                              % port [#]
velocity_0012 = data_0012All(:,7);                                          % velocity [m/s]
xLoc_0012 = data_0012All(:,9);                                              % dimless x-location
zLoc_0012 = data_0012All(:,10);                                             % dimless z-location

%% 4412 Data Manipulation

% Import 4412 files
data_4412U = importdata("Lab2_ThuB600_4412U.txt");
data_4412L = importdata("Lab2_ThuB600_4412L.txt");

% Init full 4412 data struct
data_4412All = zeros(1,10);
itr_real = 1;

% For all 5 angles of attack, rearrange data to follow convention:
% Port 7->2 on the bottom, Port 2->8 on the top.
for itr = 0:4
    % Define starting and ending indexes for lower and upper surface data
    % at this AoA
    idxL_begin = (7*itr)+2; idxL_end = (7*itr)+7;
    idxU_begin = (8*itr)+2; idxU_end = (8*itr)+8;
    
    % Grab the upper and lower surface data for this AoA
    current_lower = flipud(data_4412L.data(idxL_begin:idxL_end, :));
    current_upper = data_4412U.data(idxU_begin:idxU_end, :);

    % Plant trailing edge data, and set the current AoA and velocity 
    data_4412All(itr_real, :) = trail_edge_data;
    data_4412All(itr_real, 4) = current_lower(1, 4);
    data_4412All(itr_real, 7) = data_4412All(itr_real, 2);
    itr_real = itr_real+1;
    
    % Add the lower surface data for this AoA
    data_4412All(itr_real:itr_real+5, 1:8) = current_lower(:, :);
    data_4412All(itr_real:itr_real+5, 9) = flipud(xloc_4412L.');
    data_4412All(itr_real:itr_real+5, 10) = flipud(zloc_4412L.');
    itr_real = itr_real+6;
    
    % Plant leading edge data and set the current AoA
    data_4412All(itr_real, :) = stag_point_data;
    data_4412All(itr_real, 4) = current_lower(1, 4);
    itr_real = itr_real+1;
    
    % Add the upper surface data for this AoA
    data_4412All(itr_real:itr_real+6, 1:8) = current_upper(:, :);
    data_4412All(itr_real:itr_real+6, 9) = xloc_4412U.';
    data_4412All(itr_real:itr_real+6, 10) = zloc_4412U.';
    itr_real = itr_real+7;

    % Plant trailing edge data, and set the current AoA and velocity 
    data_4412All(itr_real, :) = trail_edge_data;
    data_4412All(itr_real, 4) = current_lower(1, 4);
    data_4412All(itr_real, 7) = data_4412All(itr_real, 2);
    itr_real = itr_real+1;
    
end

% Extract needed data from full 4412 file
hz_4412 = data_4412All(:, 1);                                               % fan speed [Hz]
q_inf_4412 = data_4412All(:, 3);                                            % dynamic pressure [Pa]
alphaDeg_4412 = data_4412All(:,4);                                          % angle of attack [deg]
scannivalve_4412 = data_4412All(:, 5);                                      % scannivalve reading [inH2O]
port_4412 = data_4412All(:,6);                                              % port [#]
velocity_4412 = data_4412All(:,7);                                          % velocity [m/s]
xLoc_4412 = data_4412All(:,9);                                              % dimless x-location
zLoc_4412 = data_4412All(:,10);                                             % dimless z-location

%% Other Data Manipulation

% Convert scannivalve values from inH2O to Pa
scannivalve_0012 = inH2OToPa(scannivalve_0012);
scannivalve_4412 = inH2OToPa(scannivalve_4412);

% Convert machine error values from volts to Pa
ERR_SV_PA = ERR_SCANNIVALVE*m_sv;
ERR_TD_PA = ERR_TRANSDUCER*m_td;

% 0012 pressure coefficient calculations and uncertainty
cp_0012 = Cp(scannivalve_0012, q_inf_0012);
dscv_0012 = 1./q_inf_0012;
dqInf_0012 = -scannivalve_0012./q_inf_0012.^2;
err_cp_0012 = sqrt((dscv_0012.*ERR_SV_PA).^2+(dqInf_0012.*ERR_TD_PA).^2);

% 4412 pressure coefficient calculations and uncertainty
cp_4412 = Cp(scannivalve_4412, q_inf_4412);
dscv_4412 = 1./q_inf_4412;
dqInf_4412 = -scannivalve_4412./q_inf_4412.^2;
err_cp_4412 = sqrt((dscv_4412.*ERR_SV_PA).^2+(dqInf_4412.*ERR_TD_PA).^2);

%% Plot 0012 Data

% Help
specificLength_0012 = length(data_0012All)/5;
AoA_0012 = zeros(1,5);
Cx_0012All = zeros(5,3); Cz_0012All = zeros(5,3);
Cl_0012All = zeros(5,3); Cd_0012All = zeros(5,3);
lbyd_0012All = zeros(5,4);
titleStr_0012 = 'NACA 0012 Cp vs. x/c, AoA = ';

for itr = 0:4
    % Grab the lower surface data for this AoA
    idx_beginL = (itr*specificLength_0012)+1;
    idx_endL = (itr*specificLength_0012)+specificLength_0012/2;
    Cp_plotL = cp_0012(idx_beginL:idx_endL, :);
    xLoc_plotL = xLoc_0012(idx_beginL:idx_endL, :);
    errCp_errL = err_cp_0012(idx_beginL+1:idx_endL-1, :);
    xLoc_errL = xLoc_0012(idx_beginL+1:idx_endL-1, :);
    Cp_errL = cp_0012(idx_beginL+1:idx_endL-1, :);
    
    % Find maximum values
    Cp_errL_max = zeros(length(Cp_plotL),1);
    Cp_errL_max(1) = Cp_plotL(1);
    Cp_errL_max(2:end-1) = Cp_plotL(2:end-1)+errCp_errL(:,:);
    Cp_errL_max(end) = Cp_plotL(end);
    
    % Find minimum values
    Cp_errL_min = zeros(length(Cp_plotL),1);
    Cp_errL_min(1) = Cp_plotL(1);
    Cp_errL_min(2:end-1) = Cp_plotL(2:end-1)-errCp_errL(:,:);
    Cp_errL_min(end) = Cp_plotL(end);
    
    % Grab the upper surface data for this AoA
    idx_beginU = idx_endL+1;
    idx_endU = idx_endL+specificLength_0012/2;
    Cp_plotU = cp_0012(idx_beginU:idx_endU, :);
    xLoc_plotU = xLoc_0012(idx_beginU:idx_endU, :);
    errCp_errU = err_cp_0012(idx_beginU+1:idx_endU-1, :);
    xLoc_errU = xLoc_0012(idx_beginU+1:idx_endU-1, :);
    Cp_errU = cp_0012(idx_beginU+1:idx_endU-1, :);
    
    % Find maximum values
    Cp_errU_max = zeros(length(Cp_plotU),1);
    Cp_errU_max(1) = Cp_plotU(1);
    Cp_errU_max(2:end-1) = Cp_plotU(2:end-1)+errCp_errU(:,:);
    Cp_errU_max(end) = Cp_plotU(end);
    
    % Find minimum values
    Cp_errU_min = zeros(length(Cp_plotU),1);
    Cp_errU_min(1) = Cp_plotU(1);
    Cp_errU_min(2:end-1) = Cp_plotU(2:end-1)-errCp_errU(:,:);
    Cp_errU_min(end) = Cp_plotU(end);

    % Grab the uncertainty data for this AoA
    idx_begin = (itr*specificLength_0012)+1; 
    idx_end = (itr*specificLength_0012)+specificLength_0012;
    errCp_plot = err_cp_0012(idx_begin:idx_end, :);
    errCp_plot(1) = 0; errCp_plot(11) = 0; errCp_plot(12) = 0; errCp_plot(end) = 0;
    
    % Complete x-z and Cp data
    xLoc_plot = xLoc_0012(idx_begin:idx_end, :);
    zLoc_plot = zLoc_0012(idx_begin:idx_end, :);
    Cp_plot = cp_0012(idx_begin:idx_end, :);

    % Concat upper and lower uncertainty
    Cp_err_min = [Cp_errL_min(:); Cp_errU_max(:)];
    Cp_err_max = [Cp_errL_max(:); Cp_errU_min(:)];

    % Grab this AoA
    alphaDeg = alphaDeg_0012(idx_begin);
    alphadegStr = int2str(alphaDeg);
    alphaRad = alphaDeg*pi/180;
    AoA_0012(itr+1) = alphaDeg;

    % Calculate all measured Cx, Cz, Cl, and Cd
    Cx_0012All(itr+1, 1) = trapz(zLoc_plot, Cp_plot);
    Cz_0012All(itr+1, 1) = -trapz(xLoc_plot, Cp_plot);
    Cl_0012All(itr+1, 1) = Cz_0012All(itr+1, 1)*cos(alphaRad)-Cx_0012All(itr+1, 1)*sin(alphaRad); 
	Cd_0012All(itr+1, 1) = Cz_0012All(itr+1, 1)*sin(alphaRad)+Cx_0012All(itr+1, 1)*cos(alphaRad);
    lbyd_0012All(itr+1, 1) = Cl_0012All(itr+1, 1)/Cd_0012All(itr+1, 1);
    
    % Calculate all minuimum Cx, Cz, Cl, and Cd
    Cx_0012All(itr+1, 2) = trapz(zLoc_plot, Cp_err_min);
    Cz_0012All(itr+1, 2) = -trapz(xLoc_plot, Cp_err_min);
    Cl_0012All(itr+1, 2) = Cz_0012All(itr+1, 2)*cos(alphaRad)-Cx_0012All(itr+1, 2)*sin(alphaRad); 
	Cd_0012All(itr+1, 2) = Cz_0012All(itr+1, 2)*sin(alphaRad)+Cx_0012All(itr+1, 2)*cos(alphaRad);
    lbyd_0012All(itr+1, 2) = Cl_0012All(itr+1, 2)/Cd_0012All(itr+1, 2);
    
    % Calculate all maximum Cx, Cz, Cl, and Cd
    Cx_0012All(itr+1, 3) = trapz(zLoc_plot, Cp_err_max);
    Cz_0012All(itr+1, 3) = -trapz(xLoc_plot, Cp_err_max);
    Cl_0012All(itr+1, 3) = Cz_0012All(itr+1, 3)*cos(alphaRad)-Cx_0012All(itr+1, 3)*sin(alphaRad); 
	Cd_0012All(itr+1, 3) = Cz_0012All(itr+1, 3)*sin(alphaRad)+Cx_0012All(itr+1, 3)*cos(alphaRad);
    lbyd_0012All(itr+1, 3) = Cl_0012All(itr+1, 3)/Cd_0012All(itr+1, 3);
    
    % Calculate dCl and dCd
    Cl_0012All(itr+1, 4) = (Cl_0012All(itr+1, 3)-Cl_0012All(itr+1, 2))/2; 
	Cd_0012All(itr+1, 4) = (Cd_0012All(itr+1, 3)-Cd_0012All(itr+1, 2))/2;
    lbyd_0012All(itr+1, 4) = (lbyd_0012All(itr+1, 3)-lbyd_0012All(itr+1, 2))/2;

    % Init new figure
    figure(itr+1); hold on; grid on; axis ij;
    title(append(titleStr_0012, alphadegStr, ' Degrees'));
    xlabel('Dimensionless Chord'); ylabel('Pressure Coefficient');

    % Plot upper surface data
    plot(xLoc_plotU, Cp_plotU, 'k-');
    plot(xLoc_plotU, Cp_errU_min, 'b-');
    plot(xLoc_plotU, Cp_errU_max, 'r-');

    % Plot lower surface data
    plot(xLoc_plotL, Cp_plotL, 'k--');
    plot(xLoc_plotL, Cp_errL_min, 'r--');
    plot(xLoc_plotL, Cp_errL_max, 'b--');

    % Plot error bars and legend
    errorbar(xLoc_plot, Cp_plot, errCp_plot, 'k.');    
    legend('Upper Surface Cp', 'Upper Surface Min Cp', 'Upper Surface Max Cp', ...
        'Lower Surface Cp', 'Lower Surface Min Cp', 'Lower Surface Max Cp', ...
        'Error Cp', 'Location', 'southeast');
    hold off;
end

% Plot the x-z cross
figure(99); hold on;
plot(xLoc_0012(idx_begin:idx_end), zLoc_0012(idx_begin:idx_end), 'black-', 'LineWidth', 2);
xlabel('x (Chord length)'); ylabel('z (Thickness)');
title('NACA Airfoil 0012 Cross-Section');
grid on; axis equal;  % Scale the x and z axes equally
hold off;

%% Plot 4412 Data

% Help
specificLength_4412 = length(data_4412All)/5;
AoA_4412 = zeros(1,5);
Cx_4412All = zeros(5,3); Cz_4412All = zeros(5,3);
Cl_4412All = zeros(5,4); Cd_4412All = zeros(5,4);
lbyd_4412All = zeros(5,4);
titleStr_4412 = 'NACA 4412 Cp vs. x/c, AoA = ';

for itr = 0:4
    % Grab the lower surface data for this AoA
    idx_beginL = (itr*specificLength_4412)+1;
    idx_endL = (itr*specificLength_4412)+specificLength_4412/2;
    Cp_plotL = cp_4412(idx_beginL:idx_endL, :);
    xLoc_plotL = xLoc_4412(idx_beginL:idx_endL, :);
    errCp_errL = err_cp_4412(idx_beginL+1:idx_endL-1, :);
    xLoc_errL = xLoc_4412(idx_beginL+1:idx_endL-1, :);
    Cp_errL = cp_4412(idx_beginL+1:idx_endL-1, :);
    
    % Find maximum values
    Cp_errL_max = zeros(length(Cp_plotL),1);
    Cp_errL_max(1) = Cp_plotL(1);
    Cp_errL_max(2:end-1) = Cp_plotL(2:end-1)+errCp_errL(:,:);
    Cp_errL_max(end) = Cp_plotL(end);
    
    % Find minimum values
    Cp_errL_min = zeros(length(Cp_plotL),1);
    Cp_errL_min(1) = Cp_plotL(1);
    Cp_errL_min(2:end-1) = Cp_plotL(2:end-1)-errCp_errL(:,:);
    Cp_errL_min(end) = Cp_plotL(end);
    
    % Grab the upper surface data for this AoA
    idx_beginU = idx_endL;
    idx_endU = idx_endL+specificLength_4412/2;
    Cp_plotU = cp_4412(idx_beginU:idx_endU, :);
    xLoc_plotU = xLoc_4412(idx_beginU:idx_endU, :);
    errCp_errU = err_cp_4412(idx_beginU+1:idx_endU-1, :);
    xLoc_errU = xLoc_4412(idx_beginU+1:idx_endU-1, :);
    Cp_errU = cp_4412(idx_beginU+1:idx_endU-1, :);
    
    % Find maximum values
    Cp_errU_max = zeros(length(Cp_plotU),1);
    Cp_errU_max(1) = Cp_plotU(1);
    Cp_errU_max(2:end-1) = Cp_plotU(2:end-1)+errCp_errU(:,:);
    Cp_errU_max(end) = Cp_plotU(end);

    % Find minimum values
    Cp_errU_min = zeros(length(Cp_plotU),1);
    Cp_errU_min(1) = Cp_plotU(1);
    Cp_errU_min(2:end-1) = Cp_plotU(2:end-1)-errCp_errU(:,:);
    Cp_errU_min(end) = Cp_plotU(end);

    % Grab the uncertainty data for this AoA
    idx_begin = (itr*specificLength_4412)+1; 
    idx_end = (itr*specificLength_4412)+specificLength_4412;
    errCp_plot = err_cp_4412(idx_begin:idx_end, :);
    errCp_plot(1) = 0; errCp_plot(8) = 0; errCp_plot(end) = 0;

    % Complete x-z and Cp data
    xLoc_plot = xLoc_4412(idx_begin:idx_end, :);
    zLoc_plot = zLoc_4412(idx_begin:idx_end, :);
    Cp_plot = cp_4412(idx_begin:idx_end, :);

    % Concat upper and lower uncertainty
    Cp_err_min = [Cp_errL_min(:); Cp_errU_max(2:end)];
    Cp_err_max = [Cp_errL_max(:); Cp_errU_min(2:end)];

    % Grab this AoA
    alphaDeg = alphaDeg_4412(idx_begin);
    alphadegStr = int2str(alphaDeg);
    alphaRad = alphaDeg*pi/180;
    AoA_4412(itr+1) = alphaDeg;

    % Calculate all measured Cx, Cz, Cl, and Cd
    Cx_4412All(itr+1, 1) = trapz(zLoc_plot, Cp_plot);
    Cz_4412All(itr+1, 1) = -trapz(xLoc_plot, Cp_plot);
    Cl_4412All(itr+1, 1) = Cz_4412All(itr+1, 1)*cos(alphaRad)-Cx_4412All(itr+1, 1)*sin(alphaRad); 
	Cd_4412All(itr+1, 1) = Cz_4412All(itr+1, 1)*sin(alphaRad)+Cx_4412All(itr+1, 1)*cos(alphaRad);
    lbyd_4412All(itr+1, 1) = Cl_4412All(itr+1, 1)/Cd_4412All(itr+1, 1);
    
    % Calculate all minimum Cx, Cz, Cl, and Cd
    Cx_4412All(itr+1, 2) = trapz(zLoc_plot, Cp_err_min);
    Cz_4412All(itr+1, 2) = -trapz(xLoc_plot, Cp_err_min);
    Cl_4412All(itr+1, 2) = Cz_4412All(itr+1, 2)*cos(alphaRad)-Cx_4412All(itr+1, 2)*sin(alphaRad); 
	Cd_4412All(itr+1, 2) = Cz_4412All(itr+1, 2)*sin(alphaRad)+Cx_4412All(itr+1, 2)*cos(alphaRad);
    lbyd_4412All(itr+1, 2) = Cl_4412All(itr+1, 2)/Cd_4412All(itr+1, 2);
    
    % Calculate all maximum Cx, Cz, Cl, and Cd
    Cx_4412All(itr+1, 3) = trapz(zLoc_plot, Cp_err_max);
    Cz_4412All(itr+1, 3) = -trapz(xLoc_plot, Cp_err_max);
    Cl_4412All(itr+1, 3) = Cz_4412All(itr+1, 3)*cos(alphaRad)-Cx_4412All(itr+1, 3)*sin(alphaRad); 
	Cd_4412All(itr+1, 3) = Cz_4412All(itr+1, 3)*sin(alphaRad)+Cx_4412All(itr+1, 3)*cos(alphaRad);
    lbyd_4412All(itr+1, 3) = Cl_4412All(itr+1, 3)/Cd_4412All(itr+1, 3);
    
    % Calculate dCl and dCd
    Cl_4412All(itr+1, 4) = (Cl_4412All(itr+1, 3)-Cl_4412All(itr+1, 2))/2; 
	Cd_4412All(itr+1, 4) = (Cd_4412All(itr+1, 3)-Cd_4412All(itr+1, 2))/2;
    lbyd_4412All(itr+1, 4) = (lbyd_4412All(itr+1, 3)-lbyd_4412All(itr+1, 2))/2;

    % Init new figure
    figure(itr+6); hold on; grid on; axis ij;
    title(append(titleStr_4412, alphadegStr, ' Degrees'));
    xlabel('Dimensionless Chord'); ylabel('Pressure Coefficient');

    % Plot upper surface data
    plot(xLoc_plotU, Cp_plotU, 'k-');
    plot(xLoc_plotU, Cp_errU_min, 'b-');
    plot(xLoc_plotU, Cp_errU_max, 'r-');
    
    % Plot lower surface data
    plot(xLoc_plotL, Cp_plotL, 'k--');
    plot(xLoc_plotL, Cp_errL_min, 'r--');
    plot(xLoc_plotL, Cp_errL_max, 'b--');
    
    % Plot error bars and legend
    errorbar(xLoc_plot, Cp_plot, errCp_plot, 'k.');
    legend('Upper Surface Cp', 'Upper Surface Min Cp', 'Upper Surface Max Cp', ...
        'Lower Surface Cp', 'Lower Surface Min Cp', 'Lower Surface Max Cp', ...
        'Error Cp', 'Location', 'southeast');
    hold off;
end

% Plot the x-z cross
figure(98); hold on;
plot(xLoc_4412(idx_begin:idx_end), zLoc_4412(idx_begin:idx_end), 'black-', 'LineWidth', 2);
xlabel('x (Chord length)'); ylabel('z (Thickness)');
title('NACA Airfoil 4412 Cross-Section');
grid on; axis equal;  % Scale the x and z axes equally
hold off;

%% Plot 0012 Cl, Cd, and L/D

% Init new figure
figure(101); colororder({'k','k'});
title('NACA 0012 Cl, Cd, and L/D vs. Angle of Attack');
yyaxis left; hold on; grid on;
xlabel('Angle of Attack [deg]'); ylabel('Cl, Cd [dimless]');
xlim([0,12]); ylim([0,1]);

% Plot Cl and Cd data
plot(AoA_0012, Cl_0012All(:,1).', 'b.-')
plot(AoA_0012, Cd_0012All(:,1).', 'r.-')
plot(AoA_0012, Cl_0012All(:,2).', 'b.--')
plot(AoA_0012, Cd_0012All(:,2).', 'r.--')
plot(AoA_0012, Cl_0012All(:,3).', 'b.--')
plot(AoA_0012, Cd_0012All(:,3).', 'r.--')

% Plot errorbars and legend
errorbar(AoA_0012, Cl_0012All(:,1).', Cl_0012All(:,4).', 'b.-');
errorbar(AoA_0012, Cd_0012All(:,1).', Cd_0012All(:,4).', 'r.-');
l1 = legend('Cl', 'Cd', 'Min Cl', 'Min Cd', ...
    'Max Cl', 'Max Cd', 'Err Cl', 'Err Cd');
hold off;

% Plot L/D on righthand axis
yyaxis right; hold on; ylim([0,15]);
plot(AoA_4412, lbyd_0012All(:,1).', 'k.-')
ylabel('Lift over Drag [dimless]');
l1.String(9) = {'L/D'};
hold off;

%% Plot 4412 Cl, Cd, and L/D

% Init new figure
figure(102); colororder({'k','k'});
title('NACA 4412 Cl, Cd, and L/D vs. Angle of Attack');
yyaxis left; hold on; grid on;
xlabel('Angle of Attack [deg]'); ylabel('Cl, Cd [dimless]');
xlim([0,14]); ylim([0,1.2]);

% Plot Cl and Cd data
plot(AoA_4412, Cl_4412All(:,1).', 'b.-')
plot(AoA_4412, Cd_4412All(:,1).', 'r.-')
plot(AoA_4412, Cl_4412All(:,2).', 'b.--')
plot(AoA_4412, Cd_4412All(:,2).', 'r.--')
plot(AoA_4412, Cl_4412All(:,3).', 'b.--')
plot(AoA_4412, Cd_4412All(:,3).', 'r.--')

% Plot errorbars and legend
errorbar(AoA_4412, Cl_4412All(:,1).', Cl_4412All(:,4).', 'b.-');
errorbar(AoA_4412, Cd_4412All(:,1).', Cd_4412All(:,4).', 'r.-');
l2 = legend('Cl', 'Cd', 'Min Cl', 'Min Cd', ...
    'Max Cl', 'Max Cd', 'Err Cl', 'Err Cd');
hold off;

% Plot L/D on righthand axis
yyaxis right; hold on; ylim([0,15]);
plot(AoA_4412, lbyd_4412All(:,1).', 'k.-')
ylabel('Lift over Drag [dimless]');
l2.String(9) = {'L/D'};
hold off;
