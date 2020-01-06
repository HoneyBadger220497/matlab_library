function makePlot(xlab,ylab,xdata,ydata,xerror,yerror)
  % MAKEPLOT(XL,YL,XD,YD,XE,YE) creates a plot with axis labels XL and YL
  % It sets the figure's window size to be uniform when numerouse plots are
  % created, sets the axis' and labels' interpreter to "latex", enlargenes
  % the labels' and axis ticks' font size.
  %
  % MAKEPLOT(XL,YL,XD,YD) plots the data in XD and YD as 'o's
  % MAKEPLOT(XL,YL,XD,YD,XE,YE) creates errorbars for XD and YD as well, pass an
  % empty array if you want any of the two errors not to be used

    f = figure();
    ax = axes();
    if nargin > 4
      if isempty(xerror), xerror = []; end
      if nargin < 6 || isempty(yerror), yerror = []; end
        e1 = errorbar(xdata,ydata,yerror,yerror,xerror,xerror);
    else
        e1 = plot(xdata,ydata);
    end
    l1 = xlabel(xlab);
    l2 = ylabel(ylab);

    set(f,'Position',[255 104 1090 677])
    set(e1,'Marker','o','LineStyle','none','Parent',ax)
    set(ax,'FontSize',20,'TickLabelInterpreter','latex')
    set([l1,l2],'FontSize',20,'Interpreter','latex')
end
