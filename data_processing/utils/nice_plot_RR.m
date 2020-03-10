function nice_plot_CC(axis_font_size,axis_line_width,legend_font_size,user_def_axis,labelx,labely,noisy_data)
%NICE_PLOT_MAG Summary of this function goes here
%   Detailed explanation goes here

    % Check nargin
    if nargin < 7
        noisy_data = false;
    end

    % Axes options
    a = (1:6)-0.45;
    b = (1:6)+0.45;
    d = 1e-02;
    ax = gca;
    % Set XAxis labels
    ax.XAxis.TickValues = [1 2 3 4 5];
    if labelx
        xlabel('displacement (in wavelengths)', 'interpreter', 'LaTeX');
        ax.XAxis.TickLabels = [0.1 0.2 0.3 0.4 0.5];
    else
        ax.XAxis.TickLabels = [];
    end
    % Set YAxis labels
    if noisy_data
        ax.YAxis.TickValues = 0:20:200;
    else
        ax.YAxis.TickValues = 0:20:200;
    end
    if labely
        ylabel('nRMSE RR (\%)', 'interpreter', 'LaTeX')
    else
        ax.YAxis.TickLabels = [];
    end
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
    l2 = legend('HARP','SinMod','HARP-I');
    l2.FontSize = legend_font_size;
    l2.Interpreter = 'LaTeX';

end