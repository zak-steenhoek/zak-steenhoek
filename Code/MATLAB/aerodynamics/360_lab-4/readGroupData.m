%% Header
% Author: Zakary Steenhoek
% Date: 18 November 2024
% Title: readData
% Description: This
% AEE361::LAB04

%% References

unneededVars = {'Type','Units','Time','Humidity',...
                'Temperature','BarometricPressure'};
locationFam = {'front','mid','back'};
lengthFam = {'small','med','long'};
angleFam = {'20deg','40deg','60deg'};

% Paths to data
dataPath = "C:\Users\zaste\OneDrive\Documents\Software\MATLAB\AEE360\Lab-4\data\G1\";
conditionsFile = strcat(dataPath, "Lab4_G1_Conditions.txt");
gravFiles = dir(strcat(dataPath, "grav\*.csv"));
testFiles = dir(strcat(dataPath, "test\*.csv"));


%% Read and refine Data 

% Organize data into structs. Field one for name, field 2 for data
allGravData = struct();
allTestData = struct();

% Read conditions file as table and convert to cell array
conditions = table2cell(readtable(conditionsFile));
conditions(:,1) = lower(conditions(:,1));

% Loop on grav files
for i = 1:numel(gravFiles)
    % Check only grav files
    if contains(gravFiles(i).name, 'grav', 'IgnoreCase',true)

        % Split file name and homogonize for clarity
        [~,name,~] = fileparts(gravFiles(i).name);
        nameParts = lower(split(name, '_'));
        if contains(nameParts(end-1), {'20','40','60'})
            if ~contains(nameParts(end-1), 'deg')
                nameParts(end-1) = strcat(nameParts(end-1),'deg');
            end
        end
        allGravData(i).filename = join(nameParts(end-1:end), '_');

        % Read data into a table and remove unneeded columns
        fileData = readtable(gravFiles(i).name);
        fileData = removevars(fileData,unneededVars);

        % Convert to cell array and concat with column headings
        allGravData(i).data = table2array(fileData);
    end
end

% Loop on test files
for i = 1:numel(testFiles)
    % Check only test files
    if ~contains(testFiles(i).name, 'grav', 'IgnoreCase',true)

        % Split file name and homogonize for clarity
        [~,name,~] = fileparts(testFiles(i).name);
        nameParts = lower(split(name, '_'));
        if contains(nameParts(end-1), {'20','40','60'})
            if ~contains(nameParts(end-1), 'deg')
                nameParts(end-1) = strcat(nameParts(end-1),'deg');
            end
        end
        allTestData(i).filename = join(nameParts(end-1:end), '_');

        % Read data into a table and remove unneeded columns 
        fileData = readtable(testFiles(i).name);
        fileData = removevars(fileData,unneededVars);

        % Convert to cell array and concat with column headings
        allTestData(i).data = table2array(fileData);
    end
end

% To save my poor laptop memory
% clear gravFiles testFiles fileData nameParts name i
