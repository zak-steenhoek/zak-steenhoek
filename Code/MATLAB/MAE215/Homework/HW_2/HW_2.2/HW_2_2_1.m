%Zakary Steenhoek
%HW_2.2.1
%MAE215
%2.9.23

%Clearing memory and workspace
clc; 
clear;

%Defining the given matricies and vectors
a = [8 1 6; 3 5 7; 4 9 2];
b = [35 1 6 27 19 24];
c = [9 1 6; 0 2 4; 4 7 8];
d = [1 9 17 25 33 41]';
o = [7 1 2];

%Doing the matrix operations
ptA_1 = 3*a;
ptA_2 = (4*b)/3;
ptB_1 = a + c;
ptB_2 = b-(7*d);
ptC_1 = o*a;
ptC_2 = a.*o;
ptD = d(1:3,1)\a;
ptE_1 = [a,c];
ptE_2 = [a;c];
ptF_1 = [b;d'];
ptF_2 = [b';d];
ptF_3 = [b,d'];

%Outputting results
fprintf("The result for part %s is \n", "A.1"); fprintf('%4d %4d %4d\n', ptA_1);
fprintf("The result for part %s is \n", "A.2"); fprintf('%6.3f %6.3f %6.3f\n', ptA_2);
fprintf("The result for part %s is \n", "B.1"); fprintf('%4d %4d %4d\n', ptB_1);
fprintf("The result for part %s is \n", "B.2"); fprintf('%4d %4d %4d %4d %4d %4d\n', ptB_2);
fprintf("The result for part %s is \n", "C.1"); fprintf('%4d %4d %4d\n', ptC_1);
fprintf("The result for part %s is \n", "C.2"); fprintf('%4d %4d %4d\n', ptC_2);
fprintf("The result for part %s is \n", "D"); fprintf('%4d %4d %4d\n', ptD);
fprintf("The result for part %s is \n", "E.1"); fprintf('%4d %4d %4d %4d %4d %4d\n', ptE_1);
fprintf("The result for part %s is \n", "E.2"); fprintf('%4d %4d %4d\n', ptE_2);
fprintf("The result for part %s is \n", "F.1"); fprintf('%4d %4d %4d %4d %4d %4d\n', ptF_1);
fprintf("The result for part %s is \n", "F.2"); fprintf('%4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d %4d\n', ptF_2);
fprintf("The result for part %s is \n", "F.3"); fprintf('%4d\n', ptF_3);







