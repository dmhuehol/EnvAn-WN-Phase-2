%%precipfilterASOS
    %Filter
    %
    %Version date: 4/21/2018
    %
    %Written by: Daniel Hueholt
    %North Carolina State University
    %Undergraduate Research Assistant at Environment Analytics
    %

function [precipSoundings,noPrecipSoundings] = precipfilterASOS(soundingStruct,asosData,spread)
errorCount = 0;
pCount = 1;
tc = length(soundingStruct); 

%Concept: start with the time of the sounding
%find the index in the ASOS data corresponding to the sounding time
%check the ASOS data values +/- 1 or 2 hours from the sounding time
%if the present weather is empty, no precip, save sounding number
%save all the other sounding numbers. This'll catch all the soundings with precip codes. I
%lowkey don't care at this stage if there's fog/mist being left in here,
%I bet it'd still cut down on 90% of the dross.
%Grab and output two structures

%weather codes: FZRA, FZDZ, PL, DZ, RA, SN

for count = 1:length(soundingStruct)
    time = soundingStruct(count).valid_date_num;
    for aCount = 1:length(asosData)
        if asosData(aCount).Year==time(1) && asosData(aCount).Month==time(2) && asosData(aCount).Day==time(3) && asosData(aCount).Hour==time(4) && asosData(aCount).Minute==0
            foundIt(count) = aCount;
            break
        else
            if aCount == length(asosData)
                foundIt(count) = NaN;
            end
        end
    end

end

notFound = find(isnan(foundIt)==1); %Remove NaN values
foundIt(notFound) = []; %get nuked!!!
soundingMatch = soundingStruct;
soundingMatch(notFound) = [];

spreadCount = 1;
foundCount = 1;
%Change to use spread instead of 12
while foundCount <= length(foundIt)
    if foundIt(foundCount)>12 && foundIt(foundCount)+12<length(asosData)
        found(spreadCount) = foundIt(foundCount)-12;
        found(spreadCount:spreadCount+12) = found(spreadCount):found(spreadCount)+12;
    elseif foundIt(foundCount)<12
        found(spreadCount) = 1;
        found(spreadCount:spreadCount+12) = foundIt(foundCount):foundIt(foundCount)+12;
    elseif foundIt(foundCount)+12>length(asosData)
        found(spreadCount) = foundIt(end)-12;
        found(spreadCount:spreadCount+12) = foundIt(end)-12:foundIt(end);        
    end 
    spreadCount = spreadCount+13;
    foundCount = foundCount+1;
end

asosMatch = asosData(found); %Extracts all times corresponding to sounding times +/- spread number of indices


stop = 3;


end