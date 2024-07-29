%% *This code reads the .csv files containing g-force or accel data and
 %  returns plots of the data in terms of linear acceleration vs. time, 
 %  as well as other useful information.*

%Clear all
clc;clear;clf;
%Define variable names for accel and gforce
ACCEL = {'time', 'ax', 'ay', 'az', 'atotal'};
GFORCE = {'time', 'gFx', 'gFy', 'gFz', 'TgF'};
%Define the target data analysis frequency in Hz  
analysisHz = 100;
%Set the smoothing widow multiplier
%   -The smoothing window size will be set as the product of this number
%    and the analysis Hz.
%   -The larger the multiplier, the smoother the data. 
%   -Setting this to 1 means the sliding window replaces each data point x
%    with the mean of the data over -0.5 to 0.5 seconds centered on x
smoothingNum = 4;

%% *Read data*

%Read file name
fname1 = '2024-01-31_01_100Hz.csv';
fname2 = '2024-01-31_03_100Hz.csv';
%Read data to table
T = readtable(fname2);
%Get variable names
Vars = T.Properties.VariableNames;

%% *Process the data* 

%Create figure
figure(10);
%If Table is in Gforce, enter fcn Gf_to_Accel
if (isequal(Vars,GFORCE))
    %Convert g-force to linear acceleration
    T = Gf_to_Accel(T, ACCEL);
end
%Adjust the frequency of the data
T = adjustFrequency(T,analysisHz);

%% *Plot data*

%Plot raw x,y,z accel
subplot(6,2,1); plot(T.time,[T.ax, T.ay, T.az]); grid on; title('Raw Acceleration'); ylabel('Acceleration (m/s^2)');
legend('ax','ay','az')
subplot(6,2,2); plot(T.time,T.ax); grid on; title('Raw ax');
subplot(6,2,4); plot(T.time,T.ay); grid on; title('Raw ay');
subplot(6,2,6); plot(T.time,T.az); grid on; title('Raw az');
%Plot raw total accel
subplot(6,2,3); plot(T.time,T.atotal); grid on; xlabel('Time (sec)'); ylabel('Acceleration (m/s^2)'); title('Raw atotal');
legend('acceleration')

%Smooth out the noise
smoothingWindow = analysisHz*smoothingNum;
T = smoothTable(T, smoothingWindow);
%T = load('x2024_01_31_03_100Hz');

%Plot smoothed x,y,z accel
subplot(6,2,7); plot(T.time,[T.ax, T.ay, T.az]); grid on; title('Smoothed Acceleration'); ylabel('Acceleration (m/s^2)');
legend('ax','ay','az')
subplot(6,2,8); plot(T.time,T.ax); grid on; title('Smoothed ax');
subplot(6,2,10); plot(T.time,T.ay); grid on; title('Smoothed ay');
subplot(6,2,12); plot(T.time,T.az); grid on; title('Smoothed az');
%Plot smoothed total accel
subplot(6,2,9); plot(T.time,T.atotal); grid on; xlabel('Time (sec)'); ylabel('Acceleration (m/s^2)'); title('Smoothed atotal');
legend('acceleration')
