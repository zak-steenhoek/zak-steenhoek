%PROCESSFILE Compute lift, drag, lift coefficient, drag coefficient from
% these specific files. Store the data sensibly and return it.

function [results,rho,uncertainRho] = processfile(gravdata,testdata,pressure,temperature,renum)
% Constants
R_AIR = 287.0;
MU_REF = 1.716e-5;
S_MU = 110.4;
T_REF = 273.15;
CHORD = 0.1397;
SPAN = 0.1524;
PLANFORM = CHORD*SPAN;
ERR_F = 0.05;
ERR_PITCH = 0.05;
ERR_QINF = 0.5;
ERR_THERMO = 1;
ERR_ABS_TRANSDUCER = 100;

% Inline functions
gasLaw_rho = @(P,T) P./(R_AIR.*T);
sutherland = @(T) MU_REF*(T/T_REF)^1.5*((T_REF+S_MU)/(T+S_MU));
reynold_vel = @(RE,MU,RHO) (RE*MU)/(RHO*CHORD);
pDyn = @(V,RHO) 0.5.*RHO.*V.^2;

% Air density uncertainty due to machine error
d_RHO_P = @(T) 1./(R_AIR.*T);
d_RHO_T = @(P,T) -P./(R_AIR.*T.^2);


% Derivitives
d_CL_N = @(P,Q) cos(P)./(Q.*PLANFORM);
d_CL_A = @(P,Q) -sin(P)./(Q.*PLANFORM);
d_CL_P = @(P,Q,A,N) -(A.*cos(P) + N.*sin(P))./(Q.*PLANFORM);
d_CL_Q = @(P,Q,A,N) -(N.*cos(P) - A.*sin(P))./(Q.^2.*PLANFORM);

d_CD_N = @(P,Q) sin(P)./(Q.*PLANFORM);
d_CD_A = @(P,Q) cos(P)./(Q.*PLANFORM);
d_CD_P = @(P,Q,A,N) (N.*cos(P) - A.*sin(P))./(Q.*PLANFORM);
d_CD_Q = @(P,Q,A,N) -(A.*cos(P) + N.*sin(P))./(Q.^2.*PLANFORM);

% Solve equations
rho = gasLaw_rho(pressure, temperature)
mu = sutherland(temperature)
vel = reynold_vel(renum,mu,rho)
qinf = pDyn(vel, rho)

% Grab the data we actually need
gravAxial = gravdata(2:end,1); gravNormal = gravdata(2:end,2)
testAxial = testdata(2:end,1); testNormal = testdata(2:end,2)
pitchAngle = testdata(2:end,4);

% Compensate for the weight of the wing and convert pitch
totalAxial = testAxial-gravAxial;
totalNormal = testNormal-gravNormal;
alpha = deg2rad(pitchAngle);
ERR_ALPHA = deg2rad(ERR_PITCH);

% Compute values
lift = totalNormal.*cos(alpha)-totalAxial.*sin(alpha)
drag = totalNormal.*sin(alpha)+totalAxial.*cos(alpha)
coeffLift = lift./(qinf*PLANFORM)
coeffDrag = drag./(qinf*PLANFORM)

% Compute uncertainty values
uncCL_n = (d_CL_N(alpha,qinf).*ERR_F).^2
uncCL_a = (d_CL_A(alpha,qinf).*ERR_F).^2
uncCL_pitch = (d_CL_P(alpha,qinf,totalAxial,totalNormal).*ERR_ALPHA).^2
uncCL_press = (d_CL_Q(alpha,qinf,totalAxial,totalNormal).*ERR_QINF).^2
unc_CL = sqrt(uncCL_n+uncCL_a+uncCL_pitch+uncCL_press)

uncCD_n = (d_CD_N(alpha,qinf).*ERR_F).^2
uncCD_a = (d_CD_A(alpha,qinf).*ERR_F).^2
uncCD_pitch = (d_CD_P(alpha,qinf,totalAxial,totalNormal).*ERR_ALPHA).^2
uncCD_press = (d_CD_Q(alpha,qinf,totalAxial,totalNormal).*ERR_QINF).^2
unc_CD = sqrt(uncCD_n+uncCD_a+uncCD_pitch+uncCD_press)

unc_RHO_P = (d_RHO_P(temperature).*ERR_ABS_TRANSDUCER).^2
unc_RHO_T = (d_RHO_T(pressure, temperature)*ERR_THERMO).^2

% Round for consistancy
pitchAngle = round(pitchAngle, 5, "significant")
coeffLift = round(coeffLift, 5, "significant")
coeffDrag = round(coeffDrag, 5, "significant")
unc_CL = round(unc_CL, 5, "significant")
unc_CD = round(unc_CD, 5, "significant")

% Return results
results = [pitchAngle,coeffLift,coeffDrag,unc_CL,unc_CD];
uncertainRho = sqrt(unc_RHO_P+unc_RHO_T)
end

