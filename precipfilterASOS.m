%%precipfilterASOS
    %Filters a soundings structure by whether precipitation of any kind
    %occurred in the ASOS data for the sounding time. Mist, fog, and haze
    %are ignored.
    %
    %General form: [soundingsWithPrecip,soundingsSansPrecip] = precipfilterASOS(soundStruct,asosStruct,specific)
    %
    %Outputs:
    %soundingsWithPrecip: soundings structure containing only the soundings
    %   with precipitation.
    %soundingsSansPrecip: soundings structure containing only the
    %   soundings without precipitation.
    %
    %Inputs:
    %soundStruct: a soundings data structure
    %asosStruct: an ASOS data structure from a location and time period
    %   corresponding to the soundings data. Concatenate structures similarly to
    %   arrays. (For example, for structures usefulKISP1114 and usefulKISP1214
    %   containing data from November and December 2014, respectively, use
    %   usefulKISP1112_2014 = [usefulKISP1114,usefulKISP1214] to construct
    %   a single structure containing both months of data.)
    %specific: set to 1 to check for precipitation only at the time of the
    %   sounding, or set to 0 to check for precipitation +/- a number of
    %   entries defined by the grab variable (checks 12 entries [about an hour] by default)
    %   and at the sounding time.
    %
    %Note that while it is not an input, the grab variable can be changed
    %in order to check for precipitation over a longer or shorter period of
    %time.
    %
    %Note: when we update to 2016b+ this should be changed to use datetimes
    %instead of datenumbers
    %
    %Written by: Daniel Hueholt
    %North Carolina State University
    %Undergraduate Research Assistant at Environment Analytics
    %Version Date: 6/05/2018
    %Last Major Revision: 6/05/2018
    %
    %See also ASOSimportFiveMin, fullIGRAimp, ASOSgrabber
    %

function [soundingsWithPrecip,soundingsSansPrecip] = precipfilterASOS(soundStruct,asosStruct,specific)

if ~exist('specific','var')
    specific = 0; %Specific is very restrictive, so don't use it if it isn't specified.
end

soundingDates = [soundStruct.valid_date_num];
soundingDates3 = reshape(soundingDates,1,4,length(soundStruct)); %Array containing times for all sounding observations
%Reference individual dates from this array with soundingDates(1,:,n)
fakeMinutes = zeros(1,length(soundStruct)); %Assume all soundings have a zero minute to make ASOS referencing easier
soundingDates3(1,5,:) = fakeMinutes;
soundingDates2 = permute(soundingDates3,[3,2,1]); %Reorder to be a 2D matrix with columns for YMDHM and each entry on a new row

asosDates = [[asosStruct.Year]' [asosStruct.Month]' [asosStruct.Day]' [asosStruct.Hour]' [asosStruct.Minute]']'; %'''''''
asosDates3 = reshape(asosDates,1,5,length(asosStruct)); %Array containing times for all ASOS observations
asosDates2 = permute(asosDates3,[3,2,1]); %Reorder to be a 2D matrix with columns for YMDHM and each entry on a new row

[~,~,validASOSind] = intersect(soundingDates2,asosDates2,'rows'); %The function only needs the valid ASOS indices, but the first and second output ~ are valid dates and valid sounding number, respectively

grab = 12; %+/- 1 hour by default
%Note that large values of grab can cause some soundings to be lost near the
%end of the data period, where +grab entries exceeds the dimension of the
%ASOS data structure. If the sum of sansPrecip soundings and withPrecip
%soundings is not close to the original structure, try using a smaller grab.

problemCodes = {'FG','BR','HZ'}; %These codes do not indicate precipitation

if specific == 1 %If we look for precipitation only at times exactly corresponding to the soundings time
    validASOSextract = asosStruct(validASOSind);
    precipCodes = {validASOSextract.PresentWeather};
    fog = strfind(precipCodes,problemCodes{1});
    noFog = cellfun('isempty',fog); %'isempty' is faster than @isempty
    fog(noFog) = {0}; %Place zeros where there are blanks, otherwise conversion to double will remove all blank entries
    fog = cell2mat(fog); %Make double
    fog(fog~=1) = 0; %Everything that isn't 1 needs to be 0 -- fog and the other codes aren't inherently bad; it's only the entries with these codes alone need to be ignored
    mist = strfind(precipCodes,problemCodes{2});
    noMist = cellfun('isempty',mist);
    mist(noMist) = {0};
    mist = cell2mat(mist); %Make double
    mist(mist~=1) = 0;
    haze = strfind(precipCodes,problemCodes{3});
    noHaze = cellfun('isempty',haze);
    haze(noHaze) = {0};
    haze = cell2mat(haze); %Make double
    haze(haze~=1) = 0;
    
    logicalPrecip = logical(~cellfun('isempty',precipCodes)); %Logically index on isempty weather code
    logicalPrecip(fog==1) = 0; %Fog indices are now 0
    logicalPrecip(mist==1) = 0; %Mist indices are now 0
    logicalPrecip(haze==1) = 0; %Haze indices are now 0
    %At this point, logical 1 should refer only to times with true precipitation
    
    withPrecip = logicalPrecip==1;
    sansPrecip = logicalPrecip==0;
    soundingsWithPrecip = soundStruct(withPrecip);
    soundingsSansPrecip = soundStruct(sansPrecip);
    return %End the function immediately
else
    vaic = 1; %Counts indices
    vaec = 1; %Counts in extract structure
    while vaic <=length(validASOSind)
        try %If grab is set to a large value, this process will fail whenever +grab exceeds the matrix dimensions in the ASOS structure
            validASOSextract(vaec:vaec+2*grab) = asosStruct(validASOSind(vaic)-grab:validASOSind(vaic)+grab);
            refInd(vaec:vaec+2*grab,1) = vaic;
            vaec = vaec+2*grab+1; %Because +/-, not just +
            vaic = vaic+1; %Increment index counter by 1
        catch ME %#ok
            break %Stops the loop when a matrix dimension error occurs, as this indicates that we are at/near the end of the structure anyway
            %Another potential way to deal with this would be to update
            %grab on the fly so +grab will always be less than the length
            %of asosStruct.
        end
    end
    precipCodes = {validASOSextract.PresentWeather};
    fog = strfind(precipCodes,problemCodes{1});
    noFog = cellfun('isempty',fog); %'isempty' is faster than @isempty
    fog(noFog) = {0}; %Place zeros where there are blanks, otherwise conversion to double will remove all blank entries
    fog = cell2mat(fog); %Make double
    fog(fog~=1) = 0; %Everything that isn't 1 needs to be 0 -- fog and the other codes aren't inherently bad; it's only the entries with these codes alone need to be ignored
    mist = strfind(precipCodes,problemCodes{2});
    noMist = cellfun('isempty',mist);
    mist(noMist) = {0};
    mist = cell2mat(mist); %Make double
    mist(mist~=1) = 0;
    haze = strfind(precipCodes,problemCodes{3});
    noHaze = cellfun('isempty',haze);
    haze(noHaze) = {0};
    haze = cell2mat(haze); %Make double
    haze(haze~=1) = 0;
    
    logicalPrecip = logical(~cellfun('isempty',precipCodes)); %Logically index on isempty weather code
    logicalPrecip(fog==1) = 0; %Fog codes are now 0
    logicalPrecip(mist==1) = 0; %Mist codes are now 0
    logicalPrecip(haze==1) = 0; %Haze codes are now 0
    %At this point, logical 1 should refer only to times with precip
    
    logPrecipAndInd = [logicalPrecip' refInd]; %refInd refers to sounding numbers, but still has multiple entries for each
    withPrecip = logPrecipAndInd(logPrecipAndInd(:,1)==1,:); %Grab all the precip elements and their corresponding reference indices
    withPrecipInd = unique(withPrecip(:,2)); %Unique indices are sounding numbers
    noPrecipInd = unique(refInd);
    noPrecipInd(withPrecipInd) = []; %Remove all precip entries
    
    soundingsWithPrecip = soundStruct(withPrecipInd);
    soundingsSansPrecip = soundStruct(noPrecipInd);
end

end