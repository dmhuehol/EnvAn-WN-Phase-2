numSound = length(goodfinal);

for soundCount = 1:length(numSound)
    logicalTemp = logical(goodfinal(soundCount).temp>0); %Logically index on temperatures greater than 0
    if isempty(nonzeros(logicalTemp))==1 %If there are none
        continue %This is not a warm nose sounding, continue looping
    end
    warmIndices = find(logicalTemp==1); %Isolate the indices that correspond to superfreezing temperatures
    continguousIndices = [warmIndices(1):warmIndices(end)]'; %#ok %Generate an array of the indices that would be present if there was only one nose
    if isequal(warmIndices,contiguousIndices)==0 %If warmIndices are not contiguous, there is more than one nose
        lowerBoundIndex = warmIndices(1); %First lower bound will be
        for contigCount = 1:length(warmIndices) %Compare index by index looking for where the noses are separated
            if isequal(warmIndices(contigCount),contiguousIndices(contigCount)==1
                %do nothing
            elseif isequal(warmIndices(contigCount),contiguousIndices(contigCount)==0 %This marks a nose breakpoint
                noseOneIndices = warmIndices(1:contigCount-1); %The first nose is from the first index to the index before the discontinuity
                %upper bound index
                warmTwoIndices = warmIndices(contigCount:end); %This is the second group of indices, but note this can still contain multiple noses
            end
        end
        contiguousTwoIndices = [warmTwoIndices(1):warmTwoIndices(end)]'; %#ok %Repeat the process, generate an array of indices that would be present if the second group of indices contains only one nose
        if isequal(warmTwoIndices,contiguousTwoIndices)==1
            noseTwoIndices = warmTwoIndices; %In this case the second group of indices contains only the one nose
        elseif isequal(warmTwoIndices,contiguousTwoIndices)==0
            for contigCountTwo = 1:length(warmTwoIndices)
                if isequal(warmTwoIndices(contigCountTwo),contiguousTwoIndices(contigCountTwo))==1
                    %do nothing
                elseif isequal(warmTwoIndices(contigCountTwo),contiguousIndices(contigCountTwo))==0
                    noseTwoIndices = warmTwoIndices(1:contigCountTwo-1);
                    
                end
            end
        end
    
    
    
    
    
    
    
end