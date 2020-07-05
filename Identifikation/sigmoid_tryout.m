close all

steepness = 1;
scale = 10;

x = -10:0.1:10;

mySigmo = @(x,steepness,scale) scale*(2./(1 + exp(-steepness*x))-1);

y = scale*(2*sigmf(x,[steepness 0]) - 1);
y1 = mySigmo(x',steepness,scale);

plot(x,y,'LineWidth',2); hold on
plot(x,y1,'LineWidth',2); hold off
grid on
xlabel('sigmf, P = [2 4]')
ylim([-scale scale]*1.5)