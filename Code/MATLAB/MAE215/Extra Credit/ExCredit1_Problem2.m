%Zakary Steenhoek
%Extra Credit Assignment 1_23
%MAE215
%4.26.23

clc

%% Problem 2 (20 points): 
% Resistance and current are inversely proportional to each other in
% electrical circuits. Use the give table of resistance and measured
% current to which an unknown constant voltage has been applied.
fprintf('\n\n============================ Problem 2 ============================\n')

% Given data
R = [10    15   25   40   65   100];
I = [11.11 8.04 6.03 2.77 1.97 1.51];

% (a) Plot R on the x-axis and I on the y-axis
h=figure(21); plot(R,I,'-bo'); grid on;
title('Measured Current (I) vs Resistance (R)');
xlabel('Resistance, R (ohms)'); ylabel ('Current, I (amps)');

% (b) Plot I/R on the x-axis and I on the y-axis
IoR = I./R;
h=figure(22); clf; grid on;
plot(IoR, I,'-kx'); 
title('Measured Current (I) vs Curent/Resistance (I/R)');
xlabel('Current/Resistance, I/R (amps/ohms)'); ylabel ('Current, I (amps)');

% (c) Use polyfit to calc the coefficients of the stright line shown in
% your plot in part (b). The slope of the line corresponds to the applied
% voltage.

% We want a linear fit (straight line) to get slope so use 1st order
p = polyfit(IoR, I, 1); 
fprintf('Part (c): Polynomial fit (linear): y = mx + b ==> y = %.4fx + %.4f\n',p)
fprintf('          Voltage = %.2f V\n',p(1))
% (d) Use polyval to find the calculated values of the current (I) based on
% resisters used. Plot results on a new figure, along with the measured
% data
y = polyval(p,R);
figure(23); clf; grid on; hold on;
plot(R,I,'-bo'); 
plot(R,y,'-cs');
title('Current (I) vs Resistance (R)');
xlabel('Resistance, R (ohms)'); ylabel ('Current, I (amps)');
legend('Measured I','Calculated I')

