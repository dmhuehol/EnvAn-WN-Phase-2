%Shows Jan-Mar soundings at 2 second frequency
%12/14/17
%Daniel Hueholt

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
if ~isfield(soundingStruct,'wetbulb')    
    while month < 4
        if month ==1
            while da<32
                close all
                for hr = [0,12]
                    try
                        TvZprint(2015,1,da,hr,soundingStruct)
                    catch ME;
                        disp('Failed')
                        continue
                    end
                    pause(2)
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
                        TvZprint(2015,2,da,hr,soundingStruct)
                        pause(2)
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
                        TvZprint(2015,3,da,hr,soundingStruct)
                        pause(2)
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
else
    while month < 4
        if month ==1
            while da<32
                close all
                for hr = [0,12]
                    try
                        TTwvZ(2015,1,da,hr,soundingStruct,5)
                    catch ME;
                        disp('Failed')
                        continue
                    end
                    pause(2)
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
                        TTwvZ(2015,2,da,hr,soundingStruct,5)
                        pause(2)
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
                        TTwvZ(2015,3,da,hr,soundingStruct,5)
                        pause(2)
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
end