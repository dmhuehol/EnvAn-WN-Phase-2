%ASOSimport5 another approach


filename = 'C:\Users\danielholt\Documents\MATLAB\Project 1 - Warm Noses\Surface Obs\64010KHWV201101.dat';
%filename = 'C:\Users\danielholt\Documents\MATLAB\Project 1 - Warm Noses\Surface Obs\64010K12N201201.dat';


fileID = fopen(filename);
formatString = '%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%[^\n\r]';
ASOSraw = textscan(fileID,formatString);
fclose(fileID);


fieldnamesBasic = {'a' 'b' 'c' 'd' 'e' 'f' 'g' 'h' 'i' 'j' 'k' 'l' 'm' 'n' 'o' 'p' 'q' 'r' 's' 't' 'u' 'v' 'w' 'x' 'y' 'z' 'aa' 'bb' 'cc' 'dd' 'ee'};
fieldnamesTrue = {'NCDCnum' 'CallSign' 'StationCallSign' 'Year' 'Month' 'Day' 'Hour' 'Minute' 'RecordLength' 'Date' 'ZuluTime' 'ReportType' 'StationCallSignReprise' 'ObservationType' 'EstimatedWind' 'WindDirection' 'WindSpeed' 'WindCharacter' 'WindCharSpeed' 'WindUnits' 'Visibility' 'PresentWeather' 'SkyCondition' 'Temperature' 'Dewpoint' 'Altimeter' 'UnknownOne' 'RelativeHumidity' 'UnknownTwo' 'WindDirectionMagnetic' 'WindSpeedMagnetic' 'WindCharacterMagnetic' 'WindCharacterSpeedMagnetic' 'Remarks'};
fieldnamesSave = {'DateTime' 'WindDirection' 'WindSpeed' 'WindCharacter' 'WindCharacterSpeed' 'Visibility' 'PresentWeather' 'SkyCondition' 'Temperature' 'Dewpoint' 'Altimeter' 'UnknownOne' 'RelativeHumidity' 'UnknownTwo' 'Remarks'}; 
ASOSstruct = cell2struct(ASOSraw,fieldnamesBasic,2);


%% Build the final data structure
numberOfRows = length(ASOSstruct.a);
ASOS.Identifier = ASOSstruct.a; %Identifier (NCDC number and call sign) is properly dealt with by textscan

