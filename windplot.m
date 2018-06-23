%%windplot
%This is an example of how to make a wind plot using the windbarb function,
%as in surfacePlotter and similar to its original use in CCOWindProfile.
%
%
%% windbarb attribution
% Written by: Laura Tomkins
% Research Assistant at Environment Analytics
% Last updated May 2017

%% windplot attribution
%Written by: Daniel Hueholt
%North Carolina State University
%Undergraduate Research Assistant at Environment Analytics
%Version date: 6/21/2018
%
%See also windbarb, surfacePlotter
%

%% windplot

if exist('surfaceSubset245','var')==1 %Surface subset from February 2015
    windStruct = surfaceSubset245;
    windDirdata = [windStruct.WindDirection];
    windSpddata = [windStruct.WindSpeed];
    howMuchData = length(surfaceSubset245);
else %Make up some data
    windDirdata = [90 97 95 90 93 92 40 2];
    windSpddata = [10 2 4 3 5 6 8 1];
    howMuchData = length(windSpddata);
end
xInt = 1;
yInt = 1;
for windCounter = 1:length(windSpddata)
    windbarb(xInt,yInt,windSpddata(windCounter),windDirdata(windCounter),0.04,0.08,'b',1);
    hold on
    xInt = xInt+3;
end

xlim([1 xInt+3])
disp('Finished!')