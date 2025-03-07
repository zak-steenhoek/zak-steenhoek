%% Header
% Author: Zakary Steenhoek
% Created: January 2025
% Updated: February 2025

function [fullPath] = buildPath(leaf, root)
%BUILDPATH builds the full path to a file or directory
%   [FULLPATH] = BUILDPATH(LEAF, ROOT) returns a full root path string from
%   ROOT and LEAF. ROOT defaults to the MATLAB software folder. Stop 
%   submitting your root admin path in homwork assignments!!!
%
% Input:
%   The leaf to build to, LEAF
%   OPT: To build outside the MATLAB folder, provide ROOT
%
% Output:
%   The full path string, FULLPATH
%

% Root path to MATLAB folder lives here
rootPath = 'C:\Users\zaste\OneDrive\Software\MATLAB\';

% Determine HERE, ROOT
if (~exist('root', 'var'))
    root = rootPath;
end

% Build path
fullPath = strcat(root,leaf);

end