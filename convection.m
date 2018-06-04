%%convection
    %Function to calculate various convective parameters given an input
    %sounding number. Currently, the K-index and Total Totals index are
    %calculated.
    %
    %General form: [parameters] = convection(snum,soundStruct)
    %
    %Output:
    %parameters: A structure containing fields for the convective
    %   parameters and yes/no fields estimating whether convection will occur.
    %
    %Inputs:
    %snum: A sounding number--use findsnd to locate a sounding number for a
    %   given date.
    %soundStruct: A sounding structure which must already be processed to
    %   contain dewpoint.
    %
    %Further development will include the addition of other convective
    %parameters, such as lifted index and convective available potential
    %energy. However, as convective processes are not especially important in wintry mix
    %storms in the northeastern US, this function is a low development priority.
    %
    %
    %Version date: 4/14/2018
    %Last major revision: 4/14/2018
    %Written by: Daniel Hueholt
    %North Carolina State University
    %Undergraduate Research Assistant at Environment Analytics
    %   K-index calculation is based on an excerpt from a script originally 
    %   written by Megan Amanatides, circa 2014
    %
    %See also findsnd, addDew
    %

function [parameters] = convection(snum,soundStruct)

sounding = soundStruct(snum); %Extract the input sounding
pressure = sounding.pressure; %Extract the pressure field (this isn't strictly necessary, but makes the code easier to read)

%Thermodynamic variables for calculation
temp850 = sounding.temp(pressure==85000);
temp700 = sounding.temp(pressure==70000);
temp500 = sounding.temp(pressure==50000);
dew850 = sounding.dewpt(pressure==85000);
dew700 = sounding.dewpt(pressure==70000);

parameters.Kindex = ((temp850 - temp500) + dew850 - (temp700-dew700)); %The K-index measures thunderstorm probability
    %Equation from Paul Sirvatka's website at College of DuPage
    %weather.cod.edu/sirvatka/si.html (Link active 4/14/2018)
    
if parameters.Kindex >= 20 %K-values greater than 20 indicates thunderstorm development is likely
    parameters.K_EstimatedConvection = 'yes';
elseif parameters.Kindex < 20
    parameters.K_EstimatedConvection = 'no';
else
    parameters.K_EstimatedConvection = 'error!';
    parameters.Kindex = 'error!';
end

parameters.TTindex = temp850+dew850-2*temp500; %The Total Totals index combines the vertical totals and cross totals into a single parameter
    %Equation from Paul Sirvatka's website at College of DuPage
    %weather.cod.edu/sirvatka/si.html (Link active 4/14/2018)

if parameters.TTindex >= 44 %Total Totals index values greater than 44 indicates convection is likely
    parameters.TT_EstimatedConvection = 'yes';
elseif parameters.Kindex < 44
    parameters.TT_EstimatedConvection = 'no';
else
    parameters.TT_EstimatedConvection = 'error!';
    parameters.TTindex = 'error!';
end


end