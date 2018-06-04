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
    %soundingsSansPrecip: soundings structure contatining only the
    %   soundings without precipitation.
    %
    %Inputs:
    %soundStruct: a soundings data structure
    %asosStruct: an ASOS data structure from a location and time period
    %   corresponding to the soundings data.
    %specific: set to 1 to check for precipitation only at the time of the
    %   sounding, or set to 0 to check for precipitation +/- grab number of
    %   entries (checks 12 entries [about an hour] by default) and at the
    %   sounding time.
    %
    %Note that while it is not an input, the grab variable can be changed
    %in order to check for precipitation over a longer or shorter period of
    %time.
    %
    %Note: when we update to 2016b+ this should be changed to use datetimes
    %
    %Written by: Daniel Hueholt
    %North Carolina State University
    %Undergraduate Research Assistant at Environment Analytics
    %Version Date: 6/04/2018
    %Last Major Revision: 6/04/2018
    %
    %See also ASOSimportFiveMin, fullIGRAimp, ASOSgrabber
    %

function [soundingsWithPrecip,soundingsSansPrecip] = precipfilterASOS(soundStruct,asosStruct,specific)
if ~exist('specific','var')
    specific = 0;
end

soundingDates = [soundStruct.valid_date_num];
soundingDates3 = reshape(soundingDates,1,4,length(soundStruct)); %Array containing times for all sounding observations
%Reference individual dates from this array with soundingDates(1,:,n)
fakeMinutes = zeros(1,length(soundStruct)); %Assume all soundings have a zero minute to make ASOS referencing easier
soundingDates3(1,5,:) = fakeMinutes;
soundingDates2 = permute(soundingDates3,[3,2,1]);

asosDates = [[asosStruct.Year]' [asosStruct.Month]' [asosStruct.Day]' [asosStruct.Hour]' [asosStruct.Minute]']';
asosDates3 = reshape(asosDates,1,5,length(asosStruct)); %Array containing times for all ASOS observations
asosDates2 = permute(asosDates3,[3,2,1]);

[~,~,validASOSind] = intersect(soundingDates2,asosDates2,'rows'); %The function only needs the valid ASOS indices, but the first and second ~ are valid dates and valid sounding number, respectively

grab = 12; %+/- 1 hour

problemCodes = {'FG','BR','HZ'}; %These codes do not indicate precipitation

if specific == 1 %If we look for precip only at times exactly at the soundings time
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
    
    logicalPrecip = logical(~cellfun('isempty',precipCodes));
    logicalPrecip(fog==1) = 0;
    logicalPrecip(mist==1) = 0;
    logicalPrecip(haze==1) = 0;
    
    %At this point, logical 1 should refer only to times with precip
    withPrecip = find(logicalPrecip==1);
    sansPrecip = find(logicalPrecip==0);
    
    soundingsWithPrecip = soundStruct(withPrecip); %#ok
    soundingsSansPrecip = soundStruct(sansPrecip); %#ok
    
    return %End the function immediately
    
else
    vaic = 1;
    vaec = 1;
    while vaic <=length(validASOSind)
        validASOSextract(vaec:vaec+2*grab) = asosStruct(validASOSind(vaic)-grab:validASOSind(vaic)+grab);
        refInd(vaec:vaec+2*grab,1) = vaic;
        vaec = vaec+2*grab+1; %Because +/-, not just +
        vaic = vaic+1; %Increment index counter by 1
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
    
    logicalPrecip = logical(~cellfun('isempty',precipCodes));
    logicalPrecip(fog==1) = 0;
    logicalPrecip(mist==1) = 0;
    logicalPrecip(haze==1) = 0;
    
    %At this point, logical 1 should refer only to times with precip
    logPrecipAndInd = [logicalPrecip' refInd]; %refInd should refer to sounding numbers
    withPrecip = logPrecipAndInd(logPrecipAndInd(:,1)==1,:); %Grab all the logical 1 elements and their corresponding reference indices
    withPrecipInd = unique(withPrecip(:,2)); %Unique indices are sounding numbers
    noPrecipInd = unique(refInd);
    noPrecipInd(withPrecipInd) = []; %Remove all precip entries
    
    soundingsWithPrecip = soundStruct(withPrecipInd);
    soundingsSansPrecip = soundStruct(noPrecipInd);
end

end