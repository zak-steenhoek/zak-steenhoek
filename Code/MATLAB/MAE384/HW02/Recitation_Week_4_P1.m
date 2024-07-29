clc;
%% Instructions to use this file for homework 2, Problem 1
% 1) Define original function and derivative of the function in separate files
% function y = F(x)
%y = 8 - 4.5*(x - sin(x)); Recitation Example function
%function y = dF(x)
%y = -4.5*(1 - cos(x)); Recitation Example derivative function
% 2) Call these functions in NewtonRoot functions to get xSolution value
% 3) Substitute Initial guess and Reference Error as per problem statement
% 4) Input max number of iterations as required
% Run the below function and call saved function using @, for example here
% we saved function and derivative as FunExample.m and FunDerExample.m
% respectively for we are calling those functions as @FunExample and
% @FunDerExample.
xSolution = NewtonRoot(@Fun,@FunDer,4.7,0.02,10)
% Do not change the function definition below
function Xs = NewtonRoot(Fun, FunDer, Xest, Err, imax)
% Fun = original function
% FunDer = derivative of function
% Xest = approximate root
% Err = percentage error
% imax = max number of allowable iterations
    for i = 1:imax
        Xi = Xest - (Fun(Xest)/FunDer(Xest)); % Newton-Raphson equation
        if abs((Xi - Xest)/Xest) < Err % Defining error condition
            Xs = Xi; % If condition is satisfied Xs is the solution
            break
        end
        Xest = Xi; % Updates value of Xest to use for next loop
    end
    if i == imax % Max iteration condition
        fprintf('Solution was not obtained in %i iterations.\n',imax)
        Xs = ('No answer');
    end
end