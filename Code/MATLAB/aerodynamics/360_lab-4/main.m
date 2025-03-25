%% Header
% Author: Zakary Steenhoek
% Date: 18 November 2024
% AEE361::LAB04

clc; clear; %close all;

%% Process Data

% Read all data
readData();

% To store data
allProcessedData = struct('testName', [], 'data', []);

% Loop on every test file
for itr1 = 1:numel(allTestData)
    % Grab filename and data
    thisTestName = lower(allTestData(itr1).filename);
    thisTestData = allTestData(itr1).data;

    % Extract file specifics
    fileSpecifics = split(thisTestName, '_');
    thisWinglet = fileSpecifics{1}; thisRe = fileSpecifics{2};

    % Get conditions for this winglet
    for whichCond = 1:length(conditions)
        if contains(thisTestName, conditions(whichCond, 1))
            theseConditions = conditions(whichCond, :);
            break
        end
    end

    % Get grav data for this winglet
    for itr = 1:length(allGravData)
        if contains(allGravData(itr).filename, thisWinglet)
            thisGravData = allGravData(itr).data;
            break
        end
    end

    % Determine which reynolds number for this winglet
    if contains(thisTestName, "150k")
        re = theseConditions{4}
    else
        re = theseConditions{5}
    end

    % Grab pressure and temp from subcell array
    pres = theseConditions{3}*1000
    temp = theseConditions{2}+273.15

    % Call to process this test file and store data
    [theseResults,rho,thisUncertainRho] = processfile(thisGravData, ...
                    thisTestData, pres, temp, re);
    allProcessedData(itr1).testName = thisTestName;
    allProcessedData(itr1).data = theseResults;

    if (theseConditions{6} == 0)
        conditions{whichCond,6} = rho
        conditions{whichCond,7} = thisUncertainRho
        
    end
end


%% Sort Data

% To organize data
location_150 = struct('winglet', locationFam, 'data', []);
location_300 = struct('winglet', locationFam, 'data', []);
length_150 = struct('winglet', lengthFam, 'data', []);
length_300 = struct('winglet', lengthFam, 'data', []);
angle_150 = struct('winglet', angleFam, 'data', []);
angle_300 = struct('winglet', angleFam, 'data', []);
none_150 = struct('winglet', 'none', 'data', []);
none_300 = struct('winglet', 'none', 'data', []);

% Loop on every processed test
for itr2 = 1:numel(allProcessedData)
    % Break out this iteration data
    thisName = allProcessedData(itr2).testName;
    thisData = allProcessedData(itr2).data;
    sub = split(thisName, '_');

    % If this is a 150k test
    if contains(thisName, "150k")
        % If this belongs to the location family
        if contains(thisName, locationFam)
            % Determine which one
            iw = find(contains(locationFam, sub{1}),1);
            location_150(iw).data = thisData;
            % Else if this belongs to the length family
        elseif contains(thisName, lengthFam)
            iw = find(contains(lengthFam, sub{1}),1);
            length_150(iw).data = thisData;
            % Else if this belongs to the angle family
        elseif contains(thisName, angleFam)
            iw = find(contains(angleFam, sub{1}),1);
            angle_150(iw).data = thisData;
            % Else this is none
        else
            none_150.data = thisData;
        end
        % Else this is a 300k test
    else
        % If this belongs to the location family
        if contains(thisName, locationFam)
            % Determine which one
            iw = find(contains(locationFam, sub{1}),1);
            location_300(iw).data = thisData;
            % Else if this belongs to the length family
        elseif contains(thisName, lengthFam)
            iw = find(contains(lengthFam, sub{1}),1);
            length_300(iw).data = thisData;
            % Else if this belongs to the angle family
        elseif contains(thisName, angleFam)
            iw = find(contains(angleFam, sub{1}),1);
            angle_300(iw).data = thisData;
            % Else this is none
        else
            none_300.data = thisData;
        end
    end
end

%% Plot Data

plotfamily(location_150,none_150,[1,2]);
plotfamily(length_150,none_150,[3,4]);
plotfamily(angle_150,none_150,[5,6]);

plotfamily(location_300,none_300,[7,8]);
plotfamily(length_300,none_300,[9,10]);
plotfamily(angle_300,none_300,[11,12]);

%% Export Data

% % Open a file to write
% fileID = fopen('processed_data.csv', 'w');
% 
% % Write data for each struct entry
% for i = 1:numel(allProcessedData)
%     % Write the test name
%     fprintf(fileID, '%s\n', allProcessedData(i).testName{1});
% 
%     % Write the data array
%     fprintf(fileID, '%.6f,%.6f,%.6f,%.6f,%.6f\n', allProcessedData(i).data');
%     fprintf(fileID, '\n');
% end
% 
% % Close the file
% fclose(fileID);

