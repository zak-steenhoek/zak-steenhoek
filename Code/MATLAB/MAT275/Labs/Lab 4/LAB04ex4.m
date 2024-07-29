function LAB04ex4
    t0 = 0; tf = 40; y0 = [1;0;0.5];
    [t,Y] = ode45(@f,[t0,tf],y0,[]);
    y = Y(:,1); v = Y(:,2); w = Y(:,3);   % y in output has 2 columns corresponding to u1 and u2


    figure(3); clf; tiledlayout(1,2);
    % Left plot
    ax1=nexttile; grid on; hold on;
    plot(ax1,t,y,'Color','blue'); plot(ax1,t,v,'Color','red'); plot(ax1,t,w,'Color','black'); hold off;
    legend(ax1, 'y(t)', 'v(t)', 'w(t)');
    xlabel(ax1,'t'); ylabel(ax1, 'y, v(t)=y''(t)'); 
    ylim([-3.8,3.8]);
    % Right plot
    ax2 = nexttile;
    plot3(ax2, y,v,w); grid on; hold on; view([-40,60]);
    xlabel(ax2, 'y'); ylabel(ax2,'v=y'''); zlabel(ax2,'w=y'''''); 
    ylim([-3.8,3.8]); xlim([-3,3]);
end
 %----------------------------------------------------------------------
function dydt = f(t,Y)
    y=Y(1); v=Y(2); w=Y(3);
    dydt = [v; w; 5*cos(t)-4*y.^2*w-8*y*v.^2-2*v];
end
