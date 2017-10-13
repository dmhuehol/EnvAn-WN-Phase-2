function [] = surfacePlotter(dStart,hStart,dEnd,hEnd,ASOS)
extractDays = NaN(1,length(ASOS));
extractDays(1:end) = ASOS(1:end).Day; %Array of all days within the given structure
extractDays(extractDays~=dStart & extractDays~=dEnd) = 0; %Logical indexing is v quick
extractDays(extractDays~=0) = 1;
dayIndices = find(extractDays~=0); %These are the indices of the input day(s)

lengthDay1 = length(ASOS(dayIndices(1)));
lengthDay2 = length(ASOS(dayIndices(2)));

disp('Completed!')
end