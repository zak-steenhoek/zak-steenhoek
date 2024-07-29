function smoothedTable = smoothTable(noisyTable,winSize)
    %Convert table to array for easier data manipulation
    noisyData = table2array(noisyTable);
    %Use movmean() sliding window average to remove noise
    smoothedData = movmean(noisyData, winSize);
    %Convert data back to table
    smoothedTable = array2table(smoothedData, 'VariableNames', noisyTable.Properties.VariableNames);
end