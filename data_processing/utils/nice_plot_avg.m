function nice_plot_avg(varargin)
  %NICE_PLOT_MAG Summary of this function goes here
%   Detailed explanation goes here

    %% PARSE INPUT
    % Default arguments
    defapi = struct(...
            'AxesFontSize',  20,...
            'AxesLineWidth', 2,...
            'LegendFontSize', 13,...
            'LegendLocation', 'northwest',...
            'Axis', [],...
            'XLabel', true,...
            'YLabel', true,...
            'XLabelStr', 'displacement (in wavelengths)',...
            'YLabelStr', [],...
            'YAxisTickValues', 0:10:100,...
            'YAxisExponent', 0,...
            'Legend', []);

    % Check input
    api = parseinputs(defapi, [], varargin{:});

    % Axes options
    a = (1:6)-0.45;
    b = (1:6)+0.45;
    d = 1e-02;

    % Get current axes
    ax = gca;

    % Set XAxis labels
    ax.XAxis.TickValues = [1 2 3 4 5];
    if api.XLabel
        xlabel(api.XLabelStr, 'interpreter', 'LaTeX');
        ax.XAxis.TickLabels = [0.1 0.2 0.3 0.4 0.5];
    else
        ax.XAxis.TickLabels = [];
    end

    % Set YAxis labels
    ax.YAxis.TickValues = api.YAxisTickValues;
    if api.YLabel
        ylabel(api.YLabelStr, 'interpreter', 'LaTeX')
    else
        ax.YAxis.TickLabels = [];
    end
    ax.YAxis.Exponent = api.YAxisExponent;
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
    ax.FontSize = api.AxesFontSize;
    ax.LineWidth = api.AxesLineWidth;
    ax.XAxis.MinorTick = 'off';
    ax.XAxis.MinorTickValues = [a(1):d:b(1), a(2):d:b(2),...
                                a(3):d:b(3), a(4):d:b(4),...
                                a(5):d:b(5), a(6):d:b(6)];
    ax.TickLength = [0.025, 0.25];
    ax.XAxis.TickLength = [0.0, 0.25];
    ax.TickDir = 'in';
    ax.TickLabelInterpreter = 'latex';
    axis(api.Axis);

    % Legends
    if api.Legend
        l2 = legend('$\alpha=2$','$\alpha=3$','$\alpha=4$','$\alpha=5$','$\alpha=6$','HARP','SinMod','$\alpha=1$');
        l2.FontSize = api.LegendFontSize;
        l2.Location = api.LegendLocation;
        l2.Interpreter = 'LaTeX';
    end

end

