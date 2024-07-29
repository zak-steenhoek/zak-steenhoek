function [r,a,n] = geomsum1(r,a,n)
    sum = 0;
    for i = 0:n-1
        sum = sum + a*r^i;
    end
end