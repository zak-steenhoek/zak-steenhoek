function [vl, vt] = xlin(x,ylo,yhi,linspec,txt,ytxt) 
% XLIN draws a vertical line segment with optional text
% 
% Input:
%   x-Position, X
%   Low y-Value (Start), YLO
%   High y-Value (End), YHI
%   OPT: text string, TXT
%   OPT: Text Y position, YTXT
% 
% Output: 
%   Line object, V1
%   Text object, VT
% 

% Plot the line
hold on
vl = plot([x x],[ylo yhi], linspec);

% Determine text
if (exist('txt', 'var') && exist('ytxt', 'var'))
    vt = text(x,ytxt, txt, 'Horiz','left', 'Vert','top', 'Rotation',90);
end
hold off

end