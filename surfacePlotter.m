%function [] = surfacePlotter(dStart,hStart,dEnd,hEnd,ASOS)
extractDays = [ASOS.Day]; %Array of all days within the given structure, bracket is required to form an array instead of list
logicalDays = logical(extractDays==dStart | extractDays==dEnd); %Logical indexing is v quick
try
    dayIndices = find(logicalDays~=0); %These are the indices of the input day(s)
catch ME; %If day is not found
    msg('No data from input day(s) present in structure!');
    error(msg); %Give a useful error message
end

extractHours = [ASOS(dayIndices).Hour];
logicalHours = logical(extractHours==hStart); %Since it's possible for end to be a number smaller than start and hence deceive the function, start with the start hour
try
    hStartIndices = find(logicalHours~=0);
catch ME;
    msg('Failed to find start hour in structure!');
    error(msg);
end
hStartFirstInd = hStartIndices(1); %This is the first index
hStartFinalInd = hSInd(end); %which marks where in the structure to look for the end hour
logicalHours = logical(extractHours==hEnd-1); %Remake this (DOES NOT INCLUDE data from the hEnd hour; STOPS at the hEnd hour)
logicalHours(1:hStartFinalInd) = 0; %The end hour will definitely not come before the start hour
try
    hEndIndices = find(logicalHours~=0);
catch ME;
    msg('Could not find end hour in structure!');
end
hEndFinalInd = hEndIndices(end); %This is the last data index

dataHourSpan = [hStartFirstInd hEndFinalInd]; %This is the span of hours
dataSpan = [dayIndices(hStartFirstInd) dayIndices(hEndFinalInd)];

surfaceSubset = ASOS(dataSpan(1):dataSpan(2));


disp('Completed!')
%end