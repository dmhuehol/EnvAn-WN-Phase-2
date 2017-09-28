%filename = 'C:\Users\danielholt\Documents\MATLAB\Project 1 - Warm Noses\Surface Obs\64010KHWV201101.dat';

function [ASOSstruct] = ASOSimportFiveMin(filename)
%% Import Data
surfaceObsRaw = fileread(filename); %Imports the file as a raw block of characters
trueExp = '(?<StationID>\d{5}\w{4})\s(?<ExtraID>[A-Z]{3})(?<Year>\d{4})(?<Month>\d{2})(?<Day>\d{2})(?<Time>\d{4})(?<RecordLength>\d{3})(?<DayMonthYear>\d{2}\/\d{2}\/\d{2})\s?(?<HHMMSS>\d{2}:\d{2}:\d{2})\s?\s?(?<ObservationFrequency>5-MIN)\s(?<FurtherID>[A-Z]{4})\s(?<ZuluTime>\d{6}Z)\s(?<ObservationType>AUTO)\s?(?<Wind>(VRB){0,1}\d{0,5}[GQ]{0,1}\d{2,3}KT\s?){0,1}(?<VariableWind>\d{3}V\d{3}\s?){0,1}(?<Visibility>M?\d{1,2}SM|M?\d{1}\s\d{1}\/\d{1}SM|M?\d{1}\/\d{1}SM|\d{1}\s?\d{1}\/\d{1}SM)?\s(?<PresentWeather>-?\+?(VC)?(MI|PR|BC|DR|BL|SH|TS|FZ)?(DZ|RA|SN|SG|IC|PE|GR|GS|UP)?(BR|FG|FU|VA|DU|SA|HZ|PY)?(PO|SQ|FC|SS)?\s?){0,2}(?<SkyCondition>([A-Z]{3}\d{3}|CLR|VV\d{3})\s?){0,3}\s?(?<TemperatureSlashDewpoint>M?\d{0,3}\/M?\d{0,3}|M)?\s?(?<Altimeter>A\d{4}|M)\s?(?<UnknownOne>-?\d{1,4}|M)\s?(?<RelativeHumidity>\d{2}|M|100)\s?(?<UnknownTwo>-?\d{1,4}|M)\s?(?<UnknownThree>M)?\s?(?<MagneticWind>(VRB)?\d{0,3}\/\d{2}[GQ]?\d{0,3}|\/M)\s?(?<MagneticVariableWind>\d{3}V\d{3})?\s?(?<Remarks>RMK.*)'; %THREE WEEKS OF MY LIFE WENT INTO THIS
surfaceStruct = regexp(surfaceObsRaw,trueExp,'names','dotexceptnewline');
%'names' designates structure fields based on the bracketed parts of each token
%'dotexceptnewline' causes each line to be read as a new field in the structure

%% Datatype Conversions
ASOSstruct = struct([]);
for count = 1:length(surfaceStruct)
    ASOSstruct(count).Year = sscanf(surfaceStruct(count).Year,'%4f');
    ASOSstruct(count).Month = sscanf(surfaceStruct(count).Month,'%f');
    ASOSstruct(count).Day = sscanf(surfaceStruct(count).Day,'%f');
end

end
