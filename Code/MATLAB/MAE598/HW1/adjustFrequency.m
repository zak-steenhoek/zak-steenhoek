function scaledData = adjustFrequency(unscaledTable, targetHz)
    
    % Convert table to arrays for manipulation
    time = table2array(unscaledTable(:, 1));
    acceleration = table2array(unscaledTable(:, 2:5));
    
    % Calculate the time interval between data points
    dt = mean(diff(time));
    
    % Determine the current frequency (Hz)
    currentHz = round(1 / dt);
    downsampleFactor = round(currentHz / targetHz);
    % Determine if upsampling or downsampling is needed
    if downsampleFactor == 1
        scaledData = unscaledTable;
    else
        if downsampleFactor < 1
            % Upsampling: interpolate new data points
            numPointsTarget = round(length(time) * targetHz / currentHz);
            newTime = linspace(time(1), time(end), numPointsTarget)';
            newAcceleration = interp1(time, acceleration, newTime, 'spline');
        elseif downsampleFactor > 1
            % Downsampling: average and downsize the data points
            newTime = time(1:downsampleFactor:end);
            newSize = size(newTime,1);
            newAcceleration = zeros(newSize,4);
            for i = 1:length(newTime)
                startIndex = (i - 1) * downsampleFactor + 1;
                endIndex = min(startIndex + downsampleFactor - 1, length(time));
                newAcceleration(i,1:4) = mean(acceleration(startIndex:endIndex,1:4));
            end
        end
    
        % Create a new table with adjusted frequency
        scaledData = array2table([newTime, newAcceleration], 'VariableNames', {'time', 'ax', 'ay', 'az', 'atotal'});
    end
end