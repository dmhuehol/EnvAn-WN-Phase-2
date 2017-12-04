hr = 0;
s = 1;
while s<31
    try
        TvZ(2015,1,s,hr,wetSound)
        pause(2)
        if hr==0
            hr = 12;
        elseif hr==12
            hr = 0;
            s = s+1;
        end
        close all
    catch ME;
        if hr==0
            hr=12;
        elseif hr==12
            hr=0;
        end
        close all
        continue
    end
end