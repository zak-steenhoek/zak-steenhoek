%% Header
% Author: Zakary Steenhoek
% Created: March 2025
% Updated: March 2025
% Title: finish
% Purpose: Executes on exit and cleans up the MATLAB environment

%% ========== Body ========== 

% --- Display Exit Info ---
clc; disp('⏳ Performing MATLAB shutdown tasks...');
cd C:\Users\zaste\OneDrive\Software\MATLAB

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

    % Pave session
    userpath(userPath);
    addpath(genpath(userPath));
    rmpath(genpath(fullfile(userPath, '.archive')));

catch ME
    warning(ME.identifier, '⚠ Failed to configure paths or files: %s', ME.message);
    logSessionError(ME, 'finish');
end

%% --- Save Workspace (Autosave) ---

try
    % Save entire workspace
    savex(autosaveFile, 'autosaveFile', 'logFile', 'userRoot', ...
        'userbin', 'sessionFiles');
    disp(['✔ Workspace saved to: ' autosaveFile]);

catch ME
    warning(ME.identifier, '⚠ Failed to save workspace: %s', ME.message);
    logSessionError(ME, 'finish');
end

%% --- Save and Log Open Editor Files ---
try
    docs = matlab.desktop.editor.getAll;
    openFileList = {};

    for i = 1:numel(docs)
        doc = docs(i);
        if doc.Modified
            doc.save; 
        end
        if ~isempty(doc.Filename)
            openFileList{end+1} = doc.Filename; 
        end
        doc.close;
    end

    fid = fopen(sessionFiles, 'w');
    fprintf(fid, '%s\n', openFileList{:});
    fclose(fid);
    disp(['✔ Editor session saved to: ' sessionFiles]);

catch ME
    warning(ME.identifier, '⚠ Could not save/close editor files: %s', ME.message);
    logSessionError(ME, 'finish');
end

%% --- Close All Figures and Clean Up ---

try
    close all force;
    disp('✔ Figures closed.');
catch ME
    warning(ME.identifier, '⚠ Failed to close figures: %s', ME.message);
    logSessionError(ME, 'finish');
end

%% --- Log Session End Time ---

try
    fid = fopen(logFile, 'a');
    fprintf(fid, '📅 MATLAB session ended:   %s\n', datetime("now"));
    fprintf(fid, '=============================\n\n');
    fclose(fid);
catch ME
    warning(ME.identifier, '⚠ Failed to log session end: %s', ME.message);
    logSessionError(ME, 'finish');
end

%% --- Exit Message ---
disp('✔ Cleanup complete. Goodbye!');
clearvars; pause(2);

%% ========== End ==========
