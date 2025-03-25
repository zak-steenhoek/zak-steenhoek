%% Header
% Author: Zakary Steenhoek
% Created: March 2025
% Updated: March 2025

function [argout1] = compressMe(opts)
%COMPRESSME executes compressible flow toolbox
%	[ARGOUT1] = COMPRESSME(OPTS) custom wrapper for executing the
%	compressible flow toolbox UI. 
%
% Options: 
%	Run in UI mode: opts.gui; Def: 1
%
% Input: 
%	
%
% Output: 
%	
%

% Check valid call
arguments
	% Must be <validation>
	% argin1 

	% Must be logical; Def = 1
	opts.gui logical = 1 
end

% Options vars
runUI = opts.gui;

%% <body>

% If UI indicated:
if runUI
    compressible;
else
    eid = 'CompressibleToolbox:Invalid';
    msg = 'Call the compressible function directly.';
    error(eid,msg)
end

end