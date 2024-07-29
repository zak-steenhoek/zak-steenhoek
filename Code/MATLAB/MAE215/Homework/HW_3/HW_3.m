%Zakary Steenhoek
%HW_3
%MAE215
%2.9.23

%Formatting, clearing memory and workspace
clc;
clear;
format compact;

%Declaring variables
x=1;
y=5;
u=3.1;
count = 0;

%Forming the while loop
while x<350
    Alpha= y*4 + ((u*1.2+(8-4*y)/2.5));
    Beta= Alpha * (x+7)/(x+1);
    x1 = Beta; x = x1; u = u*.6; y = (1.5*y)/(1.2);
    count=count+1;
end

%Printing output
fprintf('For the while loop, Alpha=%3.4f, Beta=%3.4f, u=%3.5f, x=%3.4f, x1=%3.4f, y=%3.4f\n', Alpha, Beta, u, x, x1, y);


%Clearing memory
clear;

%Declaring variables again
x=1;
y=5;
u=3.1;
count = 0;

%Forming the for loop
for n=1:16
    Alpha= y*4 + ((u*1.2+(8-4*y)/2.5));
    Beta= Alpha * (x+7)/(x+1);
    x1 = Beta; x = x1; u = u*.6; y = (1.5*y)/(1.2);
    count=count+1;
end

%Printing output
fprintf('For the for loop, Alpha=%3.4f, Beta=%3.4f, u=%3.5f, x=%3.4f, x1=%3.4f, y=%3.4f', Alpha, Beta, u, x, x1, y);

%end
