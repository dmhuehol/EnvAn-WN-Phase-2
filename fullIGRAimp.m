function [sndng,filtered,soundsh,soundsWithDewRH,soundsWithHeight,goodfinal,warmnosesfinal,nowarmnosesfinal] = fullIGRAimp(input_file)
%%fullIGRAimp
    %Function which, given a file of raw IGRA v1 soundings data, will read
    %the data into MATLAB, filter it according to year, filter it according
    %to level type, add dewpoint and temperature, filter by surface
    %temperature, and detect and analyze warmnoses. 
    %At each step of the way, a new soundings structure is created and can
    %be output, making this ideal for further investigation using functions 
    %like soundplots.
    %
    %General form:
    %[sndng,filtered,soundsh,soundsWithDewRH,soundsWithHeight,goodfinal,warmnosesfinal,nowarmnosesfinal] = fullIGRAimp(input_file)
    %
    %Outputs:
    %sndng: raw soundings data read into MATLAB and separated into different
    %   readings, unfiltered.
    %filtered: soundings data filtered by year
    %soundsh: soundings data filtered by level type (usually to remove extra wind levels)
    %soundsWithDewRH: soundings data with dewpoint and relative humidity data added
    %soundsWithHeight: soundings data with height
    %goodfinal: soundings data filtered by surface temperature
    %warmnosesfinal: soundings structure containing data only from
    %   soundings with warmnoses
    %nowarmnosesfinal: soundings structure containing data only from
    %   soundings without warmnoses
    %
    %Input:
    %input_file: file path of a *.dat IGRA v1 data file
    %
    %Eventually it is planned to have the various filters controlled at the
    %inputs, but for now it is necessary to change such settings within the
    %function.
    %
    %KNOWN ISSUES: more accurate progress bar is needed, runtime is
    %relatively slow.
    %Planned: filter by precipitation, prompt user for inputs like in
    %Spencer's MASC software
    %
    %Written by Daniel Hueholt
    %North Carolina State University
    %Undergraduate Research Assistant at Environment Analytics
    %Version date: 4/21/2018
    %Last major revision: 4/21/2018
    %
    %See also IGRAimpf, timefilter, levfilter, dewrelh, surfconfilter,
    %nosedetect
    %

% Give a useful message, since the first step takes longer than the others
disp('Import started!')
    
% Read soundings data into MATLAB
try
    [sndng] = IGRAimpf(input_file); %This produces a structure of soundings data with minimal quality control.
catch ME
    msg = 'Failed to create raw soundings structure! Check data file for errors and try again.';
    error(msg)
end
disp('Successfully created raw soundings structure! 1/5')

% Filter soundings by time
filter_settings.year = [2002 2016]; %Settings to remove all data that does not lie between 2002 and 2016, inclusive
filter_settings.month = [5 6 7 8 9]; %Settings to remove all data that occurs in the months of May through September, inclusive
[filtered] = timefilter(sndng,filter_settings); %Create a new structure with only the data needed
disp('Time filtering complete! 2/5')

% Filter soundings by level
[soundsh] = levfilter(filtered,3); %Remove all level type 3 data (corresponding to extra wind layers, which throw off geopotential height and other variables)
disp('Level filtering complete! 3/5')

soundsh = soundsh'; %Correct shape of structure

% Add dewpoint and temperature to the soundings data
[soundsWithDewRH] = addDewRH(soundsh);

% Add height to the soundings data
[soundsWithHeight] = addHeight(soundsWithDewRH);

% Filter soundings by surface temperature
surfcon.temp = 19;
%surfconfilter also supports filtration by relative humidity (not used by default)
[~,goodfinal] = surfconfilter(soundsWithHeight,surfcon);

disp('Quality control complete! 4/5')

% Detect warm noses
disp('Detecting warmnoses - please be patient!') %This is one of the longest portions of the function
[~,~,~,warmnosesfinal,nowarmnosesfinal,~,~,~,~,~,~,~,~] = nosedetect(goodfinal,1,length(goodfinal),0,20000); %Function to detect layers above 0C

disp('Import complete!')

end