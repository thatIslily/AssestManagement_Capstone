m = readtable('regress_example.xlsx');
N = size(m,1);
inc = N./10;

clf
plotnum=1;
subplot(11,1,plotnum);
plot(m.Date, m.JSEZAR);
title('Full Data Set');

for test=N:-inc:inc
    plotnum = plotnum+1;
    train = [];
    if test>inc
        train = 1:test-inc;
    end
    if test<N
        train = [train test+1:N];
    end
    subplot(11, 1, plotnum);
    i = test-inc+1:test;
    plot(m.Date(train), m.JSEZAR(train),'bo');
    hold on;
    plot(m.Date(i), m.JSEZAR(i),'ro');
    title(['K-Fold #' num2str(plotnum-1) ' (holdout in red)']);
end