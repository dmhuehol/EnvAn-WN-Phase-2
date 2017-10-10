%%precipfilterASOS

    %
    %Version date: 9/28/17
    %Written by: Daniel Hueholt
    %North Carolina State University
    %Undergraduate Research Assistant at Environment Analytics
    %

function [precipOutput] = precipfilterASOS(warmnosesfinal,data,spread)
year = 
errorCount = 0;
pCount = 1;
tc = length(warmnosesfinal);
for count = 1:length(warmnosesfinal)
    if obs(count).Year==year && obs(count).Month==month && obs(count).Day==day && obs(count).Hour==hour && obs(count).Minute==minute
        foundIt = count;
        break
    else
        %do nothing
    end

end
end