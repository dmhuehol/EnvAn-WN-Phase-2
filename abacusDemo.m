%%abacusDemo
    %demonstrates abacus plot creation for present weather codes
    %11/13/17
    %Daniel Hueholt
figure;
plot(1,1,'*'); 
hold on;
plot(1,2,'*'); 
hold on; 
plot(1,3,'*'); 
hold on
plot(2,1,'*');
hold on
plot(3,1,'*');
asdf = gca;
set(asdf,'YTick',[1 2 3]);
set(asdf,'YTickLabel',{'Rain','Snow','Sleet'});
ylim([0 4])
xlim([0 4])
title('Abacus plot for weather codes - uses fake data')