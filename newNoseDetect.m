%Last updated 11/12/17
%Daniel Hueholt

numSound = length(goodfinal);

for soundCount = 1:numSound
    logicalTemp = logical(goodfinal(soundCount).temp>0); %Logically index on temperatures greater than 0
    if isempty(nonzeros(logicalTemp))==1 %If there are none
        continue %This is not a warm nose sounding, continue looping
    end
    warmInd = find(logicalTemp==1); %Isolate the indices that correspond to superfreezing temperatures
    breakInd = find(diff(warmInd)~=1); %This identifies any skips in the indices, which correspond to multiple noses
    numBreak = length(breakInd);
    if numBreak==0 %No break implies single nose
        noseInd = warmInd;
    elseif numBreak==1 %One break implies two noses
        firstNoseInd = warmInd(1):warmInd(breakInd);
        secondNoseInd = warmInd(breakInd+1):warmInd(end);
    elseif numBreak==2
        firstNoseInd = warmInd(1):warmInd(breakInd(1));
        secondNoseInd = warmInd(breakInd(1)+1):warmInd(breakInd(2));
        thirdNoseInd = warmInd(breakInd(2)+1):warmInd(end);
    elseif numBreak==3
        firstNoseInd = warmInd(1):warmInd(breakInd(1));
        secondNoseInd = warmInd(breakInd(1)+1):warmInd(breakInd(2));
        thirdNoseInd = warmInd(breakInd(2)+1):warmInd(3);
        fourthNoseInd = warmInd(breakInd(3)+1):warmInd(end);
    elseif numBreak==4
        firstNoseInd = warmInd(1):warmInd(breakInd(1));
        secondNoseInd = warmInd(breakInd(1)+1):warmInd(breakInd(2));
        thirdNoseInd = warmInd(breakInd(2)+1):warmInd(3);
        fourthNoseInd = warmInd(breakInd(3)+1):warmInd(4);
        fifthNoseInd = warmInd(breakInd(4)+1):warmInd(end);
    elseif numBreak>4
        disp(soundCount)
        disp('Are you serious')
    end
    
end