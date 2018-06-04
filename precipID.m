function [dates,exact] = precipID(precipCode,ASOS)
presentWeather = {ASOS(:).PresentWeather};

logCode = zeros(1,length(ASOS));

for count = 1:length(ASOS)
    if strfind(presentWeather{count},precipCode)==1
        logCode(count)=1;
    else
        logCode(count)=0;
    end
end

precipCodeInd = find(logCode==1);

year = [ASOS(precipCodeInd).Year]';
month = [ASOS(precipCodeInd).Month]';
day = [ASOS(precipCodeInd).Day]';
hour = [ASOS(precipCodeInd).Hour]';
minute = [ASOS(precipCodeInd).Minute]';
second = zeros(length(minute),1);

dates = datenum(year,month,day);
dates = unique(dates);
dates = datestr(dates);
exact = datenum(year,month,day,hour,minute,second);
exact = datestr(exact);

end