omahaValley = '/Users/Daniel/Documents/MATLAB/Soundings/72558.dat';
thePas = '/Users/Daniel/Documents/MATLAB/Soundings/71867.dat';

greenBay = '/Users/Daniel/Documents/MATLAB/Soundings/72645.dat';
whiteLake = '/Users/Daniel/Documents/MATLAB/Soundings/72632.dat';

moreheadCity = '/Users/Daniel/Documents/MATLAB/Soundings/72305.dat';

salem = '/Users/Daniel/Documents/MATLAB/Soundings/72694.dat';

[sndng] = IGRAimpf(salem);

filter_settings.year = [1980 2015];
filter_settings.month = [4 5 6 7 8 9 10];
[filtered] = timefilter(sndng,filter_settings);

[soundsh] = levfilter(filtered,3);
for scnt  = 1:length(soundsh)
[soundsh(scnt).dewpt,soundsh(scnt).rhum] = dewrelh(soundsh(scnt).temp,soundsh(scnt).dew_point_dep); %Call to dewrelh function
end

[withHeightsSLE] = addHeight(soundsh);

surfcon.temp = 19;
%surfconfilter also supports filtration by relative humidity (not used by default)
[~,goodfinal] = surfconfilter(soundsh,surfcon);

[wetNE] = addWetbulb(withHeights);
