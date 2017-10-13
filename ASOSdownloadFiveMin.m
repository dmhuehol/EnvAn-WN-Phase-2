%%ASOSdownloadFiveMin
    %Function to download five minute ASOS data from NCDC servers. Requires
    %an Internet connection.
    %
    %General form: ASOSdownloadFiveMin(emailAddress,station,year,month,downloadedFilePath)
    %Inputs:
    %emailAddress: The user's complete email address--functions as a
    %password, as required by the NCDC FTP server.
    %station: Four character station ID, such as KHWV for Brookhaven Airport,
    %or KISP for Islip.
    %year: four-digit year
    %month: OPTIONAL two-digit month (if omitted, function will download an
    %entire year of data).
    %
    %Outputs:
    %None
    %
    %Version Date: 9/15/2017
    %Last major revision: 9/15/2017
    %Written by: Daniel Hueholt
    %North Carolina State University
    %Undergraduate Research Assistant at Environment Analytics
    %
    
function [] = ASOSdownloadFiveMin(downloadedFilePath,emailAddress,station,year,month,varargin)
% Check for month presence
if exist('month','var')==0 %This way, the spendy exist function only needs to be called once
    monthPresence = 0;
else
    monthPresence = 1;
end
% Check for file path to place data files in
if exist('downloadedFilePath','var')==0
    downloadedFilePath = pwd; %Set the default file directory to the working directory
end

% For making paths, strings, and path strings
slash = '/';
dash = '-';
obsType = '6401';
zeroChar = '0';
space = ' ';
Y = 'Y'; %#ok
N = 'N'; %#ok
fileExtension = '.dat';

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
    obsFilename = [obsType zeroChar station yearString monthString fileExtension]; %If month is present, download the specific month file.
else
    obsFilename = [obsType zeroChar station yearString '*' fileExtension]; %If month is omitted, download the entire year.
end

ftpNCDC = ftp('ftp.ncdc.noaa.gov','anonymous',emailAddress); %Opens an FTP connection to the NCDC server
cd(ftpNCDC,fiveMinPath); %Changes folder to the ASOS five minute data
cd(ftpNCDC,yearPath); %Changes folder to the year path
mget(ftpNCDC,obsFilename,downloadedFilePath); %Downloads target file(s) to the specified file path
close(ftpNCDC) %Closes FTP connection

completeMessage = 'Download complete!';
disp(completeMessage);
end
    