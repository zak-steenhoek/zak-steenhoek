% Zakary Steenhoek
% Final Project
% MAE215
% 4.30.23

function FinalProject

clear; clc;
key = zeros(2,2);

%% Problem 1: Find the Imposter's Age for key(1)
% Problem Statement: 
% The goal of this problem is use the provided information about the imposter to
% determine the imposter's age by creating a function called age_guess that that 
% solves for age based on the trick shown in the provided YouTube video.  

fprintf('\n\n********************************************************************************\n')
fprintf(    '** Problem 1: Find the Imposter''s Age for key(1) \n')
fprintf(    '********************************************************************************\n\n')

fprintf('Given information:\n');
fprintf('  Imposter''s year of birth is 2006.\n');
fprintf('  Imposter''s birthday is after April 2023.\n');
fprintf('  Pass the age_guess function value 1773 if Imposter''s birthday is \n');
fprintf('  past or 1772 if not. \n');

% The problem statement gives the inposter's year of birth as 2006
imposterBirthYear = 2006; 
% The problem statement states the imposter's birthday is after April
bday2023value  = 1772; % value given: 1773 bday has passed, 1772 bday not passed

% Note, the Matlab help for the 'rand' function explicitly states to use 
% the 'randi' function to generate random integers.
num1to9 = randi([1 9],1,1);

age = age_guess(num1to9, imposterBirthYear, bday2023value);

fprintf('\nThe age_guess function returned age=%d as the Imposter''s age.\n',age);
fprintf('Use this value for key(1).\n   key = \n'); 
key(1) = age;

disp(key);


%% Problem 2: Find the Imposter's Month of Birth for key(2)
% Problem Statement: 
% The goal of this problem is to find the Imposter's month of % birth by 
% determining the number of iterations required to converge on the % solution to
% the given equation for a given initial value of x.  The absolute error of the 
% solution must be within the given error bounds.

fprintf('\n\n********************************************************************************\n')
fprintf(    '** Problem 2: Find the Imposter''s Month of Birth for key(2) \n')
fprintf(    '********************************************************************************\n\n')

% initial_x:  Initial esitmate of x 
initial_x = 0.012; % Given initial x (0.012) requires 13 iterations; assumming typo

% maxError:   Maxium relative error of x
maxError = 0.0015;

fprintf('Determine the number of iterations required to solve the given equation\n');
fprintf('for x to within absolute error of %.4f starting with x=%.3f.\n',maxError,initial_x);
fprintf('\nNumber of iterations indicates the Imposters''s birth month.\n\n');

maxIterations = 20; % Assume maximum of 12 iteration (number of months)

x = initial_x;                  
for k = 1:maxIterations
    % Given equation to solve for x 
    new_x = 0.102*(-x) + 0.4*x^2 + 0.0975 + 0.4*((3*x)/2) + 0.039*x;  

    % Check the relative error 
    relative_error = abs(new_x - x);                            

    % Print some progress
    fprintf('Iteration %2d:  x = %+.4f;  new_x = %+.4f ==> relative_error = %+.6f\n', ...
        k,x,new_x,relative_error);

    % Check if the error is within the required bounds and exit the loop if it is
    if relative_error <= maxError
        break;
    end

    % Set x = new_x for next iteration
    x = new_x;

end %for

if relative_error > maxError
    fprintf('\nRelative error (%.5f) exceeds requirement (%.4f) after %d iterations. \n',...
        relative_error,maxError,k);
elseif k > 13 % max month
    fprintf('\nRelative error (%.5f) required %d iterations to acheive the required error\n',...
        relative_error,k); 
    fprintf('limit of %.4f. \n',maxError);
else
    fprintf('\nError tolerance acheived in %d iterations.\n',k,k);
end

% Set birth month equal to number of iterations (k)
month = k;

% if month > 12 
%     month = 12; 
%     fprintf('Number of iterations is greater than 12; setting to 12.\n')
% else
%     fprintf('Use this value for key(2).\n   key = \n ')
% end
key(2) = month;
disp(key);

%% Problem 3: Find the Number of Legs of the Imposter's Favorite Animal for key(3)
% Problem Statement: 
% Using the given matrix, follow the instructions to sum even and odd columns
% and rows and to compare combinations of these per the instructions to 
% determine the value of key(3).  
% 
% All specific given instructions are provided in the comments of each step for 
% reference.

fprintf('\n\n********************************************************************************\n');
fprintf(    '** Problem 3: Find the Number of Legs of the Imposter''s Favorite Animal for key(3) \n');
fprintf(    '********************************************************************************\n\n');

matrix = [ ...            % given matrix of values
    2 8 3 1 5 1 8 4 5 2;
    1 7 2 7 8 5 7 5 6 7;
    6 6 4 8 8 8 2 7 9 6;
    3 7 2 1 6 3 6 5 7 5;
    6 4 7 8 2 4 2 5 1 8;
    4 5 8 1 2 8 3 5 2 4;
    6 5 1 6 2 8 6 5 3 5;
    1 5 5 7 1 6 5 1 7 4;
];
[nRow,nCol] = size(matrix);

% Collect and take the sum of all the values in the odd columns
odd_col = matrix(:,1:2:nCol);
sum_odd_cols = sum(odd_col,"all"); %disp(sum_odd_cols);
fprintf('The sum of all values in odd columns is %d\n',sum_odd_cols);

% Collect and take the sum of all the values in even columns
even_cols = matrix(:,2:2:nCol);
sum_even_cols = sum(even_cols,"all"); %disp(sum_even_cols);
fprintf('The sum of all values in even columns is %d\n',sum_even_cols);

% Collect and take the sum of all the values in the odd rows 
odd_rows = matrix(1:2:nRow,:);
sum_odd_rows = sum(odd_rows,"all"); %disp(sum_odd_rows);
fprintf('The sum of all values in odd rows is %d\n',sum_odd_rows);

% Collect and take the sum of all the values in even rows
even_rows = matrix(2:2:nRow,:);
sum_even_rows = sum(even_rows,"all"); %disp(sum_even_rows);
fprintf('The sum of all values in even rows is %d\n',sum_even_rows);

% *** CORRECTED: ***
% If the odd column values plus the odd row values is less than the even column 
% values plus the even rows values your key position 3 value will be 8. 
% If the odd column values plus the odd row values is greater than the even column 
% values plus the even rows values your key position 3 value will be 6
if ((sum_odd_cols + sum_odd_rows) < (sum_even_cols + sum_even_rows))
    fprintf(['\nThe sum of odd columns + odd rows is less than the sum of \n' ...
        'even columns and even rows. Therefore, key(3) = 8.\n'])
    key(3) = 8;
elseif ((sum_odd_cols + sum_odd_rows) > (sum_even_cols + sum_even_rows))
    fprintf(['\nThe sum of odd columns + odd rows is greater than the sum of \n' ...
        'even columns and even rows. Therefore, key(3) = 6.\n'])
    key(3) = 6;
else
    error('Neither of the given conditions have been met!');
end
fprintf('key = \n')
disp(key);

%% Problem 4: Find the Imposter's Favorite Color for key(4)
% Problem Statement:
% Use provided equation F(x) to plot F(x) for x = -0.23 to 5 in steps of 0.1. 
% Then interpolate the graph to solve for the x value where F(x) = 37.21707.
% Interpolate by taking the rate of change of values as shown in the following
% link:
%      https://www.youtube.com/watch?v=Cvc-XalN_kk
%

fprintf('\n\n********************************************************************************\n');
fprintf(    '** Problem 4: Find the Imposter''s Favorite Color for key(4) \n');
fprintf(    '********************************************************************************\n\n');

x_vec = -0.23:0.1:5;  % given x values at which to evaluate the given equation
given_F = 37.21707;         % given y value at desired x point on the plot

% The equation is given as
%    F = .6*x + x*cos(x/3) + (x*30)/sin(x)
% and put into Matlab form
F = 0.6 * x_vec + x_vec .* cos(x_vec/3) + (x_vec * 30) ./ sin(x_vec); 

% Plot the equation results over the given range of x
figure(44); plot(x_vec,F,'-b.'); grid on; 
title('Problem 4: x vs F');
% Draw a line at F = 37.21707 to visualize the point on the plot to find.
hold on;
plot([min(x_vec) max(x_vec)], [given_F given_F],'-r');
hold off;

idx = find(F >= given_F,1);
key(4) = round(x_vec(idx));
fprintf('\nkey = \n')
disp(key);

fprintf(['\nReferencing the provided "Color Code Chart- US 4", the value of x (%.5f)\n' ...
         'is rounded to the nearest intger (%d) since the Conductor values are integers.\n' ...
         'This tells us the imposter''s favorite color is Red. \n'],x_vec(idx),round(x_vec(idx)));

% ** QUIZ Extra Credit: Find the value of x at F=0  **
given_F = 0;
desired_x = find(F >= given_F,1);
fprintf(['\n*** QUIZ Extra Credit: ***\n' ...
    'The value of x\n']);
fprintf('where F=0 is %.5f.\n',desired_x);


%% Problem 5: Determine Who the Imposter Is
% Problem Statement:

fprintf('\n\n********************************************************************************\n');
fprintf(    '** Problem 5: Determine Who the Imposter Is \n');
fprintf(    '********************************************************************************\n\n');

% To determine who the Imposter is, we must matrix multiply the inverse of the
% the key with the coded message to retrive the original message. 

code = [408 176 232 72 400;  % Given
        304  66  84 53 325]; 

% Decode the message
Message = (key)^(-1) * code;

% Reshape the message by stacking all the colums and then transposing it into a
% row vectors. 
Message = Message(:)';
fprintf('After decoding, we get the following Message (still in number format):\n  ');
fprintf('%.1f  ',Message); fprintf('\n\n');

fprintf('After using the inverse of the key matrix decoded from the previous matrix, multiplying that by the code matrix, and assigning the resulting numbers to letters of the alphabet, we get that Wednesday from The Adams Family is the imposter.');


%% Bonus Problem 1: Create Your Own Secret Code
% Problem Statement:
% Using the the letters "z t r c u n i a o p h g b l y e m d" create the longest
% word you can and and create at code matrix using key = [1 2; 3 4];
fprintf('\n\n********************************************************************************\n');
fprintf(    '** Bonus Problem 1: Create Your Own Secret Code\n');
fprintf(    '********************************************************************************\n\n');

myKey = [1 2; 3 4];          % Given
myWord = 'uncopyrightable';  % Contrived

fprintf(['The word selected from the letters "z t r c u n i a o p h g b l y e m d" is:\n' ...
    '   %s (%d letters)\n\n'], myWord, length(myWord));

fprintf(['Use the "encodeMessage()" function to encode the message.  The function\n' ...
         'automatically determines the appropriate message matrix size based on\n' ...
         'the size of the key that is input.\n'])

% Convert the word to numbers
myMsg = convertTextMessageToNumericMessage(myWord);
fprintf('\nPre-encoded message:\n')
disp(myMsg);

% Encode the message
myCode = encodeMessage(myKey,myMsg);
fprintf('Key: \n'); disp(key);
fprintf('Code: \n'); disp(myCode);

extraCredit  = sum(myCode,'all')/(72+1/3);
fprintf(['Extra credit is the sum of the code values divided by 72 1/3.\n' ...
         'This assumes an character to number mapping of [A..Z] ==> [1..26].\n' ...
         'Extra credit points = %.2f\n -- Thank you! --\n'],extraCredit);


fprintf(['\n** Note:\nThe code can be decrypted by using the "encodeMessage()" again but \n' ...
         'providing the key''s inverse matrix and the code in row vector form \n' ...
         'as the message. The decoded message is:\n']);
         
myMsgBack = encodeMessage(myKey^(-1), myCode(:)');
fprintf('\nMessage (numeric): \n'); disp(myMsgBack);
fprintf('Message (text): \n  %s\n\n',convertNumericMessageToTextMessage(myMsgBack(:)'));


end % function FinalProject

function msgText = convertNumericMessageToTextMessage(msgNumbers)
    % [1..26] --> [A..Z], 0 is a space
    % Ascii is [65..90] --> [A..Z] so use this to build our vector
    letters = char(65:90); letters = [' ' letters];
    numbers = 0:26;
    msgNumbers = round(msgNumbers);
    msgText = char(zeros(1,length(msgNumbers)));
    for k = 1:length(msgNumbers)
        if ~(ismember(msgNumbers(k),numbers))
            fprintf('\n\n** NUMBER (%d) IS OUT OF RANGE. Decoding failed!. **\n\n',msgNumbers(k));
            error('Message decoding error - numeric value out of range.');
        end
        idx = find(numbers==msgNumbers(k),1);
        msgText(k) = letters(idx);
    end
end

function msgNumbers = convertTextMessageToNumericMessage(msgText)
    % [1..26] --> [A..Z], 0 is a space
    % Ascii is [65..90] --> [A..Z] so use this to build our vector
    letters = char(65:90); letters = [' ' letters];
    numbers = 0:26;

    msgText = upper(msgText); % use uppper case
    msgLen = length(msgText);
    msgNumbers = zeros(1,msgLen);
    for k = 1:msgLen
        idx = strfind(letters, msgText(k)) - 0;
        msgNumbers(k) = numbers(idx);
    end
end

function [age] = age_guess(num1to9, yearOfBirth, bday2023value)
% This function returns a person's age based on the following inputs:
%   1. num1to9:        Random integer input from 1 to 9 
%   2. yearOfBirth:    Year the person was born
%   3. bday2023value:  Given constant values of,
%          1772 if the person's 2023 bday has not yet passed 
%          1773 if the person has already celebrated their 2023 bday 

% Algorithm:
% 1. Multiply input random number of 1 to 9 (num1to9) by 2
number = num1to9 * 2;
% 2. Add 5 to above result. 
number = number + 5;
% 3. Multiply the above result by 50.
number = number * 50;
% 4. Add input bday2023value (1773 if bday has passed, 1772 otherwise)
number = number + bday2023value;
% 5. Subtract the year of  birth from the result.
number = number - yearOfBirth;

% The resulting 3-digit number is the person's age in the tens and ones digits
age = mod(number,100);

end % function age_guess


function [code] = encodeMessage(key,message)
% This function encodes a message based on any square key size and returns the
% coded message. 
code = -1;  % Error return values

% Check the key for square
[R,C] = size(key);
if (R ~= C)
    warning(['** The key provided is a %dx%d matrix; the matrix must be square. **\n' ...
        'Operation aborted.'],R,C)
    return;
end

% To reshape the message into an RxN matrix we need an even number of values; 
% check the length and add 0's if needed
modVal = mod(length(message),R);
if modVal > 0
    nZeros = R - modVal;
    addZeros = zeros(1:nZeros);
    message = [message addZeros]; 
end

% Based on the key size we will have R rows of the message; find the number of
% columns of the message.
C = length(message)/R;
myMsgMatrix = zeros(R,C);  % Pre-allocate
% Reshape the message vector per the key size
for k = 1:length(message)
    % Coded in this manner, Matlab will fill the first column top to bottom,
    % then next column and so forth
    myMsgMatrix(k) = message(k);
end

% Now encode the message
code = key * myMsgMatrix;

end %function encodeMessage







