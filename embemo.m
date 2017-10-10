%%embemo
    %Script to demonstrate the plots which will be embedded with the
    %MRR+warm nose+profile plots. Creates two figures using toy data: the first displays
    %temperature, dewpoint, humidity, pressure, and precipitation type, and
    %the second displays surface wind.
    %
    %REQUIRES ACCESSORY FUNCTION PLOTYYY
    %
    %Version date: 10/9/2017
    %Written by: Daniel Hueholt
    %Undergraduate Research Assistant at Environment Analytics
    %North Carolina State University
    %
    %See also embemo_2014bOrNewer
    %

% Imaginary data
dewpoint = [3 2 4 3 2]; %Imaginary dewpoint data
temperature = [4 2 4 5 6]; %Imaginary temperature data
time = [datenum(2011,2,1,1,0,0),datenum(2011,2,1,6,0,0),datenum(2011,2,1,11,0,0),datenum(2011,2,1,16,0,0),datenum(2011,2,1,21,0,0)]; %Imaginary time
humidity = [75 100 100 60 33]; %Imaginary humidity (note this is made up, not calculated from dewpoint and temperature)
pressure = [999 1000 1001 999 999.3]; %Imaginary pressure
tTd = [dewpoint;temperature]; %Concatenate dewpoint and temperature to make plotting possible
precipTimes = [time(2) time(3) time(4)]; %Times where precip occurred
precipType = {'SN','RA','SNRA'}; %Snow at first, rain at second, then both
windDir = [204 270 206 209 215]; %Imaginary direction
windSpd = [3 5 9 11 2]; %Imaginary speed

% Place precipitation type markers at top of plot
for count = 1:length(precipType) %Loop to look for all precipitation type markers
    precipPoint = plot(precipTimes(count),100,'Marker','o','MarkerSize',5,'MarkerFaceColor','w'); %Invisible at first
    if strcmp(precipType{count},'SNRA') == 1 %If snow and rain
        set(precipPoint,'MarkerFaceColor','b')
        set(precipPoint,'Marker','p') %Blue pentagons
    elseif strcmp(precipType{count},'SN')==1 %If snow
        set(precipPoint,'MarkerFaceColor','k') %Black stars
        set(precipPoint,'Marker','*')
        set(precipPoint,'MarkerSize',7) %Make a little larger because stars are hard to see
    elseif strcmp(precipType{count},'RA')==1 %If rain
        set(precipPoint,'MarkerFaceColor','b') %Blue circles
    end
    hold on
end
[ax,hlines] = plotyyy(time,humidity,time,pressure,time,tTd); %Requires secondary function plotyyy
datetick(ax(1)) %Date tick on x axis
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

% Wind plot
windU = windSpd.*cos(windDir); %Calculate u
windV = windSpd.*sin(windDir); %Calculate v
numWind = length(windDir); %Number of wind entries
colors = parula(numWind); %Use parula color map for high contrast and easy distinguishability, makes evenly spaced entires
maxWind = max(windSpd); %Maximum entry is maximum radius of compass
f2 = figure(2); %New figure
hiddenArrow = compass(maxWind); %Need to set maximum compass size at beginning, otherwise large arrows will size off the screen
set(hiddenArrow,'Visible','off');
for datescount = 1:length(time)
    dateStrings{datescount} = datestr(time(datescount)); %Need date strings to label the color bar
end
colormap parula %Specify color map
caxis([1 numWind]); %otherwise color axis and colorbar will use default regardless of what the plot uses
cb = colorbar('YTick',1:numWind,'YTickLabels',dateStrings);
hold on
for windC = 1:numWind %Plot vector iteratively
    h = compass(windU(windC),windV(windC)); %Time is visible as color
    set(h,'Color',colors(windC,:))
    hold on
end