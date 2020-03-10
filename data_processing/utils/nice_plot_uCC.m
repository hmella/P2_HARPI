function nice_plot_CC(axis_font_size,axis_line_width,legend_font_size,user_def_axis)
%NICE_PLOT_MAG Summary of this function goes here
%   Detailed explanation goes here

a = (1:6)-0.45;
b = (1:6)+0.45;
d = 1e-02;

% Axis
xlabel('motion level', 'interpreter', 'LaTeX');
ylabel('nRMSE CC (\%)', 'interpreter', 'LaTeX')
ax = gca;
ax.XAxis.TickValues = [1 2 3 4 5 6];
ax.YAxis.TickValues = 0:5:30;
ax.XGrid = 'off';
ax.YGrid = 'off';
ax.XMinorGrid = 'on';
ax.YMinorGrid = 'off';
ax.MinorGridLineStyle = '-';
ax.MinorGridAlpha = 0.1;
ax.GridAlpha = ax.MinorGridAlpha;
ax.Box = 'on';
ax.FontWeight = 'bold';
ax.FontSmoothing = 'on';
ax.FontSize = axis_font_size;
ax.LineWidth = axis_line_width;
ax.XAxis.MinorTick = 'off';
ax.XAxis.MinorTickValues = [a(1):d:b(1), a(2):d:b(2),...
                            a(3):d:b(3), a(4):d:b(4),...
                            a(5):d:b(5), a(6):d:b(6)];
ax.TickLength = [0.025, 0.25];
ax.XAxis.TickLength = [0.0, 0.25];
ax.TickDir = 'in';
ax.TickLabelInterpreter = 'latex';
axis(user_def_axis);

% Legends
l2 = legend('$$\alpha=1$$','$$\alpha=2$$','$$\alpha=3$$','$$\alpha=4$$','$$\alpha=5$$');
l2.FontSize = legend_font_size;
l2.Interpreter = 'LaTeX';

end

