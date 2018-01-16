sounding = wetSound;
c = 1;
c2 = 1;
rowc = 1;

soundingsToPlot = [48 49 78 79 104 123 124];
forComposite = sounding(soundingsToPlot);

colors = [255,0,0; 255,140,0; 255,225,0; 0,255,0; 4,234,255; 0,0,255; 183,1,255]./255;

plot([0 0],[0,5],'k','LineWidth',2)
hold on
while c<=length(forComposite)
    oho = plot(forComposite(c).wetbulb,forComposite(c).height,'Color',colors(rowc,:),'LineWidth',1.7);
    hold on
    for c2=1:length(forComposite(c).wetbulb)
        if forComposite(c).rhum(c2)>=80
            a = plot(forComposite(c).wetbulb(c2),forComposite(c).height(c2),'p');
            set(a,'Color',colors(rowc,:))
            set(a,'MarkerFaceColor',colors(rowc,:))
            set(a,'MarkerSize',9.6)
            hold on
        else
            b = plot(forComposite(c).wetbulb(c2),forComposite(c).height(c2),'+');
            set(b,'Color',colors(rowc,:))
            set(b,'MarkerFaceColor',colors(rowc,:))
            set(b,'MarkerSize',9.6)
            hold on
        end
    end
    c = c+1;
    rowc = rowc+1;
end
ylim([0 5])
xlim([-7 8])

ax = gca;
set(ax,'FontSize',30)
set(ax,'FontName','Oxygen')

x = xlabel('Wetbulb Temperature in C');
set(x,'FontSize',37)
set(x,'FontName','Oxygen')
yl = ylabel('Height in km');
set(yl,'FontSize',37)
set(yl,'FontName','Oxygen')
