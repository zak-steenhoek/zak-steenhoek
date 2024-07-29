%Zakary Steenhoek
%HW_2.2.2
%MAE215
%2.9.23

%Clearing memory and workspace
clc; 
clear;

%Defining the given matrix
A = [...
    64 2 3 61 60 6 7 57;
    9 55 54 12 13 51 50 16;
    17 47 46 20 21 43 42 24;
    40 26 27 37 36 30 31 33;
    32 34 35 29 28 38 39 25;
    41 23 22 44 45 19 18 48;
    49 15 14 52 53 11 10 56;
    8 58 59 5 4 62 63 1];

%Outputting results
fprintf("The result for part %s is: %d", "A", A(1,1));
fprintf("\nThe result for part %s is: %d", "B", A(2,2));
fprintf("\nThe result for part %s is: %d", "C", max(A, [], 'all'));
fprintf("\nThe result for part %s is: %d", "D", det(A));
fprintf("\nThe result for part %s is:\n", "E"); fprintf('%d %d\n', A(:,4:5));
fprintf("\nThe result for part %s is:\n", "F"); fprintf('%2d %2d %2d %2d %2d %2d %2d %2d\n', [A(6,:); A(8,:)]');
fprintf("\nThe result for part %s is:\n", "G"); fprintf('%d, %d\n', A(1),A(2)); fprintf('This method would be used to acess the first and second elements in the first column of the matrix.')
fprintf("\nThe result for part %s is:\n", "H"); fprintf('%2d %2d %2d %2d %2d %2d %2d %2d\n', [A(1,:); A(2,:)]');
fprintf("\nThe result for part %s is:\n", "I"); fprintf('%d %d\n', A(:,1:2)');
fprintf("\nThe result for part %s using A^(-1) is:\n", "J"); fprintf('%2d %2d %2d %2d %2d %2d %2d %2d\n', A^(-1));
fprintf("\nThe result for part %s using inv(A) is:\n", "J"); fprintf('%2d %2d %2d %2d %2d %2d %2d %2d\n', inv(A));
fprintf("\nThe result for part %s is:\n", "K"); fprintf('%2d %2d %2d %2d %2d %2d %2d %2d\n', (A.')');

