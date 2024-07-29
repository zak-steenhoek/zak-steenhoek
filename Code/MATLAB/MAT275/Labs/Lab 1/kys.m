t=(4:0.2:20);
y=(exp(t/10).*cos(t.*2))/(0.2.*(t.^3)+6);
figure;
plot(t,y,'k-')
title('y vs. t');