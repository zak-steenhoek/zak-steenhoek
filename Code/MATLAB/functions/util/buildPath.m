%% Header
% Author: Zakary Steenhoek
% Created: January 2025
% Updated: March 2025

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

% Argument validation
arguments (Input)
    % Must be string
    leaf string 

    % Must be string
    root string = 'C:\Users\zaste\OneDrive\Software\MATLAB'
end

arguments (Output)
    % Must be a valid folder or file
    fullPath {mustBeFolderorFile}
end

% Options vars
% NONE

%% Body

% Build path
fullPath = fullfile(root,leaf);

end


















