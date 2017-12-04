%%TTwvZ
    %Function to plot temperature and wetbulb temperature against height
    %given an input date and soundings structure. Additionally, allows for
    %user control of the maximum height plotted.
    %
    %General form: [foundit] = TTwvZ(y,m,d,t,sounding,kmTop)
    %
    %Output:
    %foundit: the index of the sounding corresponding to the time
    %
    %Inputs:
    %y: four digit year
    %m: two digit month
    %d: one or two digit day
    %t: one or two digit time
    %sounding: a structure of soundings data with wetbulb temperature
    %kmTop: OPTIONAL maximum km to plot. Defaults to 13km (roughly the
    %boundary of the troposphere); melting layers at Long Island are always
    %within 5km.
    %
    %
    %Version Date: 11/28/17
    %Written by: Daniel Hueholt
    %North Carolina State University
    %Undergraduate Research Assistant at Environment Analytics
    %
    %See also fullIGRAimp, wetbulb, addWetbulb
    %

function [foundit] = TTwvZ(y,m,d,t,sounding,kmTop)
if exist('kmTop','var')==0
    kmTop = 13;
end
if kmTop>13
    disp('Maximum allowed km is 13!')
    kmTop = 13;
end
if kmTop<0
    disp('Negative km is not allowed!')
    kmTop = 13;
end
kmTop = round(kmTop);

[r,~] = size(sounding); %Find the number of soundings
if r==1 %If it's oriented the other way
    [~,r] = size(sounding); %Find it this way instead
end
check = fieldnames(sounding);
if isempty(nonzeros(ismember(check,'rhum'))) == 1 %Check if the sounding has a relative humidity field, named rhum if generated by dewrelh
    for a = 1:r
        [sounding(a).dewpoint,sounding(a).relative_humidity] = dewrelh(sounding(a).temp,sounding(a).dew_point_dep); %Call to dewrelh to add dewpoint and relative humidity, if necessary
    end
end

for as = 1:r %Loop through everything
    dateString{as} = sounding(as).valid_date_num;
    if isequal(dateString{as},[y,m,d,t])==1 %Look for the requested date
        foundit = as; %here it is!
        disp(foundit) %Show it just in case there wasn't an output call
        break %Don't loop longer than necessary
    else
        %do nothing
    end
end

if ~exist('foundit','var') %If the date doesn't have a corresponding entry in the sounding structure, foundit won't exist
    disp('No data available for this date!')
    return %Stop the function from running any more
end

mb200 = find(sounding(foundit).pressure >= 20000); %Find indices of readings where the pressure is greater than 20000 Pa
presheight = sounding(foundit).pressure(mb200); %Select readings greater than 20000 Pa
presheightvector = presheight/100; %Convert Pa to hPa (mb)

% First geopotential height entry should be straight from the data, if possible
if isnan(sounding(foundit).geopotential(1))==0
    geoheightvector(1) = sounding(foundit).geopotential(1)/1000;
    %disp('1 is good')
elseif isnan(sounding(foundit).geopotential(1))==1 && isnan(sounding(foundit).geopotential(2))==0
    geoheightvector(1) = sounding(foundit).geopotential(2)/1000;
    %disp('2 is good')
    %disp(foundit)
elseif isnan(sounding(foundit).geopotential(1))==1 && isnan(sounding(foundit).geopotential(2))==1 && isnan(sounding(foundit).geopotential(3))==0
    geoheightvector(1) = sounding(foundit).geopotential(3)/1000;
    %disp('all the way to 3')
    %disp(foundit)
else
    %disp('This data is really bad! Wow!')
    %disp(foundit)
end

geoheightvector = geoheightvector'; %transpose to match shape of others, important for polyxpoly

%define temp as the temperatures from the surface to 200 mb
prestemp = sounding(foundit).temp(mb200);
geotemp = sounding(foundit).temp(mb200);
geowet = sounding(foundit).wetbulb(mb200);

R = 287.75; %dry air constant J/(kgK)
grav = 9.81; %gravity m/s^2

for z = 2:length(presheightvector')
    %geoheightvector(z) = 8*log(presheightvector(1)/presheightvector(z)); %calculate height data based on the pressure height; this prevents loss of warmnoses based on the sparse height readings available in the IGRA dataset
    geoheightvector(z) = (R/grav*(((geotemp(1)+273.15)+(geotemp(z)+273.15))/2)*log(presheightvector(1)/presheightvector(z)))/1000; %Equation comes from Durre and Yin (2008) http://journals.ametsoc.org/doi/pdf/10.1175/2008BAMS2603.1
end

% Extra quality control to prevent jumps in the graphs
geoheightvector(geoheightvector<-150) = NaN;
geoheightvector(geoheightvector>100) = NaN;
presheightvector(presheightvector<0) = NaN;
prestemp(prestemp<-150) = NaN;
prestemp(prestemp>100) = NaN;
geotemp(geotemp<-150) = NaN;
geotemp(geotemp>100) = NaN;
sounding(foundit).rhum(sounding(foundit).rhum<0) = NaN;
sounding(foundit).dewpt(sounding(foundit).dewpt<-150) = NaN;
sounding(foundit).temp(sounding(foundit).temp<-150) = NaN;

%Freezing line for Tvz and TvP charts
freezingxg = [0 16];
freezingyg = ones(1,length(freezingxg)).*0;

% Plotting
randomFig = randi(10,100,1); %Generates a random number
figNumber = randomFig(1);
f9034 = figure(figNumber); %New figure, numbered randomly to reduce the risk of overwriting a currently-open figure when opening several TvZ figures at once
plot(geotemp,geoheightvector,'--','Color',[255 128 0]./255)
hold on
plot(freezingyg,freezingxg,'Color',[1 0 0]) %Tvz
hold on
plot(geowet,geoheightvector,'b');
legend('Temperature','Freezing','Wetbulb')
dateString = num2str(sounding(foundit).valid_date_num); %For title
titleHand = title(['Sounding for ' dateString]);
set(titleHand,'FontName','Helvetica'); set(titleHand,'FontSize',20)
xlabHand = xlabel('Temperature in C');
set(xlabHand,'FontName','Helvetica'); set(xlabHand,'FontSize',20)
ylabHand = ylabel('Height in km');
set(ylabHand,'FontName','Helvetica'); set(ylabHand,'FontSize',20)
limits = [0 kmTop];
ylim(limits);
ax = gca;
rightAx = axes('ylim',limits,'color','none','YAxisLocation','right');
switch kmTop
    case 13
        set(ax,'YTick',[0 0.5 1 1.5 2 2.5 3 3.5 4 4.5 5 7 9 11 13])
        set(rightAx,'YTick',[0 0.5 1 1.5 2 2.5 3 3.5 4 4.5 5 7 9 11 13])
    case 12
        set(ax,'YTick',[0 0.5 1 1.5 2 2.5 3 3.5 4 4.5 5 7 9 11])
        set(rightAx,'YTick',[0 0.5 1 1.5 2 2.5 3 3.5 4 4.5 5 7 9 11])
    case 11
        set(ax,'YTick',[0 0.5 1 1.5 2 2.5 3 3.5 4 4.5 5 7 9 11])
        set(rightAx,'YTick',[0 0.5 1 1.5 2 2.5 3 3.5 4 4.5 5 7 9 11])
    case 10
        set(ax,'YTick',[0 0.5 1 1.5 2 2.5 3 3.5 4 4.5 5 7 9])
        set(rightAx,'YTick',[0 0.5 1 1.5 2 2.5 3 3.5 4 4.5 5 7 9])
    case 9
        set(ax,'YTick',[0 0.5 1 1.5 2 2.5 3 3.5 4 4.5 5 7 9])
        set(rightAx,'YTick',[0 0.5 1 1.5 2 2.5 3 3.5 4 4.5 5 7 9])
    case 8
        set(ax,'YTick',[0 0.5 1 1.5 2 2.5 3 3.5 4 4.5 5 7])
        set(rightAx,'YTick',[0 0.5 1 1.5 2 2.5 3 3.5 4 4.5 5 7])
    case 7
        set(ax,'YTick',[0 0.5 1 1.5 2 2.5 3 3.5 4 4.5 5 7])
        set(rightAx,'YTick',[0 0.5 1 1.5 2 2.5 3 3.5 4 4.5 5 7])
    case 6
        set(ax,'YTick',[0 0.5 1 1.5 2 2.5 3 3.5 4 4.5 5])
        set(rightAx,'YTick',[0 0.5 1 1.5 2 2.5 3 3.5 4 4.5 5])
    case 5
        set(ax,'YTick',[0 0.5 1 1.5 2 2.5 3 3.5 4 4.5 5])
        set(rightAx,'YTick',[0 0.5 1 1.5 2 2.5 3 3.5 4 4.5 5])
    case 4
        set(ax,'YTick',[0 0.5 1 1.5 2 2.5 3 3.5 4])
        set(rightAx,'YTick',[0 0.5 1 1.5 2 2.5 3 3.5 4])
    case 3
        set(ax,'YTick',[0 0.5 1 1.5 2 2.5 3])
        set(rightAx,'YTick',[0 0.5 1 1.5 2 2.5 3])
    case 2
        set(ax,'YTick',[0 0.25 0.5 0.75 1 1.25 1.5 1.75 2])
        set(rightAx,'YTick',[0 0.25 0.5 0.75 1 1.25 1.5 1.75 2])
    case 1
        set(ax,'YTick',[0 0.25 0.5 0.75 1])
        set(rightAx,'YTick',[0 0.25 0.5 0.75 1])
    case 0
        disp('No data displayed!')
        clf
        return
end
set(ax,'XTick',[-70 -60 -50 -40 -30 -20 -10 -5 -4 -3 -2 -1 0 1 2 3 4 5 6 7 10])
set(ax,'FontName','Helvetica'); set(ax,'FontSize',18)
set(rightAx,'XTickLabel',[])
set(rightAx,'XTick',[])
set(rightAx,'FontName','Helvetica'); set(rightAx,'FontSize',18)
hold off

end