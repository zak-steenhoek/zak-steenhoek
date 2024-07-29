function LAB04ex1d
    t0 = 0; tf = 40; y0 = [1.5;-1.4];
    [t,Y] = ode45(@f,[t0,tf],y0,[]);
    y = Y(:,1); v = Y(:,2);    % y in output has 2 columns corresponding to u1 and u2

    figure(2); clf; tiledlayout(1,2);
    % Left plot
    ax1=nexttile; grid on; hold on;
    plot(ax1,t,y); plot(ax1,t,v); hold off;
    legend(ax1, 'y(t)', 'v(t)');
    xlabel(ax1,'t'); ylabel(ax1, 'y, v(t)=y''(t)'); 
    ylim([-3.8,3.8]);
    % Right plot
    ax2 = nexttile;
    plot(ax2, y,v); grid on;
    xlabel(ax2, 'y'); ylabel(ax2, 'v(t)=y''(t)');
    ylim([-3.8,3.8]); xlim([-3,3]);


end
 %----------------------------------------------------------------------
function dydt = f(t,Y)
    y=Y(1); v=Y(2);
    dydt = [v; 5*sin(t)-4*v-2*y];
end
