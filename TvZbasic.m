%%TvZbasic
    %Function to create a temperature vs height plot for a sounding, given
    %an input date and a data structure, with basic plot settings to make
    %customization for making printable figures easy.
    %
    %General form: [foundit] = TvZbasic(y,m,d,t,sounding,kmTop)
    %
    %Output:
    %foundit: the index of the sounding corresponding to the time
    %
    %Inputs:
    %y: four digit year
    %m: two digit month
    %d: one or two digit day
    %t: one or two digit time
    %sounding: a structure of soundings data, as created by fullIGRAimp, etc
    %kmTop: OPTIONAL INPUT to specify maximum height to be plotted,
        %defaults to 5km
    %
    %This is the same as TvZ, with some plot settings changed.
    %
    %Version Date: 6/21/2018
    %Last major revision: 6/20/2018
    %Written by: Daniel Hueholt
    %North Carolina State University
    %Undergraduate Research Assistant at Environment Analytics
    %
    %See also fullIGRAimp, soundplots
    %

function [foundit] = TvZbasic(y,m,d,t,sounding,kmTop)

% Checks relating to the kmTop input
if exist('kmTop','var')==0 %Default height is 5 km
    kmTop = 5;
    disp('Maximum height value defaulted to 5 km.')
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
f = figure;
TvZ = plot(useTemp,useGeo); %TvZ
set(TvZ,'Color','b')
set(TvZ,'LineWidth',3)
hold on
freezingLine = plot(freezingy,freezingx); %Freezing line
set(freezingLine,'Color','r')
set(freezingLine,'LineWidth',2.5)

xlabel('Temperature in C')
ylabel('Height in km')
ylim([0 kmTop]);
hold off

end