%%findTheCloud
    %Function to locate cloud layers for a sounding given an input time and
    %sounding structure.
    %
    %General form: [cloudLB,cloudUB] = findTheCloud(y,m,d,h,soundStruct)
    %
    %Outputs:
    %cloudLB: Array containing the lower bounds for all cloud layers in km (or NaN if none are found).
    %cloudUB: Array containing the upper bounds for all cloud layers in km (or NaN if none are found).
    %
    %Inputs:
    %y: 4-digit year
    %m: 1 or 2 digit month
    %d: 1 or 2 digit day
    %h: 1 or 2 digit hour
    %soundStruct: Sounding structure which must already contain relative
    %   humidity and height data.
    %
    %Cloud layers can be plotted using the cloudplot function.
    %
    %Version date: 4/21/2018
    %Last major revision: 4/21/2018
    %Written by: Daniel Hueholt
    %North Carolina State University
    %Undergraduate Research Assistant at Environment Analytics
    %
    %See also addDew, addHeight, cloudplot
    %

function [cloudLB,cloudUB] = findTheCloud(y,m,d,h,soundStruct)

[numdex] = findsnd(y,m,d,h,soundStruct); %find the index of the sounding for the input time

if isnan(numdex)==1 %If the input time can't be found in the structure
    msg  = 'The input time was not found in the structure(s)!';
    error(msg)
end

top = 11; %11km is a plausible value for height of the tropopause
validHeights = soundStruct(numdex).height<=top; %Logically index on 1 for values underneath the top and 0 over the top 
hums = soundStruct(numdex).rhum(validHeights); %Grab humidities corresponding to height<top
heights = soundStruct(numdex).height(validHeights); %Grab heights corresponding to height<top

cloudsaf = [80 80]; %This is the cloud threshold relative humidity value in %
cloudx = [0 13]; %height
cloudy = ones(1,length(cloudx)).*cloudsaf; %cloud line

%NaN entries in the height data and humidity data must be synced up or polyxpoly will fail
nanHums = hums;
nanHeights = heights;
nanHums(isnan(hums)==1) = 1; %Logically index on NaN values
nanHeights(isnan(heights)==1) = 1;
heights(nanHums==1) = NaN; %Make the height data NaN where the humidity data is NaN
hums(nanHeights==1) = NaN; %Make the humidity data NaN where the height data is NaN

try
    [x,~] = polyxpoly(heights,hums,cloudx,cloudy); %Solves for the intersections between the relative humidity-height line and the constant cloud line
catch ME; %If polyxpoly fails, give an interesting error message
    msg = 'Error finding cloud layers! Please check data and inputs then try again.';
    error(msg)
end

if isempty(x)==1 %x is empty if polyxpoly fails
    noCloudMsg = 'No cloud detected for the input time!';
    disp(noCloudMsg)
    cloudLB = NaN; cloudUB = NaN; %NaN for outputs
    return
end

if length(x)/2~=floor(length(x)/2) %If the length of x is odd
    evenIndices = 2:2:length(x)-1;
    oddIndices = 1:2:length(x);
else %If the length of x is even
    evenIndices = 2:2:length(x);
    oddIndices = 1:2:length(x)-1;
end

if hums(1)>=cloudsaf(1) %If there is fog at the surface
    fog = 1;
else
    fog = 0;
end

switch fog
    case 1 %If there is fog at the surface, then the first height index is the first cloud lower bound
        cloudLB = vertcat(heights(1),x(evenIndices));
        cloudUB = x(oddIndices);
    case 0 %If there is no fog at the surface, then the first height index is the first odd index, that is, the first index in the output from polyxpoly
        cloudLB = x(oddIndices);
        cloudUB = x(evenIndices);
end

end