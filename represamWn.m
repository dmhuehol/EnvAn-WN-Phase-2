%plotStruct generated from makeWarmCloud
%Superseded by compositePlotter and will be removed.

function [] = represamWn(plotStruct)
numColors = 10;
colors = parula(numColors);
%19 
colorCount = 1;
for count = 1:length(plotStruct)
    wpl = plot(plotStruct(count).warmWetbulbs,plotStruct(count).warmwetHeights,'o');
    ylim([0 3]); xlim([-0.5 4])
    set(wpl,'Color',colors(colorCount,:))
    hold on
    wcl = plot(plotStruct(count).warmcloudWetbulbs,plotStruct(count).warmwetcloudHeights,'p');
    ylim([0 3]); xlim([-0.5 4])
    set(wcl,'Color',colors(colorCount,:))
    set(wcl,'MarkerFaceColor',colors(colorCount,:));
    colorCount = colorCount+1;
    hold on
end