%%abacusDemo
    %demonstrates abacus plot creation for present weathers
    %10/23/17
    %Daniel Hueholt
figure; plot(1,1,'*'); hold on; plot(1,2,'*'); hold on; plot(1,3,'*'); asdf = gca; set(asdf,'YTick',[1 2 3]); set(asdf,'YTickLabel',{'Rain','Snow','Sleet'});