function [inversionNum,faulty,percentInversion] = inversionCounter(soundingStruct)

st = 1;
nst = 1;
tc = 1;
heightPlus = 1;
inversionNum = 0;
faulty = 0;
fCount = 1;

for sc = 1:length(soundingStruct)
    km5Ind = find(soundingStruct(sc).height>=5);
    if isempty(km5Ind)==1
        faulty(fCount) = sc;
        fCount = fCount+1;
        continue
    end
    %wetH(sc).temp(km5Ind(1):end) = [];
    while tc<km5Ind(1) %length(wetH(sc).temp)-1
        try
        mcheck = soundingStruct(sc).height(tc+heightPlus)-soundingStruct(sc).height(tc);
        catch ME
            disp(sc)
            fCount = fCount+1;
            tc = tc+1;
        end
        if mcheck<0.20
            heightPlus = heightPlus+1;
        else
            try
                lr(tc) = soundingStruct(sc).temp(tc+heightPlus)-soundingStruct(sc).temp(tc);
            catch ME
                disp(sc)
                disp(tc)
            end
            tc = tc+1;
            heightPlus = 1;
        end
    end
    invert = lr(lr>0);
%    disp(invert)
%    pause(0.2)
    if isempty(invert)==1
        standardtastic(st) = 1;
        st = st+1;
    elseif isempty(invert)~=1
        inversionNum = inversionNum+1;
        nst = nst+1;
    else
        disp('???')
    end
    lr = [];
    invert = [];
    heightPlus = 1;
    tc = 1;
end
percentInversion = inversionNum/(length(soundingStruct)-fCount);

end