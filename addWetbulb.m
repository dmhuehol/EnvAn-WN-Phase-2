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
    
for soundLoop = length(soundings):-1:1
    disp(soundLoop); %Display current sounding number within the soundings structure, otherwise all hope will be lost
    tic
    for levelLoop = length(soundings(soundLoop).temp):-1:1
        try
            [wetSound(soundLoop).wetbulb(levelLoop)] = wetbulb(soundings(soundLoop).pressure(levelLoop)./100,soundings(soundLoop).dewpt(levelLoop),soundings(soundLoop).temp(levelLoop)); %pressure is in Pa in IGRA
        catch ME; %#ok
            disp(soundLoop) %Display sounding number where the error occurred
            continue
        end
    end
    toc
end
    
end