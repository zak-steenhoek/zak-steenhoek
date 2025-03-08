%% Header
% Author: Zakary Steenhoek
% Created: February 2025
% Updated: March 2025

function [pathData] = retrievePathData(uniqueID, beamLength,meshSize,opts)
%RETRIEVEPATHDATA returns clean path data for a single analysis
%   [PATHDATA] = RETRIEVEPATHDATA(BEAMLENGTH,MESHSIZE,OPTS) will parse the
%   raw path data directory for a given analysis configuration. It will
%   create a struct for each path with the path coordinates, dimensional
%   coordinates, and both stresses. This method will disregard the
%   dimensional coordinates that don't change, grab a single instance of
%   the duplicate coordinate data, and combine both stresses data into a
%   single structure for each path.
% 
% Options:
%   Unless otherwise specified: Data structures for either the Y-path and
%   Z path are not returned. If single path indicated, must specify 1 or 2. 
%   If writing new file, both paths are written. To save structs as .mat 
%   files, set saveStructs
%
% Input:
%   For which beam length: beamlength
%   For which mesh size: meshSize
%   OPT: Single path: single; DEF: 0
%   OPT: Write data to new file: writeFile; DEF: 0
%
% Output:
%   Clean path data: pathData
%

% Check valid call
arguments
    % Must be string
    uniqueID string

    % Must be string;
    beamLength string

    % Must be string;
    meshSize string

    % Must be int [-1 2]; Def = -1
    opts.dataOut {mustBeInRange(opts.dataOut,-1,2)} = -1

    % Must be int [-1 2]; Def = 0
    opts.saveStructs logical = 0

    % Must be logical; Def = 0
    opts.writeFile logical = 0
end

% Options vars
dataOutput = opts.dataOut;
saveToMat = opts.saveStructs;
writeToFile = opts.writeFile;

%% Find the files for this analysis

% Load data directory
allRawFiles = dir(buildPath('AEE325\Project-1\data\raw'));

% Empty matching files list
theseRawFiles = zeros(4,1);
rfItr = 1;


% Loop directory files
for i = 1:numel(allRawFiles)

    % Get this name
    fileName = allRawFiles(i).name;
    fileNamePieces = split(fileName, '_');
    thisIden = fileNamePieces{1};

    % If name matches request
    if (strcmp(thisIden, uniqueID))

        % Add file index to the list
        theseRawFiles(rfItr) = i;
        rfItr = rfItr+1;
    end
end

%% Extract and combine

% Empty path data structures
yZV = zeros(102,1); zZV = zeros(52,1);
pathYData = struct('pathCoords', yZV, 'yCoords', yZV, ...
    'normStress', yZV, 'shearStress', yZV);
pathZData = struct('pathCoords', zZV, 'zCoords', zZV, ...
    'normStress', zZV, 'shearStress', zZV);

% Common data flags
needYCoords = 1;
needZCoords = 1;

% Should always have 4 matches
if (nnz(theseRawFiles)==4)
    % For each
    for ii = 1:numel(theseRawFiles)

        % Get details
        fileName = allRawFiles(theseRawFiles(ii)).name;
        fileData = importdata(fileName);

        % Parse name and extract accordingly
        if (contains(fileName, 'PY'))
            % If normal stress
            if (contains(fileName, 'norm'))
                pathYData.normStress = fileData.data(:,5);
            else
                % Else shear stress
                pathYData.shearStress = fileData.data(:,5);
            end

            % If coordinate data needed
            if needYCoords
                pathYData.pathCoords = fileData.data(:,1);
                pathYData.yCoords = fileData.data(:,3);
                needYCoords = 0;
            end

        % Else Z path
        elseif (contains(fileName, 'PZ'))
            % If normal stress
            if (contains(fileName, 'norm'))
                pathZData.normStress = fileData.data(:,5);
            else
                % Else shear stress
                pathZData.shearStress = fileData.data(:,5);
            end

            % If coordinate data needed
            if needZCoords
                pathZData.pathCoords = fileData.data(:,1);
                pathZData.zCoords = fileData.data(:,4);
                needZCoords = 0;
            end
        end
    end
end

%% File output

% If indicated
if writeToFile

    % New files setup
    newNamePY = join([beamLength meshSize 'PY' 'both'], '_');
    newNamePZ = join([beamLength meshSize 'PZ' 'both'], '_');
    cleanPathDir = buildPath('AEE325\Project-1\data\paths\');
    newFilePY = strcat(cleanPathDir, newNamePY, '.txt');
    newFilePZ = strcat(cleanPathDir, newNamePZ, '.txt');

    % Grab struct fields
    fnPY = fieldnames(pathYData);
    fnPZ = fieldnames(pathZData);

    % Open new .txt and write data
    fid = fopen(newFilePY,'w');
    fprintf(fid, '%s\t%s\t%s\t%s\n',fnPY{1},fnPY{2},fnPY{3},fnPY{4});
    for i = 1:length(pathYData.pathCoords)
        fprintf(fid, '%f\t%f\t%f\t%f\n', ...
            pathYData.pathCoords(i), pathYData.yCoords(i), ...
            pathYData.normStress(i), pathYData.shearStress(i));
    end
    fclose(fid); clear fid

    fid = fopen(newFilePZ,'w');
    fprintf(fid, '%s\t%s\t%s\t%s\n',fnPZ{1},fnPZ{2},fnPZ{3},fnPZ{4});
    for i = 1:length(pathZData.pathCoords)
        fprintf(fid, '%f\t%f\t%f\t%f\n', ...
            pathZData.pathCoords(i), pathZData.zCoords(i), ...
            pathZData.normStress(i), pathZData.shearStress(i));
    end
    fclose(fid);
end

%% Configure Output

% Parse return option
if (dataOutput == -1)
    pathData = [];
elseif (dataOutput == 1)
    pathData = pathYData;
elseif (dataOutput == 2)
    pathData = pathZData;
else
    pathData = {pathYData, pathZData};
end

% Parse save option
if saveToMat
    madeDataBin = buildPath('AEE325\Project-1\data\bin\');
    save(strcat(madeDataBin, newNamePY, '.mat'), 'pathYData');
    save(strcat(madeDataBin, newNamePZ, '.mat'), 'pathZData');
end

end