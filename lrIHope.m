st = 1;
nst = 1;

for sc = 1:length(wetH)
    km5Ind = find(wetH(sc).height>=5);
    wetH(sc).temp(km5Ind(1):end) = [];
    for tc = 1:length(wetH(sc).temp)-1
        lr(tc) = wetH(sc).temp(tc+1)-wetH(sc).temp(tc);
    end
    invert = lr(lr>0);
    disp(invert)
    pause(0.2)
    if isempty(invert)==1
        standardtastic(st) = 1;
        st = st+1;
    elseif isempty(invert)~=1
        inversion(nst) = 1;
        nst = nst+1;
    end
    lr = [];
    invert = [];
    
end