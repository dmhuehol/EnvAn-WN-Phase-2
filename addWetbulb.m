function [wetSound] = addWetbulb(soundings)
%%addWetbulb
	%Function to add wetbulb field to a soundings structure
    %
    %As it stands this function is apocalyptically slow thanks to the
    %nested for loops featuring numerical algebraic evaluation so be sure
    %to run on small amounts of data if possible
    %
    %Version date: 11/22/17
    %Written by: Daniel Hueholt
    %North Carolina State University
    %Undergraduate Research Assistant at Environment Analytics
    %

wetSound = soundings;
    
for c = length(soundings):-1:1
    disp(c); %Otherwise all hope will be lost
    tic
    for apocalyptic = length(soundings(c).temp):-1:1
        try
            [wetSound(c).wetbulb(apocalyptic)] = wetbulb(soundings(c).pressure(apocalyptic)./100,soundings(c).dewpt(apocalyptic),soundings(c).temp(apocalyptic)); %pressure is in Pa in IGRA
        catch ME;
            disp(c)
            continue
        end
    end
    toc
end
    
end