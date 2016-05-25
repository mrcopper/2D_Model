function opfig(opn,pw,ph,picsty)
 set(gcf,'paperunit','inch','papersize',[pw ph])
 set(gcf,'paperposition',[0,0,pw,ph])
 if picsty(1)==1, print (gcf, '-dpng', '-painters',  opn), end
 if picsty(2)==1, print (gcf, '-dpdf', '-painters', '-r1800', opn), end
 %if picsty(2)==1, print (gcf, '-dpdf',  opn), end
 if picsty(3)==1, print (gcf, '-depsc2', '-painters' ,opn), end