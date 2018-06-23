%%TvZ
    %Function to create a temperature vs height plot for a sounding given
    %an input date and a data structure.
    %
    %General form: [foundit] = TvZ(y,m,d,t,sounding,kmTop)
    %
    %Output:
    %foundit: the index of the sounding corresponding to the time
    %
    %Inputs:
    %y: four digit year
    %m: two digit month
    %d: one or two digit day
    %t: one or two digit time
    %sounding: a structure of soundings data
    %kmTop: OPTIONAL the maximum height in km to be plotted, defaults to 13 km.
    %
    %Version Date: 6/16/2018
    %Last major revision: 6/16/2018
    %Written by: Daniel Hueholt
    %North Carolina State University
    %Undergraduate Research Assistant at Environment Analytics
    %
    %See also soundplots, TTwvZ, addHeight
    %

function [foundit] = TvZ(y,m,d,t,sounding,kmTop)
% Checks relating to the kmTop input
if exist('kmTop','var')==0 %Default height is 13 km
    kmTop = 13;
    disp('Maximum height value defaulted to 13 km.')
end
if kmTop>13
    disp('Maximum allowed km is 13!')
    kmTop = 13;
elseif kmTop<0
    disp('Negative km is not allowed!')
    kmTop = 13;
elseif kmTop==0
    disp('0 km input is not allowed! Please enter an integer between 0 and 13.')
    return
end
kmTop = round(kmTop); %Fractional kilometers are not allowed

% Collect data to plot
r = length(sounding);
dateString = cell(1,r);
for as = 1:r %Loop through everything
    dateString{as} = sounding(as).valid_date_num;
    if isequal(dateString{as},[y,m,d,t])==1 %Look for the requested date
        foundit = as; %here it is!
        foundMsg = 'Index in structure is ';
        disp([foundMsg num2str(foundit)])
        break %Don't loop longer than necessary
    else
        %do nothing
    end
end

if ~exist('foundit','var') %If the date doesn't have a corresponding entry in the sounding structure, foundit won't exist
    disp('No data available for this date!')
    return %Stop the function from running any more
end

if isfield(sounding,'height')==0 %If height isn't already a field of the sounding
    [sounding] = addHeight(sounding);
end


kmCutoff = logical(sounding(foundit).height <= kmTop+1); %Find indices of readings where the height is less than or equal to the input maximum height, plus one to prevent the plot from cutting off in an ugly way
useGeo = sounding(foundit).height(kmCutoff==1);
useTemp = sounding(foundit).temp(kmCutoff==1);

% Extra quality control to prevent jumps in the graphs
useGeo(useGeo<-150) = NaN;
useGeo(useGeo>100) = NaN;
useTemp(useTemp<-150) = NaN;
useTemp(useTemp>100) = NaN;

% Freezing line
freezingx = [0 16];
freezingy = ones(1,length(freezingx)).*0;

% Plotting
figure;
plot(useTemp,useGeo,'Color','b','LineWidth',2.4); %TvZ
hold on
plot(freezingy,freezingx,'Color','r','LineWidth',2) %Freezing line

% Plot settings
dateString = datestr(datenum(sounding(foundit).valid_date_num(1),sounding(foundit).valid_date_num(2),sounding(foundit).valid_date_num(3),sounding(foundit).valid_date_num(4),0,0),'mmm dd, yyyy HH UTC'); %For title
titleHand = title(['Sounding for ' dateString]);
set(titleHand,'FontName','Lato Bold'); set(titleHand,'FontSize',14);
xlabelHand = xlabel('Temperature in C');
set(xlabelHand,'FontName','Lato Bold'); set(xlabelHand,'FontSize',14);
ylabelHand = ylabel('Height in km');
set(ylabelHand,'FontName','Lato Bold'); set(ylabelHand,'FontSize',14);
axe = gca;
set(axe,'FontName','Lato'); set(axe,'FontSize',12);
set(axe,'YTick',[0 0.5 1 1.5 2 2.5 3 3.5 4 4.5 5 6 7 8 9 10 11 12 13])
set(axe,'XTick',[-45 -40 -35 -30 -25 -22 -20 -18 -16 -14 -12 -10 -8 -6 -5 -4 -3 -2 -1 0 1 2 3 4 5 6 8 10 12 14 16 18 20 22 25 30 35 40])
xlim([min(useTemp)-1 max(useTemp)+1])
ylim([0 kmTop])
set(axe,'box','off')
hold off

end