function [ASOSstruct] = ASOSimportOneMin(input_file)
%%ASOSimport
    %Function to import ASOS one-minute surface data, remove useless
    %elements, and place the useful data into a structure.
    %
    %General form: [ASOSstruct] = ASOSimport(input_file)
    %
    %Output: 
    %ASOSstruct: a length(data) x 1 structure, which contains date, UTC time,
    %precip ID, precip amount, freezing sensor frequency, pressure
    %(3 fields, as measured on 3 sensors), temperature, and dewpoint
    %
    %Input:
    %input_file: file path for ASOS one minute data
    %
    %Station ID, 3-letter ID, time (local), unknown data column (possibly
    %thunder obs), and two trailing blank columns are removed. If any of
    %these are needed, the last place they are present is at the textscan
    %command in line 51.
    %
    %This function works, but the output is far from perfect: times are not
    %processed into datenumbers or separate fields, precip ID codes
    %are not processed to remove spaces or standardize unknowns, nothing
    %has been done with the ice sensor, and no secondary variables such as
    %relative humidity have been calculated. The one-minute dataset turned
    %out to be impractical for our purposes, with the following major flaws:
    %The precip ID frequently cannot discern precipitation type (even in uniform
    %precip cases), and only one precip type is reported at a time
    %(especially problematic given wintry mix is our primary area of
    %research). The ASOS five-minute dataset does not have these problems,
    %and thus my development focused on that. See the code dealing with
    %ASOS five-minute data for more refined data processing.
    %
    %ASOS one-minute documentation can be found at:
    %data.eol.ucar.edu/datafile/nph-get/92.006/td6406.pdf - official documentation
    %www1.ncdc.noaa.gov/pub/data/documentlibrary/tddoc/td3285.pdf - further documentation, especially for precip ID
    %(Links active as of 4/7/2018)
    %
    %Written by: Daniel Hueholt
    %North Carolina State University
    %Undergraduate Research Assistant at Environment Analytics
    %Version date: 4/7/2018
    %Last major revision: 4/7/2018
    %
    %See also ASOSdownloadFiveMin, ASOSgrabber, ASOSimportFiveMin
    %

formatSpec = '%9s%4s%8s%4s%4s%5s%9s%5s%19s%9s%8s%8s%5s%5s%s%[^\n\r]'; %Format for textscan call (I'll admit, this line was MATLAB generated)
fileID = fopen(input_file,'r'); %Open the input file in readable format

dataArray = textscan(fileID, formatSpec, 'Delimiter', '', 'WhiteSpace', '', 'ReturnOnError', false); %Read in the data to a cell array
fclose(fileID); %Close the file

%fields = {'StationID','ISP','Date','EST','UTC','PrecipID','Unknown','PrecipAmt','FrzPrecipFreq','Pressure1','Pressure2','Pressure3','Temp','Dewpoint','Blank1','Blank2'}; %Full list of field names (not used in output)
%realfields = {'Date','UTC','PrecipID','PrecipAmt','FrzFreq','Pressure1','Pressure2','Pressure3','Temp','Dewpoint'}; %Actual fieldnames; not used in the output
dataExtract = {dataArray{3} dataArray{5} dataArray{6} dataArray{8} dataArray{9} dataArray{10} dataArray{11} dataArray{12} dataArray{13} dataArray{14}}; %These are the parts of the cell array that will be used (these line up to the names in realfields)

datemat = cell2mat(dataExtract{1}); %Convert date strings into chars
ASOSstruct.date = str2num(datemat); %#ok %Sometimes str2num is just better, and the code analyzer can go suck a lemon

% The same general process is followed for all data columns: convert the
% string into chars, then convert the chars to doubles
UTCmat = cell2mat(dataExtract{2});
ASOSstruct.UTC = str2num(UTCmat); %#ok

ASOSstruct.precipID = cell2mat(dataExtract{3}); %Precip ID is a text code, so it's left as text

precipAmtmat = cell2mat(dataExtract{4});
for c = 1:length(precipAmtmat) %For loops are not fun, but neither are the [] outputs that str2double, str2num, and sscanf all give when used on the vector form
    ASOSstruct.precipAmt(c,1) = str2double(precipAmtmat(c,1:5));
end

FrzFreqmat = cell2mat(dataExtract{5});
for c = 1:length(FrzFreqmat)
    ASOSstruct.FrzFreq(c,1) = str2double(FrzFreqmat(c,1:end));
end

Pres1mat = cell2mat(dataExtract{6});
Pres2mat = cell2mat(dataExtract{7});
Pres3mat = cell2mat(dataExtract{8});
for c = 1:length(Pres1mat)
    ASOSstruct.Pres1(c,1) = str2double(Pres1mat(c,1:end));
    ASOSstruct.Pres2(c,1) = str2double(Pres2mat(c,1:end));
    ASOSstruct.Pres3(c,1) = str2double(Pres3mat(c,1:end));
end

Tempmat = cell2mat(dataExtract{9});
for c = 1:length(Tempmat)
     ASOSstruct.Temp(c,1) = str2double(Tempmat(c,1:end));
end

Dewpointmat = cell2mat(dataExtract{10});
for c = 1:length(Tempmat)
    ASOSstruct.Dewpoint(c,1) = str2double(Dewpointmat(c,1:end));
end

thisIsDumb = struct2table(ASOSstruct); %Convert the structure to a table
butItWorks = table2struct(thisIsDumb); %and now convert the table to a structure
%The above is v dumb, but it gets the structure format so that individual lines are accessed at ASOSstruct(ELEMENT).variable without using loops

ASOSstruct = butItWorks; %output

end