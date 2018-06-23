%%extractWarmCloud
    %Given a sounding structure (which must already be processed for
    %wetbulb temperature), creates a structure containing the following
    %fields:
    %   valid_date_num: year,month,day,hour corresponding to sounding time
    %   warmHeights: heights corresponding to points with air temperature above 0 degC
    %   warmTemps: temperature entries above 0 degC (correspond to height entries)
    %   warmWetbulbs: wetbulb temperature entries above 0 degC
    %      (corresponding to warmwetHeights)
    %   warmwetHeights: heights corresponding to points with wetbulb temperature above 0 degC
    %   cloudHeights: heights corresponding to points with relative humidity above 80%
    %   cloudTemps: temperatures corresponding to points with relative humidity greater than 80%
    %   cloudWetbulbs: wetbulb temperatures corresponding to points with relative humidity greater than 80%
    %   warmcloudHeights: heights corresponding to points with relative
    %      humidity above 80% and temperature above 0 degC
    %   warmwetcloudHeights: heights corresponding to points with relative
    %      humidity above 80% and wetbulb temperature above 0 degC
    %   warmcloudTemps: temperatures corresponding to points with relative
    %      humidity greater than 80% and temperature above 0 degC
    %   warmcloudWetbulbs: wetbulb temperatures corresponding to points with relative
    %      humidity greater than 80% and wetbulb temperature above 0 degC
    %   warmPoints: indices where temperature is above 0 degC
    %   cloudPoints: indices where relative humidity is above 80%
    %   warmcloudPoints: indices where temperature is above 0 degC and
    %      relative humidity is more than 80%
    %
    %General form: [infoStruct] = extractWarmCloud(soundingStruct)
    %
    %Output:
    %infoStruct: Structure containing the fields described above.
    %
    %Input:
    %soundingStruct: Soundings data structure which must already contain
    %   wetbulb temperature.
    %
    %Version date: 4/21/2018
    %Last major revision: 4/21/2018
    %Written by: Daniel Hueholt
    %North Carolina State University
    %Undergraduate Research Assistant at Environment Analytics
    %
    %See also addWetbulb, findTheCloud
    %

function [infoStruct] = extractWarmCloud(soundingStruct)

infoStruct = struct([]); %Instantiate a structure
statCount = 1; %Counter to be manually controlled in a loop

for count = 1:length(soundingStruct) %Loop through the input structure
    infoStruct(statCount).valid_date_num = soundingStruct(count).valid_date_num; %Datenumber is the same in both 
    warmTempPoints = soundingStruct(count).temp>=0; %Logically index on points greater than 0 degC; 1 is warmer, 0 is colder
    if isempty(nonzeros(warmTempPoints))==1 %If the entire sounding is colder than 0 degC
        statCount = statCount+1; %Increment the counter; this keeps the sounding numbers constant between the output and input structures
        continue %Skip, go to the next sounding
    end
    infoStruct(statCount).warmHeights = soundingStruct(count).height(warmTempPoints); %Grab heights corresponding to temperature above 0 degC
    infoStruct(statCount).warmTemps = soundingStruct(count).temp(warmTempPoints); %Grab heights corresponding to temperature above 0 degC
    
    try
        warmWetbulbPoints = soundingStruct(count).wetbulb>=0; %Logically index on points greater than 0degC in the wetbulb data; 1 is warmer, 0 is colder
        infoStruct(statCount).warmWetbulbs = double(soundingStruct(count).wetbulb(warmWetbulbPoints)); %Convert from symbol to double
        infoStruct(statCount).warmWetbulbs = infoStruct(statCount).warmWetbulbs'; %Transpose to match shape
        infoStruct(statCount).warmwetHeights = soundingStruct(count).height(warmWetbulbPoints); %Grab heights corresponding to wetbulb temperature above 0 degC
    catch ME; %#ok
        warmWetMsg = ['Failed to extract warm wetbulb temperature information for following sounding number: ' num2str(count)];
        disp(warmWetMsg)   
    end
    
    try
        cloudPoints = soundingStruct(count).rhum>80; %Logically index on points greater than 80% in the humidity data; 1 is greater, 0 is colder
        infoStruct(statCount).cloudHeights = soundingStruct(count).height(cloudPoints); %Extract height points
        infoStruct(statCount).cloudTemps = soundingStruct(count).temp(cloudPoints); %Extract temperature points
        infoStruct(statCount).cloudWetbulbs = double(soundingStruct(count).wetbulb(cloudPoints)); %Extract wetbulb ponts and convert to double from symbol
        infoStruct(statCount).cloudWetbulbs = infoStruct(statCount).cloudWetbulbs'; %Transpose to match shape
    catch ME; %#ok
        warmCloudMsg = ['Failed to extract warm cloud information for following sounding number: ' num2str(count)];
        disp(warmCloudMsg)
    end
    
    wp = find(warmTempPoints==1);
    cp = find(cloudPoints==1);
    wwp = find(warmWetbulbPoints==1);
    warmCloudPoints = intersect(wp,cp); %Points that are both warm temperature points and cloud points
    warmWetCloudPoints = intersect(wwp,cp); %Points that are both warm wetbulb temperature points and cloud points
    infoStruct(statCount).warmcloudHeights = soundingStruct(count).height(warmCloudPoints); %Extract the warm temperature cloud heights
    infoStruct(statCount).warmwetcloudHeights = soundingStruct(count).height(warmWetCloudPoints); %Extract the warm wetbulb temperature cloud heights
    infoStruct(statCount).warmcloudTemps = soundingStruct(count).temp(warmCloudPoints); %Extract the warm temperature cloud temperatures
    try 
        infoStruct(statCount).warmcloudWetbulbs = double(soundingStruct(count).wetbulb(warmWetCloudPoints)); %Extract warm cloud wetbulb temperature
        infoStruct(statCount).warmcloudWetbulbs = infoStruct(statCount).warmcloudWetbulbs'; %Transpose to match shape
    catch ME; %#ok
        warmWetCloudMsg = ['Failed to extract warm wetbulb temperature cloud information for following sounding number: ' num2str(count)];
        disp(warmWetCloudMsg)
    end
    infoStruct(statCount).warmPoints = wp;
    infoStruct(statCount).cloudPoints = cp;
    infoStruct(statCount).warmcloudPoints = warmCloudPoints;
    statCount = statCount+1; %Increment counter and continue
end

end