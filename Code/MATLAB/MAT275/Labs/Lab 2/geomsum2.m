function [r,a,n] = geomsum2(r,a,n)
    total = 0;
    e = 0:n-1;
    for i = 0: n-1
        R = r.^e;
    end
    sum(R);
end