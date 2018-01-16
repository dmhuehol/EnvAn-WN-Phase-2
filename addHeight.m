function [geoSound] = addHeight(soundStruct)
geoSound = soundStruct;
errorCount = 0;
for count = 1:length(soundStruct)
    try
        [~,geoSound(count).height] = prestogeo(soundStruct(count).pressure,soundStruct(count).temp);
    catch ME
        disp(count)
        errorCount = errorCount+1;
        if errorCount>0.05*length(soundStruct)
            msg = 'Errors encountered on greater than 5% of the dataset! Check dataset and try again.';
            error(msg);
        end
    end
end
end