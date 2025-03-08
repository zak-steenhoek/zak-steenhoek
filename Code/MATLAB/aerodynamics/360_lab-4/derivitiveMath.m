%% temp math
clear; clc;

sympref('FloatingPointOutput',true);
syms N A Q P S R T

L = N*cos(P)-A*sin(P);
D = N*sin(P)+A*cos(P);

CL = L/(Q*S);
CD = D/(Q*S);

d_CL_N = diff(CL,N);
d_CL_A = diff(CL,A);
d_CL_P = diff(CL,P);
d_CL_Q = diff(CL,Q);

d_CD_N = diff(CD,N);
d_CD_A = diff(CD,A);
d_CD_P = diff(CD,P);
d_CD_Q = diff(CD,Q);

d_CL_N = @(P,Q,S) cos(P)/(Q*S);
d_CL_A = @(P,Q,S) -sin(P)/(Q*S);
d_CL_P = @(A,P,N,Q,S) -(A*cos(P) + N*sin(P))/(Q*S);
d_CL_Q = @(A,P,N,Q,S) -(N*cos(P) - A*sin(P))/(Q^2*S);

d_CD_N = @(P,Q,S) sin(P)/(Q*S);
d_CD_A = @(P,Q,S) cos(P)/(Q*S);
d_CD_P = @(A,P,N,Q,S) (N*cos(P) - A*sin(P))/(Q*S);
d_CD_Q = @(A,P,N,Q,S) -(A*cos(P) + N*sin(P))/(Q^2*S);


gasLaw_rho = P./(R.*T);

d_RHO_P = diff(gasLaw_rho, P);
d_RHO_T = diff(gasLaw_rho, T);

