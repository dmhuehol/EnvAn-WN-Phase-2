%%surfAnalysisDemo
    %Demonstrates how to create a local surface analysis from ASOS surface
    %observations data. Uses fake data.
    %
    %Written by: Daniel Hueholt
    %North Carolina State University
    %Undergraduate Research Assistant at Environment Analytics
    %Version date: 6/11/2018
    %Last major revision: 6/11/2018
    %
    %See also surfAnalysisLI
    %
    
% Set boundary box
latMinNEUS = 38.928734;
lonMinNEUS = -75.613705;
latMaxNEUS = 42.176652;
lonMaxNEUS = -69.908428;
axLI = usamap([latMinNEUS latMaxNEUS],[lonMinNEUS lonMaxNEUS]);
latlim = getm(axLI,'MapLatLimit');
lonlim = getm(axLI,'MapLonLimit');
states = shaperead('usastatehi','UseGeoCoords',true,'BoundingBox',[lonlim',latlim']);
geoshow(axLI,states,'FaceColor',[1 1 1]);
%Could designate multiple boxes and assign them names, then have that
%controlled at input
%Or could have all ASOS stations coded in and have either input control the
%box or have input control the center and have the box calculated
%automatically.

% Instantiate the wind barbs
KISPlat = 40.795; KISPlon = -73.1; %KISP Islip
[KISPx,KISPy] = mfwdtran(KISPlat,KISPlon);
windbarbForSurfAn(KISPx,KISPy,18,91,0.028,0.08,'r',1)
KFOKlat = 40.844; KFOKlon = -72.62; %KFOK Westhampton Beach
[KFOKx,KFOKy] = mfwdtran(KFOKlat,KFOKlon);
windbarbForSurfAn(KFOKx,KFOKy,20,102,0.028,0.08,'r',1)
KHWVlat = 40.822; KHWVlon = -72.867; %KHWV Brookhaven
[KHWVx,KHWVy] = mfwdtran(KHWVlat,KHWVlon);
windbarbForSurfAn(KHWVx,KHWVy,30,20,0.028,0.08,'r',1)
KFRGlat = 40.729; KFRGlon = -73.414; %KFRG Farmingdale
[KFRGx,KFRGy] = mfwdtran(KFRGlat,KFRGlon);
windbarbForSurfAn(KFRGx,KFRGy,5,226,0.028,0.08,'r',1)
KJFKlat = 40.64; KJFKlon = -73.779; %KJFK JFK Airport
[KJFKx,KJFKy] = mfwdtran(KJFKlat,KJFKlon);
windbarbForSurfAn(KJFKx,KJFKy,2,120,0.028,0.08,'r',1)
KLGAlat = 40.777; KLGAlon = -73.873;
[KLGAx,KLGAy] = mfwdtran(KLGAlat,KLGAlon); %KLGA LaGuardia Airport
windbarbForSurfAn(KLGAx,KLGAy,0,95,0.028,0.08,'r',1)
KLGAlat = 40.777; KLGAlon = -73.873;
[KLGAx,KLGAy] = mfwdtran(KLGAlat,KLGAlon); %KLGA LaGuardia Airport
windbarbForSurfAn(KLGAx,KLGAy,0,95,0.028,0.08,'r',1)
KHPNlat = 41.067; KHPNlon = -73.708;
[KHPNx,KHPNy] = mfwdtran(KHPNlat,KHPNlon); %KHPN West Plains
windbarbForSurfAn(KHPNx,KHPNy,0,95,0.028,0.08,'r',1)
KMGJlat = 41.51; KMGJlon = -74.265;
[KMGJx,KMGJy] = mfwdtran(KMGJlat,KMGJlon); %KMGJ Montgomery
windbarbForSurfAn(KMGJx,KMGJy,0,95,0.028,0.08,'r',1)
KPOUlat = 41.627; KPOUlon = -73.884;
[KPOUx,KPOUy] = mfwdtran(KPOUlat,KPOUlon); %KPOU Poughkeepsie - Hudson Valley
windbarbForSurfAn(KPOUx,KPOUy,0,95,0.028,0.08,'r',1)
KTEBlat = 40.85; KTEBlon = -74.061;
[KTEBx,KTEBy] = mfwdtran(KTEBlat,KTEBlon); %KTEB Teterboro
windbarbForSurfAn(KTEBx,KTEBy,0,95,0.028,0.08,'r',1)
KEWRlat = 40.693; KEWRlon = -74.169;
[KEWRx,KEWRy] = mfwdtran(KEWRlat,KEWRlon); %KEWR Newark
windbarbForSurfAn(KEWRx,KEWRy,0,95,0.028,0.08,'r',1)
KCDWlat = 40.875; KCDWlon = -74.281;
[KCDWx,KCDWy] = mfwdtran(KCDWlat,KCDWlon); %KCDW Caldwell
windbarbForSurfAn(KCDWx,KCDWy,0,95,0.028,0.08,'r',1)
KSMQlat = 40.626; KSMQlon = -74.67;
[KSMQx,KSMQy] = mfwdtran(KSMQlat,KSMQlon); %KSMQ Somerville
windbarbForSurfAn(KSMQx,KSMQy,0,95,0.028,0.08,'r',1)

% Temperature, dewpoint, pressure, precipitation code
%Color code this stuff eventually! For instance below/near/above freezing
temperature = textm(KISPlat+0.04,KISPlon-0.06,'10');
set(temperature,'FontSize',6); set(temperature,'FontName','Lato Bold'); set(temperature,'Color','r')
dewpoint = textm(KISPlat-0.04,KISPlon-0.06,'3');
set(dewpoint,'FontSize',6); set(dewpoint,'FontName','Lato Bold'); set(dewpoint,'Color','r')
altimeter = textm(KISPlat+0.04,KISPlon+0.04,'1014.7');
set(altimeter,'FontSize',6); set(altimeter,'FontName','Lato Bold'); set(altimeter,'Color','r')
precipCode = textm(KISPlat-0.04,KISPlon+0.04,'RA');
set(precipCode,'FontSize',6); set(precipCode,'FontName','Lato Bold'); set(precipCode,'Color','r')

temperature = textm(KFOKlat+0.04,KFOKlon-0.06,'9.7');
set(temperature,'FontSize',6); set(temperature,'FontName','Lato Bold'); set(temperature,'Color','r')
dewpoint = textm(KFOKlat-0.04,KFOKlon-0.06,'2.8');
set(dewpoint,'FontSize',6); set(dewpoint,'FontName','Lato Bold'); set(dewpoint,'Color','r')
altimeter = textm(KFOKlat+0.04,KFOKlon+0.04,'1014.2');
set(altimeter,'FontSize',6); set(altimeter,'FontName','Lato Bold'); set(altimeter,'Color','r')
precipCode = textm(KFOKlat-0.04,KFOKlon+0.04,'RA');
set(precipCode,'FontSize',6); set(precipCode,'FontName','Lato Bold'); set(precipCode,'Color','r')

temperature = textm(KHWVlat+0.04,KHWVlon-0.06,'0.7');
set(temperature,'FontSize',6); set(temperature,'FontName','Lato Bold'); set(temperature,'Color','r')
dewpoint = textm(KHWVlat-0.04,KHWVlon-0.06,'-1.0');
set(dewpoint,'FontSize',6); set(dewpoint,'FontName','Lato Bold'); set(dewpoint,'Color','r')
altimeter = textm(KHWVlat+0.04,KHWVlon+0.04,'1014');
set(altimeter,'FontSize',6); set(altimeter,'FontName','Lato Bold'); set(altimeter,'Color','r')
precipCode = textm(KHWVlat-0.04,KHWVlon+0.04,'SN');
set(precipCode,'FontSize',6); set(precipCode,'FontName','Lato Bold'); set(precipCode,'Color','r')

temperature = textm(KFRGlat+0.04,KFRGlon-0.06,'0.0');
set(temperature,'FontSize',6); set(temperature,'FontName','Lato Bold'); set(temperature,'Color','r')
dewpoint = textm(KFRGlat-0.04,KFRGlon-0.06,'-0.8');
set(dewpoint,'FontSize',6); set(dewpoint,'FontName','Lato Bold'); set(dewpoint,'Color','r')
altimeter = textm(KFRGlat+0.04,KFRGlon+0.04,'1014.2');
set(altimeter,'FontSize',6); set(altimeter,'FontName','Lato Bold'); set(altimeter,'Color','r')
precipCode = textm(KFRGlat-0.04,KFRGlon+0.04,'None');
set(precipCode,'FontSize',6); set(precipCode,'FontName','Lato Bold'); set(precipCode,'Color','r')

temperature = textm(KJFKlat+0.04,KJFKlon-0.06,'9.0');
set(temperature,'FontSize',6); set(temperature,'FontName','Lato Bold'); set(temperature,'Color','r')
dewpoint = textm(KJFKlat-0.04,KJFKlon-0.06,'6.5');
set(dewpoint,'FontSize',6); set(dewpoint,'FontName','Lato Bold'); set(dewpoint,'Color','r')
altimeter = textm(KJFKlat+0.04,KJFKlon+0.04,'1014.8');
set(altimeter,'FontSize',6); set(altimeter,'FontName','Lato Bold'); set(altimeter,'Color','r')
precipCode = textm(KJFKlat-0.04,KJFKlon+0.04,'RA');
set(precipCode,'FontSize',6); set(precipCode,'FontName','Lato Bold'); set(precipCode,'Color','r')

temperature = textm(KLGAlat+0.04,KLGAlon-0.06,'3.7');
set(temperature,'FontSize',6); set(temperature,'FontName','Lato Bold'); set(temperature,'Color','r')
dewpoint = textm(KLGAlat-0.04,KLGAlon-0.06,'-2.5');
set(dewpoint,'FontSize',6); set(dewpoint,'FontName','Lato Bold'); set(dewpoint,'Color','r')
altimeter = textm(KLGAlat+0.04,KLGAlon+0.04,'1010.2');
set(altimeter,'FontSize',6); set(altimeter,'FontName','Lato Bold'); set(altimeter,'Color','r')
precipCode = textm(KLGAlat-0.04,KLGAlon+0.04,'RAPL');
set(precipCode,'FontSize',6); set(precipCode,'FontName','Lato Bold'); set(precipCode,'Color','r')

temperature = textm(KHPNlat+0.04,KHPNlon-0.06,'3.7');
set(temperature,'FontSize',6); set(temperature,'FontName','Lato Bold'); set(temperature,'Color','r')
dewpoint = textm(KHPNlat-0.04,KHPNlon-0.06,'-2.5');
set(dewpoint,'FontSize',6); set(dewpoint,'FontName','Lato Bold'); set(dewpoint,'Color','r')
altimeter = textm(KHPNlat+0.04,KHPNlon+0.04,'1010.2');
set(altimeter,'FontSize',6); set(altimeter,'FontName','Lato Bold'); set(altimeter,'Color','r')
precipCode = textm(KHPNlat-0.04,KHPNlon+0.04,'RAPL');
set(precipCode,'FontSize',6); set(precipCode,'FontName','Lato Bold'); set(precipCode,'Color','r')

temperature = textm(KMGJlat+0.04,KMGJlon-0.06,'3.7');
set(temperature,'FontSize',6); set(temperature,'FontName','Lato Bold'); set(temperature,'Color','r')
dewpoint = textm(KMGJlat-0.04,KMGJlon-0.06,'-2.5');
set(dewpoint,'FontSize',6); set(dewpoint,'FontName','Lato Bold'); set(dewpoint,'Color','r')
altimeter = textm(KMGJlat+0.04,KMGJlon+0.04,'1010.2');
set(altimeter,'FontSize',6); set(altimeter,'FontName','Lato Bold'); set(altimeter,'Color','r')
precipCode = textm(KMGJlat-0.04,KMGJlon+0.04,'RAPL');
set(precipCode,'FontSize',6); set(precipCode,'FontName','Lato Bold'); set(precipCode,'Color','r')

temperature = textm(KPOUlat+0.04,KPOUlon-0.06,'3.7');
set(temperature,'FontSize',6); set(temperature,'FontName','Lato Bold'); set(temperature,'Color','r')
dewpoint = textm(KPOUlat-0.04,KPOUlon-0.06,'-2.5');
set(dewpoint,'FontSize',6); set(dewpoint,'FontName','Lato Bold'); set(dewpoint,'Color','r')
altimeter = textm(KPOUlat+0.04,KPOUlon+0.04,'1010.2');
set(altimeter,'FontSize',6); set(altimeter,'FontName','Lato Bold'); set(altimeter,'Color','r')
precipCode = textm(KPOUlat-0.04,KPOUlon+0.04,'RAPL');
set(precipCode,'FontSize',6); set(precipCode,'FontName','Lato Bold'); set(precipCode,'Color','r')

temperature = textm(KTEBlat+0.04,KTEBlon-0.06,'3.7');
set(temperature,'FontSize',6); set(temperature,'FontName','Lato Bold'); set(temperature,'Color','r')
dewpoint = textm(KTEBlat-0.04,KTEBlon-0.06,'-2.5');
set(dewpoint,'FontSize',6); set(dewpoint,'FontName','Lato Bold'); set(dewpoint,'Color','r')
altimeter = textm(KTEBlat+0.04,KTEBlon+0.04,'1010.2');
set(altimeter,'FontSize',6); set(altimeter,'FontName','Lato Bold'); set(altimeter,'Color','r')
precipCode = textm(KTEBlat-0.04,KTEBlon+0.04,'RAPL');
set(precipCode,'FontSize',6); set(precipCode,'FontName','Lato Bold'); set(precipCode,'Color','r')

temperature = textm(KEWRlat+0.04,KEWRlon-0.06,'3.7');
set(temperature,'FontSize',6); set(temperature,'FontName','Lato Bold'); set(temperature,'Color','r')
dewpoint = textm(KEWRlat-0.04,KEWRlon-0.06,'-2.5');
set(dewpoint,'FontSize',6); set(dewpoint,'FontName','Lato Bold'); set(dewpoint,'Color','r')
altimeter = textm(KEWRlat+0.04,KEWRlon+0.04,'1010.2');
set(altimeter,'FontSize',6); set(altimeter,'FontName','Lato Bold'); set(altimeter,'Color','r')
precipCode = textm(KEWRlat-0.04,KEWRlon+0.04,'RAPL');
set(precipCode,'FontSize',6); set(precipCode,'FontName','Lato Bold'); set(precipCode,'Color','r')

temperature = textm(KCDWlat+0.04,KCDWlon-0.06,'3.7');
set(temperature,'FontSize',6); set(temperature,'FontName','Lato Bold'); set(temperature,'Color','r')
dewpoint = textm(KCDWlat-0.04,KCDWlon-0.06,'-2.5');
set(dewpoint,'FontSize',6); set(dewpoint,'FontName','Lato Bold'); set(dewpoint,'Color','r')
altimeter = textm(KCDWlat+0.04,KCDWlon+0.04,'1010.2');
set(altimeter,'FontSize',6); set(altimeter,'FontName','Lato Bold'); set(altimeter,'Color','r')
precipCode = textm(KCDWlat-0.04,KCDWlon+0.04,'RAPL');
set(precipCode,'FontSize',6); set(precipCode,'FontName','Lato Bold'); set(precipCode,'Color','r')

temperature = textm(KSMQlat+0.04,KSMQlon-0.06,'3.7');
set(temperature,'FontSize',6); set(temperature,'FontName','Lato Bold'); set(temperature,'Color','r')
dewpoint = textm(KSMQlat-0.04,KSMQlon-0.06,'-2.5');
set(dewpoint,'FontSize',6); set(dewpoint,'FontName','Lato Bold'); set(dewpoint,'Color','r')
altimeter = textm(KSMQlat+0.04,KSMQlon+0.04,'1010.2');
set(altimeter,'FontSize',6); set(altimeter,'FontName','Lato Bold'); set(altimeter,'Color','r')
precipCode = textm(KSMQlat-0.04,KSMQlon+0.04,'RAPL');
set(precipCode,'FontSize',6); set(precipCode,'FontName','Lato Bold'); set(precipCode,'Color','r')

%end