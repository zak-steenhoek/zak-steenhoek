function [hl, ht] = ylin(y,xlo,xhi,linspec,txt,xtxt) 
% YLIN draws a horizontal line segment with optional text
% 
% Input:
%   y-Position, Y
%   Low x-Value (Start), XLO
%   High x-Value (End), XHI
%   OPT: text string, TXT
%   OPT: Text x position, XTXT
% 
% Output: 
%   Line object, H1
%   Text object, HT
% 

% Plot the line
hold on
hl = plot([xlo xhi], [y y], linspec);

% Determine text
if (exist('txt', 'var') && exist('xtxt', 'var'))
    ht = text(y, xtxt, txt, 'Horiz','left', 'Vert','top');
end
hold off

end