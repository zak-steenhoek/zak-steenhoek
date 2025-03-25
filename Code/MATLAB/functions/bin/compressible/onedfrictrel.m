function varargout=onedfrictrel(varargin)
%[M,T/T*,p/p*,roh/roh*,po/po*,4fL*/D]=onedfrictrel(I,[gamma],[choice])
%Provides the one dimensional flow with friction relations for the input M
%If gamma is not specified, air is assumed (gamma=1.4)
%If only one output is given, a matrix of results is given, and if there is
%5 outputs given, it seperates. Note this code CAN handle vectors of M
%choice options - M:  input the mach number (default)   (M>=0)
%                 T:  input the temperature relation    (T>=0)
%                 P:  input the pressure relation       (P>=0)
%                 R:  input the density relation        (R>0.40821 for air)
%                 P0A:input the total presure relation (supersonic)  (POA>=1)
%                 P0B:input the total presure relation (subsonic)    (1.2679>POB>=1 for air)
%                 F:  input the friction the dimensionless friction for L* (F<0.8215 for air)
%
% Created by Tom Ransegnola, last edited 11/24/14
% If errors are found, please email at transegn@gmail.com

%%%%%%%%%%%%%%%%%%%%CHECK INPUTS
if nargin==0
    help onedfrictrel
    varargout=[];
    return
elseif nargin==2
    gamma=varargin{2};
    choice='M';
elseif nargin==1
    gamma=1.4; %assume air
    choice='M';
elseif nargin==3
    choice=varargin{3};
    if ~isempty(varargin{2})
        gamma=varargin{2};
    else
        gamma=1.4;
    end
else
    error('Inputs not accepted')
end

if ~isnumeric(varargin{1}) || ~isnumeric(gamma) || ~any(strcmpi(choice,{'M','T','P','F','R','P0A','P0B'}))
    error('Inputs not accepted')
end


%%%%%%%%%%%%%%%%%%%%SOLVE FOR MISSING DATA
if strcmpi(choice,'M') && all(varargin{1}>0)
    M=reshape(varargin{1},numel(varargin{1}),1);
    TT=(gamma+1)./(2+(gamma-1).*M.^2);    %modern compressible equation (3.103)
    pp=TT.^(1/2)./M;                     %eq (3.104)
    rohroh=TT.^(-1/2)./M;                    %eq (3.105)
    p0p0=TT.^(-(gamma+1)/(2*(gamma-1)))./M;  %eq (3.106)
    fLD=(1-M.^2)./(gamma.*M.^2)+(gamma+1)/(2*gamma).*log(TT.*M.^2);  %eq (3.107)
elseif strcmpi(choice,'T') && all(varargin{1}>=0)
    TT=reshape(varargin{1},numel(varargin{1}),1);
    M=(((gamma - 1).*(gamma - 2.*TT + 1))./TT).^(1/2)./(gamma - 1);
    pp=TT.^(1/2)./M;                     %eq (3.104)
    rohroh=TT.^(-1/2)./M;                    %eq (3.105)
    p0p0=TT.^(-(gamma+1)/(2*(gamma-1)))./M;  %eq (3.106)
    fLD=(1-M.^2)./(gamma.*M.^2)+(gamma+1)/(2*gamma).*log(TT.*M.^2);  %eq (3.107)
elseif strcmpi(choice,'P') && all(varargin{1}>=0)
    pp=reshape(varargin{1},numel(varargin{1}),1);
    M=(-(pp - (gamma^2 + pp.^2 - 1).^(1/2))./(pp.*(gamma - 1))).^(1/2); %modern compressible flow eq (3.85) solved for M
    TT=(gamma+1)./(2+(gamma-1).*M.^2);    %modern compressible equation (3.103)
    rohroh=TT.^(-1/2)./M;                    %eq (3.105)
    p0p0=TT.^(-(gamma+1)/(2*(gamma-1)))./M;  %eq (3.106)
    fLD=(1-M.^2)./(gamma.*M.^2)+(gamma+1)/(2*gamma).*log(TT.*M.^2);  %eq (3.107)
elseif strcmpi(choice,'F')
    [~,~,~,~,~,p]=onedfrictrel(1e100,gamma,'M');
    if all(varargin{1}<p)
        fLD=reshape(varargin{1},numel(varargin{1}),1);
        for i=length(fLD):-1:1   %solve for corresponding M and then use that M to find the rest of the values
            M(i,1)=fzero(@(x) (1-x.^2)./(gamma.*x.^2)+(gamma+1)/(2*gamma).*log(((gamma+1)./(2+(gamma-1).*x.^2)).*x.^2) - fLD(i),1);
        end
        TT=(gamma+1)./(2+(gamma-1).*M.^2);    %modern compressible equation (3.103)
        pp=TT.^(1/2)./M;                     %eq (3.104)
        rohroh=TT.^(-1/2)./M;                    %eq (3.105)
        p0p0=TT.^(-(gamma+1)/(2*(gamma-1)))./M;  %eq (3.106)
    else
        error('Input Out of Range')
    end
elseif strcmpi(choice,'R')
    [~,~,~,p,~,~]=onedfrictrel(1e100,gamma,'M');
    if all(varargin{1}>p)
        rohroh=reshape(varargin{1},numel(varargin{1}),1);
        M=2^(1/2).*(1/(gamma.*rohroh.^2 - gamma + rohroh.^2 + 1)).^(1/2);
        TT=(gamma+1)./(2+(gamma-1).*M.^2);    %modern compressible equation (3.103)
        pp=TT.^(1/2)./M;                     %eq (3.104)
        p0p0=TT.^(-(gamma+1)/(2*(gamma-1)))./M;  %eq (3.106)
        fLD=(1-M.^2)./(gamma.*M.^2)+(gamma+1)/(2*gamma).*log(TT.*M.^2);  %eq (3.107)
    else
        error('Input Out of Range')
    end
elseif strcmpi(choice,'P0A') && all(varargin{1}>=1)
    p0p0=reshape(varargin{1},numel(varargin{1}),1);
    for i=length(p0p0):-1:1
        f=@(x) ((gamma+1)./(2+(gamma-1).*x.^2)).^(-(gamma+1)/(2*(gamma-1)))./x - p0p0(i);
        
        xlb=1;
        fl=f(xlb);
        xub=10;
        while f(xub)*fl>0
            xub=xub*10;
        end
        
        M(i,1)=bisection(1e-6,1e6,f,xlb,xub);
    end
    TT=(gamma+1)./(2+(gamma-1).*M.^2);    %modern compressible equation (3.103)
    pp=TT.^(1/2)./M;                     %eq (3.104)
    rohroh=TT.^(-1/2)./M;                    %eq (3.105)
    fLD=(1-M.^2)./(gamma.*M.^2)+(gamma+1)/(2*gamma).*log(TT.*M.^2);  %eq (3.107)
elseif strcmpi(choice,'P0B') && all(varargin{1}>=1)
    p0p0=reshape(varargin{1},numel(varargin{1}),1);
    for i=length(p0p0):-1:1
        f=@(x) ((gamma+1)./(2+(gamma-1).*x.^2)).^(-(gamma+1)/(2*(gamma-1)))./x - p0p0(i);
        
        xub=1;
        fh=f(xub);
        xlb=1/10;
        while f(xlb)*fh>0
            xlb=xlb/10;
        end
        
        M(i,1)=bisection(1e-6,1e6,f,xlb,xub);
    end
    TT=(gamma+1)./(2+(gamma-1).*M.^2);    %modern compressible equation (3.103)
    pp=TT.^(1/2)./M;                     %eq (3.104)
    rohroh=TT.^(-1/2)./M;                    %eq (3.105)
    fLD=(1-M.^2)./(gamma.*M.^2)+(gamma+1)/(2*gamma).*log(TT.*M.^2);  %eq (3.107)
else
    error('Input Out of Range')
end


%%%%%%%%%%%%%%%%%%%%FORMAT OUTPUTS
if nargout<=1 %work with it if they dont wana differentiate
    varargout{1}=[M,TT,pp,rohroh,p0p0,fLD];
elseif nargout==6 %put it back how you found it if they give enough output info
    varargout{1}=reshape(M,size(varargin{1}));
    varargout{2}=reshape(TT,size(varargin{1}));
    varargout{3}=reshape(pp,size(varargin{1}));
    varargout{4}=reshape(rohroh,size(varargin{1}));
    varargout{5}=reshape(p0p0,size(varargin{1}));
    varargout{6}=reshape(fLD,size(varargin{1}));
else %probably a mistake
    error('Innaproiate Number of Output Arguements')
end
end

function out=bisection(tolx,maxit,f,xl,xh)


fl=f(xl);
fh=f(xh);

%If root is already given by bounds
if fl==0
    out=xl;
    return;
elseif fh==0
    out=xh;
    return;
elseif fl*fh>0
    error('The root cross is not captured in this bounds');
end

it=0;
while 2*(xh-xl)/(xh+xl)>tolx
    
    if it>maxit
        error('Root finding did not converge in allotted iterations in bisection().')
    end
    
    x=(xh+xl)/2;
    fx=f(x);
    
    if fl*fx>0
        %fx and fl share sign, x is new lb
        fl=fx;
        xl=x;
    elseif fh*fx>0
        %fx and fh share sign, x is new ub
        fh=fx;
        xh=x;
    else
        %fx=0
        out=x;
        return;
    end
    
    %Increment iteration counter
    it=it+1;
    
end

out=(xh+xl)/2;
end