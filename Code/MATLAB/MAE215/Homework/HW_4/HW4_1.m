%Zakary Steenhoek
%HW 4.1
%MAE215
%3.16.23

%Formatting, clearing memory and workspace
clc;
clear;
format compact;

%Declaring variables
r=0.06;
n=12;
t=18;
a=3000;
vec=[0];
x=0:18;
counter=0;

%For loop to determine the amount in the account after 18 years
for i=1:n*t
    A=a+(r/n)*a+300;
    a=A;
    counter=counter+1;
    %While loop to record the value once every year
    while(counter==12)
        vec(end+1)=A;
        counter=0;
    end
end

%Displaying the amount in the account after 18 years
fprintf('The amount in the account after 18 years is %5.2f.\n',a);

%Plotting the data about the amount in the account every year for 18 years.
p=plot(x,vec,"-.*r",'linewidth',1);
title("Money vs. Time");
xlabel("Time (Years)");
ylabel("Money (Dollars)");

%Clearing variables.
clear;

%Declaring variables
A=3000;
r=0.06;
n=12;
a=3000;
vec=[];
counter=0;
T=15000*8;

%While loop to determine the number of months it would take to save up for
%4 years of college at ASU.
while(A<=T)
    A=a+(r/n)*a+300;
    a=A;
    counter=counter+1;
end

remain=mod(counter,12);
years=(counter-remain)/12;

%Outputting the amount of time it would take to pay for 4 years of college
%at ASU.
fprintf('It would take %d years and %d months to save up for 4 years of college at ASU.',years, remain);
