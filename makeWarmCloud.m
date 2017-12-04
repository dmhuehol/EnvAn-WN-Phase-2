function [statStruct] = makeWarmCloud(soundStruct)
statStruct = struct([]);
statCount = 1;
for count = 1:length(soundStruct)
    statStruct(statCount).valid_date_num = soundStruct(count).valid_date_num;
    warmPoints = soundStruct(count).temp>=0;
    if isempty(nonzeros(warmPoints))==1
        continue
    end
    statStruct(statCount).warmHeights = soundStruct(count).height(warmPoints);
    statStruct(statCount).warmTemps = soundStruct(count).temp(warmPoints);
    try
        warmWetbulbPoints = soundStruct(count).wetbulb>=0;
        statStruct(statCount).warmWetbulbs = double(soundStruct(count).wetbulb(warmWetbulbPoints));
        statStruct(statCount).warmWetbulbs = statStruct(statCount).warmWetbulbs';
        statStruct(statCount).warmwetHeights = soundStruct(count).height(warmWetbulbPoints);
    catch ME;
        disp(count)
        disp('Failed at warm wetbulb!')    
    end
    cloudPoints = soundStruct(count).rhum>80;
    statStruct(statCount).cloudHeights = soundStruct(count).height(cloudPoints);
    statStruct(statCount).cloudTemps = soundStruct(count).temp(cloudPoints);
    try
        statStruct(statCount).cloudWetbulbs = double(soundStruct(count).wetbulb(cloudPoints));
        statStruct(statCount).cloudWetbulbs = statStruct(statCount).cloudWetbulbs';
    catch ME;
        disp(count)
        disp('Failed at cloud wetbulb!')
    end
    wp = find(warmPoints==1);
    cp = find(cloudPoints==1);
    wwp = find(warmWetbulbPoints==1);
    warmcloudPoints = intersect(wp,cp);
    warmwetcloudPoints = intersect(wwp,cp);
    statStruct(statCount).warmcloudHeights = soundStruct(count).height(warmcloudPoints);
    statStruct(statCount).warmwetcloudHeights = soundStruct(count).height(warmwetcloudPoints);
    statStruct(statCount).warmcloudTemps = soundStruct(count).temp(warmcloudPoints);
    try 
        statStruct(statCount).warmcloudWetbulbs = double(soundStruct(count).wetbulb(warmwetcloudPoints));
        statStruct(statCount).warmcloudWetbulbs = statStruct(statCount).warmcloudWetbulbs';
    catch ME;
        disp(count)
        disp('Failed at warm cloud wetbulb!')
    end
    statStruct(statCount).warmPoints = wp;
    statStruct(statCount).cloudPoints = cp;
    statStruct(statCount).warmcloudPoints = warmcloudPoints;
    statCount = statCount+1;
end
end