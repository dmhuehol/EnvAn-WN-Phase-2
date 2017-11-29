%Version Date: 11/27/17
%Written by Daniel Hueholt
%function [] = surfAnalysisLI(startYear,startMonth,startDay,startHour,startMinute,endYear,endMonth,endDay,endHour,endMinute)
fakeSecond = 0;
%startTime = [startYear,startMonth,startDay,startHour,startMinute,fakeSecond];
%endTime = [endYear,endMonth,endDay,endHour,endMinute,fakeSecond];

latMinNEUS = 38.928734;
lonMinNEUS = -75.613705;
latMaxNEUS = 42.176652;
lonMaxNEUS = -69.908428;
axLI = usamap([latMinNEUS latMaxNEUS],[lonMinNEUS lonMaxNEUS]);
latlim = getm(axLI,'MapLatLimit');
lonlim = getm(axLI,'MapLonLimit');
states = shaperead('usastatehi','UseGeoCoords',true,'BoundingBox',[lonlim',latlim']);
geoshow(axLI,states,'FaceColor',[1 1 1]);

KISPlat = 40.795; KISPlon = -73.1;
hold on
[KISPx,KISPy] = mfwdtran(KISPlat,KISPlon);
windbarb(KISPx,KISPy,10,95,0.028,0.08,'r',1)
hold on
temperature = textm(KISPlat+0.04,KISPlon-0.04,'10');
set(temperature,'FontSize',6); set(temperature,'FontName','Lato Bold'); set(temperature,'Color','r')
dewpoint = textm(KISPlat-0.04,KISPlon-0.04,'3');
set(dewpoint,'FontSize',6); set(dewpoint,'FontName','Lato Bold'); set(dewpoint,'Color','r')
altimeter = textm(KISPlat+0.04,KISPlon+0.04,'1014.7');
set(altimeter,'FontSize',6); set(altimeter,'FontName','Lato Bold'); set(altimeter,'Color','r')
precipCode = textm(KISPlat-0.04,KISPlon+0.04,'FZRA');
set(precipCode,'FontSize',6); set(precipCode,'FontName','Lato Bold'); set(precipCode,'Color','r')

%end