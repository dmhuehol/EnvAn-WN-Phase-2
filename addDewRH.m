%%addDewRH
    %Low-stress way to add dewpoint and/or relative humidity data to a
    %soundings structure. For IGRA processing, best if run after level 3
    %data has been filtered out.
    %
    %General form: [dew] = addDewRH(sounding,type)
    %
    %Output:
    %dew: sounding structure with dewpoint and relative humidity fields,
    %otherwise identical to the input structure
    %
    %Inputs:
    %sounding: processed soundings data structure, as from IGRAimpf+levfilter
    %type: specify whether to add dewpoint ('dew'), relative humidity ('RH'), or both ('both').
    %
    %Written by: Daniel Hueholt
    %North Carolina State University
    %Undergraduate Research Assistant at Environment Analytics
    %Version date: 6/22/2018
    %Last major revision: 6/22/2018
    %
    %See also IGRAimpf, levfilter
    %

function [dew] = addDewRH(sounding,type)

dew = sounding;

switch type
    case 'both' %Add both dewpoint and relative humidity 
        for scnt = 1:length(sounding)
            [dew(scnt).dewpt,dew(scnt).rhum] = dewrelh(sounding(scnt).temp,sounding(scnt).dew_point_dep); %dewrelh calculates dewpoint and relative humidity from dewpoint depression and temperature
        end
    case 'RH' %Add only relative humidity
        for scnt = 1:length(sounding)
            [~,dew(scnt).rhum] = dewrelh(sounding(scnt).temp,sounding(scnt).dew_point_dep); %dewrelh calculates dewpoint and relative humidity from dewpoint depression and temperature
        end
    case 'dew' %Add only dewpoint
        for scnt = 1:length(sounding)
            [dew(scnt).dewpt,~] = dewrelh(sounding(scnt).temp,sounding(scnt).dew_point_dep); %dewrelh calculates dewpoint and relative humidity from dewpoint depression and temperature
        end
%Calculation will return NaN if temperature and/or dewpoint depression are NaNs.
end