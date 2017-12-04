function [geoSound] = addHeight(soundStruct)
geoSound = soundStruct;
for count = 1:length(soundStruct)
    [~,geoSound(count).height] = prestogeo(soundStruct(count).pressure,soundStruct(count).temp);
end
end