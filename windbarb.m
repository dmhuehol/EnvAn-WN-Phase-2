%%windbarb
    %
    % Draw wind barb given wind speed and direction on current plot.
    % The size of the barb is scaled by the diagonal length of the plot.
    % Assumes wind speeds are in KNOTS
    %
    % windbarb(x,y,spd,dir,scale,width,color,barb)
    %
    % x: horizontal coordinate
    % y: vertical coordinate
    % spd: wind speed in KNOTS
    % dir: wind direction from in degrees
    % scale: scale factor for barb
    % width: width of lines for barb
    % color: color of barb
    % barb: logical for plotting barbs
    %
    % Written by: Laura Tomkins
    % Research Assistant at Environment Analytics
    % Last updated May 2017
    %

function windbarb(x,y,spd,dir,scale,width,color,barb)

xm = get(gca,'XLim');
ym = get(gca,'YLim');

as = pbaspect; %pbaspect is plot box aspect ratio; helps to scale the barbs
axpos = get(gca,'position');
ppos=get(gcf,'paperposition');

yrat=(axpos(3)/axpos(4))*(ppos(3)/ppos(4));

ll = sqrt((xm(2)-xm(1))^2+(ym(2)-ym(1))^2);
l1 = ll * scale;
%l2 = 0.5 * l1;
l2 = 0.3 * l1;

x0 = x;
y0 = y;

if (strcmp(get(gca,'ydir'),'reverse'))
    ydirflag = -1;
else
    ydirflag = 1;
end

if (strcmp(get(gca,'xdir'),'reverse'))
    xdirflag = -1;
else
    xdirflag = 1;
end



% (x,y) 0/1/3/5/7/9
if dir <= 90
    x1 = x0 + xdirflag*l1 * abs(sin(pi*dir/180)) * (xm(2)-xm(1))/ll;
    y1 = y0 + yrat*ydirflag * l1 * abs(cos(pi*dir/180)) * (ym(2)-ym(1))/ll * as(1)/as(2);
elseif dir <= 180
    x1 = x0 + xdirflag*l1 * abs(sin(pi*dir/180)) * (xm(2)-xm(1))/ll;
    y1 = y0 - yrat*ydirflag * l1 * abs(cos(pi*dir/180)) * (ym(2)-ym(1))/ll * as(1)/as(2);
elseif dir <= 270
    x1 = x0 - xdirflag*l1 * abs(sin(pi*dir/180)) * (xm(2)-xm(1))/ll;
    y1 = y0 - yrat*ydirflag * l1 * abs(cos(pi*dir/180)) * (ym(2)-ym(1))/ll * as(1)/as(2);
else
    x1 = x0 - xdirflag*l1 * abs(sin(pi*dir/180)) * (xm(2)-xm(1))/ll;
    y1 = y0 + yrat*ydirflag * l1 * abs(cos(pi*dir/180)) * (ym(2)-ym(1))/ll * as(1)/as(2);
end

%x3 = x0 + 0.875 * (x1-x0);
%y3 = y0 + 0.875 * (y1-y0);
%x5 = x0 + 0.750 * (x1-x0);
%y5 = y0 + 0.750 * (y1-y0);
%x7 = x0 + 0.625 * (x1-x0);
%y7 = y0 + 0.625 * (y1-y0);
%x9 = x0 + 0.500 * (x1-x0);
%y9 = y0 + 0.500 * (y1-y0);
%x11 = x0 + 0.375 * (x1-x0);
%y11 = y0 + 0.375 * (y1-y0);

x3 = x0 + 0.85 * (x1-x0);
y3 = y0 + 0.85 * (y1-y0);
x5 = x0 + 0.70 * (x1-x0);
y5 = y0 + 0.70 * (y1-y0);
x7 = x0 + 0.55 * (x1-x0);
y7 = y0 + 0.55 * (y1-y0);
x9 = x0 + 0.40 * (x1-x0);
y9 = y0 + 0.40 * (y1-y0);
x11 = x0 + 0.25 * (x1-x0);
y11 = y0 + 0.25 * (y1-y0);



% (x,y) 2/4/6/8/x
l3 = sqrt(l1^2+l2^2-2*l1*l2*cos(pi*(90+30)/180));
d1 = 180/pi*acos((l1^2+l3^2-l2^2)/2/l1/l3);

d0 = dir + d1;
if d0 > 360
    d0 = d0 - 360;
end

if d0 <= 90
    x2 = x0 + xdirflag*l3 * abs(sin(pi*d0/180)) * (xm(2)-xm(1))/ll;
    y2 = y0 + yrat*ydirflag * l3 * abs(cos(pi*d0/180)) * (ym(2)-ym(1))/ll * as(1)/as(2);
elseif d0 <= 180
    x2 = x0 + xdirflag*l3 * abs(sin(pi*d0/180)) * (xm(2)-xm(1))/ll;
    y2 = y0 - yrat*ydirflag * l3 * abs(cos(pi*d0/180)) * (ym(2)-ym(1))/ll * as(1)/as(2);
elseif d0 <= 270
    x2 = x0 - xdirflag*l3 * abs(sin(pi*d0/180)) * (xm(2)-xm(1))/ll;
    y2 = y0 - yrat*ydirflag * l3 * abs(cos(pi*d0/180)) * (ym(2)-ym(1))/ll * as(1)/as(2);
else
    x2 = x0 - xdirflag*l3 * abs(sin(pi*d0/180)) * (xm(2)-xm(1))/ll;
    y2 = y0 + yrat*ydirflag * l3 * abs(cos(pi*d0/180)) * (ym(2)-ym(1))/ll * as(1)/as(2);
end

x4 = x3 + (x2 - x1);
y4 = y3 + (y2 - y1);
x6 = x5 + (x2 - x1);
y6 = y5 + (y2 - y1);
x8 = x7 + (x2 - x1);
y8 = y7 + (y2 - y1);
x10 = x9 + (x2 - x1);
y10 = y9 + (y2 - y1);
x12 = x11 + (x2 - x1);
y12 = y11 + (y2 - y1);
%
% dot at plotting point
%
line(x0,y0,'linestyle','none','marker','o','markersize',2,...
    'markerfacecolor',color,'markeredgecolor',color)

% wind barb
line([x0 x1],[y0 y1],'linewidth',width,'color',color)
if (barb)
    if spd >= 150
        line([x1 x2],[y1 y2],'linewidth',width,'color',color)
        line([x2 x3],[y2 y3],'linewidth',width,'color',color)
        line([x3 x4],[y3 y4],'linewidth',width,'color',color)
        line([x4 x5],[y4 y5],'linewidth',width,'color',color)
        line([x5 x6],[y5 y6],'linewidth',width,'color',color)
        line([x6 x7],[y6 y7],'linewidth',width,'color',color)
    elseif spd >= 140
        line([x1 x2],[y1 y2],'linewidth',width,'color',color)
        line([x2 x3],[y2 y3],'linewidth',width,'color',color)
        line([x3 x4],[y3 y4],'linewidth',width,'color',color)
        line([x4 x5],[y4 y5],'linewidth',width,'color',color)
        line([x5 x6],[y5 y6],'linewidth',width,'color',color)
        line([x7 x8],[y7 y8],'linewidth',width,'color',color)
        line([x9 x10],[y9 y10],'linewidth',width,'color',color)
        line([x11 x12],[y11 y12],'linewidth',width,'color',color)
    elseif spd >= 135
        line([x1 x2],[y1 y2],'linewidth',width,'color',color)
        line([x2 x3],[y2 y3],'linewidth',width,'color',color)
        line([x3 x4],[y3 y4],'linewidth',width,'color',color)
        line([x4 x5],[y4 y5],'linewidth',width,'color',color)
        line([x5 x6],[y5 y6],'linewidth',width,'color',color)
        line([x7 x8],[y7 y8],'linewidth',width,'color',color)
        line([x9 x10],[y9 y10],'linewidth',width,'color',color)
        line([x11 (x12+x11)/2],[y11 (y12+y11)/2],'linewidth',width,'color',color)
    elseif spd >= 130
        line([x1 x2],[y1 y2],'linewidth',width,'color',color)
        line([x2 x3],[y2 y3],'linewidth',width,'color',color)
        line([x3 x4],[y3 y4],'linewidth',width,'color',color)
        line([x4 x5],[y4 y5],'linewidth',width,'color',color)
        line([x5 x6],[y5 y6],'linewidth',width,'color',color)
        line([x7 x8],[y7 y8],'linewidth',width,'color',color)
        line([x9 x10],[y9 y10],'linewidth',width,'color',color)
    elseif spd >= 125
        line([x1 x2],[y1 y2],'linewidth',width,'color',color)
        line([x2 x3],[y2 y3],'linewidth',width,'color',color)
        line([x3 x4],[y3 y4],'linewidth',width,'color',color)
        line([x4 x5],[y4 y5],'linewidth',width,'color',color)
        line([x5 x6],[y5 y6],'linewidth',width,'color',color)
        line([x7 x8],[y7 y8],'linewidth',width,'color',color)
        line([x9 (x10+x9)/2],[y9 (y10+y9)/2],'linewidth',width,'color',color)
    elseif spd >= 120
        line([x1 x2],[y1 y2],'linewidth',width,'color',color)
        line([x2 x3],[y2 y3],'linewidth',width,'color',color)
        line([x3 x4],[y3 y4],'linewidth',width,'color',color)
        line([x4 x5],[y4 y5],'linewidth',width,'color',color)
        line([x5 x6],[y5 y6],'linewidth',width,'color',color)
        line([x7 x8],[y7 y8],'linewidth',width,'color',color)
    elseif spd >= 115
        line([x1 x2],[y1 y2],'linewidth',width,'color',color)
        line([x2 x3],[y2 y3],'linewidth',width,'color',color)
        line([x3 x4],[y3 y4],'linewidth',width,'color',color)
        line([x4 x5],[y4 y5],'linewidth',width,'color',color)
        line([x5 x6],[y5 y6],'linewidth',width,'color',color)
        line([x7 (x8+x7)/2],[y7 (y8+y7)/2],'linewidth',width,'color',color)
    elseif spd >= 110
        line([x1 x2],[y1 y2],'linewidth',width,'color',color)
        line([x2 x3],[y2 y3],'linewidth',width,'color',color)
        line([x3 x4],[y3 y4],'linewidth',width,'color',color)
        line([x4 x5],[y4 y5],'linewidth',width,'color',color)
        line([x5 x6],[y5 y6],'linewidth',width,'color',color)
    elseif spd >= 105
        line([x1 x2],[y1 y2],'linewidth',width,'color',color)
        line([x2 x3],[y2 y3],'linewidth',width,'color',color)
        line([x3 x4],[y3 y4],'linewidth',width,'color',color)
        line([x4 x5],[y4 y5],'linewidth',width,'color',color)
        line([x5 (x6+x5)/2],[y5 (y6+y5)/2],'linewidth',width,'color',color)
    elseif spd >= 100
        line([x1 x2],[y1 y2],'linewidth',width,'color',color)
        line([x2 x3],[y2 y3],'linewidth',width,'color',color)
        line([x3 x4],[y3 y4],'linewidth',width,'color',color)
        line([x4 x5],[y4 y5],'linewidth',width,'color',color)
    elseif spd >= 95
        line([x1 x2],[y1 y2],'linewidth',width,'color',color)
        line([x2 x3],[y2 y3],'linewidth',width,'color',color)
        line([x3 x4],[y3 y4],'linewidth',width,'color',color)
        line([x5 x6],[y5 y6],'linewidth',width,'color',color)
        line([x7 x8],[y7 y8],'linewidth',width,'color',color)
        line([x9 x10],[y9 y10],'linewidth',width,'color',color)
        line([x11 (x12+x11)/2],[y11 (y12+y11)/2],'linewidth',width,'color',color)
    elseif spd >= 90
        line([x1 x2],[y1 y2],'linewidth',width,'color',color)
        line([x2 x3],[y2 y3],'linewidth',width,'color',color)
        line([x3 x4],[y3 y4],'linewidth',width,'color',color)
        line([x5 x6],[y5 y6],'linewidth',width,'color',color)
        line([x7 x8],[y7 y8],'linewidth',width,'color',color)
        line([x9 x10],[y9 y10],'linewidth',width,'color',color)
    elseif spd >= 85
        line([x1 x2],[y1 y2],'linewidth',width,'color',color)
        line([x2 x3],[y2 y3],'linewidth',width,'color',color)
        line([x3 x4],[y3 y4],'linewidth',width,'color',color)
        line([x5 x6],[y5 y6],'linewidth',width,'color',color)
        line([x7 x8],[y7 y8],'linewidth',width,'color',color)
        line([x9 (x10+x9)/2],[y9 (y10+y9)/2],'linewidth',width,'color',color)
    elseif spd >= 80
        line([x1 x2],[y1 y2],'linewidth',width,'color',color)
        line([x2 x3],[y2 y3],'linewidth',width,'color',color)
        line([x3 x4],[y3 y4],'linewidth',width,'color',color)
        line([x5 x6],[y5 y6],'linewidth',width,'color',color)
        line([x7 x8],[y7 y8],'linewidth',width,'color',color)
    elseif spd >= 75
        line([x1 x2],[y1 y2],'linewidth',width,'color',color)
        line([x2 x3],[y2 y3],'linewidth',width,'color',color)
        line([x3 x4],[y3 y4],'linewidth',width,'color',color)
        line([x5 x6],[y5 y6],'linewidth',width,'color',color)
        line([x7 (x8+x7)/2],[y7 (y8+y7)/2],'linewidth',width,'color',color)
    elseif spd >= 70
        line([x1 x2],[y1 y2],'linewidth',width,'color',color)
        line([x2 x3],[y2 y3],'linewidth',width,'color',color)
        line([x3 x4],[y3 y4],'linewidth',width,'color',color)
        line([x5 x6],[y5 y6],'linewidth',width,'color',color)
    elseif spd >= 65
        line([x1 x2],[y1 y2],'linewidth',width,'color',color)
        line([x2 x3],[y2 y3],'linewidth',width,'color',color)
        line([x3 x4],[y3 y4],'linewidth',width,'color',color)
        line([x5 (x6+x5)/2],[y5 (y6+y5)/2],'linewidth',width,'color',color)
    elseif spd >= 60
        line([x1 x2],[y1 y2],'linewidth',width,'color',color)
        line([x2 x3],[y2 y3],'linewidth',width,'color',color)
        line([x3 x4],[y3 y4],'linewidth',width,'color',color)
    elseif spd >= 55
        line([x1 x2],[y1 y2],'linewidth',width,'color',color)
        line([x2 x3],[y2 y3],'linewidth',width,'color',color)
        line([x3 (x4+x3)/2],[y3 (y4+y3)/2],'linewidth',width,'color',color)
    elseif spd >= 50
        line([x1 x2],[y1 y2],'linewidth',width,'color',color)
        line([x2 x3],[y2 y3],'linewidth',width,'color',color)
    elseif spd >= 45
        line([x1 x2],[y1 y2],'linewidth',width,'color',color)
        line([x3 x4],[y3 y4],'linewidth',width,'color',color)
        line([x5 x6],[y5 y6],'linewidth',width,'color',color)
        line([x7 x8],[y7 y8],'linewidth',width,'color',color)
        line([x9 (x10+x9)/2],[y9 (y10+y9)/2],'linewidth',width,'color',color)
    elseif spd >= 40
        line([x1 x2],[y1 y2],'linewidth',width,'color',color)
        line([x3 x4],[y3 y4],'linewidth',width,'color',color)
        line([x5 x6],[y5 y6],'linewidth',width,'color',color)
        line([x7 x8],[y7 y8],'linewidth',width,'color',color)
    elseif spd >= 35
        line([x1 x2],[y1 y2],'linewidth',width,'color',color)
        line([x3 x4],[y3 y4],'linewidth',width,'color',color)
        line([x5 x6],[y5 y6],'linewidth',width,'color',color)
        line([x7 (x8+x7)/2],[y7 (y8+y7)/2],'linewidth',width,'color',color)
    elseif spd >= 30
        line([x1 x2],[y1 y2],'linewidth',width,'color',color)
        line([x3 x4],[y3 y4],'linewidth',width,'color',color)
        line([x5 x6],[y5 y6],'linewidth',width,'color',color)
    elseif spd >= 25
        line([x1 x2],[y1 y2],'linewidth',width,'color',color)
        line([x3 x4],[y3 y4],'linewidth',width,'color',color)
        line([x5 (x6+x5)/2],[y5 (y6+y5)/2],'linewidth',width,'color',color)
    elseif spd >= 20
        line([x1 x2],[y1 y2],'linewidth',width,'color',color)
        line([x3 x4],[y3 y4],'linewidth',width,'color',color)
    elseif spd >= 15
        line([x1 x2],[y1 y2],'linewidth',width,'color',color)
        line([x3 (x4+x3)/2],[y3 (y4+y3)/2],'linewidth',width,'color',color)
    elseif spd >= 10
        line([x1 x2],[y1 y2],'linewidth',width,'color',color)
    elseif spd >= 5
        line([x3 (x4+x3)/2],[y3 (y4+y3)/2],'linewidth',width,'color',color)
        %line([x1 (x2+x1)/2],[y1 (y2+y1)/2],'linewidth',width,'color',color)
    else
        %line([x1 (x2+3*x1)/4],[y1 (y2+3*y1)/4],'linewidth',width,'color',color)
    end
end