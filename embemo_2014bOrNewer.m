%This is a version of the embemo file which is only functional in
%MATLAB 2014b or newer, which implements the colorbar object. Other 2014b
%functionality could be included, such as dot notation. This will be the
%dominant method once the lab upgrades MATLAB versions.
%Requires accessory function plotyyy
%Version date: 10/10/2017
%Last Major Revision: 10/11/2017
%Written by: Daniel Hueholt
%Undergraduate Research Assistant at Environment Analytics
%North Carolina State University
%
%See also embemo_2014bOrNewer
%

dewpoint = [3 2 4 3 2];
temperature = [4 2 4 5 6];
time = [datenum(2011,2,1,1,0,0),datenum(2011,2,1,6,0,0),datenum(2011,2,1,11,0,0),datenum(2011,2,1,16,0,0),datenum(2011,2,1,21,0,0)];
humidity = [75 100 100 60 33];
pressure = [999 1000 1001 999 999.3];
tTd = [dewpoint;temperature];

[ax,hlines] = plotyyy(time,humidity,time,pressure,time,tTd);
datetick(ax(1))
hold on
set(hlines(1),'Color',[204 0 0]./255)
set(hlines(1),'LineWidth',1.2)
set(ax(1),'ycolor',[204 0 0]./255)
ylabel(ax(1),'%')
set(hlines(2),'Color',[0 0 223]./255);
set(hlines(2),'LineWidth',1.2)
set(ax(2),'ycolor',[0 0 223]./255);
ylabel(ax(2),'hPa')
set(hlines(3),'Color',[0 0 0]./255);
set(hlines(3),'LineWidth',1.2)
set(ax(3),'ycolor',[0 0 0]./255)
ylabel(ax(3),'deg C')
set(hlines(4),'Color',[0 255 0]./255);
set(hlines(4),'LineWidth',1.2)
legend(hlines,'Humidity','Pressure','Temperature','Dewpoint');

windDir = [204 270 206 209 215];
windSpd = [3 5 9 11 2];
windU = windSpd.*cos(windDir);
windV = windSpd.*sin(windDir);
numWind = length(windDir);
colors = parula(numWind);
maxWind = max(windSpd);
f2 = figure(2);
hiddenArrow = compass(maxWind);
set(hiddenArrow,'Visible','off');
cb = colorbar; %Only available in MATLAB2014b or newer
for datescount = 1:length(time)
    dateStrings{datescount} = datestr(time(datescount));
end
%Operations involving colorbar object
set(cb,'TickLabels',dateStrings);
set(cb,'Ticks',linspace(0,1,length(time)));

hold on

for windC = 1:numWind
    h = compass(windU(windC),windV(windC));
    set(h,'Color',colors(windC,:))
    hold on
end