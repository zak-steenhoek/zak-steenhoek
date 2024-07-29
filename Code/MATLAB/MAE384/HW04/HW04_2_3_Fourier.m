clc; clear;

x = -2:0.001:2;
k = 1;
fn = (-7/6);
f = (x.^3) - (x.^2) + (x.*2) - 2;
ftF = ((-24/pi*k)*cos(pi*k)+...
       (-16/(pi*k)^2)*sin(pi*k)+...
       (96/(pi*k)^3)*cos(pi*k))*sin((pi*k*x)/2)+...
      ((24/pi*k)*sin(pi*k)+...
       (-16/(pi*k)^2)*cos(pi*k)+...
       (-96/(pi*k)^3)*sin(pi*k))*cos((pi*k*x)/2);

figure; hold on;
plot(x,f);

k = 2;
for n = 0:k
    fn = fn + ftF;
end
plot(x,fn);
fn = (-7/6);

k = 5;
for n = 0:k
    fn = fn + ftF;
end
plot(x,fn);
fn = (-7/6);

k = 10;
for n = 0:k
    fn = fn + ftF;
end
plot(x,fn);
fn = (-7/6);

legend('og fcn', 'k=2', 'k=5', 'k=10');