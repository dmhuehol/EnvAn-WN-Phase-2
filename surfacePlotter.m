%Requires external functions datetickzoom and addaxis
%
%See also datetickzoom, addaxis, addaxislabel
%
function [surfaceSubset] = surfacePlotter(dStart,hStart,dEnd,hEnd,ASOS)
%% Locate the data in question
extractDays = [ASOS.Day]; %Array of all days within the given structure, bracket is required to form an array instead of list
logicalDays = logical(extractDays==dStart | extractDays==dEnd); %Logically index the days; 1 represents start/end day entries, 0 represents all others
try
    dayIndices = find(logicalDays~=0); %These are the indices of the input day(s)
catch ME; %If day is not found
    msg('No data from input day(s) present in structure!');
    error(msg); %Give a useful error message
end

extractHours = [ASOS(dayIndices).Hour]; %Array of all hours from the given days
logicalHours = logical(extractHours==hStart); %Since it's possible for end to be a number smaller than start and hence deceive the function, start by finding only the start hour
try
    hStartIndices = find(logicalHours~=0);
catch ME;
    msg('Failed to find start hour in structure!');
    error(msg);
end
hStartFirstInd = hStartIndices(1); %This is the first index
hStartFinalInd = hStartIndices(end); %which marks where in the structure to look for the end hour
logicalHours = logical(extractHours==hEnd); %Remake the logical matrix (INCLUDES data from the hEnd hour)
logicalHours(1:hStartFinalInd) = 0; %The end hour will definitely not come before the start hour
try
    hEndIndices = find(logicalHours~=0);
catch ME;
    msg('Could not find end hour in structure!');
end
hEndFinalInd = hEndIndices(end); %This is the last data index

dataHourSpan = [hStartFirstInd hEndFinalInd]; %This is the span of indices corresponding to hour locations within the found days
dataSpan = [dayIndices(dataHourSpan(1)) dayIndices(dataHourSpan(2))]; %This is the span of indices corresponding to data positions in the actual structure

surfaceSubset = ASOS(dataSpan(1):dataSpan(2)); %Extract the requested data from the structure

%% Plot Td, T, RH, P data
dewpoint = [surfaceSubset.Dewpoint]; %Dewpoint data
temperature = [surfaceSubset.Temperature]; %Temperature data
humidity = [surfaceSubset.RelativeHumidity]; %Humidity
pressure = [surfaceSubset.Altimeter]; %Pressure
tTd = [dewpoint;temperature]; %Concatenate dewpoint and temperature to make plotting possible
times = [surfaceSubset.Year; surfaceSubset.Month; surfaceSubset.Day; surfaceSubset.Hour; surfaceSubset.Minute; zeros(1,length(surfaceSubset))];
serialTimes = datenum(times(1,:),times(2,:),times(3,:),times(4,:),times(5,:),times(6,:));

presentWeather = {surfaceSubset.PresentWeather}; %Weather codes
fogchk = 0; frzfogchk = 0; mistchk = 0; rainchk = 0; frzdrizchk = 0; drizchk = 0; frzrainchk = 0;
sleetchk = 0; graupchk = 0; snowchk = 0; upchk = 0; hailchk = 0; icchk = 0; thunderchk = 0;
yplacer = 0;
figure;
presentAxis = gca;
for count = 1:length(presentWeather) %Sometimes you just have to get loopy
    if isempty(regexp(presentWeather{count},'(FG){1}','once'))~=1
        if fogchk==0
            fogplace = yplacer+1;
            yplacer = yplacer+1;
            presentLabels{yplacer} = 'Fog'; %#ok
            fogchk=1;
        end
        plot(serialTimes(count),fogplace,'b','Marker','.','MarkerEdgeColor',[128 128 128]./255,'MarkerSize',5);
        hold on
    end
    if isempty(regexp(presentWeather{count},'(FZFG){1}','once'))~=1
        if frzfogchk==0
            frzfogplace = yplacer+1;
            yplacer = yplacer+1;
            presentLabels{yplacer} = 'Frz Fog'; %#ok
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
        plot(serialTimes(count),dzplace,'k','Marker','.','MarkerSize',8);
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
        plot(serialTimes(count),rainplace,'Marker','.','MarkerFaceColor','b','MarkerSize',12);
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
        plot(serialTimes(count),sleetplace,'o','MarkerEdgeColor',[128 128 128]./255,'MarkerFaceColor',[128 128 128]./255,'MarkerSize',8);
        hold on
    end
    if isempty(regexp(presentWeather{count},'(SG){1}','once'))~=1 || isempty(regexp(presentWeather{count},'(GS){1}','once'))~=1
        if graupchk==0
            graupplace = yplacer+1;
            yplacer = yplacer+1;
            presentLabels{yplacer} = 'Graupel';
            graupchk=1;
        end
        plot(serialTimes(count),graupplace,'Marker','*','MarkerEdgeColor','g');
        hold on
    end
    if isempty(regexp(presentWeather{count},'(SN){1}','once'))~=1
        if snowchk==0
            snowplace = yplacer+1;
            yplacer = yplacer+1;
            presentLabels{yplacer} = 'Snow';
            snowchk=1;
        end
        plot(serialTimes(count),snowplace,'Marker','*','MarkerEdgeColor','c');
        hold on
    end
    if isempty(regexp(presentWeather{count},'(IC){1}','once'))~=1
        if icchk==0
            icplace = yplacer+1;
            yplacer = yplacer+1;
            presentLabels{yplacer} = 'Ice Crystals';
            icchk=1;
        end
        plot(serialTimes(count),icplace,'Marker','-','MarkerEdgeColor',[128 128 128]./255,'MarkerSize',8);
        hold on
    end
    if isempty(regexp(presentWeather{count},'(GR){1}','once'))~=1
        if hailchk==0
            hailplace = yplacer+1;
            yplacer = yplacer+1;
            presentLabels{yplacer} = 'Hail';
            hailchk=1;
        end
        plot(serialTimes(count),hailplace,'Marker','o','MarkerEdgeColor','r','MarkerFaceColor','r','MarkerSize',8);
        hold on
    end
    if isempty(regexp(presentWeather{count},'(TS){1}','once'))~=1
        if thunderchk==0
            thunderplace = yplacer+1;
            yplacer = yplacer+1;
            presentLabels{yplacer} = 'Thunderstorm';
            thunderchk=1;
        end
        plot(serialTimes(count),thunderplace,'Marker','d','MarkerEdgeColor','y','MarkerFaceColor','y','MarkerSize',6);
        hold on
    end
    if isempty(regexp(presentWeather{count},'(UP){1}','once'))~=1
        if upchk==0
            upplace = yplacer+1;
            yplacer = yplacer+1;
            presentLabels{yplacer} = 'Uknwn Precip';
            upchk=1;
        end
        plot(serialTimes(count),upplace,'Marker','p','MarkerEdgeColor','m','MarkerFaceColor','m','MarkerSize',6);
        hold on
    end
    hold on
end
ylim([0 yplacer+1]);
set(presentAxis,'YTick',1:yplacer);
set(presentAxis,'YTickLabel',presentLabels);
title('Precip Type')
datetickzoom('x')
hold off

figure;
tempdew = plot(serialTimes,tTd);
ylabel('deg C')
addaxis(serialTimes,pressure,'r');
addaxislabel(2,'hPa')
addaxis(serialTimes,humidity,'m');
addaxislabel(3,'%')
legend('Temperature','Dewpoint','Pressure','Humidity');
datetickzoom

titleString = 'Surface observations data for ';
toString = 'to';
spaceString = {' '}; %Yes those curly brackets are needed
if dStart==dEnd
    obsDateNum = datenum(surfaceSubset(1).Year,surfaceSubset(1).Month,surfaceSubset(1).Day);
    obsDate = datestr(obsDateNum);
    titleMsg = [titleString datestr(obsDate)];
else
    obsDateNum1 = datenum(surfaceSubset(1).Year,surfaceSubset(1).Month,surfaceSubset(1).Day);
    obsDate1 = datestr(obsDateNum1);
    obsDateNum2 = datenum(surfaceSubset(end).Year,surfaceSubset(end).Month,surfaceSubset(end).Day);
    obsDate2 = datestr(obsDateNum2);
    titleMsg = strcat(titleString,spaceString,datestr(obsDate1),spaceString,toString,spaceString,datestr(obsDate2));
end
title(titleMsg);
hold off

%% Plot wind data
windDirection = [surfaceSubset.WindDirection]; %Imaginary direction
windSpeed = [surfaceSubset.WindSpeed]; %Imaginary speed
windU = windSpeed.*cos(windDirection); %Calculate u
windV = windSpeed.*sin(windDirection); %Calculate v
numWind = length(windDirection); %Number of wind entries
colors = parula(numWind); %Use parula color map for high contrast and easy distinguishability, makes evenly spaced entires
maxWind = max(windSpeed); %Maximum entry is maximum radius of compass
figure; %New figure
hiddenArrow = compass(maxWind); %Need to set maximum compass size at beginning, otherwise large arrows will size off the screen
set(hiddenArrow,'Visible','off');
hold on
for windC = 1:15:numWind %Plot vector iteratively
    h = compass(windU(windC),windV(windC)); %Time is visible as color
    set(h,'Color',colors(windC,:))
    hold on
end
colormap parula %Specify color map
cb = colorbar('YTick',[1 numWind],'YTickLabel',{'Early','Late'}); %('YTick',1:numWind,'YTickLabels',dateStrings);

disp('Completed!')
end