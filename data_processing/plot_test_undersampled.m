clear; close all; clc;

% Add functions path
addpath('utils/')

% Data cell
tmp = zeros([8 6]);
data_mean = struct('MAG',tmp,'ANG',tmp,'CC',tmp,'RR',tmp);

% Target frequency
f_target = 2;

% Get data
for undersamplingfac=1:6

    % HARPI options
    avgundersampling = false;               % average undersampling 
    interpolation    = 'Multiquadric3'; % interpolation scheme ('gridfit'/'tpaps')

    % Output folder
    harpi_output = 'outputs/noisy/HARPI/';
    if avgundersampling
        harpi_output = [harpi_output,sprintf('%s/avg/%dX/',interpolation,undersamplingfac)];
    else
        harpi_output = [harpi_output,sprintf('%s/no_avg/%dX/',interpolation,undersamplingfac)];    
    end
    figures_dir = [harpi_output,'figures/'];
    mkdir(figures_dir)

    % Load workspace
    if undersamplingfac==1
        load([harpi_output,'workspace.mat'],...
                'mean_HARP_mag', 'mean_SinMod_mag', 'mean_HARPI_mag',...
                'mean_HARP_ang', 'mean_SinMod_ang', 'mean_HARPI_ang',...
                'mean_HARP_CC', 'mean_SinMod_CC', 'mean_HARPI_CC',...
                'mean_HARP_RR', 'mean_SinMod_RR', 'mean_HARPI_RR'),
    else
        load([harpi_output,'workspace.mat'],...
                'mean_HARPI_mag', 'std_HARPI_mag',...
                'mean_HARPI_ang', 'std_HARPI_ang',...
                'mean_HARPI_CC', 'std_HARPI_CC',...
                'mean_HARPI_RR', 'std_HARPI_RR'),
    end

    % Save data
    data_mean.MAG(undersamplingfac,:) = squeeze(mean_HARPI_mag(f_target,:));
    data_mean.ANG(undersamplingfac,:) = squeeze(mean_HARPI_ang(f_target,:));
    data_mean.CC(undersamplingfac,:) = squeeze(mean_HARPI_CC(f_target,:));
    data_mean.RR(undersamplingfac,:) = squeeze(mean_HARPI_RR(f_target,:));
    if undersamplingfac == 1
        data_mean.MAG(7,:) = squeeze(mean_HARP_mag(f_target,:));
        data_mean.ANG(7,:) = squeeze(mean_HARP_ang(f_target,:));
        data_mean.CC(7,:) = squeeze(mean_HARP_CC(f_target,:));
        data_mean.RR(7,:) = squeeze(mean_HARP_RR(f_target,:));
        data_mean.MAG(8,:) = squeeze(mean_SinMod_mag(f_target,:));
        data_mean.ANG(8,:) = squeeze(mean_SinMod_ang(f_target,:));
        data_mean.CC(8,:) = squeeze(mean_SinMod_CC(f_target,:));
        data_mean.RR(8,:) = squeeze(mean_SinMod_RR(f_target,:));
    end

end

% Colors
% co = linspecer(8);
co = distinguishable_colors(8,'w');

% Plot settings
api = struct(...
    'AxesFontSize',  20,...
    'AxesLineWidth', 2,...
    'LegendFontSize', 17,...
    'LegendLocation', 'northeastoutside',...
    'Axis', [],...
    'XLabel', true,...
    'YLabel', true,...
    'XLabelStr', 'Displacement (in WL)',...
    'YLabelStr', [],...
    'YAxisTickValues', [],...
    'Legend', true);
plot_line_width = 2;
plot_marker_size = 6.5;

% Plots visibility
visibility = 'on';

% Pixel size
pxsz = 0.001;
dr = 0.17;

% Cardiac phases
cp = [NaN 1 2 3 4 5];
labels = [true,false,false,false];

%% ERROR PLOTS
% Plot error for each undersampling factor

% Plot magnitude results
figure('Visible',visibility)
for i=1:8

    if i==1 || i==7 || i== 8
        a(i) = plot(cp,data_mean.MAG(i,:),'s','Color',co(i,:),'MarkerSize',plot_marker_size,'MarkerFaceColor',co(i,:)); hold on;
    else
        plot(cp,data_mean.MAG(i,:),'Color',co(i,:),'LineWidth',plot_line_width); hold on;
    end

end
uistack(a(1),'top')
hold off

% Plot formatting
api.XLabel = false;
api.YLabel = true;
api.YLabelStr = 'nRMSE (\%)';
api.Axis = [0.5 5.5 3 12];
api.YAxisTickValues = 0:3:15;
api.Legend = true;
nice_plot_avg(api);

% Get current axis and figure
ref_ax = gca;
ref_fig = gcf;
fig_pos = get(ref_fig,'position');
ax_pos = get(ref_ax,'position');
set(gcf,'position',[fig_pos(1) fig_pos(2) fig_pos(3) fig_pos(4)])
dx = 0.1;
set(gca,'position',[ax_pos(1) ax_pos(2)+dx ax_pos(3) ax_pos(4)-0.6*dx])

% Export image
print('-depsc','-r600','MAG')


% Plot angular results
figure('Visible',visibility)
for i=1:8

    if i==1 || i==7 || i== 8
        a(i) = plot(cp,data_mean.ANG(i,:),'s','Color',co(i,:),'MarkerSize',plot_marker_size,'MarkerFaceColor',co(i,:)); hold on;
    else
        plot(cp,data_mean.ANG(i,:),'Color',co(i,:),'LineWidth',plot_line_width); hold on;
    end

end
uistack(a(1),'top')
hold off

% Plot formatting
api.XLabel = false;
api.YLabel = true;
api.YLabelStr = 'DE ($^o$)';
api.Axis = [0.5 5.5 1.0 4.5];
api.YAxisTickValues = 0:1:6;
api.Legend = true;
nice_plot_avg(api);

% Set current axes
fig_pos = get(ref_fig,'position');
set(gcf,'position',fig_pos)
set(gca,'position',get(ref_ax,'position'))

% Export image
print('-depsc','-r600','ANG')


% Plot CC results
figure('Visible',visibility)
for i=1:8

    if i==1 || i==7 || i== 8
        a(i) = plot(cp,data_mean.CC(i,:),'s','Color',co(i,:),'MarkerSize',plot_marker_size,'MarkerFaceColor',co(i,:)); hold on;
    else
        plot(cp,data_mean.CC(i,:),'Color',co(i,:),'LineWidth',plot_line_width); hold on;
    end

end
uistack(a(1),'top')
hold off

% Plot formatting
api.XLabel = true;
api.YLabel = true;
api.YLabelStr = 'nRMSE CC (\%)';
api.Axis = [0.5 5.5 0 45];
api.YAxisTickValues = 0:10:150;
api.Legend = false;
nice_plot_avg(api);

% Get current axes
fig_pos = get(ref_fig,'position');
set(gcf,'position',fig_pos)
set(gca,'position',get(ref_ax,'position'))

% Export image
print('-depsc','-r600','CC')


% Plot RR results
figure('Visible',visibility)
for i=1:8

    if i==1 || i==7 || i==8
        a(i) = plot(cp,data_mean.RR(i,:),'s','Color',co(i,:),'MarkerSize',plot_marker_size,'MarkerFaceColor',co(i,:)); hold on;
    else
        plot(cp,data_mean.RR(i,:),'Color',co(i,:),'LineWidth',plot_line_width); hold on;
    end

end
uistack(a(1),'top')
hold off

% Plot formatting
api.XLabel = true;
api.YLabel = true;
api.YLabelStr = 'nRMSE RR (\%)';
api.Axis = [0.5 5.5 10 90];
api.YAxisTickValues = 0:10:100;
api.Legend = false;
nice_plot_avg(api);

% Get current axes
fig_pos = get(ref_fig,'position');
set(gcf,'position',fig_pos)
set(gca,'position',get(ref_ax,'position'))

% Export image
print('-depsc','-r600','RR')