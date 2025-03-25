%% Header
% Author: Zakary Steenhoek
% Created: 24 March 2025
% Updated: 24 March 2025

function [argout] = function_template(argin1,opts)
%FUNCTION_TEMPLATE <summary>
%	[ARGOUT] = FUNCTION_TEMPLATE(ARGIN1,OPTS) <documentation>
%
% Input: 
%	argin1: <type> - <description>
% 
% Options: 
%	optin1: <type> - <description>. Default = <value>
% 
% Output: 
%	argout: <type or struct> - <description>
%

%% Argument validation
arguments (Input)
	% Required Inputs
	argin1 class {validation}

	% Optional Parameters 
	opts.optin1 class {validation} = 1
end

% Optional output validation
arguments (Output)
	% Outputs
	argout class {validation}
end

% Options assignment
optin1 = opts.optin1;

%% Body

% Function logic
val1 = argin1 + optin1;
val2 = argin1 * optin1;

%% Output

% Struct output
argout = struct();
argout.sum = val1;
argout.prod = val2;

% Single variable output
% argout = val1;

end
