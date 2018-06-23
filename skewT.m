%%skewT
    %Function to plot a skewT-logP diagram for a given set of pressure,
    %temperature, and relative humidity data. This is a general skewT
    %plotter designed to work for any set of thermodynamic data vectors.
    %For easier plotting with an IGRA data structure, see skewtIGRA.
    %
    %General form: [] = skewT(pz,tz,rhz)
    %
    %Inputs:
    %pz: pressure data in Pa
    %tz: temperature data in deg C
    %rhz: relative humidity data in %
    %
    %Note that the isotherms plotted are relative to, but NOT the same as the
    %labels on the x-axis. The x labels refer to the imaginary isotherms
    %passing through the tip of their tick marks. The magenta line is the
    %0C isotherm, not the black isotherm closest to the 0C tick mark.
    %
    %Adapted from code found on MIT Open Courseware, ocw.mit.edu
    %Written by: Daniel Hueholt
    %Version date: 6/06/2018
    %Last major revision: 6/06/2018
    %
    %See also skewtIGRA, TvZ, soundplots, findsnd, fullIGRAimp
    %
    
function []=skewT(pz,tz,rhz)
pz = pz./100; %convert from Pa to hPa
rhz = rhz./100; %Retrieve relative humidity and convert from % to decimal

ez=6.112.*exp(17.67.*tz./(243.5+tz)); %calculate saturation vapor pressure
qz=rhz.*0.622.*ez./(pz-ez); %calculate mixing ratio
chi=log(pz.*qz./(6.112.*(0.622+qz)));
tdz=243.5.*chi./(17.67-chi); %calculate dew
%
p=1050:-25:100; %Construct values for the pressure axis
pplot=p';
t0=-48:2:50; %Construct values for the temperature axis
ps = length(p);
ts = length(t0);
for i=1:ts,
   for j=1:ps,
      tem(i,j)=t0(i)+30.*log(0.001.*p(j)); %This will draw temperature lines
      thet(i,j)=(273.15+tem(i,j)).*(1000./p(j)).^.287; %dry adiabats
      es=6.112.*exp(17.67.*tem(i,j)./(243.5+tem(i,j)));
      q(i,j)=622.*es./(p(j)-es); %isohumes
      thetaea(i,j)=thet(i,j).*exp(2.5.*q(i,j)./(tem(i,j)+273.15)); %equivalent potential temperature
   end
end
p=p';
t0=t0';
temp=tem';
theta=thet';
thetae=thetaea';
qs=sqrt(q)';
contour(t0,pplot,temp,16,'k'); %Adds isotherms and isobars
hold on
set(gca,'yscale','log','ydir','reverse') %pressure decreases with height
set(gca,'ytick',100:100:1000)
set(gca,'ygrid','on')
set(gca,'FontName','Lato Bold')
hold on
contour(t0,pplot,theta,24,'b'); %dry adiabats
contour(t0,pplot,qs,24,'g'); %isohumes
contour(t0,pplot,thetae,24,'r'); %moist adiabats
%tsound=30.+43.5.*log(0.001.*p);
%tsoundm=tsound-30.*log(0.001.*p);
tzm=tz-30.*log(0.001.*pz); %Skew the temperature
tdzm=tdz-30.*log(0.001.*pz); %Skew the dewpoint
h=plot(tzm,pz,'k',tdzm,pz,'k--'); %Plot temperature and dewpoint
set(h,'linewidth',2)

%Construct a 0C isotherm to for easier interpretation
freezingLine = NaN(length(tzm'),1); %make a new column vector to be plotted
freezingLine(:) = 0; %this is where the 0C line appears on the graph
%Yes, you could accomplish the same thing with zeros(length(tzm'),1)
%instead of NaN, but this makes it clearer that this same approach can be
%used to construct any new isotherms.
temp0m = freezingLine-30.*log(0.001.*pz); %Skew the freezing line
h2 = plot(temp0m,pz,'m'); %plot in magenta
set(h2,'linewidth',2.3)

hold off
xlabel('Temperature (C)','FontName','Lato Bold')
ylabel('Pressure (mb)','FontName','Lato Bold')

%Title will need  to be hand made; a skeleton consistent with aesthetics of
%the rest of the plot is below.
% t = title('Skew-T Diagram');
% set(t,'FontName','Lato Bold')
% set(t,'FontSize',16)

end