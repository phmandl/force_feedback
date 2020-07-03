close all

center = 0;
steepness = 1;
scale = 10;

x = -10:0.1:10;

mySigmo = @(x,steepness,center) 2./(1 + exp(-steepness*(x-center)))-1;

y = scale*(2*sigmf(x,[steepness center]) - 1);
y1 = scale*mySigmo(x',steepness,center);

plot(x,y,'LineWidth',2); hold on
plot(x,y1,'LineWidth',2); hold off
grid on
xlabel('sigmf, P = [2 4]')
ylim([-scale scale]*1.5)