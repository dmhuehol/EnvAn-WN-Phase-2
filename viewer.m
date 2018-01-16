function [] = viewer(soundingStruct,month,da,hr)
if exist('month','var')==0
    month = 1
end
if exist('da','var')==0
    da = 1  
end
if exist('hr','var')==0
    hr = 0;
end
fig = 1;
while month < 4
    if month ==1
        while da<32
            close all
            for hr = [0,12]
                try
                    TTwvZ(2015,1,da,hr,soundingStruct,10,fig)
                    fig = fig+1;
                catch ME;
                    disp('Failed')
                    continue
                end
                pause(1)
                close all
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
                    TTwvZ(2015,2,da,hr,soundingStruct,5,fig)
                    fig = fig+1;
                    pause(1)
                    close all
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
                    TTwvZ(2015,3,da,hr,soundingStruct,5,fig)
                    fig = fig+1;
                    pause(1)
                    close all
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