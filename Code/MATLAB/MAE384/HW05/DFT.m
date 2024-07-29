function [kp, Ak, Bk] = DFT(t,y)
    N = (length(y)-1)/2;
    dt = (t(2*N)-t(1))/(2*N-1);
    kp = 0:N;
    
    Ak(1) = 0; Ak(N+1)=0;
    Bk(1) = sum(y(1:2*N))/(2*N);

    for i=2:N
        Ak(i)=0; 
        Bk(i)=0;

        for j=1:2*N
            Ak(i)=Ak(i)+y(j)*sin(pi*(i-1)*t(j)/(dt*N));
            Bk(i)=Bk(i)+y(j)*cos(pi*(i-1)*t(j)/(dt*N));
        end

        Ak(i)=Ak(i)/N;
        Bk(i)=Bk(i)/N;
    end
    Bk(N+1)=0;

    for j=1:2*N
        Bk(N+1)=Bk(N+1)+y(j)*cos(pi*N*t(j)/(dt*N));
    end

    Bk(N+1)=Bk(N+1)/(2*N);
end
