%Zakary Steenhoek
%HW_2.1
%MAE215
%2.9.23

%Clearing memory and workspace
clc; 
clear;

%Declaring the test vectors
testVar1 = [5 4 7];
testVar2 = [2 4 7 9 2];

%Finding and declaring the roots returned from the roots() function
rootUsingRootsFx = roots(testVar1);
root1UsingRootsFx = rootUsingRootsFx(1);
root2UsingRootsFx = rootUsingRootsFx(2);

%Finding and declaring the roots found by deriving the quadratic formula
root1 = ((-testVar1(2))+(sqrt(testVar1(2).^2-4*testVar1(1)*testVar1(3))))/(2*testVar1(1));
root2 = ((-testVar1(2))-(sqrt(testVar1(2).^2-4*testVar1(1)*testVar1(3))))/(2*testVar1(1));

%Finding and declaring mean using mean()
Mean = mean(testVar2);

%Finding and declaring the mean calculated manually
Summation = sum(testVar2);
size = length(testVar2);
manualMean = Summation/size;

%Finding and declaring the standard deviation using std()
Stand = std(testVar2);

%Finding and declaring the standard deviation calculated manually
stdMan = sqrt(sum(abs(testVar2-Mean).^2)/(size-1));

%Printing the results to the console
fprintf("The values returned from the roots() function are %.3f + %fi and %.3f + %fi. \n", ...
    real(root1UsingRootsFx), imag(root2UsingRootsFx), real(root1UsingRootsFx), imag(root2UsingRootsFx));
fprintf("The values returned from the quadratic formula are %.3f + %fi and %.3f + %fi.\n", ...
    real(root1), imag(root1), real(root2), imag(root2));
fprintf("These values are numerically equal, so either method works.\n");
fprintf("The value returned from the mean() function is %.4f. \n", ...
    Mean);
fprintf("The value returned from the mean formula is %.4f. \n", ...
    manualMean);
fprintf("These values are numerically equal, so either method works.\n");
fprintf("The value returned from the std() function is %.4f. \n", ...
    Stand);
fprintf("The value returned from the standrd deviation formula is %.4f. \n", ...
    stdMan);
fprintf("These values are numerically equal, so either method works.");