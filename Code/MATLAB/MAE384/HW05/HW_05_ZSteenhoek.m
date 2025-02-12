clc; clear; clf;
t = 0:1:6;
y = [3.8 2.6 3.8 6.9 3.6 2.8 3.8];
[kp, Ak, Bk] = DFT(t,y);
tau = t(length(t));
tp = linspace(0, tau, 200);
ft = zeros(length(kp), length(tp));

for i = 1:length(kp)
    for j = 1:length(tp)
        ft(i,j) = Bk(i)*cos((kp(i)*2*pi*tp(j))/tau) + Ak(i)*sin((kp(i)*2*pi*tp(j))/tau);
    end
end

ft = sum(ft);
fk=kp/tau;

figure(1); tiledlayout(3,1);
ax1 = nexttile; hold on; plot(ax1,t,y,'o'); plot(tp, ft); title('Fourier Approx.'); hold off;
ax2 = nexttile; hold on; stem(ax2,fk,Ak, 'ob'); title(ax2, 'Fx A_k'); ax2.XLim = [-0.2 0.65]; ax2.YLim = [-0.16 0.06]; hold off;
ax3 = nexttile; hold on; stem(ax3,fk,Bk, 'ob'); title(ax3, 'Fx B_k'); ax3.XLim = [-0.2 0.65]; ax3.YLim = [-2 4.6]; hold off;

kp = kp';
Ak = Ak';
Bk = Bk';

tbl = table(kp, Ak, Bk); disp(tbl);

