%requires cloud bounds to already be calculated
%Version date 11/29/17
%Written by Daniel Hueholt
%See also findTheCloud
function [] = cloudplot(y,m,d,h,cloudLB,cloudUB)
numberOfClouds = length(cloudLB);
min = 0; s = 0;
xAx = datenum(y,m,d,h,min,s);
noCloud = rectangle('Position',[xAx 0 0.01 8]);
set(noCloud,'FaceColor','b')
set(noCloud,'EdgeColor','b')
set(noCloud,'LineWidth',5)
for cloudLoop = 1:numberOfClouds
    cloud = rectangle('Position',[xAx cloudLB(cloudLoop) 0.01 cloudUB(cloudLoop)-cloudLB(cloudLoop)]);
    set(cloud,'FaceColor',[255,128,0]./255)
    set(cloud,'EdgeColor',[255,128,0]./255)
    set(cloud,'LineWidth',5)
end
end
