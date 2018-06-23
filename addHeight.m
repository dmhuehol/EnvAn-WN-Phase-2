%%addHeight
    %Adds geopotential height field to a sounding data structure. Uses
    %equation found in Durre and Yin (2008).
    %Link to paper: http://journals.ametsoc.org/doi/pdf/10.1175/2008BAMS2603.1
    %
    %General form: [geoSound] = addHeight(soundStruct)
    %
    %Output
    %geosound: sounding structure with calculated geopotential height field,
    %otherwise identical to input structure
    %
    %Input:
    %soundStruct: processed soundings data structure, as from IGRAimpf
    %
    %Written by: Daniel Hueholt
    %North Carolina State University
    %Undergraduate Research Assistant at Environment Analytics
    %Version Date: 4/9/2018
    %Last major revision: 4/9/2018
    %
    %See also IGRAimpf, prestogeo
    %

function [geoSound] = addHeight(soundStruct)
geoSound = soundStruct;
errorCount = 1;
errorThreshold = 0.08*length(soundStruct); %Set a threshold for an acceptable number of errors

for count = 1:length(soundStruct)
    try
        [~,geoSound(count).height] = prestogeo(soundStruct(count).pressure,soundStruct(count).temp); %prestogeo converts pressure to geopotential height
    catch ME;
        errorCount = errorCount+1;
        if errorCount>errorThreshold %This keeps the function from blundering through a forest of errors; don't change this without a REALLY good reason
            msg = 'Number of errors has exceeded maximum allowable value! Check dataset or code for problems.';
            error(msg);
        else
            continue
        end
    end
end

%disp(errorCount); %Uncomment this line for troubleshooting
end