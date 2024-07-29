%Zakary Steenhoek
%Extra Credit Assignment 1_23
%MAE215
%4.26.23

clc; clear;
val1(1)=1;
% val2(1)=.99497487437185934;
val2(1)=.995;
for i = 1:200
    diff(i) = val1(i) - val2(i);
    g(i) = val1(i)/(val1(i)-val2(i));
    if g(i) > 0
        val1(i+1) = val1(i)-diff(i);
        val2(i+1) = val2(i)-diff(i);
    else 
       fprintf('The value of ''g'' (%.20f) less than zero at i=%d.\n',g(i),i)
       break;
    end
end
figure(62); clf;
subplot(3,1,1); plot(val1); hold on; plot(val2); hold off; grid on; title('Val1, Val2');
subplot(3,1,2); plot(diff); grid on;title('diff');
subplot(3,1,3); plot(g); grid on;title('g');


fprintf('The code fails because the larger difference causes ''g'' to go to zero in \n');
fprintf('fewer than 200 iterations at which time the code fails to generate the \n');
fprintf('(i+1) term in val1 and val2 which the subsequent loop iteration requires,\n');
fprintf('thus the array access goes out of bounds and throws an error.\n')

fprintf('To find the smallest initial value of val2, set "val1/(val1-val2) = 200" and \n');
fprintf('and solve for val2 given val1 = 1.  The solution give 0.9950, however, I found \n');
fprintf('through iteration that an inital val2 of 0.99497487437185934 is the smallest \n');
fprintf('value of val2 (though 17 digits of precision) that still works.\n');


