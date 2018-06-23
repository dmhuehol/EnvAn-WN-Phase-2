%%viewer
    %Displays either temperature vs height or temperature+wetbulb vs height
    %soundings for an input span of time, opening each as an individual
    %image. Options to save all images are commented out just after the
    %plot settings within the loop.
    %
    %General form: [errorDates] = viewer(soundingStruct,startYear,startMonth,startDay,startHour,endYear,endMonth,endDay,endHour,kmTop,tempToPlot)
    %
    %Output:
    %errorDates: A cell array containing all dates that failed to be
        %plotted. Failures can happen for many possible reasons, but the most
        %common is that the geopotential height calculation failed, usually
        %because the first temperature reading is NaN.
    %
    %Inputs:
    %soundingStruct: A structure of sounding data, which must contain
        %dewpoint and geopotential height data.
    %startYear
    %startMonth
    %startDay
    %startHour: Either 0 or 12 UTC for soundings obeying WMO guidelines
    %endYear
    %endMonth
    %endDay
    %endHour
    %kmTop: Maximum height to be plotted in km; 5km is most common. Wetbulb
        %calculation is dicey above ~13km.
    %tempToPlot: String input, either 'temp' or 'both'. 'temp' will plot
        %temperature vs height only; 'both' will plot temperature+wetbulb vs
        %height.
    %
    %Next phase of viewer will use the geopotential height field from the
    %data preferentially, in reflection of its presence in IGRA v2 data.
    %
    %Version Date: 6/21/2018
    %Last major revision: 6/21/2018
    %Written by: Daniel Hueholt
    %North Carolina State University
    %Undergraduate Research Assistant at Environment Analytics
    %
    %See also addHeight
    %

function [errorDates] = viewer(soundingStruct,startYear,startMonth,startDay,startHour,endYear,endMonth,endDay,endHour,kmTop,tempToPlot)
if nargin~=11
    msg = 'Missing input variable! Check syntax and try again.';
    error(msg)
end

[startInd] = findsnd(startYear,startMonth,startDay,startHour,soundingStruct);
[endInd] = findsnd(endYear,endMonth,endDay,endHour,soundingStruct);

eCount = 1;
if strcmp('both',tempToPlot)==1
    for snum = startInd:endInd
        try
            kmCutoff = logical(soundingStruct(snum).height <= kmTop+1); %Find indices of readings where the height less than the maximum height requested, plus a bit for better plotting
            useTemp = soundingStruct(snum).temp(kmCutoff==1);
            useHeight = soundingStruct(snum).height(kmCutoff==1);
            if isfield(soundingStruct,'wetbulb')==1 %Check if structure already has wetbulb temperature
                useWet = soundingStruct(snum).wetbulb(kmCutoff==1);
            else %If it doesn't, then calculate wetbulb for just this sounding
                usePressure = soundingStruct(snum).pressure(kmCutoff==1);
                usePressure = usePressure./100; %Pressure must be in hPa for wetbulb calculation
                useDew = soundingStruct(snum).dewpt(kmCutoff==1); %Needed for wetbulb calculation
                useWet = NaN(length(useTemp),1);
                for c = 1:length(useTemp)
                    try
                        [useWet(c)] = wetbulb(usePressure(c),useDew(c),useTemp(c));
                    catch ME;
                        %do nothing
                    end
                end
            end
            
            % Extra quality control to prevent jumps in the graphs
            useHeight(useHeight<-150) = NaN;
            useHeight(useHeight>100) = NaN;
            useTemp(useTemp<-150) = NaN;
            useTemp(useTemp>100) = NaN;
            useWet(useWet<-150) = NaN;
            useWet(useWet>100) = NaN;
            soundingStruct(snum).temp(soundingStruct(snum).temp<-150) = NaN;
            
            % Freezing line
            freezingx = [0 16];
            freezingy = ones(1,length(freezingx)).*0;
            
            % Plotting
            f = figure; %Figure is assigned to a handle for save options
            plot(useTemp,useHeight,'Color',[255 128 0]./255,'LineWidth',2.4) %TvZ
            hold on
            plot(freezingy,freezingx,'Color',[1 0 0],'LineWidth',2) %Freezing line
            hold on
            plot(useWet,useHeight,'Color',[128 0 255]./255,'LineWidth',2.4); %TwvZ
            
            % Plot settings
            legend('Temperature','Freezing','Wetbulb')
            dateString = datestr(datenum(soundingStruct(snum).valid_date_num(1),soundingStruct(snum).valid_date_num(2),soundingStruct(snum).valid_date_num(3),soundingStruct(snum).valid_date_num(4),0,0),'mmm dd, yyyy HH UTC'); %For title
            titleHand = title(['Sounding for ' dateString]);
            set(titleHand,'FontName','Lato Bold'); set(titleHand,'FontSize',20)
            xlabHand = xlabel('Temperature in C');
            set(xlabHand,'FontName','Lato Bold'); set(xlabHand,'FontSize',20)
            ylabHand = ylabel('Height in km');
            set(ylabHand,'FontName','Lato Bold'); set(ylabHand,'FontSize',20)
            limits = [0 kmTop];
            ylim(limits);
            ax = gca;
            set(ax,'box','off')
            switch kmTop
                case 13
                    set(ax,'YTick',[0 0.5 1 1.5 2 2.5 3 3.5 4 4.5 5 6 7 8 9 10 11 12 13])
                case 12
                    set(ax,'YTick',[0 0.5 1 1.5 2 2.5 3 3.5 4 4.5 5 6 7 8 9 10 11 12])
                case 11
                    set(ax,'YTick',[0 0.5 1 1.5 2 2.5 3 3.5 4 4.5 5 6 7 8 9 10 11])
                case 10
                    set(ax,'YTick',[0 0.5 1 1.5 2 2.5 3 3.5 4 4.5 5 6 7 8 9 10])
                case 9
                    set(ax,'YTick',[0 0.5 1 1.5 2 2.5 3 3.5 4 4.5 5 6 7 8 9])
                case 8
                    set(ax,'YTick',[0 0.5 1 1.5 2 2.5 3 3.5 4 4.5 5 6 7 8])
                case 7
                    set(ax,'YTick',[0 0.5 1 1.5 2 2.5 3 3.5 4 4.5 5 6 7])
                case 6
                    set(ax,'YTick',[0 0.5 1 1.5 2 2.5 3 3.5 4 4.5 5 5.5 6])
                case 5
                    set(ax,'YTick',[0 0.5 1 1.5 2 2.5 3 3.5 4 4.5 5])
                case 4
                    set(ax,'YTick',[0 0.5 1 1.5 2 2.5 3 3.5 4])
                case 3
                    set(ax,'YTick',[0 0.5 1 1.5 2 2.5 3])
                case 2
                    set(ax,'YTick',[0 0.25 0.5 0.75 1 1.25 1.5 1.75 2])
                case 1
                    set(ax,'YTick',[0 0.125 0.25 0.375 0.5 0.625 0.75 0.875 1])
            end
            set(ax,'FontName','Lato Bold'); set(ax,'FontSize',18)
            hold off
            
            set(ax,'XTick',[-45 -40 -35 -30 -25 -22 -20 -18 -16 -14 -12 -10 -8 -6 -5 -4 -3 -2 -1 0 1 2 3 4 5 6 8 10 12 14 16 18 20 22 25 30 35 40])
            
            if min(useWet)<min(useTemp) %Wetbulb is always less than air temperature
                minLim = min(useWet);
            else %But sometimes the moisture data cuts off early
                minLim = min(useTemp);
            end
            maxLim = max(useTemp);
            xlim([minLim-1 maxLim+1])
            %Max air temperature will always be greater than max wetbulb temperature:
            %Either both have been recorded, in which case air temperature is always
            %greater than wetbulb by definition, or air temperature stopped recording,
            %in which case the wetbulb cannot be calculated anyway.
            
            % Common settings for making poster graphics from Long Island
            %set(ax,'XTick',[-30 -15 -10 -6 -4 -3 -2 -1 0 1 2 3 4 6 7 10])
            %xlim([-15 10]) %Typical to fix axis for poster graphics; this usually covers most cases from Long Island
            
            % Optional save options
            %print(f,'-dpng','-r300')
            % set(f,'PaperPositionMode','manual')
            % set(f,'PaperUnits','inches','PaperPosition',[0 0 9 9])
            % print(f,'-dpng','-r400')
            
            % Blank variables to prevent the old data from being replotted
            useTemp = [];
            useHeight = [];
            useWet = [];
            minLim = [];
            maxLim = [];
        catch ME;
            dateString = datestr(datenum(soundingStruct(snum).valid_date_num(1),soundingStruct(snum).valid_date_num(2),soundingStruct(snum).valid_date_num(3),soundingStruct(snum).valid_date_num(4),0,0),'mmm dd, yyyy HH UTC'); %For title
            disp(['Sounding from ' dateString ' skipped due to plotting error.'])
            errorDates{eCount} = dateString;
            eCount = eCount+1;
        end
    end
elseif strcmp('temp',tempToPlot)==1
    for snum = startInd:endInd
        try
            kmCutoff = logical(soundingStruct(snum).height <= kmTop+1); %Find indices of readings where the height less than the maximum height requested, plus a bit for better plotting
            useTemp = soundingStruct(snum).temp(kmCutoff==1);
            useHeight = soundingStruct(snum).height(kmCutoff==1);
            
            % Extra quality control to prevent jumps in the graphs
            useHeight(useHeight<-150) = NaN;
            useHeight(useHeight>100) = NaN;
            useTemp(useTemp<-150) = NaN;
            useTemp(useTemp>100) = NaN;
                        
            % Freezing line
            freezingx = [0 16];
            freezingy = ones(1,length(freezingx)).*0;
            
            % Plotting
            f = figure; %Figure is assigned to a handle for save options
            plot(useTemp,useHeight,'Color',[255 128 0]./255,'LineWidth',2.4) %TvZ
            hold on
            plot(freezingy,freezingx,'Color',[1 0 0],'LineWidth',2) %Freezing line
            
            % Plot settings
            legend('Temperature','Freezing')
            dateString = datestr(datenum(soundingStruct(snum).valid_date_num(1),soundingStruct(snum).valid_date_num(2),soundingStruct(snum).valid_date_num(3),soundingStruct(snum).valid_date_num(4),0,0),'mmm dd, yyyy HH UTC'); %For title
            titleHand = title(['Sounding for ' dateString]);
            set(titleHand,'FontName','Lato Bold'); set(titleHand,'FontSize',20)
            xlabHand = xlabel('Temperature in C');
            set(xlabHand,'FontName','Lato Bold'); set(xlabHand,'FontSize',20)
            ylabHand = ylabel('Height in km');
            set(ylabHand,'FontName','Lato Bold'); set(ylabHand,'FontSize',20)
            limits = [0 kmTop];
            ylim(limits);
            ax = gca;
            set(ax,'box','off')
            switch kmTop
                case 13
                    set(ax,'YTick',[0 0.5 1 1.5 2 2.5 3 3.5 4 4.5 5 6 7 8 9 10 11 12 13])
                case 12
                    set(ax,'YTick',[0 0.5 1 1.5 2 2.5 3 3.5 4 4.5 5 6 7 8 9 10 11 12])
                case 11
                    set(ax,'YTick',[0 0.5 1 1.5 2 2.5 3 3.5 4 4.5 5 6 7 8 9 10 11])
                case 10
                    set(ax,'YTick',[0 0.5 1 1.5 2 2.5 3 3.5 4 4.5 5 6 7 8 9 10])
                case 9
                    set(ax,'YTick',[0 0.5 1 1.5 2 2.5 3 3.5 4 4.5 5 6 7 8 9])
                case 8
                    set(ax,'YTick',[0 0.5 1 1.5 2 2.5 3 3.5 4 4.5 5 6 7 8])
                case 7
                    set(ax,'YTick',[0 0.5 1 1.5 2 2.5 3 3.5 4 4.5 5 6 7])
                case 6
                    set(ax,'YTick',[0 0.5 1 1.5 2 2.5 3 3.5 4 4.5 5 5.5 6])
                case 5
                    set(ax,'YTick',[0 0.5 1 1.5 2 2.5 3 3.5 4 4.5 5])
                case 4
                    set(ax,'YTick',[0 0.5 1 1.5 2 2.5 3 3.5 4])
                case 3
                    set(ax,'YTick',[0 0.5 1 1.5 2 2.5 3])
                case 2
                    set(ax,'YTick',[0 0.25 0.5 0.75 1 1.25 1.5 1.75 2])
                case 1
                    set(ax,'YTick',[0 0.125 0.25 0.375 0.5 0.625 0.75 0.875 1])
            end
            set(ax,'FontName','Lato Bold'); set(ax,'FontSize',18)
            hold off
            
            set(ax,'XTick',[-45 -40 -35 -30 -25 -22 -20 -18 -16 -14 -12 -10 -8 -6 -5 -4 -3 -2 -1 0 1 2 3 4 5 6 8 10 12 14 16 18 20 22 25 30 35 40])
            
            minLim = min(useTemp);
            maxLim = max(useTemp);
            xlim([minLim-1 maxLim+1])
           
            % Common settings for making poster graphics from Long Island
            %set(ax,'XTick',[-30 -15 -10 -6 -4 -3 -2 -1 0 1 2 3 4 6 7 10])
            %xlim([-15 10]) %Typical to fix axis for poster graphics; this usually covers most cases from Long Island
            
            % Optional save options
            %print(f,'-dpng','-r300')
            % set(f,'PaperPositionMode','manual')
            % set(f,'PaperUnits','inches','PaperPosition',[0 0 9 9])
            % print(f,'-dpng','-r400')
            
            % Blank the variables to prevent data from being replotted
            useTemp = [];
            useHeight = [];
            minLim = [];
            maxLim = [];
            
            pause(1)
            
        catch ME;
            dateString = datestr(datenum(soundingStruct(snum).valid_date_num(1),soundingStruct(snum).valid_date_num(2),soundingStruct(snum).valid_date_num(3),soundingStruct(snum).valid_date_num(4),0,0),'mmm dd, yyyy HH UTC'); %For title
            disp(['Sounding from ' dateString ' skipped due to plotting error.'])
            errorDates{eCount} = dateString;
            eCount = eCount+1;
        end
    end
end

msgbox('End date has been reached!','viewer','help')
end