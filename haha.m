height1 = wetSound(48).height(1:8); %all in cloud
temp1 = double(wetSound(48).wetbulb(1:8))';

height2 = wetSound(49).height(1:3);
temp2 = double(wetSound(49).wetbulb(1:3))';

height3 = wetSound(78).height(9:13);
temp3 = double(wetSound(78).wetbulb(9:13))';
height35 = wetSound(78).height(16:18);
temp35 = double(wetSound(78).wetbulb(16:18))';

height4 = wetSound(79).height(8:13);
height4(1) = 1;
temp4 = double(wetSound(78).wetbulb(8:13))';
temp4(1) = 0;

height5 = 0;
temp5 = 0;
height55 = wetSound(104).height(3:6);
height55(1) = 0.48;
temp55 = double(wetSound(104).wetbulb(3:6))';
temp55(1) = 0;

height6 = wetSound(123).height(9:11);
temp6 = double(wetSound(123).wetbulb(9:11))';

height7 = wetSound(124).height(1:15);
temp7 = double(wetSound(124).wetbulb(1:15))';

figure;
plot([0 0],[0 5],'r');
hold on
plot(temp1,height1,'p-','Color',[179 2 255]./255,'MarkerFaceColor',[179 2 255]./255)
hold on
plot(temp2,height2,'p-','Color',[0 0 1],'MarkerFaceColor',[0 0 1])
hold on
plot(temp3,height3,'+-','Color',[0 1 0],'MarkerFaceColor',[0 1 0])
hold on
plot(temp3(1:2),height3(1:2),'p-','Color',[0 1 0],'MarkerFaceColor',[0 1 0])
hold on
plot(temp35,height35,'+-','Color',[0 1 0],'MarkerFaceColor',[0 1 0])
hold on
plot(temp35(2),height35(2),'p-','Color',[0 1 0],'MarkerFaceColor',[0 1 0])
hold on
plot(temp4,height4,'p-','Color',[255 208 0]./255,'MarkerFaceColor',[255 208 0]./255)
hold on
plot(temp5,height5,'p-','Color',[255 132 0]./255,'MarkerFaceColor',[255 132 0]./255)
hold on
plot(temp55,height55,'p-','Color',[255 132 0]./255,'MarkerFaceColor',[255 132 0]./255)
hold on
plot(temp6,height6,'p-','Color',[1 0 0],'MarkerFaceColor',[1 0 0])
hold on
plot(temp7,height7,'+-','Color',[0 0 0],'MarkerFaceColor',[0 0 0])
hold on
plot(temp7(1:10),height7(1:10),'p-','Color',[0 0 0],'MarkerFaceColor',[0 0 0]);
hold on
plot(temp7(14:15),height7(14:15),'p-','Color',[0 0 0],'MarkerFaceColor',[0 0 0]);

hold on
plot(wetSound(48).wetbulb,wetSound(48).height,'-)


xlim([-4 8])
ylim([0 5])
aa = ylabel('Height (km)');
set(aa,'FontName','Helvetica'); set(aa,'FontSize',20)
ax = gca;
set(ax,'FontName','Helvetica'); set(ax,'FontSize',16)
ab = xlabel('Wetbulb Temperature (C)')
set(ab,'FontNAme','Helvetica'); set(ab,'FontSize',20)