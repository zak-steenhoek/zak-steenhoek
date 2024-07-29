% This is our predictive model for the speed of our vehicle in units of
% ft/sec. Created by team number 8: Zak Steenhoek, Omar Lopez, Sriman R, and Evan Lenz on 11/9/22.

rpm = 2718; % Rotational speed of our final drive gear
torque = ((0.0735*rpm/8000))+0.00735; % Torque, calculated with equation from mini expirement part 2
radius = 0.019; % Radius of our wheel in meters
mpsTofpsConstant = 3.281; % Constant to convert m/s to feet per second
mass = 0.449; % Mass of our cart (estimated)
force = (mass*9.81); % Downward force of our car due to gravity
x = linspace(0,3,50); % Creates a vector from 0 to 3 that we plug into as watts
y = (x*(radius)*mpsTofpsConstant)/(torque*force);
powerTrail = 1.7;% this it the amount of watts that our solar panel will produce on trial day 
trailDay=(powerTrail*(radius)*mpsTofpsConstant)/(torque*force);%the speed of the vehicle on trial day at 1.7 watts
plot(x,y)
xlabel('Solar Power Avaible(Watts)')
ylabel('Speed(ft/s)')
title('Solar Power Avaible(Watts) vs Speed(ft/s)')