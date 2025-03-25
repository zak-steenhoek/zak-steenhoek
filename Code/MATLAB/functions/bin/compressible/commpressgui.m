function commpressgui(varargin)
%This GUI displays the results that can be calculated using the
%compressible function. It allows you to insert you desired input and gamma
%value and find the values corresponded to the table you wish to use
%
% Created by Tom Ransegnola, last edited 11/24/14
% If errors are found, please email at transegn@gmail.com


%#ok<*ST2NM>   for some reason, it tries to make me change my str2num calls to str2double,
%                but str2num uses "eval" so it will evaluate formulas if they are inputted
%                which is better here (that statement just supresses the warning to change)

%%% create the figure
close all %make space
color=[1 1 1]; shiftup=8;
S.fh = figure('units','pixels',...
    'position',[256 148 895 502],...
    'menubar','none',...
    'name','Compressible Flow Relations',...
    'Color',color,...
    'numbertitle','off',...
    'visible','off',...
    'resize','off');


%%%% table choice components
S.tabsel = uicontrol('style','popupmenu',...
    'unit','pix',...
    'position',[100 60 200 400],...
    'min',0,'max',2,...
    'fontsize',14,...
    'callback',{@table_call,S},...
    'string',{'1 - Isentropic Flow';'2 - Normal Shock';'3 - Heat Addition';'4 - Flow with Friction';'5 - Prandtl Meyer';'6 - Theta Beta M'});

S.tablab = uicontrol('style','text',...
    'unit','pix',...
    'position',[25 430 75 25],...  +x    y down   width height
    'min',0,'max',2,...
    'fontsize',14,...
    'BackgroundColor',color,...
    'string',{'Table A.'});



%%%% input choice components
S.choicelab = uicontrol('style','text',...
    'unit','pix',...
    'position',[320 430 90 25],...  +x    y down   width height
    'min',0,'max',2,...
    'fontsize',14,...
    'BackgroundColor',color,...
    'string',{'Input type:'});

S.choicesel = uicontrol('style','popupmenu',...
    'unit','pix',...
    'position',[410 60 145 400],...
    'min',0,'max',2,...
    'fontsize',14,...
    'callback',{@choice_call,S},...
    'string',{'Mach Number';'p0/p';'rho0/rho';'T0/T';'A/A* (M>1)';'A/A* (M<1)'});


%%%% input value component
S.inputlab = uicontrol('style','text',...
    'unit','pix',...
    'position',[580 430 60 25],...  +x    y down   width     height
    'min',0,'max',2,...
    'fontsize',14,...
    'BackgroundColor',color,...
    'string',{'Value:'});

S.inputsel = uicontrol('style','edit',...
    'unit','pix',...
    'position',[640 430 145 25],...
    'min',0,'max',1,...
    'fontsize',14,...
    'callback',{@input_call,S},...
    'string',{''});

%%% list displays
w=800;pos=370;h=300;wc=160;
cnames = {'Mach Number','p0/p','rho0/rho','T0/T','A/A*'};   % GUI starts on table 1
% Create the uitable
S.listsel = uitable(...
    'position',[(895-w+20)/2 pos-h wc*5+2 h],...
    'RowName',[],...
    'ColumnWidth',{wc,wc,wc,wc,wc},...
    'ColumnName',cnames);


%%% gamma input component
start=10;width1=80;
S.gammalab = uicontrol('style','text',...
    'unit','pix',...
    'position',[start 10+shiftup width1 25],...  +x    y down   width     height
    'min',0,'max',2,...
    'fontsize',14,...
    'BackgroundColor',color,...
    'string',{'Gamma:'});

S.gammasel = uicontrol('style','edit',...
    'unit','pix',...
    'position',[start+width1 10+shiftup 145 25],...
    'min',0,'max',1,...
    'fontsize',14,...
    'callback',{@gamma_call,S},...
    'string',{'1.4'});



%%%%%clear list component
S.pbclear = uicontrol('style','push',...
    'units','pix',...
    'position',[700 10+shiftup 180 25],...
    'fontsize',14,...
    'string','Clear List',...
    'callback',{@clear_call,S});


%%%%theta-beta-M hidden components
%extra input type selection
S.tbmlab = uicontrol('style','text',...
    'unit','pix',...
    'position',[320 390 90 25],...  +x    y up   width height
    'min',0,'max',2,...
    'visible','off',...
    'fontsize',14,...
    'BackgroundColor',color,...
    'string',{'Input type:'});

S.tbmsel = uicontrol('style','popupmenu',...
    'unit','pix',...
    'position',[410 20 145 400],...
    'min',0,'max',2,...
    'visible','off',...
    'callback',{@choice2_call,S},...
    'fontsize',14,...
    'string',{'Mach Number';'p0/p';'rho0/rho';'T0/T';'A/A* (M>1)';'A/A* (M<1)'});

%%%extra input box
S.tbminlab = uicontrol('style','text',...
    'unit','pix',...
    'position',[580 390 60 25],...  +x    y down   width     height
    'min',0,'max',2,...
    'visible','off',...
    'fontsize',14,...
    'BackgroundColor',color,...
    'string',{'Value:'});

S.tbminsel = uicontrol('style','edit',...
    'unit','pix',...
    'position',[640 390 145 25],...
    'min',0,'max',1,...
    'visible','off',...
    'fontsize',14,...
    'callback',{@input_call,S},...
    'string',{''});


%%%limit label
S.limlab = uicontrol('style','text',...
    'unit','pix',...
    'position',[640 460 145 25],...  +x    y down   width     height
    'min',0,'max',2,...
    'visible','on',...
    'fontsize',14,...
    'BackgroundColor',color,...
    'string',{'I>=0'});


%%%change background color
S.colorsel = uicontrol('style','popupmenu',...
    'unit','pix',...
    'position',[500-180+60 13+shiftup 180 25],...
    'min',0,'max',2,...
    'visible','on',...
    'callback',{@color_call,S},...
    'fontsize',14,...
    'string',{'White';'Yellow';'Magenta';'Cyan';'Red';'Green';'Blue';'Black'});

S.colorlab = uicontrol('style','text',...
    'unit','pix',...
    'position',[500-180 10+shiftup 60 25],...  +x    y down   width     height
    'min',0,'max',2,...
    'visible','on',...
    'fontsize',14,...
    'BackgroundColor',color,...
    'string',{'Color:'});


%%%error messages if bad inputs
S.badgammalab = uicontrol('style','text',...
    'unit','pix',...
    'position',[start+width1 40+shiftup 800 17],...  +x    y up   width     height
    'min',0,'max',2,...
    'visible','off',...
    'fontsize',10,...
    'BackgroundColor',color,...
    'ForegroundColor',[1 0 0],...
    'HorizontalAlignment','left',...
    'string',{''});

S.badinputlab = uicontrol('style','text',...
    'unit','pix',...
    'position',[0 410 784 17],...  +x    y up   width     height
    'min',0,'max',2,...
    'visible','off',...
    'fontsize',10,...
    'BackgroundColor',color,...
    'ForegroundColor',[1 0 0],...
    'HorizontalAlignment','right',...
    'string',{''});


%%%hidden cell to hold previous gamma value
S.hiddengamma = uicontrol('style','text',...
    'unit','pix',...
    'position',[1 1 1 1],...
    'visible','off',...
    'fontsize',10,...
    'string',{'1.4'});

set(S.fh,'Visible','on')








function [] = clear_call(varargin)
% Callback for pushbutton, deletes lines from table. Also resets column widths
S = varargin{3};  % Get the structure.
child=flipud(get(S.fh,'Children'));
set(child(7),'Data',1)
set(child(7),'Data',[]);set(child([18 19]),'Visible','off')


function [] = gamma_call(varargin)
% Callback for gamma input, clears table and input to avoid confusion on which gamma
% was used to calculate something. Defaults back to gamma=1.4 if it doesnt like the input
S = varargin{3};  % Get the structure.
child=flipud(get(S.fh,'Children'));
gammain=get(child(9),'String');
set(child([18 19]),'Visible','off')
if isempty(str2num(gammain{1})) || length(str2num(gammain{1}))>1 || str2num(gammain{1})<=1  %it would have me use str2double, but I like str2num more because
    set(child(9),'String',get(child(20),'String'))                                          %it uses the "eval" fn and therefore recognizes gamma=3/2=1.5
    if length(gammain{1})<=20
        set(child(18),'Visible','on','string',['Input ' gammain{1} ' not recognized'])
    else
        set(child(18),'Visible','on','string','Input not recognized')
    end
else
    set(child([9 20]),'String',{num2str(str2num(gammain{1}))})
    set(child([18 19]),'Visible','off')
end
set(child(4),'Value',1)
if get(child(1),'value')==2 || get(child(1),'value')==5
    set(child(15),'string','I>=1')
else
    set(child(15),'string','I>=0')
end
set(child(7),'Data',1);set(child(6),'String',[]);set(child(7),'Data',[]);set(child(14),'String',[])


function [] = table_call(varargin)
%Callback for table choice. Clears the data and formats for the new table.
%Also puts the correct list of choices for the input possibilites
S = varargin{3};  % Get the structure.
child=flipud(get(S.fh,'Children'));
T = get(child(1),'value');  % Get the users choice
switch T
    case 1
        set(child(4),'value',1,'string',{'Mach Number';'p0/p';'rho0/rho';'T0/T';'A/A* (M>1)';'A/A* (M<1)'})
        set(child(11),'Visible','off');set(child(12),'Visible','off');set(child(13),'Visible','off');set(child(14),'Visible','off')
        wc=160;
        set(child(7),'ColumnWidth',{wc,wc,wc,wc,wc},'ColumnName',{'Mach Number','p0/p','rho0/rho','T0/T','A/A*'})
        set(child(15),'string','I>=0','Visible','on')
        set(child(19),'Position',[0 410 784 17])
    case 2
        set(child(4),'value',1,'string',{'Mach Number';'p2/p1';'rho2/rho1';'T2/T1';'p02/p01';'p02/p1';'M2'})
        set(child(11),'Visible','off');set(child(12),'Visible','off');set(child(13),'Visible','off');set(child(14),'Visible','off')
        wc=160*5/7;
        set(child(7),'ColumnWidth',{wc,wc,wc,wc,wc,wc,wc},'ColumnName',{'Mach Number','p2/p1','rho2/rho1','T2/T1','p02/p01','p02/p1','M2'})
        set(child(15),'string','I>=1','Visible','on')
        set(child(19),'Position',[0 410 784 17])
    case 3
        set(child(4),'value',1,'string',{'Mach Number';'p/p*';'T/T* (M>1)';'T/T* (M<1)';'rho/rho*';'p0/p0* (M>1)';'p0/p0* (M<1)';'T0/T0* (M>1)';'T0/T0* (M<1)'})
        set(child(11),'Visible','off');set(child(12),'Visible','off');set(child(13),'Visible','off');set(child(14),'Visible','off')
        wc=160*5/6;
        set(child(7),'ColumnWidth',{wc,wc,wc,wc,wc,wc},'ColumnName',{'Mach Number','p/p*','T/T*','rho/rho*','p0/p0*','T0/T0*'})
        set(child(15),'string','I>=0','Visible','on')
        set(child(19),'Position',[0 410 784 17])
    case 4
        set(child(4),'value',1,'string',{'Mach Number';'T/T*';'p/p*';'rho/rho*';'p0/p0* (M>1)';'p0/p0* (M<1)';'4fL*/D'})
        set(child(11),'Visible','off');set(child(12),'Visible','off');set(child(13),'Visible','off');set(child(14),'Visible','off')
        wc= 160*5/6;
        set(child(7),'ColumnWidth',{wc,wc,wc,wc,wc,wc},'ColumnName',{'Mach Number','T/T*','p/p*','rho/rho*','p0/p0*','4fL*/D'})
        set(child(15),'string','I>0','Visible','on')
        set(child(19),'Position',[0 410 784 17])
    case 5
        set(child(4),'value',1,'string',{'Mach Number';'v(M)';'Mach Angle (deg)'})
        set(child(11),'Visible','off');set(child(12),'Visible','off');set(child(13),'Visible','off');set(child(14),'Visible','off')
        wc=160*5/3;
        set(child(7),'ColumnWidth',{wc,wc,wc},'ColumnName',{'Mach Number','v(M)','Mach Angle (deg)'})
        set(child(15),'string','I>=1','Visible','on')
        set(child(19),'Position',[0 410 784 17])
    case 6
        set(child(4),'value',1,'string',{'Theta';'Beta'})
        set(child(11),'Visible','on');set(child(13),'Visible','on');set(child(14),'Visible','on')
        set(child(12),'Visible','on','value',1,'string',{'Beta';'M(weak)';'M(strong)'})
        wc=160*5/3;
        set(child(7),'ColumnWidth',{wc,wc,wc},'ColumnName',{'Theta','Beta','M'})
        set(child(15),'Visible','off')
        set(child(19),'Position',[0 370 784 17])
end
set(child(7),'Data',1);set(child(6),'String',[]);set(child(7),'Data',[]);set(child(14),'String',[]);set(child([18 19]),'Visible','off');


function [] = choice_call(varargin)
% Callback for input choice. Clears the old input choice to avoid reusing
% value for previous input and getting confused. Also sets the options for
% second input if using the TBM table
S = varargin{3};  % Get the structure.
child=flipud(get(S.fh,'Children'));
T=get(child(1),'value');
I1=get(child(4),'value');
gammain=get(child(9),'String');
gamma=str2num(gammain{1});
if T==1
    switch I1
        case 1
            set(child(15),'string','I>=0')
        case {2,3}
            set(child(15),'string','I>1')
        case {4,5,6}
            set(child(15),'string','I>=1')
    end
elseif T==2
    switch I1
        case {1,2,3,4,5}
            set(child(15),'string','I>=1')
        case 6
            [~,~,~,~,~,p,~]=normalshockrel(1,gamma,'M');
            set(child(15),'string',sprintf('I>%.4f',p))
        case 7
            [~,~,~,~,~,~,p]=normalshockrel(1e100,gamma,'M');
            set(child(15),'string',sprintf('%.4f<I<=1',p))
    end
elseif T==3
    switch I1
        case 1
            set(child(15),'string','I>=0')
        case 2
            set(child(15),'string','I>0')
        case {3,4,8,9}
            set(child(15),'string','I<=1')
        case 5
            [~,~,~,p,~,~]=onedheataddrel(1e100,gamma,'M');
            set(child(15),'string',sprintf('I>%.4f',p))
        case {6,7}
            set(child(15),'string','I>=1')
    end
elseif T==4
    switch I1
        case 1
            set(child(15),'string','I>0')
        case {2,3}
            set(child(15),'string','I>=0')
        case 4
            [~,~,~,p,~,~]=onedfrictrel(1e100,gamma,'M');
            set(child(15),'string',sprintf('I>%.4f',p))
        case {5,6}
            set(child(15),'string','I>=1')
        case 7
            [~,~,~,~,~,p]=onedfrictrel(1e100,gamma,'M');
            set(child(15),'string',sprintf('I<%.4f',p))
    end
elseif T==5
    switch I1
        case 1
            set(child(15),'string','I>=1')
        case 2
            [~,p,~]=prandtlmeyerrel(1e100,gamma,'M');
            set(child(15),'string',sprintf('0<=I<%.4f',p))
        case 3
            set(child(15),'string','0<=I<=90')
    end
elseif T==6
    if I1==1
        set(child(12),'value',1,'string',{'Beta';'M(weak)';'M(strong)'})
    else
        set(child(12),'value',1,'string',{'M'})
    end
end
data=get(child(7),'Data');
set(child(7),'Data',1);set(child(7),'Data',data)
set(child(6),'String',[]);set(child(14),'String',[]);set(child([18 19]),'Visible','off');


function [] = choice2_call(varargin)
% Callback for second input choice. Clears the old input choice to avoid reusing
% value for previous input and getting confused
S = varargin{3};  % Get the structure.
child=flipud(get(S.fh,'Children'));
data=get(child(7),'Data');
set(child(7),'Data',1);set(child(7),'Data',data)
set(child(14),'String',[]);set(child([18 19]),'Visible','off')


function [] = input_call(varargin)
% Callback for input value. Calculates and displays the results for the
% given table and input type. It will overwrite the oldest entry if the
% list will go off the page
S = varargin{3};  % Get the structure.
child=flipud(get(S.fh,'Children'));
T = get(child(1),'value');
set(child([18 19]),'Visible','off')
if T==6
    if get(child(4),'value')==1
        if get(child(12),'value')==1
            choice='TB';
            sel1='Theta';sel2='Beta';
        elseif get(child(12),'value')==2
            choice='TMW';
            sel1='Theta';sel2='Mach Number';
        else
            choice='TMS';
            sel1='Theta';sel2='Mach Number';
        end
    else
        choice='BM';
        sel1='Beta';sel2='Mach Number';
    end
else
    choices={{'M','P','R','T','AA','AB'},{'M','P','R','T','P0','P1','M2'},{'M','P','TA','TB','R','P0A','P0B','T0A','T0B'},{'M','T','P','R','P0A','P0B','F'},{'M','P','A'}};
    choice=choices{T}{get(child(4),'value')};
    choicewords=get(child(7),'ColumnName');
    choiceinds={[1 2 3 4 5 5],1:1:7,[1 2 3 3 4 5 5 6 6],[1 2 3 4 5 5 6],[1 2 3]};
    if T==5 && get(child(4),'value')==3
        sel1='Mach Angle';
    else
        sel1=choicewords{choiceinds{T}(get(child(4),'value'))};
    end
end
inputstr=get(child(6),'String');
input2str=get(child(14),'String');
if iscell(inputstr)                       %same as the gamma input, str2num is better because it can evaluate formulas entered in input
    inputstr=inputstr{1};
end
if iscell(input2str)
    input2str=input2str{1};
end
[input,ok]=str2num(inputstr);
[input2,ok2]=str2num(input2str);
if ~ok && ~isempty(inputstr)
    set(child(6),'String',[]);
    set(child(19),'Visible','on','string',[sel1 ' not recognized'])
    set(child(18),'Visible','off')
    data=get(child(7),'Data');
    set(child(7),'Data',1);set(child(7),'Data',data)
    return
elseif ~ok2 && ~isempty(input2str)
    set(child(14),'String',[]);
    set(child(19),'Visible','on','string',[sel2 ' not recognized'])
    set(child(18),'Visible','off')
    data=get(child(7),'Data');
    set(child(7),'Data',1);set(child(7),'Data',data)
    return
else
    set(child([18 19]),'Visible','off')
end
gammain=get(child(9),'String');
gamma=str2num(gammain{1});
if T==6
    if isempty(input) || isempty(input2)
        set(child([18 19]),'Visible','off')
        data=get(child(7),'Data');
        set(child(7),'Data',1);set(child(7),'Data',data)
        return
    elseif ~(numel(input)==numel(input2))
        set(child(6),'String',[]);set(child(14),'String',[]);
        set(child(18),'Visible','off')
        set(child(19),'Visible','on','string','Input dimensions must agree')
        data=get(child(7),'Data');
        set(child(7),'Data',1);set(child(7),'Data',data)
        return
    else
        input=[reshape(input,[],1) reshape(input2,[],1)];
    end
end
if ~isempty(input)
    isok=testok(input,T,get(child(4),'Value'),gamma);
    if isok
        specs=compressible(input,T,choice,gamma);
        data=get(child(7),'Data');
        if any(any(isnan(specs)))
            set(child(18),'Visible','off')
            if T==6;
                title='Combination';
                tlow='combination';
            else
                title='Input';
                tlow='input';
            end
            if size(specs,1)==1
                set(child(19),'Visible','on','string',[title ' not possible'])
                set(child(6),'String',[]);set(child(14),'String',[]);
                data=get(child(7),'Data');
                set(child(7),'Data',1);set(child(7),'Data',data)
                return
            else
                concat=[specs(~any((isnan(specs)),2),:);data];
                set(child(19),'Visible','on','string',['Some ' tlow 's were impossible and ignored'])
            end
        else
            concat=[specs;data];
            set(child([18 19]),'Visible','off')
        end
        if size(concat,1)<=15
            set(child(7),'Data',concat)
        else
            set(child(7),'Data',concat(1:15,:))
        end
    else
        set(child(19),'Visible','on','string','Input out of range')
        set(child(18),'Visible','off')
    end
end
data=get(child(7),'Data');
set(child(7),'Data',1);set(child(7),'Data',data)
set(child(6),'String',[]);set(child(14),'String',[]);


function [] = color_call(varargin)
% Callback for color list, changes background and font colors
S = varargin{3};  % Get the structure.
child=flipud(get(S.fh,'Children'));
data=get(child(7),'Data');
colorvec={[1 1 1],[1 1 0],[1 0 1],[0 1 1],[1 0 0],[0 1 0],[0 0 1],[0 0 0]};
errorvec={[1 0 0],[1 0 0],[0 0 0],[0 0 0],[0 0 0],[0 0 0],[1 0 0],[1 0 0]};
fontcol= {[0 0 0],[0 0 0],[0 0 1],[1 0 0],[0 1 0],[0 0 1],[1 0 0],[1 1 1]};
color=colorvec{get(child(16),'Value')};
errorf=errorvec{get(child(16),'Value')};
font=fontcol{get(child(16),'Value')};
set(S.fh,'Color',color);set(child(7),'Data',1);set(child(7),'Data',data)
set(child([18 19]),'Visible','off','ForegroundColor',errorf,'BackgroundColor',color)
set(child([2 3 5 8 11 13 15 17]),'BackgroundColor',color,'ForegroundColor',font)


function decision=testok(input,T,choice,gamma)
if T==1
    switch choice
        case 1
            if all(input>=0)
                decision=true;
            else
                decision=false;
            end
        case {2,3}
            if all(input>1)
                decision=true;
            else
                decision=false;
            end
        case {4,5,6}
            if all(input>=1)
                decision=true;
            else
                decision=false;
            end
    end
elseif T==2
    switch choice
        case {1,2,3,4,5}
            if all(input>=1)
                decision=true;
            else
                decision=false;
            end
        case 6
            [~,~,~,~,~,p,~]=normalshockrel(1,gamma,'M');
            if all(input>p)
                decision=true;
            else
                decision=false;
            end
        case 7
            [~,~,~,~,~,~,p]=normalshockrel(1e100,gamma,'M');
            if all(input<=1) && all(input>=p)
                decision=true;
            else
                decision=false;
            end
    end
elseif T==3
    switch choice
        case 1
            if all(input>=0)
                decision=true;
            else
                decision=false;
            end
        case 2
            if all(input>0)
                decision=true;
            else
                decision=false;
            end
        case {3,4,8,9}
            if all(input<=1) && all(input>=0)
                decision=true;
            else
                decision=false;
            end
        case 5
            [~,~,~,p,~,~]=onedheataddrel(1e100,gamma,'M');
            if all(input>p)
                decision=true;
            else
                decision=false;
            end
        case {6,7}
            if all(input>=1)
                decision=true;
            else
                decision=false;
            end
    end
elseif T==4
    switch choice
        case 1
            if all(input>0)
                decision=true;
            else
                decision=false;
            end
        case {2,3}
            if all(input>=0)
                decision=true;
            else
                decision=false;
            end
        case 4
            [~,~,~,p,~,~]=onedfrictrel(1e100,gamma,'M');
            if all(input>p)
                decision=true;
            else
                decision=false;
            end
        case {5,6}
            if all(input>=1)
                decision=true;
            else
                decision=false;
            end
        case 7
            [~,~,~,~,~,p]=onedfrictrel(1e100,gamma,'M');
            if all(input<p) && all(input>=0)
                decision=true;
            else
                decision=false;
            end
    end
elseif T==5
    switch choice
        case 1
            if all(input>=1)
                decision=true;
            else
                decision=false;
            end
        case 2
            [~,p,~]=prandtlmeyerrel(1e100,gamma,'M');
            if all(input>=0) && all(input<p)
                decision=true;
            else
                decision=false;
            end
        case 3
            if all(input>=0) && all(input<=90)
                decision=true;
            else
                decision=false;
            end
    end
else
    decision=true;
end

