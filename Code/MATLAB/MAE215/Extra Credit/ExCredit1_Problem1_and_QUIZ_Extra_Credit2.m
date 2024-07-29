%Zakary Steenhoek
%Extra Credit Assignment 1_23
%MAE215
%4.26.23

clc

%% Problem 1 (20 points): 
% Approximate the value of cos(x) using a Maclaurin series.  Use a 
% mid-point break loop to determine the number of terms that must 
% be included in the summation to find the correct value of cos(2) 
% within and error of 0.001.  Limit the iterations  to 10. 

maxError = 0.001;   % Approximation must be accurate to within maxError
cosOf2 = cos(2);    % Actual value of cos(2)
maxIterations = 10; % Maximum iterations allowed to achieve approx within error bounds

term = zeros(maxIterations,1);  % Store each term just for fun
x = 2;                          % Set the x term of cos(x) equal to 2
summation = 0;                  % Initialize the summation
for k = 1:maxIterations
    % General expression of the Maclaurin series 
    term(k) = (-1)^(k-1) * x^((k-1)*2) / factorial((k-1)*2);  

    % Sum the terms over iterations
    summation = summation + term(k);                          
    
    % Check the error of the approximation
    curErr = cosOf2 - summation;                              

    % Print some progress
    fprintf('Term %d:  %+.4f;   Approximation = %+.4f;  Error = %+.4f\n',k,term(k),summation,curErr);

    % Check if the error is within the required bounds and exit the loop if it is
    if abs(curErr) <= maxError
        break;
    end

end %for

% Display the results and answer the number of terms question
fprintf('\nRESULTS:\n');
fprintf(  'Actual value of cos(2)         = %+4f\n', cosOf2);
fprintf(  'Approximation of cos(2)        = %+4f\n', summation);
fprintf(  'Appoximation error             = %.4f\n', curErr);
fprintf(  'Terms req''d for error < %.3f  = %d\n', maxError, k);   


%% QUIZ Extra Credit (20 points)
% Procedure on how to solve Exra Credit 1, Problem 1
%{
To approximate cos(2), we can use the general expression of the Maclaurin 
series. The approximation becomes more exact the more terms are summed 
together. Each term is represented by 'k' where k begins at 1 and counts 
up; weshould need less than 10 terms to approximate cos(2) to wihin an 
error of 0.001.
  1. Using x=2 and k = 1, calculate the first term.
  2. Subtract the first term from the actual value of cos(2) to find the
     approximation error. If the error is greater than 0.001, then continue
     otherwise we're done; skip the remaining steps.
  3. Using x = 2 and k = 2, calculate the second term.  Add the second term
     to the first term.  We will call this result the 'summation'.  The
     summation is our current approximation of cos(2).
  4. Subtract the summation from the actual value of cos(2) to find the
     approximation error. If the error is greater than 0.001, then continue
     otherwise we're done; skip the remaining steps.
  5. Using x = 2 and k = 3, calculate the third term.  Add the third term
     to the summation.  This new summation is our current approximation of cos(2).
  6. Subtract the summation from the actual value of cos(2) to find the
     approximation error. If the error is greater than 0.001, then continue
     otherwise we're done; skip the remaining steps.
  7. Repeat steps 5 and 6 for k = 4, 5, 6, 7, 8, 9, and 10 if necessary. If
     the approximation error becomes less than 0.001 you can skip the 
     calculations for any remaining k values.
%}