function y = f(x)
    if x==9
        disp('The function undefined at x = 9')
    elseif x <= 2
        y = (-3*x)-3;
    elseif (2 < x) && (x <= 4)
        y = exp(x-9);
    elseif (4 < x)
        y = x/(x-9);
    end
end