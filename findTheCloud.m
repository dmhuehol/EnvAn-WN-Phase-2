function [cloudLB,cloudUB] = findTheCloud(y,m,d,h,soundStruct,plotCNCN)
datenumber = datenum(y,m,d,h,0,0);

try
    [numdex] = findsnd(y,m,d,h,soundStruct); %find the index of the sounding for the input time
catch ME; %#ok
    disp([y m d h]);
    return %findsnd will take care of the warning message
end

top = 13;
validHeights = soundStruct(numdex).height<=top;
hums = soundStruct(numdex).rhum(validHeights);
heights = soundStruct(numdex).height(validHeights);

cloudsaf = [80 80];
cloudx = [0 13]; %height
cloudy = ones(1,length(cloudx)).*cloudsaf; %freezing line (z) 

[x,~] = polyxpoly(heights,hums,cloudx,cloudy);

if length(x)/2~=floor(length(x)/2)
    evensInd = 2:2:length(x)-1;
    oddsInd = 1:2:length(x);
else
    evensInd = 2:2:length(x);
    oddsInd = 1:2:length(x)-1;
end

if hums(1)>=cloudsaf(1)
    fog = 1;
else
    fog = 0;
end

switch fog
    case 1
        cloudLB = vertcat(heights(1),x(evensInd));
        cloudUB = x(oddsInd);
    case 0
        cloudLB = x(evensInd);
        cloudUB = x(oddsInd);
end

end