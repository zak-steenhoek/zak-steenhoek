function ex_with_param
   t0 = 0; tf = 3; y0 = 1;
   a = 1;
   [t,y] = ode45(@f,[t0,tf],y0,[],a);
   disp(['y(' num2str(t(end)) ') = ' num2str(y(end))])
   disp(['length of y = ' num2str(length(y))])
end
%-------------------------------------------------
function dydt = f(t,y,a)
dydt = -a*(y-exp(-t))-exp(-t);
end