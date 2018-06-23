%% Documentation Section
% Script:  CCOWindProfile.m
% Author:  Laura Tomkins
% Version Date:  24 May 2017
% Purpose:  Inputs CCO Wind Profiler data and outputs an image of the profile 
%
% Functions Used: windbarb.m
%                   
% Required Paths: N/A
%
% Written By: Laura Tomkins, 17 Aug. 2016

% August 17th, 2016
%
% Note: Vmax: wspd of SBJ, Hmax: height of SBJ
%%

clear all
clc

load cmap

starttime = '20100402130000'; % CHANGE
endtime =   '20100402220000'; % CHANGE
SBJ_parameter = 'height'; % CHANGE

begdayt = datenum(starttime, 'yyyymmddHHMMSS');
enddayt = datenum(endtime, 'yyyymmddHHMMSS');

filename = ['CCO', starttime(3:4), '_915lapwind_neiman'];
load(filename)

cco_ind_winds = find(cco915_dayt > begdayt & cco915_dayt < enddayt); % Indices within time range
cco_dayt_winds_sub = cco915_dayt(cco_ind_winds); % Time matrix
cco915_wspd_sub = cco915_wspd(cco_ind_winds,:); % windspeed matrix
cco915_wdir_sub = cco915_wdir(cco_ind_winds,:);
cco915_u_sub = cco915_u(cco_ind_winds,:);
cco915_v_sub = cco915_v(cco_ind_winds,:);
cco915_u70_sub = cco915_u70(cco_ind_winds,:);
cco915_u340_sub = cco915_u340(cco_ind_winds,:);
cco915_ht_sub = cco915_ht(cco_ind_winds,:); % Height matrix
clear cco_ind_winds

plot_types = {'wspd_totalbarbs', 'wspd_staffs', 'v_totalbarbs', 'u340_totalbarbs', 'u340_staffs'};

% for type = 1%:length(plot_types)
type = 4; % see plot types above
vertskip = 5; % skip this many radar gates for plotting barbs (otherwise too crowded)
timelab = begdayt:0.25:enddayt;

set(0, 'DefaultFigurePosition', [1640,-25,1920,1003])

figure;

% Plot
ax1 = subplot(2,1,1);
switch type
    case 1
        imagesc(cco_dayt_winds_sub,cco915_ht_sub(1,:)/1000,cco915_wspd_sub',[0 35])
    case 2
        imagesc(cco_dayt_winds_sub,cco915_ht_sub(1,:)/1000,cco915_wspd_sub',[0 35])
    case 3
        imagesc(cco_dayt_winds_sub,cco915_ht_sub(1,:)/1000,cco915_v_sub',[0 35])
    case 4
        imagesc(cco_dayt_winds_sub,cco915_ht_sub(1,:)/1000,cco915_u340_sub',[0 35])
    case 5
        imagesc(cco_dayt_winds_sub,cco915_ht_sub(1,:)/1000,cco915_u340_sub',[0 35])
end

a1pos = get(ax1, 'position');
set(gca,'ydir','normal')
axis([begdayt enddayt -0.2 4])
set(gca,'xdir','reverse','fontsize',10,'fontweight','bold')
set(gca,'xtick',timelab,'xticklabel',datestr(timelab,'HH'))
set(gca,'fontsize',10,'fontweight','bold')
cbar = colormap(LCH_Spiral(180,1,180,1));
hc=colorbar;
set(hc,'fontsize',10,'fontweight','bold')
set(ax1, 'position', a1pos);

% plot wind barbs
for i=1:1:length(cco_dayt_winds_sub)
    for j=1:vertskip:size(cco915_ht_sub,2)
        if (~isnan(cco915_wspd_sub(i,j))) && (type == 1 || type == 3 || type == 4)
            windbarb(cco_dayt_winds_sub(i),cco915_ht_sub(1,j)/1000,cco915_wspd_sub(i,j)*1.94,cco915_wdir_sub(i,j),0.04,0.8,'black',1);
        elseif (~isnan(cco915_wspd_sub(i,j))) && (type == 2 || type == 5)
            windbarb(cco_dayt_winds_sub(i),cco915_ht_sub(1,j)/1000,cco915_wspd_sub(i,j)*1.94,cco915_wdir_sub(i,j),0.04,0.8,'black',0);
        end
    end
end

xlabel(['{\leftarrow}Time (UTC):', datestr(begdayt)],'fontsize',10,'fontweight','bold')
ylabel('Height MSL (km)','fontsize',10,'fontweight','bold')
title('CCO Terrain Parallel Wind (340 deg, m/s, shaded), Total Wind Speed (barbs)' ,'fontsize',12,'fontweight','bold')

% Calculating height & speed of SBJ for each time step
% Criteria for SBJ based on Neiman et al. (2010)

SBJ_height = zeros(size(cco_dayt_winds_sub));
SBJ_speed = zeros(size(cco_dayt_winds_sub));

for ind_time = 1:length(cco_dayt_winds_sub)
    
    ind_height = cco915_ht_sub(ind_time,:); % array of height values
    ind_wind = cco915_u340_sub(ind_time,:); % array of speed values
    [peaks,locs] = findpeaks(ind_wind); % finds local max (and index) of wind speed
    min_peak_ind = min(locs); % finds the lowest maximum (i.e. location of LLJ)
    try
        SBJ_height(ind_time) = ind_height(min_peak_ind); % finds the height of LLJ
        SBJ_speed(ind_time) = ind_wind(min_peak_ind); % finds the wspd of LLJ
    catch
        SBJ_height(ind_time) = NaN; % if no LLJ found - set to NaN
        SBJ_speed(ind_time) = NaN;
    end
    
    
    % Criteria - check to make sure LLJ satisfies the SBJ criteria
    
    % adjacent gates must have data
    if isnan(ind_height((min_peak_ind+1))) || isnan(ind_height((min_peak_ind+1))) % if the data above /below is NaN, try the next "jet"
        try
            min_peak_ind = locs(find(locs==min_peak_ind)+1); % sets LLJ to the next local max higher up
            SBJ_height(ind_time) = ind_height(min_peak_ind);
            SBJ_speed(ind_time) = ind_wind(min_peak_ind);
        catch
            warning('Vmax has no data in adjacent gates')
            SBJ_height(ind_time) = NaN;
            SBJ_speed(ind_time) = NaN;
        end
        
    % Hmax must be 200m above ground
    elseif SBJ_height(ind_time) <= 200 
        try
            while SBJ_height(ind_time)<=200
                min_peak_ind = locs(find(locs==min_peak_ind)+1);
                SBJ_height(ind_time) = ind_height(min_peak_ind);
            end
            min_peak_ind = locs(find(locs==min_peak_ind)+1);
            SBJ_height(ind_time) = ind_height(min_peak_ind);
            SBJ_speed(ind_time) = ind_wind(min_peak_ind);
        catch
            warning('Vmax occurs less than 200 m above ground and no other maxima exist')
            SBJ_height(ind_time) = NaN;
            SBJ_speed(ind_time) = NaN;
        end
        
    % Hmax must be less than 3000m above ground    
    elseif SBJ_height(ind_time) > 3000 
        SBJ_height(ind_time) = NaN;
        SBJ_speed(ind_time) = NaN;
        
    % Vmax must be > 12 m/s    
    elseif SBJ_speed(ind_time) < 12        
        try
            while ind_wind(min_peak_ind) < 12
                min_peak_ind = locs(find(locs==min_peak_ind)+1);
            end
            if ind_wind(min_peak_ind) >= 12 && ind_height(min_peak_ind) >= 200 && ind_height(min_peak_ind) < 3000
                SBJ_height(ind_time) = ind_height(min_peak_ind);
                SBJ_speed(ind_time) = ind_wind(min_peak_ind);
            else
                SBJ_height(ind_time) = NaN;
                SBJ_speed(ind_time) = NaN;
            end
        catch
            warning('Vmax is less than 12m/s and no other maxima exist')
            SBJ_height(ind_time) = NaN;
            SBJ_speed(ind_time) = NaN;
        end
    end
    
    % V component must decrease by more than 2 m/s with incresing height
    % somewhere between Hmax and 3km
    thres = abs(ind_height-3000);
    mindiff = min(thres);
    threekm_ind = find(thres == min(mindiff));
    threekmwspd = ind_wind(threekm_ind);
    
    while_ind = min_peak_ind+1;
    speed_diff = abs(SBJ_speed(ind_time)-ind_wind(while_ind));
    while speed_diff < 2
        while_ind = while_ind + 1 ;
        speed_diff = abs(SBJ_speed(ind_time)-ind_wind(while_ind));
        if while_ind == find(ind_height==max(ind_height))
            SBJ_height(ind_time) = NaN;
            SBJ_speed(ind_time) = NaN;
            break
        end
    end
end

SBJ_height = SBJ_height/1000; % convert to km

% Calculate statistics on SB
switch SBJ_parameter
    case 'height'
        plot_case = SBJ_height;
        mean_SBJ = nanmean(SBJ_height);
        median_SBJ = nanmedian(SBJ_height);
        max_SBJ = nanmax(SBJ_height);
        min_SBJ = nanmin(SBJ_height);
        twofive_SBJ = prctile(SBJ_height, 25);
        sevenfive_SBJ = prctile(SBJ_height, 75);
    case 'speed'
        plot_case = SBJ_speed;
        mean_SBJ = nanmean(SBJ_speed);
        median_SBJ = nanmedian(SBJ_speed);
        max_SBJ = nanmax(SBJ_speed);
        min_SBJ = nanmin(SBJ_speed);
        twofive_SBJ = prctile(SBJ_speed, 25);
        sevenfive_SBJ = prctile(SBJ_speed, 75);
    otherwise
        disp('Invalid SBJ parameter')
end

% Plot line below wind profile
ax2 = subplot(2,1,2);
plot(cco_dayt_winds_sub, plot_case, 'LineWidth', 2); 

set(gca,'xdir','reverse','fontsize',10,'fontweight','bold')
set(gca,'xtick',timelab,'xticklabel',datestr(timelab,'HH'))
set(gca,'fontsize',10,'fontweight','bold')
ylim([0 4])
set(gca,'ydir','normal')
xlabel(['{\leftarrow}Time (UTC):', datestr(begdayt)],'fontsize',10,'fontweight','bold')
ylabel('Height MSL (km)','fontsize',10,'fontweight','bold')
title('CCO Average SBJ Height (km)' ,'fontsize',12,'fontweight','bold')

% plots statistics values on line chart
hold on
meanline = refline([0, mean_SBJ]);
set(meanline, 'Color', 'r');
text(cco_dayt_winds_sub(end), mean_SBJ, ['mean = ', num2str(mean_SBJ)], 'BackgroundColor', 'w', 'FontSize', 11)

hold on
medianline = refline([0, median_SBJ]);
set(medianline, 'Color', 'r');
text(cco_dayt_winds_sub(2), median_SBJ, ['median = ', num2str(median_SBJ)], 'BackgroundColor', 'w', 'FontSize', 11)

hold on
maxline = refline([0, max_SBJ]);
set(maxline, 'Color', 'r');
%text(cco_dayt_winds_sub(end), max_SBJ, ['maximum = ', num2str(max_SBJ)], 'BackgroundColor', 'w', 'FontSize', 11)

hold on
minline = refline([0, min_SBJ]);
set(minline, 'Color', 'r');
%text(cco_dayt_winds_sub(end), min_SBJ, ['minimum = ', num2str(min_SBJ)], 'BackgroundColor', 'w', 'FontSize', 11)

hold on
twofiveline = refline([0, twofive_SBJ]);
set(twofiveline, 'Color', 'r');
%text(cco_dayt_winds_sub(end), twofive_SBJ, ['25th percentile = ', num2str(twofive_SBJ)], 'BackgroundColor', 'w', 'FontSize', 11)

hold on
sevenfiveline = refline([0, sevenfive_SBJ]);
set(sevenfiveline, 'Color', 'r');
%text(cco_dayt_winds_sub(1), sevenfive_SBJ, ['75th percentile = ', num2str(sevenfive_SBJ)], 'BackgroundColor', 'w', 'FontSize', 11)

linkaxes([ax1 ax2], 'x') % lines up line and wind profile

% Displays statistics on plot
disp(['Mean SBJ', SBJ_parameter, ' = ', num2str(mean_SBJ)])
disp(['Median SBJ', SBJ_parameter, ' = ', num2str(median_SBJ)])
disp(['Max SBJ', SBJ_parameter, ' = ', num2str(max_SBJ)])
disp(['Min SBJ', SBJ_parameter, ' = ', num2str(min_SBJ)])
%disp(['25th percentile SBJ', SBJ_parameter, ' = ', num2str(twofive_SBJ)])
%disp(['75th percentile SBJ', SBJ_parameter, ' = ', num2str(sevenfive_SBJ)])

keyboard; % stops code if you want to check plot before saving

save_dir = ['/home/disk/zathras/ltomkins/matlab/SBJ_images/' SBJ_parameter, '/'];
save_name = [save_dir, starttime(1:8),'_',starttime(9:10), '_340_SBJ_height.png'];
fig_save_name = [save_dir, starttime(1:8), '_',starttime(9:10),'_340_SBJ_height.fig'];
img = getframe(gcf);
imwrite(img.cdata, save_name);
%saveas(gcf, save_name);
%saveas(gcf, fig_save_name);

close;


%% SCRATCH
%     maxspd=max(cco915_wspd_sub(:));
%     [maxspdrow, maxspdcolumn] = find(cco915_wspd_sub == maxspd);
%     abovemaxspd = cco915_wspd_sub(maxspdrow(1), (maxspdcolumn(1)+1));
%     belowmaxspd = cco915_wspd_sub(maxspdrow(1), (maxspdcolumn(1)-1));
%     maxheight=cco915_ht_sub(maxspdrow(1), maxspdcolumn(1));
%
%     thres = abs(cco915_ht_sub-3000);
%     mindiff = min(thres);
%     [threekmrow, threekmcolumn] = find(thres == min(mindiff));
%
%     threekmwspd = cco915_wspd_sub(maxspdrow(1), threekmcolumn(1)); % wspd at 3km
%
%     deltawspd = maxspd-threekmwspd;

%     if maxspd > 12 && maxheight > 200 && deltawspd > 2 && ~isnan(abovemaxspd) && ~isnan(belowmaxspd)
%         disp(['Vmax = ', num2str(maxspd),' m/s. Height of Vmax is ',num2str(maxheight), ' m']);
%     elseif maxspd <= 12
%         disp('Vmax less than 12 m/s')
%     elseif maxheight <= 200
%         disp('Vmax occurs less than 200 m above ground')
%     elseif deltawspd <= 2
%         disp('V decreases by less than 2 m/s between max speed and 3km')
%     elseif isnan(abovemaxspd) || isnan(belowmaxspd)
%         disp('Adjacent range gates are NAN')
%     end

%     savestring = ['ccoth_', plot_types{type}, '_', starttime(1:8), '.png'];
%     print('-dpng',savestring)
%close

% end