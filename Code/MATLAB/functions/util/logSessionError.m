%% Header
% Author: Zakary Steenhoek
% Created: March 2025
% Updated: March 2025

function logSessionError(ME, source)
%LOGSESSIONERROR Logs error details to the session log.
%
% Options:
%	Where the exception occured: source; Def: 'unknown'
%
% Input:
%   MException object: ME
%
% Output:
%	NONE
%

% Check valid call
arguments
    % Must be MException object
    ME MException

    % Must be string; Def = 'unknown'
    source string {mustBeNonzeroLengthText} = 'unknown'
end

%% Body

% Source log file
logFile  = fullfile(userpath, 'bin', 'session_log.txt');

try
    fid = fopen(logFile, 'a');
    fprintf(fid, '[%s] ERROR in %s:\n', datetime("now"), source);
    fprintf(fid, '  Identifier: %s\n', ME.identifier);
    fprintf(fid, '  Message   : %s\n', ME.message);

    % Log first line of stack trace
    if ~isempty(ME.stack)
        s = ME.stack(1);
        fprintf(fid, '  Location  : %s (line %d)\n', s.file, s.line);
    end

    fprintf(fid, '-----------------------------\n');
    fclose(fid);
catch innerME
    warning(innerME.identifier, 'Failed to write error to log: %s', innerME.message);
end

end

