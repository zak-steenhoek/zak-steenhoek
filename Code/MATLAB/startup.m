%% Header
% Author: Zakary Steenhoek
% Created: March 2025
% Updated: March 2025
% Title: startup
% Purpose: Executes on startup and configures the MATLAB environment

%% ========== Body ==========

% --- Display Startup Info ---
clc; disp('⏳ Setting up MATLAB environment...');

%% --- Define and Configure Paths ---

try
    % Util paths
    userRoot = getenv('USERPROFILE');
    userPath = fullfile(userRoot, 'OneDrive', 'Software', 'MATLAB');
    userBin = fullfile(userPath, 'bin');
    archiveDir = fullfile(userBin, 'session_archive');

    % Util files
    logFile       = fullfile(userBin, 'session_log.txt');
    autosaveFile  = fullfile(userBin, 'autosave.mat');
    sessionFiles  = fullfile(userBin, 'session_files.txt');
    sessionPaths  = fullfile(userBin, 'session_paths.mat');
    logArchive    = fullfile(archiveDir, 'session_log_archive.txt');

    % Pave session
    userpath(userPath);
    addpath(genpath(userPath));
    rmpath(genpath(fullfile(userPath, '.archive')));

catch ME
    warning(ME.identifier, '⚠ Failed to configure paths or files: %s', ME.message);
    logSessionError(ME, 'startup');
end

% Attempt previous archive
try
    if isfolder(archiveDir)
        files = dir(fullfile(archiveDir, '*'));
        nowTime = datetime('now');

        for i = 1:numel(files)
            if ~files(i).isdir
                fileAge = nowTime - datetime(files(i).datenum, 'ConvertFrom', 'datenum');
                if days(fileAge) > 5
                    delete(fullfile(archiveDir, files(i).name));
                end
            end
        end

        disp('✔ Old archived session files cleaned.');

    else
        mkdir(archiveDir); % Just in case
    end

    timestamp = datestr(now, 'yyyy-mm-dd_HH-MM-SS');

    % Archive autosave.mat
    if isfile(autosaveFile)
        [~, name, ext] = fileparts(autosaveFile);
        copyfile(autosaveFile, fullfile(archiveDir, [name '_' timestamp ext]));
    end

    % Archive session_files.txt
    if isfile(sessionFiles)
        [~, name, ext] = fileparts(sessionFiles);
        copyfile(sessionFiles, fullfile(archiveDir, [name '_' timestamp ext]));
    end
    % Archive session_log.txt
    if isfile(logFile)
        % Read current session log
        fidIn = fopen(logFile, 'r');
        logContent = fread(fidIn, '*char')';
        fclose(fidIn);

        % Append to archive
        fidOut = fopen(logArchive, 'a');
        fprintf(fidOut, '\n--- Archived from %s ---\n', datestr(now));
        fwrite(fidOut, logContent);
        fprintf(fidOut, '\n'); % Extra newline separator
        fclose(fidOut);

    end

    disp(['✔ Previous session files backed up to: ' archiveDir]);

    % Create new session log
    fid = fopen(logFile, 'w');
    fprintf(fid, '📅 MATLAB session started: %s\n', datetime("now"));
    fprintf(fid, '-----------------------------\n');
    fclose(fid);
catch ME
    warning(ME.identifier, '⚠ Failed to archive previous session files: %s', ME.message);
    logSessionError(ME, 'startup');
end

% Store session paths for external use
try
    paths = struct( ...
        'userRoot', userRoot, ...
        'userPath', userPath, ...
        'userBin', userBin, ...
        'autosaveFile', autosaveFile, ...
        'sessionFiles', sessionFiles, ...
        'logFile', logFile, ...
        'archiveDir', fullfile(userBin, 'session_archive') ...
        );
    save(sessionPaths, '-struct', 'paths');
    disp('✔ Session paths saved to session_paths.mat');
catch ME
    warning(ME.identifier, '⚠ Failed to save session paths: %s', ME.message);
    logSessionError(ME, 'startup');
end

%% --- Set Environment Variables ---

try
    setenv('HOME', userPath);
    disp(['✔ Env var HOME set to: ' getenv('HOME')]);
    setenv('BIN', userBin);
    disp(['✔ Env var BIN set to: ' getenv('BIN')]);
catch ME
    warning(ME.identifier, '⚠ Failed to set environment variables: %s', ME.message);
    logSessionError(ME, 'startup');
end

%% --- Configure Display Defaults ---

try
    format compact;
    format shortEng;
    set(0, 'DefaultFigureColor', [1 1 1]);
    set(0, 'DefaultAxesFontSize', 12);
    set(0, 'DefaultLineLineWidth', 1.3);
    disp('✔ Display settings configured.');
catch ME
    warning(ME.identifier, '⚠ Failed to set display preferences: %s', ME.message);
    logSessionError(ME, 'startup');
end

%% --- Check Required Toolboxes ---

try
    req = {'Aerospace Toolbox', 'Control System Toolbox', ...
        'Curve Fitting Toolbox', 'Optimization Toolbox', ...
        'Simulink', 'Symbolic Math Toolbox'};
    v = ver;
    installed = {v.Name};
    missing = setdiff(req, installed);

    if isempty(missing)
        disp('✔ All required toolboxes available.');
    else
        warning('⚠ Missing toolboxes: %s', strjoin(missing, ', '));
    end
catch ME
    warning(ME.identifier, '⚠ Toolbox check failed: %s', ME.message);
    logSessionError(ME, 'startup');
end

%% --- Prompt to Restore Previous Session ---

try
    if and(isfile(autosaveFile), isfile(sessionFiles))
        % Get or set restore input
        answer = input('🕘 Restore previous session? Y/N [N]: ', 's');
        if isempty(answer)
            answer = 'N';
        end
        if ~(or(strcmpi(answer, 'Y'), strcmpi(answer, 'N')))
            answer = 'N';
        end

        % If restore indicated
        if strcmpi(answer, 'Y')
            % Restore workspace variables
            if isfile(autosaveFile)
                load(autosaveFile);
                disp('✔ Workspace variables restored from autosave.mat.');
            end

            % Restore editor files
            if isfile(sessionFiles)
                fid = fopen(sessionFiles, 'r');
                filesToOpen = textscan(fid, '%s', 'Delimiter', '\n');
                fclose(fid);

                filesToOpen = filesToOpen{1};
                for i = 1:numel(filesToOpen)
                    if isfile(filesToOpen{i})
                        matlab.desktop.editor.openDocument(filesToOpen{i});
                    else
                        warning('⚠ File not found: %s (skipped)', filesToOpen{i});
                    end
                end
                disp('✔ Previous editor session restored.');
                delete(autosaveFile); delete(sessionFiles);
            end
        else
            disp('⏩ Session restore skipped.');
            delete(autosaveFile); delete(sessionFiles);
        end
    end
catch ME
    warning(ME.identifier, '⚠ Session restore failed: %s', ME.message);
    logSessionError(ME, 'startup');
end

%% --- Ready Message ---
clear autosaveFile logFile userRoot userBin sessionFiles ans fid ...
    filesToOpen answer missing req toolboxes v i archiveDir ext installed ...
    name paths sessionPaths timestamp userPath fileAge files nowTime ...
    fidIn fidOut logArchive logContent
disp('✔ Environment setup complete.');
pause(3); clc;

%% ========== End ==========
