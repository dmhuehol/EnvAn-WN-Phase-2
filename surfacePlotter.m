%%surfacePlotter
    %Visualizes ASOS 5-minute data on two figures. One is a surface conditions
    %plot which plots temperature, dewpoint, pressure, and relative
    %humidity data on a standard xy plot and shows wind data using wind
    %barbs, and the other is an abacus plot which visualizes
    %precipitation type. Additionally, returns the subset of the input
    %ASOS structure corresponding to the requested times.
    %
    %General form: [surfaceSubset] = surfacePlotter(dStart,hStart,dEnd,hEnd,ASOS)
    %
    %Output:
    %surfaceSubset: a subset of ASOS data corresponding to the input times.
    %
    %Inputs:
    %dStart: 1 or 2 digit starting day
    %hStart: 1 or 2 digit starting hour
    %dEnd: 1 or 2 digit ending day
    %hEnd: 1 or 2 digit ending hour
    %ASOS: structure of ASOS data
    %
    %Requires external functions tlabel, addaxis, and windbarb
    %
    %THIS FUNCTION IS CURRENTLY UNDER DEVELOPMENT AND HAS MULTIPLE MAJOR ISSUES
    %USE AT OWN RISK
    %UPDATED FREQUENTLY; SEE @dmhuehol GITHUB README FOR CURRENT DETAILS
    %
    %Written by: Daniel Hueholt
    %North Carolina State University
    %Undergraduate Research Assistant at Environment Analytics
    %Version date: 11/3/2017
    %Last major revision: 11/3/2017
    %
    %tlabel written by Carlos Adrian Vargas Aguilera, last updated 9/2009,
        %found on the MATLAB File Exchange
    %addaxis written by Harry Lee, last updated 7/7/2016, found on the
        %MATLAB File Exchange
    %windbarb written by Laura Tomkins, last updated 5/2017, found on
        %Github at user profile @lauratomkins
    %
    %
    %See also abacusdemo, tlabel, addaxis, addaxislabel, ASOSimportFiveMin,
    %windbarb
    %
function [surfaceSubset] = surfacePlotter(dStart,hStart,dEnd,hEnd,ASOS)
%% Locate the requested data
extractDays = [ASOS.Day]; %Array of all days within the given structure, bracket is required to form an array instead of list
logicalDays = logical(extractDays==dStart | extractDays==dEnd); %Logically index the days; 1 represents start/end day entries, 0 represents all others
dayIndices = find(logicalDays~=0); %These are the indices of the input day(s)
if isempty(dayIndices)==1; %If day is not found
    msg = 'No data from input day(s) present in structure!';
    error(msg); %Give a useful error message
end

extractHours = [ASOS(dayIndices).Hour]; %Array of all hours from the given days
logicalHours = logical(extractHours==hStart); %Since it's possible for end to be a number smaller than start and hence deceive the function, start by finding only the start hour
hStartIndices = find(logicalHours~=0); %These are the indices of the input starting hour
if isempty(hStartIndices)==1; %if start hour is not found
    msg = 'Failed to find start hour in structure!';
    error(msg);
end
hStartFirstInd = hStartIndices(1); %This is the first index
hStartFinalInd = hStartIndices(end); %which marks where in the structure to look for the end hour
%KNOWN BUG: does not work for end hours which are smaller in magnitude than
%start hours. High priority to fix.
logicalHours = logical(extractHours==hEnd); %Remake the logical matrix, this time logically indexing on the input ending hour (INCLUDES data from the hEnd hour)
if hStart==hEnd %For cases where the end hour and start hour are the same number
    logicalHours(1:hStartFinalInd) = 0; %Zero all the indices that corresponded to the start hour
end
hEndIndices = find(logicalHours~=0); %These are the indices of the ending hour
if isempty(hEndIndices)==1; %Check to see whether the ending indices were located 
    msg = 'Could not find end hour in structure!'; %If not
    error(msg); %give a useful error message
end
hEndFinalInd = hEndIndices(end); %This is the last data index

dataHourSpan = [hStartFirstInd hEndFinalInd]; %This is the span of indices corresponding to hour locations within the found days
dataSpan = [dayIndices(dataHourSpan(1)) dayIndices(dataHourSpan(2))]; %This is the span of indices corresponding to data positions in the actual structure

surfaceSubset = ASOS(dataSpan(1):dataSpan(2)); %Extract the requested data from the structure

%% Plot Td, T, RH, P, wind data
dewpoint = [surfaceSubset.Dewpoint]; %Dewpoint data
temperature = [surfaceSubset.Temperature]; %Temperature data
humidity = [surfaceSubset.RelativeHumidity]; %Humidity
pressure = [surfaceSubset.Altimeter]; %Pressure
TdT = [dewpoint;temperature]; %Concatenate dewpoint and temperature for plotting on same axis
times = [surfaceSubset.Year; surfaceSubset.Month; surfaceSubset.Day; surfaceSubset.Hour; surfaceSubset.Minute; zeros(1,length(surfaceSubset))]; %YMDHM are real from data, S are generated at 0
serialTimes = datenum(times(1,:),times(2,:),times(3,:),times(4,:),times(5,:),times(6,:)); %Make times into datenumbers
%Note: use actual datetimes once we update to 2016+

minDegC = nanmin(dewpoint); %Minimum Td will be min for both T and Td, since Td is always less than T
maxDegC = nanmax(temperature); %Maximum T will be max for both T and Td, since T is always greater than Td
minHum = nanmin(humidity);
maxHum = 100; %Maximum humidity will always be at least close to 100, so set to 100 to make figures more consistent
minPre = nanmin(pressure);
maxPre = nanmax(pressure);

figure; %Make new figure
plot(serialTimes,TdT); %Plot temperature and dewpoint in deg C
ylim([minDegC-3 maxDegC+1]) %set ylim according to max/min degree; the min limit is offset by -3 instead of -1 in order to make room for the wind barbs
ylabel('deg C')
degCaxis = gca; %Grab axis in order to change color
set(degCaxis,'YColor',[0 112 115]./255); %Teal - note that this is the same axis for temperature (blue) and dewpoint (green)
addaxis(serialTimes,pressure,[minPre-0.2 maxPre+0.2],'r'); %Plot pressure in inHg
addaxislabel(2,'hPa')
addaxis(serialTimes,humidity,[minHum-10 maxHum],'m'); %Plot humidity in %, leaving max at maxHum because it's 100
addaxislabel(3,'%')
legend('Dewpoint','Temperature','Pressure','Humidity');

%%Plot wind data
%Note this is on the same plot as above data
windSpd = [surfaceSubset.WindSpeed]; %Wind speed data
windDir = [surfaceSubset.WindDirection]; %Wind direction data
windCharSpd = [surfaceSubset.WindCharacterSpeed]; %Wind character speed data - currently wind character is not displayed,
    %which is sort of acceptable in the short term because essentially all wind characters at Upton are gusts
barbScale = 0.021; %Modifies the size of the wind barbs for both wind character and regular wind barbs
spacer = -5; %Displaying all wind barbs takes very long and makes the figure confusing; this sets the skip interval for the following loop
for windCount = length(serialTimes):spacer:1 %Loop backwards through winds
    windbarb(serialTimes(windCount),minDegC-1,windSpd(windCount),windDir(windCount),barbScale,0.08,'r',1); %#justiceforbarb
    if isnan(windCharSpd(windCount))~=1 %If there is a wind character entry
        windbarb(serialTimes(windCount),minDegC-2,windCharSpd(windCount),windDir(windCount),barbScale,0.08,'g',1); %Make wind barb for the character as well
    end
    hold on %Otherwise only one barb will be plotted
end
tlabel('x','HH:MM','FixLow',10,'FixHigh',12) %x-axis is date axis; FixLow and FixHigh arguments control the number of ticks that are displayed
xlim([serialTimes(1)-0.05 serialTimes(end)+0.05]); %For the #aesthetic

titleString = 'Surface observations data for ';
toString = 'to';
spaceString = {' '}; %Yes those curly brackets are needed
if dStart==dEnd
    obsDate = datestr(serialTimes(1),'mm/dd/yy');
    titleMsg = [titleString datestr(obsDate)]; %Builds title message "Surface observations data for mm/dd/yy"
else
    obsDate1 = datestr(serialTimes(1),'mm/dd/yy HH:MM');
    obsDate2 = datestr(serialTimes(end),'mm/dd/yy HH:MM');
    titleMsg = strcat(titleString,spaceString,datestr(obsDate1),spaceString,toString,spaceString,datestr(obsDate2)); %Builds title message "Surface observations data for mm/dd/yy"
end
windString = 'Red barbs denote winds and green barbs denote wind character';
titleAndSubtitle = {cell2mat(titleMsg),windString}; %Adds the above subtitle
    %I agree that the above syntax is unwieldy but oh well
title(titleAndSubtitle);
hold off

%% Plot weather codes
presentWeather = {surfaceSubset.PresentWeather}; %Weather codes
if isempty(nonzeros(~cellfun('isempty',presentWeather)))==1 %Skip making a precipitation type plot if no precipitation occurs
    emptyMsg = 'No precipitation during requested period! Skipped precipitation type plot.';
    disp(emptyMsg);
else
    %Weather codes covered in the abacus plot: fog, freezing fog,
    %mist, rain, freezing drizzle, drizzle, freezing rain, sleet, graupel,
    %snow, unknown precipitation, hail, ice crystals, thunder
    %
    %KNOWN PROBLEM: ASOS sometimes misrepresents graupel as snow, likely due to confusion about fall speed. This is
    %currently impossible to fix and must just be kept in mind. Someday
    %snow codes might be able to be cross-checked against other
    %environmental variables or a database of flake pictures but that day
    %is far far away.
    fogchk = 0; frzfogchk = 0; mistchk = 0; rainchk = 0; frzdrizchk = 0; drizchk = 0; frzrainchk = 0;
    sleetchk = 0; graupchk = 0; snowchk = 0; upchk = 0; hailchk = 0; icchk = 0; thunderchk = 0;
    yplacer = 0;
    figure;
    presentAxis = gca;
    for count = length(presentWeather):-1:1 %Sometimes you just have to get loopy
        %Note that the reverse loop is very slightly slower than a forward
        %loop would be, but is used to make MATLAB less worried about how
        %the adaptive labels are created.
        if isempty(regexp(presentWeather{count},'(FG){1}','once'))~=1
            if fogchk==0
                fogplace = yplacer+1; %Sets the wire where fog beads will be placed
                yplacer = yplacer+1; %Increments the label placer so each code gets its own wire
                presentLabels{yplacer} = 'Fog';
                fogchk=1; %Make sure that the above only happens once, otherwise each new fog entry will receive its own label and wire
            end
            plot(serialTimes(count),fogplace,'b','Marker','.','MarkerEdgeColor',[128 128 128]./255,'MarkerSize',5); %Gray
            hold on
        end
        if isempty(regexp(presentWeather{count},'(FZFG){1}','once'))~=1
            if frzfogchk==0
                frzfogplace = yplacer+1;
                yplacer = yplacer+1;
                presentLabels{yplacer} = 'Frz Fog';
                frzfogchk=1;
            end
            plot(serialTimes(count),frzfogplace,'b','Marker','.','MarkerEdgeColor',[128 128 128]./255,'MarkerSize',5);
            hold on
        end
        if isempty(regexp(presentWeather{count},'(BR){1}','once'))~=1
            if mistchk==0
                mistplace = yplacer+1;
                yplacer = yplacer+1;
                presentLabels{yplacer} = 'Mist';
                mistchk=1;
            end
            plot(serialTimes(count),mistplace,'b','Marker','.','MarkerEdgeColor',[128 128 128]./255,'MarkerSize',5);
            hold on
        end
        if isempty(regexp(presentWeather{count},'(DZ){1}','once'))~=1 && isempty(regexp(presentWeather{count},'(FZDZ){1}','once'))==1
            if drizchk==0
                dzplace = yplacer+1;
                yplacer = yplacer+1;
                presentLabels{yplacer} = 'Drizzle';
                drizchk=1;
            end
            plot(serialTimes(count),dzplace,'k','Marker','.','MarkerSize',8); %Black
            hold on
        end
        if isempty(regexp(presentWeather{count},'(FZDZ){1}','once'))~=1
            if frzdrizchk==0
                fzdzplace = yplacer+1;
                yplacer = yplacer+1;
                presentLabels{yplacer} = 'Frz Drizzle';
                frzdrizchk=1;
            end
            plot(serialTimes(count),fzdzplace,'k','Marker','.','MarkerSize',8);
            hold on
        end
        if isempty(regexp(presentWeather{count},'(RA){1}','once'))~=1 && isempty(regexp(presentWeather{count},'(FZRA){1}','once'))==1
            if rainchk==0
                rainplace = yplacer+1;
                yplacer = yplacer+1;
                presentLabels{yplacer} = 'Rain';
                rainchk=1;
            end
            plot(serialTimes(count),rainplace,'Marker','.','MarkerFaceColor','b','MarkerSize',12); %Blue
            hold on
        end
        if isempty(regexp(presentWeather{count},'(FZRA){1}','once'))~=1
            if frzrainchk==0
                fzraplace = yplacer+1;
                yplacer = yplacer+1;
                presentLabels{yplacer} = 'Frz Rain';
                frzrainchk=1;
            end
            plot(serialTimes(count),fzraplace,'Marker','.','MarkerFaceColor','b','MarkerSize',12);
            hold on
        end
        if isempty(regexp(presentWeather{count},'(PL){1}','once'))~=1 || isempty(regexp(presentWeather{count},'(PE){1}','once'))~=1
            if sleetchk==0
                sleetplace = yplacer+1;
                yplacer = yplacer+1;
                presentLabels{yplacer} = 'Sleet';
                sleetchk=1;
            end
            plot(serialTimes(count),sleetplace,'o','MarkerEdgeColor',[128 128 128]./255,'MarkerFaceColor',[128 128 128]./255,'MarkerSize',8); %Gray
            hold on
        end
        if isempty(regexp(presentWeather{count},'(SG){1}','once'))~=1 || isempty(regexp(presentWeather{count},'(GS){1}','once'))~=1
            if graupchk==0
                graupplace = yplacer+1;
                yplacer = yplacer+1;
                presentLabels{yplacer} = 'Graupel';
                graupchk=1;
            end
            plot(serialTimes(count),graupplace,'Marker','*','MarkerEdgeColor','g'); %Green
            hold on
        end
        if isempty(regexp(presentWeather{count},'(SN){1}','once'))~=1
            if snowchk==0
                snowplace = yplacer+1;
                yplacer = yplacer+1;
                presentLabels{yplacer} = 'Snow';
                snowchk=1;
            end
            plot(serialTimes(count),snowplace,'Marker','*','MarkerEdgeColor','c'); %Cyan
            hold on
        end
        if isempty(regexp(presentWeather{count},'(IC){1}','once'))~=1
            if icchk==0
                icplace = yplacer+1;
                yplacer = yplacer+1;
                presentLabels{yplacer} = 'Ice Crystals';
                icchk=1;
            end
            plot(serialTimes(count),icplace,'Marker','-','MarkerEdgeColor',[128 128 128]./255,'MarkerSize',8); %Gray
            hold on
        end
        if isempty(regexp(presentWeather{count},'(GR){1}','once'))~=1
            if hailchk==0
                hailplace = yplacer+1;
                yplacer = yplacer+1;
                presentLabels{yplacer} = 'Hail';
                hailchk=1;
            end
            plot(serialTimes(count),hailplace,'Marker','o','MarkerEdgeColor','r','MarkerFaceColor','r','MarkerSize',8); %Red
            hold on
        end
        if isempty(regexp(presentWeather{count},'(TS){1}','once'))~=1
            if thunderchk==0
                thunderplace = yplacer+1;
                yplacer = yplacer+1;
                presentLabels{yplacer} = 'Thunderstorm';
                thunderchk=1;
            end
            plot(serialTimes(count),thunderplace,'Marker','d','MarkerEdgeColor','y','MarkerFaceColor','y','MarkerSize',6); %Yellow
            hold on
        end
        if isempty(regexp(presentWeather{count},'(UP){1}','once'))~=1
            if upchk==0
                upplace = yplacer+1;
                yplacer = yplacer+1;
                presentLabels{yplacer} = 'Uknwn Precip';
                upchk=1;
            end
            plot(serialTimes(count),upplace,'Marker','p','MarkerEdgeColor','m','MarkerFaceColor','m','MarkerSize',6); %Magenta
            hold on
        end
        hold on
    end
    ylim([0 yplacer+1]); %y limits are set +/- 1 larger than number of wires 
    set(presentAxis,'YTick',1:yplacer);
    set(presentAxis,'YTickLabel',presentLabels); %Only label wires with precipitation types that actually occurred
  
    %Make adaptive title including start and end times
    weatherCodeTitleString = 'Precip type data for ';
    if dStart==dEnd
        obsDate = datestr(serialTimes(1),'mm/dd/yy');
        titleMsg = [weatherCodeTitleString datestr(obsDate)]; %Builds title message "Precip type data for mm/dd/yy"
    else
        obsDate1 = datestr(serialTimes(1),'mm/dd/yy HH:MM');
        obsDate2 = datestr(serialTimes(end),'mm/dd/yy HH:MM');
        titleMsg = strcat(weatherCodeTitleString,spaceString,datestr(obsDate1),spaceString,toString,spaceString,datestr(obsDate2)); %Builds title message "Precip type data for mm/dd/yy HH:MM to mm/dd/yy HH:MM"
    end
    title(titleMsg);
    tlabel('x','HH:MM','FixLow',10,'FixHigh',12) %Set axis to be the same as surface conditions plot
    xlim([serialTimes(1)-0.05 serialTimes(end)+0.05]); %Set bounds to be the same as surface conditions plot
    hold off
end

%% Finalizing
disp('Completed!') %Yay!

end