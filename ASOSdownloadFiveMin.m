%%ASOSdownloadFiveMin
    %Function to download five minute ASOS data from NCDC servers. Requires
    %an Internet connection.
    %Written by: Daniel Hueholt
    %North Carolina State University
    %Undergraduate Research Assistant at Environment Analytics
    %Version Date: 9/13/17
    
function [] = ASOSdownloadFiveMin(emailAddress,station,year,month,varargin)
% Check for month presence
if exist('month','var')==0 %This way, the spendy exist function only needs to be called once
    monthPresence = 0;
else
    monthPresence = 1;
end

% For making paths, strings, and path strings
slash = '/';
dash = '-';
obsType = '6401';
zeroChar = '0';
space = ' ';
Y = 'Y'; %#ok
N = 'N'; %#ok

% If month isn't entered, check with user to be sure that they want to download a year
if monthPresence == 0
    wholeYearMessageFirst = 'Current input will download all data from ';
    yearString = num2str(year);
    wholeYearMessageBegin = [wholeYearMessageFirst,space,yearString];
    wholeYearMessageEnd = '. Continue, Y/N?';
    wholeYearMessage = strcat(wholeYearMessageBegin,wholeYearMessageEnd);
    YN = input(wholeYearMessage);
    if strcmp(YN,'Y')==1 || strcmp(YN,'y')==1 || strcmp(YN,'Yes')==1 || strcmp(YN,'yes')==1
        %Do nothing
    elseif strcmp(YN,'N')==1 || strcmp(YN,'n')==1 || strcmp(YN,'No')==1 || strcmp(YN,'no')==1
        return %In this case the user has entered 'N'
    end
else
    %do nothing
end

% Ensure two-digit month
if monthPresence == 1 %If there is an input month
    monthString = num2str(month);
    if numel(monthString)==1 %Check the number of digits in month
        monthString = strcat(zeroChar,monthString); %Add a leading zero if month is one-digit
    end
end

% Set up file paths
fiveMinPath = '/pub/data/asos-fivemin/'; %Path to five minute data on FTP server
yearPrefix = strcat(obsType,dash); %ASOS data is stored by year in folders with the prefix 6401-. For example, 2015 data is stored in the folder 6401-2015.
yearString = num2str(year); yearDirString = strcat(yearPrefix,yearString); %Creates the year directory string by concatenating the prefix and the input year
yearPath = strcat(fiveMinPath,yearDirString); %This is the path for the input year
if monthPresence==1
    obsFilename = [obsType zeroChar station yearString monthString];
else
    obsFilename = [obsType zeroChar station yearString '*'];
end

%ftpNCDC = ftp('ftp.ncdc.noaa.gov','anonymous',emailAddress); %Opens an FTP connection to the NCDC server
%cd(ftpNCDC,fiveMinPath); %Changes folder to the ASOS five minute data
%cd(ftpNCDC,yearPath)

%close(ftpNCDC)
completeMessage = 'Completed!'
end
    