%% Header
% Author: Zakary Steenhoek
% Created: November 2024
% Updated: February 2025

function autosave(figName, localPath, itt, type)
%AUTOSAVE saves open figures to specified directory in high res.
%   AUTOSAVE(FIGNAME, LOCALPATH, ITT, TYPE) will save open figures in high
%   resolution without distortion. It will close all of the figures 
%   sequentially as it saves them. 
%
% Input:
%   Figure name to saveas: FIGNAME
%   Figure directory to saveas: LOCALPATH
%   OPT: Iterative save, if ~ITT, itt == 0
%   OPT: File type, if ~TYPE, type = png
%
% Output:
%   NONE
%

% Detect figures
h = findobj('type','figure');

% Detect optional ITT or default to false
if (~exist('itt', 'var'))
    itt = false;
end

% Detect optional TYPE or default to .png
if (~exist('type', 'var'))
    type = 'png';
end

% Build full path
figDir = buildPath(localPath);

% Save figure(s)
if itt
    for i = 1:length(h)
        fullName = strcat(figName,num2str(i));
        saveas(gcf, fullfile(figDir, fullName{1}), type);
        close(gcf);
    end
else
    saveas(gcf, fullfile(figDir, figName), type);
    close(gcf);
end
