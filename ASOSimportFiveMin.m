filename = 'C:\Users\danielholt\Documents\MATLAB\Project 1 - Warm Noses\Surface Obs\64010KHWV201101.dat';

%function [surfaceObs] = ASOSimportFiveMin(filename)
surfaceObsRaw = fileread(filename); %Imports the file as a raw block of characters
surfaceObs = struct([]);
%characters 1:25 are the same every time
%characters 26 27 28 are the record length
%characters 29+record length are the data and remarks
% 
ncdcNumberExp = '\d{5}'; %54790
callSignExp = '[A-Z]{4}'; %KHWV
[firstGroup,otherObsRaw] = regexp(surfaceObsRaw,[ncdcNumberExp callSignExp],'match','split');
firstGroup = cell2mat(firstGroup);
[ncdcNumber,callSign] = regexp(firstGroup,ncdcNumberExp,'match','split');

callSign(1) = [];
otherObsRaw(1) = [];
otherObsRaw = cell2mat(otherObsRaw);

stationCallSignExp = '[A-Z]{3}'; %HWV
yearMonthDayHourMinExp = '\d{12}'; %201501010000
recordLengthExp = '\d{3}'; %117
dateTimeStringExp = '[0123456789/]{8}\s[0123456789:]{8}'; %01/01/15 00:00:31

[secondGroup,otherObsRaw] = regexp(otherObsRaw,[stationCallSignExp yearMonthDayHourMinExp recordLengthExp dateTimeStringExp],'match','split');
secondGroup = cell2mat(secondGroup);
stationCallSign = regexp(secondGroup,stationCallSignExp,'match');
[yearMonthDayHourMinExp,secondRemains] = regexp(secondGroup,yearMonthDayHourMinExp,'match','split');
secondRemains(1) = [];
secondRemains = cell2mat(secondRemains);
recordLength = regexp(secondRemains,recordLengthExp,'match');
dateTimeString = regexp(secondRemains,dateTimeStringExp,'match');

otherObsRaw(1) = [];
otherObsRaw = cell2mat(otherObsRaw);

reportTypeExp = '[5MIN\-]{5}'; %5-MIN
%ANOTHER CALL SIGN

[thirdGroup,otherObsRaw] = regexp(otherObsRaw,[reportTypeExp '\s' callSignExp],'match','split');
thirdGroup = cell2mat(thirdGroup);
[reportType,~] = regexp(thirdGroup,reportTypeExp,'match','split');

otherObsRaw(1) = [];
otherObsRaw = cell2mat(otherObsRaw);

zuluTimeExp = '\d{6}[Z]{1}'; %010500Z
observationTypeExp = '[AUTO]{4}'; %AUTO
estimatedWindExp = '[E]{0,1}'; %OPTIONAL

[fourthGroup,otherObsRaw] = regexp(otherObsRaw,[zuluTimeExp '\s' observationTypeExp '\s' estimatedWindExp],'match','split');
fourthGroup = cell2mat(fourthGroup);
[zuluTime,fourthRemains] = regexp(fourthGroup,zuluTimeExp,'match','split');
fourthRemains(1) = [];
[observationType,fourthRemains] = regexp(fourthRemains,observationTypeExp,'match','split');
if isequal(fourthRemains{1:end},{' ' ' '})~=1 %Check if there are any estimated wind values
    fourthRemains(1) = [];
    estimatedWind = regexp(fourthRemains,estimatedWindExp,'match');
else
    estimatedWind = [];
end

otherObsRaw(1) = [];
otherObsRaw = cell2mat(otherObsRaw);

windDirSpeedCharUnitExp = '((VRB){0,1}\d{0,6}\w{0,4}(KT){1}){1}\s?(\d{3}V{1}\d{3}){0,1}'; %28004KT 28004G34KT 28004G123KT
aaaAHH = '((VRB){0,1}\d{0,6}\w{0,4}(KT){1}){1}\s?(\d{3}V{1}\d{3}){0,1}\s\w{3,4}|(\d{1,2}(SM))|\d{5}(KT)\s(\d{1} \d{1}\/\d{1}SM)';

[dataLines] = regexp(otherObsRaw,'\n','split');
dataLines(end) = [];

windFieldExp = '(VRB){0,1}\d{0,5}[GQ]{0,1}\d{2,3}KT'; %Wind direction, wind speed, wind character, wind character speed
windField = cell(1,length(dataLines));

for lineByLine = 1:length(dataLines)
    [windField{lineByLine}] = regexp(dataLines{lineByLine},windFieldExp,'match');
end

% visibilityExp = '[01234579/ SM<+]{4,7}'; %10SM 2 3/4SM 1/4SM <1/4SM
% presentWeather = '[-+]?\w{2,6}'; %OPTIONAL ZR- RA+ RA SN PL ZRPL etc
% skyCondition = '[CLR]{3}|[A-Z]{3}\d{3}'; %BKN034
% tempAndDewpoint = 'M{0,1}\d{2}\/{1}M{0,1}\d{2}'; %M04/M12
% altimeter = 'A{1}\d{4}'; %A3018
% unknownOne = '-?\d{1,3}'; %-150 MEANING UNKNOWN
% relativeHumidity = '\d{2}'; %55
% unknownTwo = '-?\d{1,4}'; %-2500 MEANING UNKNOWN
% magneticWindDirSpeedCharUnit = '\d{3}\/{1}\d{2}[GQ]{0,1}\d{0,3}'; %290/04G23 290/04
% remarks = 'RMK.*';
% 
% 
% %54790KHWV HWV20150101000011701/01/15 00:00:31  5-MIN KHWV 010500Z AUTO 28004KT 10SM CLR M04/M12 A3018 -150 55 -2500 290/04 RMK AO2 T10441122 TSNO
% %matches
% %\d{5}\w{4}\s[01234567890A-Z]{15}\d{3}[0123456789/]{8}\s[0123456789:]{8}\s\s[5MIN\-]{5}\s\w{4}\s\d{6}[zZ]{1}\s[AUTO]{4}\s[E]{0,1}\d{5}[GQ]{0,1}\d{0,3}[KT]{2}\s[01234579/ SM<+]{4,7}\s[CLRFEWSCTBKNOVC]{3}\d{0,3}\sM{0,1}\d{2}\/{1}M{0,1}\d{2}\sA{1}\d{4}\s-?\d{1,3}\s\d{2}\s-?\d{1,4}\s\d{3}\/{1}\d{2}[GQ]{0,1}\d{0,3}\sRMK.*
% %54790KHWV HWV20150101034513201/01/15 03:45:31  5-MIN KHWV 010845Z AUTO 26007KT 10SM UP CLR M04/M12 A3013 -100 52 -2400 270/07 RMK AO2 UPB38 P0000 T10391122 TSNO
% %matches
% %\d{5}\w{4}\s[01234567890A-Z]{15}\d{3}[0123456789/]{8}\s[0123456789:]{8}\s\s[5MIN\-]{5}\s\w{4}\s\d{6}[zZ]{1}\s[AUTO]{4}\s[E]{0,1}\d{5}[GQ]{0,1}\d{0,3}[KT]{2}\s[01234579/ SM<+]{3,7}\s(?:\w{6}|\w{4}|\w{2})\s[CLRFEWSCTBKNOVC]{3}\d{0,3}\sM{0,1}\d{2}\/{1}M{0,1}\d{2}\sA{1}\d{4}\s-?\d{1,3}\s\d{2}\s-?\d{1,4}\s\d{3}\/{1}\d{2}[GQ]{0,1}\d{0,3}\sRMK.*
% %54790KHWV HWV20150104081015301/04/15 08:10:31  5-MIN KHWV 041310Z AUTO 24009KT 3SM RA BR SCT007 BKN014 OVC043 09/08 A2997 40 93 -500 250/09 RMK AO2 RAB00 PRESRR P0003 T00940083 TSNO
% %matches
% %\d{5}\w{4}\s[01234567890A-Z]{15}\d{3}[0123456789/]{8}\s[0123456789:]{8}\s\s[5MIN\-]{5}\s\w{4}\s\d{6}[zZ]{1}\s[AUTO]{4}\s[E]{0,1}\d{5}[GQ]{0,1}\d{0,3}[KT]{2}\s[01234579/ SM<+]{3,7}\s(?:\w{6}|\w{4}|\w{2}\s){1,2}([CLR]{3}|[FEWSCTBKNOVC]{3}\d{3}\s){1,3}M{0,1}\d{2}\/{1}M{0,1}\d{2}\sA{1}\d{4}\s-?\d{1,3}\s\d{2}\s-?\d{1,4}\s\d{3}\/{1}\d{2}[GQ]{0,1}\d{0,3}\sRMK.*
% 
% 
% [banaynay] = regexp(surfaceObsRaw(1:13),expression,'match');