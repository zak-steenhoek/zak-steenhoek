clc; clear;

Re = 2142098;
e = 0.00005; D = 0.75;
eD = e/D;
guess = [.0001 .1];

f = fzero(@colebrookEqn,guess,[],Re,eD)

function y = colebrookEqn(f,Re,eD)
    y = 1./sqrt(f)+2*log10(eD/3.7+2.51/Re./sqrt(f));
end



