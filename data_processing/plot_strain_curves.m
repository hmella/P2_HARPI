clear; clc; close all

% Colors
co = [0.0000 0.4470 0.7410
      0.8500 0.3250 0.0980
      0.9290 0.6940 0.1250
      0.4940 0.1840 0.5560
      0.4660 0.6740 0.1880
      0.3010 0.7450 0.9330
      0.6350 0.0780 0.1840];

% Load strains
load('fullysampled_strain.mat')

% Plot settings
api = struct(...
    'AxesFontSize',  20,...
    'AxesLineWidth', 2,...
    'LegendFontSize', 17,...
    'LegendLocation', 'northeast',...
    'Axis', [],...
    'XLabel', true,...
    'YLabel', true,...
    'XLabelStr', 'Frame',...
    'YLabelStr', 'Strain',...
    'YAxisTickValues', [],...
    'MinorTicks', false);
plot_line_width = 2;
plot_marker_size = 3.5;

%% HARP plot
% Plot curves
visibility = 'on';
figure('visible',visibility)
errorbar(mean(strain_h.segments_CC,1), std(strain_h.segments_CC,1),'o',...
            'Color',co(1,:),'MarkerSize',plot_marker_size,...
            'MarkerFaceColor',co(1,:),'LineWidth',plot_line_width)
% Nice plot        
api.Axis = [0 19 -0.3 0.3];
api.XAxisTickValues = [1 6 12 18];
api.YAxisTickValues = -0.3:0.1:0.3;

ax = gca;
ax.XAxis.TickValues = [1 6 12 18];
xlabel(api.XLabelStr, 'interpreter', 'LaTeX');
ax.YAxis.TickValues = api.YAxisTickValues;
ylabel(api.YLabelStr, 'interpreter', 'LaTeX')
ax.XGrid = 'off';
ax.YGrid = 'off';
ax.XMinorGrid = 'off';
ax.YMinorGrid = 'off';
ax.MinorGridLineStyle = '-';
ax.MinorGridAlpha = 0.1;
ax.Box = 'on';
ax.FontWeight = 'bold';
ax.FontSmoothing = 'on';
ax.FontSize = api.AxesFontSize;
ax.LineWidth = api.AxesLineWidth;
ax.XAxis.MinorTick = 'off';
ax.TickLength = [0.025, 0.25];
ax.XAxis.TickLength = [0.0, 0.25];
ax.TickDir = 'in';
ax.TickLabelInterpreter = 'latex';
axis(api.Axis);

% Get current axis and figure
ref_ax = gca;
ref_fig = gcf;
fig_pos = get(ref_fig,'position');
ax_pos = get(ref_ax,'position');
set(gcf,'position',[fig_pos(1) fig_pos(2) fig_pos(3)-140 fig_pos(4)])
set(gca,'position',[ax_pos(1)+0.1 ax_pos(2) ax_pos(3)-0.15 ax_pos(4)])

% Set position
fig_pos = get(ref_fig,'position');
ax_pos = get(ref_ax,'position');
set(gcf,'position',fig_pos)
set(gca,'position',ax_pos)


%% SinMod plot
% Plot curves
visibility = 'on';
figure('visible',visibility)
errorbar(mean(strain_s.segments_CC,1), std(strain_s.segments_CC,1),'o',...
            'Color',co(1,:),'MarkerSize',plot_marker_size,...
            'MarkerFaceColor',co(1,:),'LineWidth',plot_line_width)
% Nice plot        
api.Axis = [0 19 -0.3 0.3];
api.XAxisTickValues = [1 6 12 18];
api.YAxisTickValues = -0.3:0.1:0.3;

ax = gca;
ax.XAxis.TickValues = [1 6 12 18];
xlabel(api.XLabelStr, 'interpreter', 'LaTeX');
ax.YAxis.TickValues = api.YAxisTickValues;
ylabel(api.YLabelStr, 'interpreter', 'LaTeX')
ax.XGrid = 'off';
ax.YGrid = 'off';
ax.XMinorGrid = 'off';
ax.YMinorGrid = 'off';
ax.MinorGridLineStyle = '-';
ax.MinorGridAlpha = 0.1;
ax.Box = 'on';
ax.FontWeight = 'bold';
ax.FontSmoothing = 'on';
ax.FontSize = api.AxesFontSize;
ax.LineWidth = api.AxesLineWidth;
ax.XAxis.MinorTick = 'off';
ax.TickLength = [0.025, 0.25];
ax.XAxis.TickLength = [0.0, 0.25];
ax.TickDir = 'in';
ax.TickLabelInterpreter = 'latex';
axis(api.Axis);

% Set position
set(gcf,'position',fig_pos)
set(gca,'position',ax_pos)


%% HARPI plot
% Plot curves
visibility = 'on';
figure('visible',visibility)
errorbar(mean(strain_i.segments_CC,1), std(strain_i.segments_CC,1),'o',...
            'Color',co(1,:),'MarkerSize',plot_marker_size,...
            'MarkerFaceColor',co(1,:),'LineWidth',plot_line_width)
% Nice plot        
api.Axis = [0 19 -0.3 0.3];
api.XAxisTickValues = [1 6 12 18];
api.YAxisTickValues = -0.3:0.1:0.3;

ax = gca;
ax.XAxis.TickValues = [1 6 12 18];
xlabel(api.XLabelStr, 'interpreter', 'LaTeX');
ax.YAxis.TickValues = api.YAxisTickValues;
ylabel(api.YLabelStr, 'interpreter', 'LaTeX')
ax.XGrid = 'off';
ax.YGrid = 'off';
ax.XMinorGrid = 'off';
ax.YMinorGrid = 'off';
ax.MinorGridLineStyle = '-';
ax.MinorGridAlpha = 0.1;
ax.Box = 'on';
ax.FontWeight = 'bold';
ax.FontSmoothing = 'on';
ax.FontSize = api.AxesFontSize;
ax.LineWidth = api.AxesLineWidth;
ax.XAxis.MinorTick = 'off';
ax.TickLength = [0.025, 0.25];
ax.XAxis.TickLength = [0.0, 0.25];
ax.TickDir = 'in';
ax.TickLabelInterpreter = 'latex';
axis(api.Axis);

% Set position
set(gcf,'position',fig_pos)
set(gca,'position',ax_pos)