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
%weatherPresence = logical(~cellfun('isempty',presentWeather)); %Logically index the present weather codes; no weather code (0)/weather code (1)
%precipTimes = [time(2) time(3) time(4)]; %Times where precip occurred
%precipType = {'SN','RA','SNRA'}; %Snow at first, rain at second, then both

% Place precipitation type markers at top of plot
% for count = 1:length(precipType) %Loop to look for all precipitation type markers
%     precipPoint = plot(precipTimes(count),100,'Marker','o','MarkerSize',5,'MarkerFaceColor','w'); %Invisible at first
%     if strcmp(precipType{count},'SNRA') == 1 %If snow and rain
%         set(precipPoint,'MarkerFaceColor','b')
%         set(precipPoint,'Marker','p') %Blue pentagons
%     elseif strcmp(precipType{count},'SN')==1 %If snow
%         set(precipPoint,'MarkerFaceColor','k') %Black stars
%         set(precipPoint,'Marker','*')
%         set(precipPoint,'MarkerSize',7) %Make a little larger because stars are hard to see
%     elseif strcmp(precipType{count},'RA')==1 %If rain
%         set(precipPoint,'MarkerFaceColor','b') %Blue circles
%     end
%     hold on
% end
figure;
presentAxis = gca;
for count = 1:length(presentWeather)
    if isempty(regexp(presentWeather{count},'(FG){1}','once'))~=1
        plot(serialTimes(count),1,'b');
        hold on
    end
    if isempty(regexp(presentWeather{count},'(BR){1}','once'))~=1
        plot(serialTimes(count),2,'b');
        hold on
    end
    if isempty(regexp(presentWeather{count},'(DZ){1}','once'))~=1 && isempty(regexp(presentWeather{count},'(FZDZ){1}','once'))==1
        plot(serialTimes(count),3,'k');
        hold on
    end
%     if isempty(regexp(presentWeather{count},'(FZDZ){1}','once'))~=1
        plot(serialTimes(count),4,'k');
        hold on
    end
    if isempty(regexp(presentWeather{count},'(RA){1}','once'))~=1 && isempty(regexp(presentWeather{count},'(FZRA){1}','once'))==1
        plot(serialTimes(count),5,'Marker','.','MarkerFaceColor','b');
        hold on
    end
    if isempty(regexp(presentWeather{count},'(FZRA){1}','once'))~=1
        plot(serialTimes(count),6,'Marker','.','MarkerFaceColor','b');
        hold on
    end
    if isempty(regexp(presentWeather{count},'(PL){1}','once'))~=1 %|| isempty(regexp(presentWeather{count},'(PE){1}','once'))~=1
        plot(serialTimes(count),7,'o','MarkerEdgeColor',[128 128 128]./255,'MarkerFaceColor',[128 128 128]./255);
        hold on
    end
    if isempty(regexp(presentWeather{count},'(SG){1}','once'))~=1
        plot(serialTimes(count),8,'Marker','*','MarkerEdgeColor','g');
        hold on
    end
    if isempty(regexp(presentWeather{count},'(SN){1}','once'))~=1
        plot(serialTimes(count),9,'Marker','*','MarkerEdgeColor','c');
    end
    hold on
end
ylim([0 10]);
set(presentAxis,'YTick',[1 2 3 4 5 6 7 8 9]);
set(presentAxis,'YTickLabel',{'Fog','Mist','Drizzle','Frz Drizzle','Rain','Frz Rain','Sleet','Graupel','Snow'});
datetick('x')
hold off

figure;
[ax,hlines] = plotyyy(serialTimes,humidity,serialTimes,pressure,serialTimes,tTd); %Requires secondary function plotyyy
datetick(ax(1)) %Date tick on x axis
datetick(ax(2))
datetick(ax(3))
set(hlines(1),'Color',[204 0 0]./255) %Humidity color
set(hlines(1),'LineWidth',1.2)
set(ax(1),'ycolor',[204 0 0]./255) %Humidity axis
ylabel(ax(1),'%')
set(hlines(2),'Color',[0 0 223]./255); %Pressure color
set(hlines(2),'LineWidth',1.2)
set(ax(2),'ycolor',[0 0 223]./255); %Pressure axis
ylabel(ax(2),'hPa')
set(hlines(3),'Color',[0 0 0]./255); %deg C color
set(hlines(3),'LineWidth',1.2)
set(ax(3),'ycolor',[0 0 0]./255) %deg C axis
ylabel(ax(3),'deg C')
set(hlines(4),'Color',[0 255 0]./255); %deg C color
set(hlines(4),'LineWidth',1.2)
legend(hlines,'Humidity','Pressure','Temperature','Dewpoint');
set(ax(2),'XTick',[]) %Disable other x axis tick marks
set(ax(3),'XTick',[])

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
% dateStrings = cell(1,length(serialTimes));
% for datescount = 1:length(serialTimes)
%     dateStrings{datescount} = datestr(serialTimes(datescount)); %Need date strings to label the color bar
% end
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