%assorted things easier here than in command window
%12/15/17
%Daniel Hueholt

bismarck = 'C:\Users\danielholt\Documents\MATLAB\Project 1 - Warm Noses\Soundings Data\72764.dat';
greensboro = 'C:\Users\danielholt\Documents\MATLAB\Project 1 - Warm Noses\Soundings Data\72317.dat';
upton = 'C:\Users\danielholt\Documents\MATLAB\Project 1 - Warm Noses\Soundings Data\72501.dat';
salem = 'C:\Users\danielholt\Documents\MATLAB\Project 1 - Warm Noses\Soundings Data\72694.dat';

[sndng] = IGRAimpf(upton);

filter_settings.year = [2015 2015];
filter_settings.month = [1 2 3 4 5 9 10 11 12];
[filtered] = timefilter(sndng,filter_settings);

[soundsh] = levfilter(filtered,3);
for scnt = 1:length(soundsh)
    [soundsh(scnt).dewpt,soundsh(scnt).rhum] = dewrelh(soundsh(scnt).temp,soundsh(scnt).dew_point_dep);
end

[withHeightsOKXsum] = addHeight(soundsh);

try
    [wetBIS] = addWetbulb(withHeightsBIS);
catch ME;
    disp('Bismarck failed!')
end

try
    [wetDTX] = addWetbulb(withHeightsDTX);
catch ME;
    disp('White Lake failed!')
end

try 
    [wetGRB] = addWetbulb(withHeightsGRB);
catch ME;
    disp('Green Bay failed!')
end

try
    [wetGSO] = addWetbulb(withHeightsGSO);
catch ME;
    disp('Greensboro failed!')
end

try
    [wetMHX] = addWetbulb(withHeightsMHX);
catch ME;
    disp('Morehead City failed!')
end

try
    [wetOAX] = addWetbulb(withHeightsOAX);
catch ME;
    disp('Omaha City failed!')
end

try
    [wetYQD] = addWetbulb(withHeightsYQD);
catch ME;
    disp('The Pas failed!')
end