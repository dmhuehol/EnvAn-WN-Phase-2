%Last updated 11/12/17
%Daniel Hueholt

numSound = length(goodfinal);

for soundCount = 4297:length(numSound)
    logicalTemp = logical(goodfinal(soundCount).temp>0); %Logically index on temperatures greater than 0
    if isempty(nonzeros(logicalTemp))==1 %If there are none
        continue %This is not a warm nose sounding, continue looping
    end
    warmInd = find(logicalTemp==1); %Isolate the indices that correspond to superfreezing temperatures
    breakInd = find(diff(warmInd)~=1); %This identifies any skips in the indices, which correspond to multiple noses
    
end