%% Header
% Author: Zakary Steenhoek
% Created: 24 March 2025
% Updated: 24 March 2025

function restoreLastSession()
%RESTORELASTSESSION Restores most recent autosave and editor session files.
%	RESTORELASTSESSION() loads the latest autosave workspace and reopens
%   editor files based on session_files.txt from the session_archive folder.
%

%% Body

try
    userRoot = getenv('USERPROFILE');  % or getenv('HOME') for Unix/macOS
    userPath = fullfile(userRoot, 'OneDrive', 'Software', 'MATLAB');
    userBin = fullfile(userPath, 'bin');
    archiveDir = fullfile(userBin, 'session_archive');

    if ~isfolder(archiveDir)
        error('Session archive directory does not exist.');
    end

    % Get list of archived autosave files
    matFiles = dir(fullfile(archiveDir, 'autosave_*.mat'));
    txtFiles = dir(fullfile(archiveDir, 'session_files_*.txt'));

    if isempty(matFiles) && isempty(txtFiles)
        disp('⚠ No archived session files found.');
        return;
    end

    % Sort by date to get the most recent
    if ~isempty(matFiles)
        [~, idx] = max([matFiles.datenum]);
        latestMat = fullfile(archiveDir, matFiles(idx).name);
        load(latestMat);
        fprintf('✔ Workspace restored from: %s\n', matFiles(idx).name);
    end

    if ~isempty(txtFiles)
        [~, idx] = max([txtFiles.datenum]);
        latestTxt = fullfile(archiveDir, txtFiles(idx).name);
        fid = fopen(latestTxt, 'r');
        files = textscan(fid, '%s', 'Delimiter', '\n');
        fclose(fid);

        for i = 1:numel(files{1})
            file = files{1}{i};
            if isfile(file)
                matlab.desktop.editor.openDocument(file);
            else
                warning('⚠ File not found: %s (skipped)', file);
            end
        end
        fprintf('✔ Editor session restored from: %s\n', txtFiles(idx).name);
    end

catch ME
    warning(ME.identifier, '⚠ Failed to restore last session: %s', ME.message);
    logSessionError(ME, 'restoreLastSession');
end

end
