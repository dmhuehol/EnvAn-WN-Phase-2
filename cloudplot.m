%%cloudplot
    %Function to plot the cloud profile of the atmosphere. displaying cloud
    %in orange and cloud-free regions in blue.
    %Requires cloud bounds to already be calculated.
    %
    %General form: [] = cloudplot(y,m,d,h,cloudLB,cloudUB)
    %Inputs:
    %y: year
    %m: month
    %d: day
    %h: hour
    %cloudLB: Array containing the lower bound(s) of the cloud(s) in height
    %coordinates.
    %cloudUB: Array containing the upper bound(s) of the cloud(s) in height
    %coordinates.
    %
    %Note that "cloud" displayed at surface is dicey, and does not
    %necessarily imply fog. The cloud/acloud distinction is currently a
    %binary determined by a threshold (see help for findTheCloud), but the
    %relative humidity-cloud relation is known to be variable at different levels,
    %and is much more linked to relative humidity near or at the surface.
    %
    %Version date: 4/21/2018
    %Last major revision: 4/7/2018
    %Written by: Daniel Hueholt
    %North Carolina State University
    %Undergraduate Research Assistant at Environment Analytics
    %
    %See also findTheCloud
    %

function [] = cloudplot(y,m,d,h,cloudLB,cloudUB)
numberOfClouds = length(cloudLB); %Every cloud has a lower bound
min = 0; s = 30; %Make up a minute and second
xAx = datenum(y,m,d,h,min,s); %This is the input time
noCloud = rectangle('Position',[xAx 0 0.0001 10]); %x,y,width,height
set(noCloud,'FaceColor','b'); set(noCloud,'EdgeColor','b')
for cloudLoop = 1:numberOfClouds %For every cloud
    cloud = rectangle('Position',[xAx cloudLB(cloudLoop) 0.0001 cloudUB(cloudLoop)-cloudLB(cloudLoop)]); %Make a rectangle, same as above
    set(cloud,'FaceColor',[255,128,0]./255) %except this time it's orange
    set(cloud,'EdgeColor',[255,128,0]./255)
end

hold on
cheatForLegend1 = patch([4 5],[4 5],'b'); %Create a blue object
hold on
cheatForLegend2 = patch([3 4],[3 4],[255,128,0]./255); %Create an orange object
legend({'No cloud','Cloud'}) %Make a legend, referring it to the above objects
set(cheatForLegend1,'Visible','off') %Make the blue and orange objects invisible
set(cheatForLegend2,'Visible','off')

xlim([datenum(y,m,d,h,min,0), datenum(y,m,d,h,1,0)]); %Set the x bounds to be reasonably small
ylim([0,10]) %Set y bounds up to 10 km
axe = gca;
set(axe,'FontName','Lato')
xl = xlabel('Time');
set(xl,'FontName','Lato')
yl = ylabel('Height (km)');
set(yl,'FontName','Lato')
xT = datestr(xAx); %Only show a single x tick corresponding to the input time
set(axe,'xtick',xAx)
set(axe,'xticklabel',xT)
t = title(['Cloud profile for ' xT]);
set(t,'FontName','Lato')

end
