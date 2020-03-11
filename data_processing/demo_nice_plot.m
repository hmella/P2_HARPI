clear; clc; close all

% Dummy image
x = 1:5;
y1 = 10*ones(size(x));
y2 = 50*ones(size(x));
y3 = 100*ones(size(x));

% Plot settings
api = struct(...
    'AxesFontSize',  20,...
    'AxesLineWidth', 2,...
    'LegendFontSize', 13,...
    'Axis', [],...
    'XLabel', true,...
    'YLabel', true,...
    'XLabelStr', 'displacement (in wavelengths)',...
    'YLabelStr', [],...
    'YAxisTickValues', []);
plot_line_width = 2;
plot_marker_size = 3.5;

% Plot FIRST image
figure(1)
plot(x,y1,'LineWidth',plot_line_width); hold on
plot(x,y2,'LineWidth',plot_line_width); hold on
plot(x,y3,'LineWidth',plot_line_width); hold off

% Plot formatting
api.XLabel = true;
api.YLabel = true;
api.YLabelStr = 'nRMSE (\%)';
api.Axis = [0.5 5.5 0 120];
api.YAxisTickValues = 0:10:120;
nice_plot(api);

% Get reference axis and figure
ref_ax = gca;
ref_fig = gcf;
pos = get(ref_fig,'position')
set(gcf,'position',[pos(1) pos(2) 1.6*pos(3) pos(4)])
set(gca,'position',get(ref_ax,'position'))


% Plot SECOND image
figure(2)
plot(x,100*y1,'LineWidth',plot_line_width); hold on
plot(x,100*y2,'LineWidth',plot_line_width); hold on
plot(x,100*y3,'LineWidth',plot_line_width); hold off

% Plot formatting
api.XLabel = true;
api.YLabel = false;
api.YLabelStr = 'nRMSE (\%)';
api.Axis = [0.5 5.5 0 100*120];
api.YAxisTickValues = 0:10*100:100*120;
api.YAxisExponent = 3;
nice_plot(api);

pos = get(ref_fig,'position')
set(gcf,'position',pos)
set(gca,'position',get(ref_ax,'position'))