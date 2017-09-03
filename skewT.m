function [f] = skewT(RELH,TEMP,PRES,DEW)
%%skewT
    %Function to create a skew-T graph when given column vectors of relative
    %humidity, temperature, and pressure.
    %
    %General form: [f] = FWOKXskew(RELH,TEMP,PRES,DEW)
    %
    %Outputs: f is the figure handle for the skew-T chart
    %Inputs: RELH is humidity data in percent, TEMP is temperature in deg C, PRES
    %is pressure in Pa, and DEW is dewpoint in deg C
    %All other thermodynamic variables needed are calculated within the
    %function. Additionally, units are adjusted from the above as necessary
    %within the function.
    %
    %Description of graph:
    %solid black line: measured temperature profile, deg C
    %dashed black line: measured dewpoint profile, deg C
    %horizontal thin dashed line: isobars (lines of constant pressure)
    %solid black line slanted right: isotherms (lines of constant temperature)
    %solid magenta line slanted right: freezing isotherm (line of 0 deg C temperature)
    %blue curved line: dry adiabat (lines of constant potential temperature)
    %red curved line: saturated adiabat (lines of constant potential temperature)
    %green slanted line: isohume (lines of constant mixing ratio)
    %
    %KNOWN PROBLEM: the isotherms do not perfectly line up with the
    %rWecorded temperatures on IGRA soundings, and are usually located ~+2
    %degrees C. This will be fixed eventually, but is not a high priority
    %since skew-T charts are not especially important for warm nose analysis.
    %
    %Written by: Daniel Hueholt
    %Adapted from code found on MIT Open Courseware, ocw.mit.edu
    %Version date: 8/4/17
    %Last major revision: 5/24/17
    %

PRES = PRES/100; %change Pa to hPa for charting
RHUM = RELH./100; %express relative humidity as decimal instead of percentage
ez=6.112.*exp(17.67.*TEMP./(243.5+TEMP)); %calculate saturation vapor pressure
qz=RHUM.*0.622.*ez./(PRES-ez); %calculate saturation mixing ratio
chi= log(PRES.*qz./(6.112.*(0.622+qz))); %calculate dewpoint
%
tdz=DEW; %243.5.*chi./(17.67-chi); %finish calculating dewpoint
%
f = figure(1234);
p=[1050:-25:100]; %row vector for pressure
pplot=transpose(p); %make that a column vector
t0=[-48:2:50]; %row vector for temperature
[ps1,ps2]=size(p); %size of pressure
ps=max(ps1,ps2); %pick the larger of the two
[ts1,ts2]=size(t0); %size of temperature
ts=max(ts1,ts2); %pick the larger of the two
for i=1:ts, %loop through temperature vector indexing i
   for j=1:ps, %loop through pressure vector indexing j
      tem(i,j)= t0(i)+30.*log(0.001.*p(j)); %draw temperature lines on skew T
      thet(i,j)= (273.15+tem(i,j)).*(1000./p(j)).^.287; %draw moist adiabats
      es= 6.112.*exp(17.67.*tem(i,j)./(243.5+tem(i,j))); %draw dry adiabats
      q(i,j)=622.*es./(p(j)-es); %draw mixing ratio lines
      thetaea(i,j)= thet(i,j).*exp(2.5.*q(i,j)./(tem(i,j)+273.15)); %draw equivalent potential temperature lines
   end
end
p=transpose(p);
t0=transpose(t0);
temp=transpose(tem);
theta=transpose(thet);
thetae=transpose(thetaea);
qs=transpose(sqrt(q));
h=contour(t0,pplot,temp,16,'k'); %isotherms
hold on
set(gca,'ytick',[1000:100:100]) %pressure ticks
set(gca,'yscale','log','ydir','reverse') %use log scale, reverse so higher values are at the bottom of the chart
set(gca,'ytick',[100:100:1000]) %draw lines of constant pressure across the chart
set(gca,'ygrid','on') %draw lines of constant pressure across the chart
hold on
h=contour(t0,pplot,theta,24,'b'); %moist adiabats
h=contour(t0,pplot,qs,24,'g'); %mixing ratio lines
h=contour(t0,pplot,thetae,24,'r'); %equivalent potential temperature lines
%tsound=30.+43.5.*log(0.001.*p);
%tsoundm=tsound-30.*log(0.001.*p);
TEMPm=TEMP-30.*log(0.001.*PRES); %temperature adjusted for proper plotting
temp0 = NaN(length(TEMPm'),1); %make a new column vector to be plotted
temp0(:) = 1.9; %this is where the 0C line appears on the graph (it isn't zero because skew-Ts are strange ducks)
temp0m = temp0-30.*log(0.001.*PRES); %adjust for proper plotting
tdzm=tdz-30.*log(0.001.*PRES); %dewpoint adjusted for proper plotting
h=plot(TEMPm,PRES,'k',tdzm,PRES,'k--'); %plot soundings data on skew T
%h=plot(TEMPm,HE,'k',tdzm,HE,'k--'); %plot soundings data on skew T
hold on
h2 = plot(temp0m,PRES,'m'); %plot 0C isotherm in magenta
%h2 = plot(temp0,HE,'m'); %plot 0C isotherm in magenta
set(h,'linewidth',2) %bold the T and Td profiles
set(h2,'linewidth',2) %also bold the 0C isotherm
hold off
xlabel('Temperature (C)') %label x axis
ylabel('Pressure (mb)') %label y axis
title('Skew-T Chart of Sounding Data')
end