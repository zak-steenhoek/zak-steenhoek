% Made by: Zakary Steenhoek on 9.29.22

close all
clear global
clc

x=linspace(0,2*pi,100);
y=sin(2*x);
g=2*cos(2*x);
plot(x,y,'bs',x,g,'ro');
title('x vs. g');
xlabel('ind. variable');
ylabel('dep. variable');
legend('y','g');
