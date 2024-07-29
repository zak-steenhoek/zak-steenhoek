clc;
clear;
t=(4:0.2:20);
y=Y(t);
function f=Y(t)
    f=(exp(t/10).*cos(t.*2))/(0.2.*(t.^3)+6);
end