month = 1
da = 1
hr = 0;


while month < 4
    if month ==1
        while da<32
            close all
            for hr = [0,12]
                try
                    TTwvZ(2015,1,da,hr,wetSound,5)
                catch ME;
                    disp('Failed')
                    continue
                end
                pause(2)
            end
            da = da+1;
        end
        month = month+1;
        da = 1;
    elseif month == 2
        while da<29
            close all
            for hr = [0 12]
                try
                    TTwvZ(2015,2,da,hr,wetSound,5)
                    pause(2)
                catch ME
                    disp('Failed')
                    continue
                end
            end
            da = da+1;
        end
        month = month+1;
        da = 1;
    elseif month == 3
        while da<32
            close all
            for hr = [0 12]
                try
                    TTwvZ(2015,3,da,hr,wetSound,5)
                    pause(2)
                catch ME
                    disp('Failed')
                    continue
                end
            end
            da = da+1;
        end
        month = month+1;
    end
end