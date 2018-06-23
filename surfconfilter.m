%%surfconfilter
    %Function to filter a soundings data structure based on the surface
    %temperature and relative humidity. Useful to narrow down soundings to
    %those with precipitation at the surface, or those near freezing.
    %
    %General form: [gooddays,goodfinal] = surfconfilter(soundsh,surfcon)
    %
    %Outputs:
    %gooddays: a logical matrix, where 1 designates those soundings which will
    %   be included in the filtered structure and 0 designates those which will be
    %   excluded
    %goodfinal: a structure containing soundings data, filtered to exclude
    %   those outside of the conditions specified by surfcon
    %
    %Inputs:
    %soundsh: an IGRA v1 soundings data structure
    %surfcon: a structure containing fields (named "temp" and/or
    %   "relative_humidity" with a single value which will be used to filter the
    %   data in soundsh. For example, if wanting to exclude all temperature above
    %   4 deg C and all humidity below 80%, surfcon should be created using
    %   commands surfcon.temp = 4;surfcon.relative_humidity=80
    %
    %To filter by time, see timefilter. To filter by level type, see
    %levfilters. To filter by precipitation, see precipfilterASOS.
    %
    %Version date: 6/14/2018
    %Last major revision: 5/31/17
    %Based on a section of a script originally written by Megan Amanatides at NC State
    %Written by: Daniel Hueholt
    %North Carolina State University
    %Undergraduate Research Assistant at Environment Analytics
    %
    %See also fullIGRAimp, levfilter, timefilter, precipfilterASOS
    %

function [gooddays,goodfinal] = surfconfilter(soundsh,surfcon)

% For notices in case of missing surfcon settings
check = ones(1,2);

% Preallocate arrays for later in the function
cold = zeros(length(soundsh),1); %Will specify values cold enough
moist = zeros(length(soundsh),1); %Will specify values moist enough

% Check values in the structure against surface condition filter settings
% Nested structures mean it's time to get loopy
for d = 1:length(soundsh) %Loop through sounding data
    if ~isempty(soundsh(d).level_type) %If soundsh(d) has data (level type should never be empty, even if it's NaN in certain edge cases)
        if ismember('temp',fieldnames(surfcon))==1 %Check if temperature filtration was requested
            if soundsh(d).temp(1) <= surfcon.temp %First temperature value is taken as surface temperature
                cold(d) = 1; %Add entry in logical for final filtration
            end
        elseif ismember('temperature',fieldnames(surfcon))==1 %Include functionality for the most obvious mistake in the world
            if soundsh(d).temp(1) <= surfcon.temperature %First temperature value is taken as surface temperature
                cold(d) = 1; %Add entry in logical for final filtration
            end
        else
            if check(1,1) == 1 %This message should only appear once, not length(soundsh) number of times
                disp('No temperature filtration was applied')
                check(1,1) = 0;
            end
           cold(d) = 1; %Add entry in logical for final filtration
        end
        if ismember('relative_humidity',fieldnames(surfcon))==1
            if soundsh(d).rhum(1) >= surfcon.relative_humidity %First relative humidity value is surface relative humidity
                moist(d) = 1; %Add entry in logical for final filtration
            end
        else
            if check(1,2) == 1 %This message should only display once
                disp('No relative humidity filter was applied.')
                check(1,2) = 0;
            end
            moist(d) = 1; %Add entry in logical for final filtration
        end
    end
end

% Creation of new structure containing only the filtered data
gooddays = and(logical(cold), logical(moist)); %Merge the logicals of cold and moist-filtered data
goodfinal = soundsh(gooddays); %This is the output structure

end