% Question 1
clc;

joules = 305;
clmbs = 10;
volts = joules/clmbs;
v = volts;
%% Question 2
clc;
%q = -18*exp(-t);
t = linspace(0, 0.1, 1000);
dq(t) = 18*exp(-1.*t);
graph(dq(t), t);
