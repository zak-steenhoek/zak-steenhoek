function LAB04ex2d
    t0 = 0; tf = 40; y0 = [1;0];
    [t,Y] = ode45(@f,[t0,tf],y0,[]);
    y = Y(:,1); %v = Y(:,2);    % y in output has 2 columns corresponding to u1 and u2

    [te, Ye] = euler(@f,[t0,tf],y0,400);
    ye = Ye(:,1);

    figure(4); clf;
    grid on; hold on;
    plot(t,y,'Color','black'); plot(te,ye,'Color','red'); hold off;
    legend('ode45', 'euler');
    xlabel('t'); ylabel('y'); 
    ylim([-3.8,3.8]);
end
 %----------------------------------------------------------------------
function dydt = f(t,Y)
    y=Y(1); v=Y(2);
    dydt = [v; 5*sin(t)-4*y.^2*v-2*y];
end
