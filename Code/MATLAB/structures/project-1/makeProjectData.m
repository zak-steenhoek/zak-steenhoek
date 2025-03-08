%% Header
% Author: Zakary Steenhoek
% Created: March 2025
% Updated: March 2025

function makeProjectData()
%MAKEPROJECTDATA saves all project data
%   MAKEPROJECTDATA() stores all required data for the project to a .mat 
%   file that can be loaded in the main script. Results struct indexing
%   follows the order seen in the project instructions, starting with
%   the 1m length and 50mm mesh. With the 1m length, decreasing mesh
%   to 6.25mm. Then with 6.25mm mesh, decreasing length to 0.125m.
%
% Options:
%   Unless otherwise specified: Will not re-create clean path data files
%
% Input:
%   OPT: Regenerate cleaned path data files: regenPathFiles; DEF: 0
%
% Output:
%   FILE: .mat with all project data
%

% Check valid call
arguments
    % None
end

% Options vars

%% Data Structures

% Results 
numConfigs = 10; 
results(numConfigs) = struct('beamLength', [], 'meshSize', [], ...
    'maxDefB', [], 'minDefB', [], ...
    'maxDefXS', [], 'minDefXS', [], ...
    'maxNormB', [], 'minNormB', [], ...
    'maxNormXS', [], 'minNormXS', [], ...
    'maxShearB', [], 'minShearB', [], ...
    'maxShearXS', [], 'minShearXS', [], ...
    'pathYData', [], 'pathZData', []);

% Path data
pathYData = cell(1,10);
pathZData = cell(1,10);

%% Constants

% Lists
units = [{'Deformation'},{'mm'};{'Stress'},{'GPa'}];
meshSizes = [{'50mm'} {'35mm'} {'25mm'} {'12.5mm'} {'6.25mm'}];
beamLengths = [{'1m'} {'0.75m'} {'0.5m'} {'0.375m'} {'0.25m'} {'0.125m'}];

% Analysis parameters
meshConfigs = [{'50mm'} {'35mm'} {'25mm'} {'12.5mm'} {'6.25mm'} ...
               {'6.25mm'} {'6.25mm'} {'6.25mm'} {'6.25mm'} {'6.25mm'}];
lengthConfigs = [{'1m'} {'1m'} {'1m'} {'1m'} {'1m'} ...
                 {'0.75m'} {'0.5m'} {'0.375m'} {'0.25m'} {'0.125m'}];

% ANSYS results
minDefB = [0 0 0 0 0 0 0 0 0 0]; 

maxDefB = [1.6369 1.6429 1.6461 1.6541 1.6612 ...
           0.74393 0.26679 0.14827 8.4601E-2 5.5838E-2]; 

minNormB = [-0.15035 -0.15043 -0.15033 -0.15042 -0.15043 ...
            -0.11307 -0.12876 -0.11773 -0.12391 -0.1572]; 

maxNormB = [0.15028 0.15042 0.15034 0.22186 0.42188 ...
            0.32097 0.49642 0.33468 0.34612 0.34934]; 

minShearB = [-2.4316E-2 -5.1511E-2 -5.2995E-2 -0.11635 -0.2559 ...
             -0.24676 -0.26383 -0.24968 -0.27437 -0.35429]; 

maxShearB = [2.6147E-2 4.9573E-2 6.7358E-2 0.11851 0.20223 ...
             0.19242 0.1991 0.24537 0.24689 0.19716]; 

minDefXS = [1.1559 1.1612 1.1629 1.1713 1.1788 ...
            0.52918 0.19405 0.11141 6.8219E-2 4.7875E-2]; 

maxDefXS = [1.232 1.2384 1.2408 1.2503 1.2579 ...
            0.58736 0.22984 0.13589 8.1282E-2 5.5367E-2]; 

minNormXS = [-0.11281 -0.11303 -0.1129 -0.11291 -0.11293 ...
             -8.4987E-2 -5.7124E-2 -4.2457E-2 -2.5183E-2 -9.0405E-3]; 

maxNormXS = [0.11314 0.11303 0.11289 0.11921 0.11293 ...
             8.4923E-2 5.7072E-2 4.4179E-2 3.5949E-2 5.0854E-2]; 

minShearXS = [-8.8115E-3 -7.611E-3 -8.0336E-3 -7.8863E-3 -7.7995E-3 ...
              -7.8762E-3 -7.8057E-3 -8.1728E-3 -9.4167E-3 -1.1955E-2]; 

maxShearXS = [-1.0305E-3 -1.5477E-4 -7.5076E-5 -1.141E-5 3.4993E-6 ...
              -2.4277E-6 1.9475E-6 8.2522E-6 3.7703E-4 7.2686E-3]; 

%% Clean Path Data

% Loop on mesh size for 1m length
for i = 1:numel(meshSizes)
    % Make and write clean data for this mesh size
    pathData = retrievePathData(meshSizes{i}, '1m', meshSizes{i}, ...
        'writeFile',1, 'saveStructs',1, 'dataOut',0);
    pathYData{i} = pathData{1};
    pathZData{i} = pathData{2};
end

% Loop on beam length for 6.25mm mesh
for i = 2:numel(beamLengths)
    % Make and write clean data for this beam length
    pathData = retrievePathData(beamLengths{i}, beamLengths{i},'6.25mm', ...
        'writeFile',1, 'saveStructs',1, 'dataOut',0);
    pathYData{i+4} = pathData{1};
    pathZData{i+4} = pathData{2};
end

%% Populate results 

for i = 1:numConfigs
    results(i).beamLength = lengthConfigs(i);
    results(i).meshSize = meshConfigs(i);
    
    results(i).maxDefB = maxDefB(i);
    results(i).minDefB = minDefB(i);
    results(i).maxDefXS = maxDefXS(i);
    results(i).minDefXS = minDefXS(i);
    
    results(i).maxNormB = maxNormB(i);
    results(i).minNormB = minNormB(i);
    results(i).maxNormXS = maxNormXS(i);
    results(i).minNormXS = minNormXS(i);
    
    results(i).maxShearB = maxShearB(i);
    results(i).minShearB = minShearB(i);
    results(i).maxShearXS = maxShearXS(i);
    results(i).minShearXS = minShearXS(i);

    results(i).pathYData = pathYData{i};
    results(i).pathZData = pathZData{i};
end

%% Store 

% Save results struct and constants
madeDataBin = buildPath('AEE325\Project-1\data\bin\');
save(strcat(madeDataBin, 'beamAnalysisResults.mat'), 'results');
save(strcat(madeDataBin, 'projectConstants.mat'), ...
    'meshSizes','beamLengths','units');

end