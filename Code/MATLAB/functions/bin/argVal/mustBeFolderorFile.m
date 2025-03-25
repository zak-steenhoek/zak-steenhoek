%% Header
% Author: Zakary Steenhoek
% Created: March 2025
% Updated: March 2025

function mustBeFolderorFile(Path)
%MUSTBEFOLDERORFILE Validate that input path points to a folder
%	MUSTBEFOLDERORFILE(PATH) throws an error if PATH doesn't point to a folder.
%   MATLAB calls isfolder to determine if PATH points to a folder. If PATH
%   contains a wildcard indicator '*', validation is skipped
%
% Options:
%	NONE
%
% Input:
%	Path to validate, path
%
% Output:
%	NONE
%

%% Body

% Check for wildcard
noChk = contains(Path, '*');
Path = Path(~noChk);

% Check if either folder or file
tf1 = isfolder(Path);
tf2 = isfile(Path);
tf = any([tf1;tf2],1);


if ~all(tf, 'all')
    eid = 'Custom:validator:mustBeFolderorFile';
    msg = 'One or more of the requested folders or files does not exist';
    error(eid,msg)
end


end