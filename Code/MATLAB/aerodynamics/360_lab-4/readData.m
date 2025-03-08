%% Header
% Author: Zakary Steenhoek
% Date: 18 November 2024
% Title: readData
% Description: This
% AEE361::LAB04

%% References

% Explicit paths to data
dataPath = "C:\Users\zaste\OneDrive\Software\MATLAB\AEE360\Lab-4\data\best\";
binPath = "C:\Users\zaste\OneDrive\Software\MATLAB\AEE360\Lab-4\data\bin\";
unneededVars = {'Type','Units','Time','Humidity','Temperature','BarometricPressure'};

locationFam = {'front','mid','back'};
lengthFam = {'small','med','long'};
angleFam = {'20deg','40deg','60deg'};
save(strcat(binPath, "families.mat"), "angleFam", "lengthFam", "locationFam");

conditionsFile = strcat(dataPath, "Lab4_G6_Conditions.txt");
gravFiles = dir(strcat(dataPath, "grav\*.csv"));
testFiles = dir(strcat(dataPath, "test\*.csv"));

% conditionsFile = strcat(dataPath1, "Lab4_G7_Conditions.txt");
% files = dir(strcat(dataPath1, "*.csv"));

%% Read and refine Data 

% Organize data into structs. Field one for name, field 2 for data
allGravData = struct();
allTestData = struct();

% Read conditions file as table and convert to cell array
conditions = table2cell(readtable(conditionsFile));
conditions(:,1) = lower(conditions(:,1));
conditions(:,6:7) = {0};
save(strcat(binPath, "conditions.mat"), "conditions");

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
save(strcat(binPath, "gravData.mat"), "allGravData");

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
save(strcat(binPath, "testData.mat"), "allTestData");

% % Loop on files
% gravi = 1;
% testi = 1;
% for i = 1:numel(files)
%     % Check only grav files
%     if contains(files(i).name, 'grav', 'IgnoreCase',true)
% 
%         % Split file name and homogonize for clarity
%         [~,name,~] = fileparts(files(i).name);
%         nameParts = lower(split(name, '_'));
%         allGravData(gravi).filename = join(nameParts(end-1:end), '_');
% 
%         % Read data into a table and remove unneeded columns
%         fileData = readtable(files(i).name);
%         fileData = removevars(fileData,unneededVars);
% 
%         % Convert to cell array and concat with column headings
%         allGravData(gravi).data = table2array(fileData);
%         gravi = gravi+1;
%     end
% end
% for i = 1:numel(files)
%     % Check only test files
%     if ~contains(files(i).name, 'grav', 'IgnoreCase',true)
% 
%         % Split file name and homogonize for clarity
%         [~,name,~] = fileparts(files(i).name);
%         nameParts = lower(split(name, '_'));
%         allTestData(testi).filename = join(nameParts(end-1:end), '_');
% 
%         % Read data into a table and remove unneeded columns 
%         fileData = readtable(files(i).name);
%         fileData = removevars(fileData,unneededVars);
% 
%         % Convert to cell array and concat with column headings
%         allTestData(testi).data = table2array(fileData);
%         testi = testi + 1;
%     end
% end

% To save my poor laptop memory
clear gravFiles testFiles fileData nameParts name i
% clear files fileData nameParts name i
