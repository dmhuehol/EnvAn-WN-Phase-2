%%abacusDemo
    %Demonstrates the "abacus plot" used for plotting ASOS surface
    %conditions data against time.
    %
    %Written by: Daniel Hueholt
    %North Carolina State University
    %Undergraduate Research Assistant at Environment Analytics
    %Version date: 3/12/2018
    %Last major revision: 3/11/2018
    %
    %See also surfacePlotter
    %

figure;
plot(datenum(2150,3,3,1,5,0),1,'*'); 
hold on
plot(datenum(2150,3,3,1,5,0),2,'*'); 
hold on; 
plot(datenum(2150,3,3,1,5,0),2.5,'*'); 
hold on
plot(datenum(2150,3,3,1,10,0),1,'*');
hold on
plot(datenum(2150,3,3,1,15,0),1,'*');

asdf = gca;
set(asdf,'YTick',[0.5 1 1.5 2 2.5]); %Don't increment by ones; takes too much space
set(asdf,'YTickLabel',{'Snow','Sleet','Freezing Rain','Rain','Fog'}); %These are all present weather codes currently used for winter weather analysis.
ylim([0.3 2.7]) %+/- 0.2 from first and last wires
datetick;
title('Abacus plot for weather codes - uses fake data')