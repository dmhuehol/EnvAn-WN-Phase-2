%%compositePlotter
%Plots composites of wetbulb temperature and/or temperature vs height for multiple soundings, given a
%set of sounding numbers. By default, can only composite up to 12 profiles;
%add more colors to the 'colors' variable to plot more.
%
%General form: [] = compositePlotter(soundingStruct,snumToPlot,tempType)
%
%Inputs:
%soundingStruct: A structure of soundings data. If the structure has not
    %been processed for wetbulb temperature already, then it will
    %automatically calculate wetbulb temperature for only the requested
    %soundings.
%snumToPlot: An array of (up to 12, by default) sounding numbers. Use
    %findsnd to get sounding numbers.
%tempType: String input designating what kind of temperature to plot.
    %Use 'wetbulb' to plot wetbulb, 'temp' to plot air temperature, or 'both' to
    %plot both.
%
%Outputs:
%compositeSubset: An extract of the soundings structure containing the requested times,
    %with wetbulb temperature added.
%
%
%Version date: 6/20/2018
%Last major revision: 6/19/2018
%Written by: Daniel Hueholt
%North Carolina State University
%Undergraduate Research Assistant at Environment Analytics
%
%See also findsnd, addWetbulb
%


function [compositeSubset] = compositePlotter(soundingStruct,soundingsToPlot,tempType)

if ~exist('tempType','var')==1 %If temperature type is left unspecified
    tempType = 'both'; %then plot both wetbulb temperature and air temperature
    msg = 'Both wetbulb temperature and air temperature will be plotted. Change tempType input to specify which temperature type to plot.';
    disp(msg); %but inform the user that temperature type can be specified
end

%Temperature type to plot
if strcmp(tempType,'wetbulb')==1 || strcmp(tempType,'wet')==1 || strcmp(tempType,'Wetbulb')==1 || strcmp(tempType,'wetbulb temperature')==1 || strcmp(tempType,'Wetbulb Temperature')==1 || strcmp(tempType,'Wetbulb temperature')==1
    tempType = 1;
elseif strcmp(tempType,'temp')==1 || strcmp(tempType,'temperature')==1 || strcmp(tempType,'Temp')==1 || strcmp(tempType,'Temperature')==1
    tempType = 2;
elseif strcmp(tempType,'both')==1 || strcmp(tempType,'twt')==1
    tempType = 3;
else
    msg = 'Improper input! Check for accuracy and try again.';
    error(msg);
end

%Colors are used to denote time; different soundings are plotted in
%different colors. Twelve distinct colors are used by default.
%colorsToPlot = [255,168,163; 255,0,0; 255,140,0; 255,225,0; 0,255,0; 4,234,255; 53,123,166; 0,0,255; 183,1,255; 181,146,255; 98,1,133; 0,0,0]./255;
colorsToPlot = [255,0,0; 255,140,0; 255,225,0; 0,255,0; 4,234,255; 53,123,166; 0,0,255; 183,1,255; 181,146,255; 98,1,133; 0,0,0]./255;
%Salmon, red, orange, yellow, green, teal, light blue, dark blue, lavender, purple, dark purple, black

if length(soundingsToPlot)>length(colorsToPlot) %If there are more sounding numbers than colors to plot
    numberOfColors = num2str(length(colorsToPlot));
    msg = ['Too many soundings requested! Maximum allowable number is ' numberOfColors]; %Warn the user, informing them of the maximum number that can be used
    error(msg);
end

colorCount = 1; %Counter to track color usage
cloudThreshold = 80; %Relative humidity threshold to determine cloud presence/absence

compositeSubset = soundingStruct(soundingsToPlot); %Subset of requested soundings

if isfield(compositeSubset,'wetbulb')==0 %If the overall structure hasn't already been processed for wetbulb temperature
    disp('Calculating wetbulb temperature, please wait.') %This can take some time, so reassure the user
    [compositeSubset] = addWetbulb(compositeSubset); %Add wetbulb to just the requested subset
end


%For generating the legend later
dates = double([[compositeSubset.year]',[compositeSubset.month]',[compositeSubset.day]',[compositeSubset.hour]',zeros(length(compositeSubset),1),zeros(length(compositeSubset),1)]); %Need to be converted to doubles
dateStrings = datestr(dates,'yyyy-mm-dd HH UTC'); %Convert to datestrings for legend

plot([0 0],[0,5],'k','LineWidth',2) %Freezing line

hold on %buckle up

switch tempType %Depending on input, plot wetbulb temperature vs height, air temperature vs height, or both wetbulb temperature and air temperature vs height
    case 1 %Wetbulb temperature vs height
        compositePlotTw = zeros(1,length(compositeSubset)); %Preallocation
        for soundCount=1:length(compositeSubset)
            compositePlotTw(soundCount) = plot(compositeSubset(soundCount).wetbulb,compositeSubset(soundCount).height,'Color',colorsToPlot(colorCount,:),'LineWidth',1.9); %Connect the data dots
            hold on
            logicalCloud = compositeSubset(soundCount).rhum>=cloudThreshold; %Logically index based on the threshold value for relative humidity
            if isempty(nonzeros(logicalCloud))==1 %Cloud-free through whole sounding
                %Do nothing
            else
                cloud = plot(compositeSubset(soundCount).wetbulb(logicalCloud==1),compositeSubset(soundCount).height(logicalCloud==1),'d'); %Cloud points are diamonds
                set(cloud,'Color',colorsToPlot(colorCount,:))
                set(cloud,'MarkerFaceColor',colorsToPlot(colorCount,:))
                set(cloud,'MarkerSize',9.6)
            end
            acloud = plot(compositeSubset(soundCount).wetbulb(logicalCloud==0),compositeSubset(soundCount).height(logicalCloud==0),'+'); %Cloud-free points are pluses
            set(acloud,'Color',colorsToPlot(colorCount,:))
            set(acloud,'MarkerFaceColor',colorsToPlot(colorCount,:))
            set(acloud,'MarkerSize',9.6)
            hold on
            colorCount = colorCount+1; %Increment the color
        end
        
        %Aesthetic changes to the figure
            %These are all done within the switch/case because the labels and
            %legend are different for each case, and if the axis changes
            %came later they would override any text changes made here.
            
        axe = gca;
        set(axe,'FontSize',18)
        set(axe,'FontName','Lato')
        
        degreeSymbol = char(176);
        x = xlabel(['Wetbulb Temperature (' degreeSymbol 'C)']); %x-axis is wetbulb temperature
        set(x,'FontSize',18)
        set(x,'FontName','Lato')
        yl = ylabel('Height (km)'); %y-axis is km
        set(yl,'FontSize',18)
        set(yl,'FontName','Lato')
        
        t = title({'Wetbulb Temperature vs Height';'+ denotes no cloud, \diamondsuit denotes cloud'});
        set(t,'FontSize',18)
        set(t,'FontName','Lato Bold')
        
    case 2 %Air temperature vs height
        compositePlotT = zeros(1,length(compositeSubset)); %Preallocation
        for soundCount=1:length(compositeSubset)
            compositePlotT(soundCount) = plot(compositeSubset(soundCount).temp,compositeSubset(soundCount).height,'Color',colorsToPlot(colorCount,:),'LineWidth',1.9); %Connect the data dots
            hold on
            logicalCloud = compositeSubset(soundCount).rhum>=cloudThreshold; %Logically index based on the threshold value for relative humidity
            cloud = plot(compositeSubset(soundCount).temp(logicalCloud==1),compositeSubset(soundCount).height(logicalCloud==1),'d'); %Cloud points are diamonds
            set(cloud,'Color',colorsToPlot(colorCount,:))
            set(cloud,'MarkerFaceColor',colorsToPlot(colorCount,:))
            set(cloud,'MarkerEdgeColor',colorsToPlot(colorCount,:))
            set(cloud,'MarkerSize',9.6)
            acloud = plot(compositeSubset(soundCount).temp(logicalCloud==0),compositeSubset(soundCount).height(logicalCloud==0),'+'); %Cloud-free points are pluses
            set(acloud,'Color',colorsToPlot(colorCount,:))
            set(acloud,'MarkerFaceColor',colorsToPlot(colorCount,:))
            set(acloud,'MarkerSize',9.6)
            hold on
            colorCount = colorCount+1; %Increment the color
        end
        
        axe = gca;
        set(axe,'FontSize',18)
        set(axe,'FontName','Lato')
        
        degreeSymbol = char(176);
        x = xlabel(['Air temperature (' degreeSymbol 'C)']); %x-axis is air temperature
        set(x,'FontSize',18)
        set(x,'FontName','Lato')
        yl = ylabel('Height (km)'); %y-axis is km
        set(yl,'FontSize',18)
        set(yl,'FontName','Lato')
        
        t = title({'Air Temperature vs Height';'+ denotes no cloud, \diamondsuit denotes cloud'});
        set(t,'FontSize',18)
        set(t,'FontName','Lato Bold')
        
    case 3 %Wetbulb temperature and air temperature vs height
        compositePlotT = zeros(1,length(compositeSubset)); %Preallocation
        for soundCount=1:length(compositeSubset)
            compositePlotT(soundCount) = plot(compositeSubset(soundCount).temp,compositeSubset(soundCount).height,'Color',colorsToPlot(colorCount,:),'LineWidth',1.9); %Connect the data dots
            hold on
            compositePlotTw = plot(compositeSubset(soundCount).wetbulb,compositeSubset(soundCount).height,'Color',colorsToPlot(colorCount,:),'LineWidth',1.9); %Connect the data dots
            set(compositePlotTw,'LineStyle','--') %Set wetbulb to be a dashed line
            hold on
            logicalCloud = compositeSubset(soundCount).rhum>=cloudThreshold; %Logically index based on the threshold value for relative humidity
            if isempty(nonzeros(logicalCloud))==1
                %Do nothing
            else
                cloudT = plot(compositeSubset(soundCount).temp(logicalCloud==1),compositeSubset(soundCount).height(logicalCloud==1),'d'); %Cloud points are diamonds
                set(cloudT,'Color',colorsToPlot(colorCount,:))
                set(cloudT,'MarkerFaceColor',colorsToPlot(colorCount,:))
                set(cloudT,'MarkerSize',9.6)
                cloudTw = plot(compositeSubset(soundCount).wetbulb(logicalCloud==1),compositeSubset(soundCount).height(logicalCloud==1),'d'); %Cloud points are diamonds
                set(cloudTw,'Color',colorsToPlot(colorCount,:))
                set(cloudTw,'MarkerFaceColor',colorsToPlot(colorCount,:))
                set(cloudTw,'MarkerSize',9.6)
            end
            acloudT = plot(compositeSubset(soundCount).temp(logicalCloud==0),compositeSubset(soundCount).height(logicalCloud==0),'+'); %Cloud-free points are pluses
            set(acloudT,'Color',colorsToPlot(colorCount,:))
            set(acloudT,'MarkerFaceColor',colorsToPlot(colorCount,:))
            set(acloudT,'MarkerSize',9.6)
            acloudTw = plot(compositeSubset(soundCount).wetbulb(logicalCloud==0),compositeSubset(soundCount).height(logicalCloud==0),'+'); %Cloud-free points are pluses
            set(acloudTw,'Color',colorsToPlot(colorCount,:))
            set(acloudTw,'MarkerFaceColor',colorsToPlot(colorCount,:))
            set(acloudTw,'MarkerSize',9.6)
            hold on
            colorCount = colorCount+1; %Increment the color
        end
           
        axe = gca;
        set(axe,'FontSize',18)
        set(axe,'FontName','Lato')
         
        degreeSymbol = char(176);
        x = xlabel(['Temperature (' degreeSymbol 'C)']); %x-axis is temperature
        set(x,'FontSize',18)
        set(x,'FontName','Lato')
        yl = ylabel('Height (km)'); %y-axis is km
        set(yl,'FontSize',18)
        set(yl,'FontName','Lato')
        
        t = title({'Air Temperature and Wetbulb Temperature vs Height';'+ denotes no cloud, \diamondsuit denotes cloud'});
        set(t,'FontSize',18)
        set(t,'FontName','Lato Bold')
end

%xlim([-5 18]) %Changes the limits on the degrees Celsius axis. This often needs to be changed to enhance visibility, as no single span will work well across all months and locations.
xlim([-18 14])
ylim([0 4]) %Changes the limits on the height axis. 0 to 4km or 0 to 5km are standard.

switch tempType %Build the legend
    case 1 %Wetbulb temperature uses compositePlotTw variable
        leg = legend(compositePlotTw,dateStrings);
        set(leg,'FontSize',10)
        set(leg,'FontName','Lato')
    otherwise %Both and air temperature both use compositePlotT variable
        leg = legend(compositePlotT,dateStrings);
        set(leg,'FontSize',10)
        set(leg,'FontName','Lato')
end

end
