%Zakary Steenhoek
%HW0
%MAE215
%1/19/23 (LATE)

clc; 
clear; %Clearing memory and workspace

disp('Hello World'); %Greeting
disp('The ourpose of this code is to evluate the probability of a user randomly selecting an ace from a regular deck of cards.'); %Purpose of the code

favorableOutcomes = input("How many favorable outcomes are there? "); %Takes user input for the nuber of favorable outcomes
totalOutcomes = input("How many total outcomes are there? "); %Takes user input for the number of total outcomes

probability = favorableOutcomes/totalOutcomes*100; %Calculates the percent chance to draw an ace from a deck of cards using the equation p(A) = n(A)/n(S) * 100

format = 'The probability to draw an ace from a regular deck of cards is %2.3f%%.'; %Setting the output text and formatting the result to three decimal places
fprintf(format,probability); %Printing the result using the above format

%end