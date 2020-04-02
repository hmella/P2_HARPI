clear; close all; clc;

% Add functions path
addpath('utils/')

% HARPI options
undersamplingfac = 1;                   % undersampling factor
avgundersampling = false;               % average undersampling 
interpolation    = 'Multiquadric3'; % interpolation scheme ('gridfit'/'tpaps')

% Output foldercasa
harpi_output = 'outputs/noise_free/HARPI/';
if avgundersampling
    harpi_output = [harpi_output,sprintf('%s/avg/%dX/',interpolation,undersamplingfac)];
else
    harpi_output = [harpi_output,sprintf('%s/no_avg/%dX/',interpolation,undersamplingfac)];    
end
figures_dir = [harpi_output,'figures/'];
mkdir(figures_dir)

% Load workspace
load([harpi_output,'workspace.mat'],...
         'mean_SinMod_mag', 'std_SinMod_mag',...
         'mean_HARP_mag', 'std_HARP_mag',...
         'mean_HARPI_mag', 'std_HARPI_mag',...
         'mean_SinMod_ang', 'std_SinMod_ang',...
         'mean_HARP_ang', 'std_HARP_ang',...
         'mean_HARPI_ang', 'std_HARPI_ang',...
         'mean_SinMod_CC', 'std_SinMod_CC',...
         'mean_HARP_CC', 'std_HARP_CC',...
         'mean_HARPI_CC', 'std_HARPI_CC',...
         'mean_SinMod_RR', 'std_SinMod_RR',...
         'mean_HARP_RR', 'std_HARP_RR',...
         'mean_HARPI_RR', 'std_HARPI_RR',...
         'nRMSE','nRMSE_CC')

% Colors
co = linspecer(3);
% co = distinguishable_colors(3,'w');

% Plot settings
api = struct(...
    'AxesFontSize',  20,...
    'AxesLineWidth', 2,...
    'LegendFontSize', 17,...
    'Axis', [],...
    'XLabel', true,...
    'YLabel', true,...
    'XLabelStr', 'Displacement (in WL)',...
    'YLabelStr', [],...
    'YAxisTickValues', []);
plot_line_width = 2;
plot_marker_size = 3.5;

% Plots visibility
visibility = 'off';

% Pixel size
pxsz = 0.001;
dr = 0.17;

% Cardiac phases
cp = [NaN 1 2 3 4 5];
labels = [true,false,false,false];

%% ERROR PLOTS
% Wavelengths
WL = [3,6,8,12];

% Plot error for each tag frequency
for f=[2]%[1 2 4]

    % Plot SinMod and HARP results
    figure('Visible',visibility)
    errorbar(cp,squeeze(mean_HARP_mag(f,:)),squeeze(std_HARP_mag(f,:)),'o',...
            'Color',co(2,:),'MarkerSize',plot_marker_size,'MarkerFaceColor',co(2,:),'LineWidth',plot_line_width); hold on        
    errorbar(cp-dr,squeeze(mean_SinMod_mag(f,:)),squeeze(std_SinMod_mag(f,:)),'o',...
            'Color',co(1,:),'MarkerSize',plot_marker_size,'MarkerFaceColor',co(1,:),'LineWidth',plot_line_width); hold on
    errorbar(cp+dr,squeeze(mean_HARPI_mag(f,:)),squeeze(std_HARPI_mag(f,:)),'o',...
            'Color',co(3,:),'MarkerSize',plot_marker_size,'MarkerFaceColor',co(3,:),'LineWidth',plot_line_width); hold off;

    % Plot formatting
    api.XLabel = false;
    api.YLabel = labels(f);
    api.YLabelStr = 'nRMSE (\%)';
    api.Axis = [0.5 5.5 0 20];
    api.YAxisTickValues = 0:5:20;
    nice_plot(api);

    % Get current axis and figure
    if f == 2
        ref_ax = gca;
        ref_fig = gcf;
        fig_pos = get(ref_fig,'position');
        ax_pos = get(ref_ax,'position');
        set(gcf,'position',[fig_pos(1) fig_pos(2) fig_pos(3) fig_pos(4)])
        dx = 0.1;
        set(gca,'position',[ax_pos(1) ax_pos(2)+dx ax_pos(3) ax_pos(4)-0.6*dx])
    else
        fig_pos = get(ref_fig,'position');
        set(gcf,'position',fig_pos)
        set(gca,'position',get(ref_ax,'position'))
    end
    
    % Print plots
    print('-depsc','-r600', [figures_dir,sprintf('MAG_WL_%02d',WL(f))]);
    print('-dpng','-r600', [figures_dir,sprintf('MAG_WL_%02d',WL(f))])

    % Print results
    fprintf('\nnRMSE results\n')
    fprintf('--------------------------------------------------------\n')
    fprintf('HARP mean nRMSE: [%.1f, %.1f, %.1f, %.1f, %.1f]\n',squeeze(mean_HARP_mag(f,2:end)));
    fprintf('HARP std nRMSE:  [%.1f, %.1f, %.1f, %.1f, %.1f]\n',squeeze(std_HARP_mag(f,2:end)))
    fprintf('--------------------------------------------------------\n')
    fprintf('SinMod mean nRMSE: [%.1f, %.1f, %.1f, %.1f, %.1f]\n',squeeze(mean_SinMod_mag(f,2:end)));
    fprintf('SinMod std nRMSE:  [%.1f, %.1f, %.1f, %.1f, %.1f]\n',squeeze(std_SinMod_mag(f,2:end)))
    fprintf('--------------------------------------------------------\n')
    fprintf('HARP-I mean nRMSE: [%.1f, %.1f, %.1f, %.1f, %.1f]\n',squeeze(mean_HARPI_mag(f,2:end)));
    fprintf('HARP-I std nRMSE:  [%.1f, %.1f, %.1f, %.1f, %.1f]\n',squeeze(std_HARPI_mag(f,2:end)))


    %% ANGULAR ERROR

    % Plot results
    figure('Visible',visibility)
    errorbar(cp,squeeze(mean_HARP_ang(f,:)),squeeze(std_HARP_ang(f,:)),'o',...
            'Color',co(2,:),'MarkerSize',plot_marker_size,'MarkerFaceColor',co(2,:),'LineWidth',plot_line_width); hold on        
    errorbar(cp-dr,squeeze(mean_SinMod_ang(f,:)),squeeze(std_SinMod_ang(f,:)),'o',...
            'Color',co(1,:),'MarkerSize',plot_marker_size,'MarkerFaceColor',co(1,:),'LineWidth',plot_line_width); hold on
    errorbar(cp+dr,squeeze(mean_HARPI_ang(f,:)),squeeze(std_HARPI_ang(f,:)),'o',...
            'Color',co(3,:),'MarkerSize',plot_marker_size,'MarkerFaceColor',co(3,:),'LineWidth',plot_line_width); hold off;

    % Plot formatting
    api.XLabel = true;
    api.YLabel = labels(f);
    api.YLabelStr = 'DE ($^o$)';
    api.Axis = [0.5 5.5 0.0 6.0];
    api.YAxisTickValues = 0:1:5;
    nice_plot(api);

    % Set current axes
    fig_pos = get(ref_fig,'position');
    set(gcf,'position',fig_pos)
    set(gca,'position',get(ref_ax,'position'))
    
    % Print plots
    print('-depsc','-r600', [figures_dir,sprintf('DE_WL_%02d',WL(f))]);
    print('-dpng','-r600', [figures_dir,sprintf('DE_WL_%02d',WL(f))])

    % Print results
    fprintf('\nDE results\n')
    fprintf('--------------------------------------------------------\n')
    fprintf('HARP mean DE: [%.2e, %.2e, %.2e, %.2e, %.2e]\n',squeeze(mean_HARP_ang(f,2:end)));
    fprintf('HARP std DE:  [%.2e, %.2e, %.2e, %.2e, %.2e]\n',squeeze(std_HARP_ang(f,2:end)))
    fprintf('--------------------------------------------------------\n')
    fprintf('SinMod mean DE: [%.2e, %.2e, %.2e, %.2e, %.2e]\n',squeeze(mean_SinMod_ang(f,2:end)));
    fprintf('SinMod std DE:  [%.2e, %.2e, %.2e, %.2e, %.2e]\n',squeeze(std_SinMod_ang(f,2:end)))
    fprintf('--------------------------------------------------------\n')
    fprintf('HARP-I mean DE: [%.2e, %.2e, %.2e, %.2e, %.2e]\n',squeeze(mean_HARPI_ang(f,2:end)));
    fprintf('HARP-I std DE:  [%.2e, %.2e, %.2e, %.2e, %.2e]\n',squeeze(std_HARPI_ang(f,2:end)))


    %% CC-COMPONENT ERROR

    % Plot SinMod and HARP results
    figure('Visible',visibility)
    errorbar(cp,squeeze(mean_HARP_CC(f,:)),squeeze(std_HARP_CC(f,:)),'o',...
            'Color',co(2,:),'MarkerSize',plot_marker_size,'MarkerFaceColor',co(2,:),'LineWidth',plot_line_width); hold on        
    errorbar(cp-dr,squeeze(mean_SinMod_CC(f,:)),squeeze(std_SinMod_CC(f,:)),'o',...
            'Color',co(1,:),'MarkerSize',plot_marker_size,'MarkerFaceColor',co(1,:),'LineWidth',plot_line_width); hold on
    errorbar(cp+dr,squeeze(mean_HARPI_CC(f,:)),squeeze(std_HARPI_CC(f,:)),'o',...
            'Color',co(3,:),'MarkerSize',plot_marker_size,'MarkerFaceColor',co(3,:),'LineWidth',plot_line_width); hold off;

    % Plot formatting
    api.XLabel = false;
    api.YLabel = labels(f);
    api.YLabelStr = 'nRMSE CC (\%)';
    api.Axis = [0.5 5.5 0 15];
    api.YAxisTickValues = 0:3:18;
    nice_plot(api);

    % Get current axes
    fig_pos = get(ref_fig,'position');
    set(gcf,'position',fig_pos)
    set(gca,'position',get(ref_ax,'position'))
    
    % Print plots
    print('-depsc','-r600', [figures_dir,sprintf('CC_WL_%02d',WL(f))]);
    print('-dpng','-r600', [figures_dir,sprintf('CC_WL_%02d',WL(f))])


    %% RR-COMPONENT ERROR

    % Plot SinMod and HARP results
    figure('Visible',visibility)
    errorbar(cp,squeeze(mean_HARP_RR(f,:)),squeeze(std_HARP_RR(f,:)),'o',...
            'Color',co(2,:),'MarkerSize',plot_marker_size,'MarkerFaceColor',co(2,:),'LineWidth',plot_line_width); hold on        
    errorbar(cp-dr,squeeze(mean_SinMod_RR(f,:)),squeeze(std_SinMod_RR(f,:)),'o',...
            'Color',co(1,:),'MarkerSize',plot_marker_size,'MarkerFaceColor',co(1,:),'LineWidth',plot_line_width); hold on
    errorbar(cp+dr,squeeze(mean_HARPI_RR(f,:)),squeeze(std_HARPI_RR(f,:)),'o',...
            'Color',co(3,:),'MarkerSize',plot_marker_size,'MarkerFaceColor',co(3,:),'LineWidth',plot_line_width); hold off;

    % Plot formatting
    api.XLabel = true;
    api.YLabel = labels(f);
    api.YLabelStr = 'nRMSE RR (\%)';
    api.Axis = [0.5 5.5 0 70];
    api.YAxisTickValues = 0:20:90;
    nice_plot(api);

    % Get current axes
    fig_pos = get(ref_fig,'position');
    set(gcf,'position',fig_pos)
    set(gca,'position',get(ref_ax,'position'))
    
    % Print plots
    print('-depsc','-r600', [figures_dir,sprintf('RR_WL_%02d',WL(f))]);
    print('-dpng','-r600', [figures_dir,sprintf('RR_WL_%02d',WL(f))])


end


%% PRINT AVERAGES
% Print mean errors
fprintf('\n\n Average errors and stds across displacements:')
fprintf('\n  nRMSE and DE means:')
a = mean_HARP_mag([2],2:end); mu = mean(a); stdev = std(a);
b = mean_HARP_ang([2],2:end); mub = mean(b); stdevb = std(b);
fprintf('\n     HARP:   %.2f pm %.2f%% and %.2f pm %.2f°',mu,stdev,mub,stdevb)
a = mean_SinMod_mag([2],2:end); mu = mean(a); stdev = std(a);
b = mean_SinMod_ang([2],2:end); mub = mean(b); stdevb = std(b);
fprintf('\n     SinMod: %.2f pm %.2f%% and %.2f pm %.2f°',mu,stdev,mub,stdevb)
a = mean_HARPI_mag([2],2:end); mu = mean(a); stdev = std(a);
b = mean_HARPI_ang([2],2:end); mub = mean(b); stdevb = std(b);
fprintf('\n     HARPI:  %.2f pm %.2f%% and %.2f pm %.2f°',mu,stdev,mub,stdevb)

fprintf('\n  nRMSE and DE stds:')
a = std_HARP_mag([2],2:end); mu = mean(a); stdev = std(a);
b = std_HARP_ang([2],2:end); mub = mean(b); stdevb = std(b);
fprintf('\n     HARP:   %.2f pm %.2f%% and %.2f pm %.2f°',mu,stdev,mub,stdevb)
a = std_SinMod_mag([2],2:end); mu = mean(a); stdev = std(a);
b = std_SinMod_ang([2],2:end); mub = mean(b); stdevb = std(b);
fprintf('\n     SinMod: %.2f pm %.2f%% and %.2f pm %.2f°',mu,stdev,mub,stdevb)
a = std_HARPI_mag([2],2:end); mu = mean(a); stdev = std(a);
b = std_HARPI_ang([2],2:end); mub = mean(b); stdevb = std(b);
fprintf('\n     HARPI:  %.2f pm %.2f%% and %.2f pm %.2f°\n',mu,stdev,mub,stdevb)

fprintf('\n  CC and RR means:')
a = mean_HARP_CC([2],2:end); mu = mean(a); stdev = std(a);
b = mean_HARP_RR([2],2:end); mub = mean(b); stdevb = std(b);
fprintf('\n     HARP:   %.2f pm %.2f%% and %.2f pm %.2f%%',mu,stdev,mub,stdevb)
a = mean_SinMod_CC([2],2:end); mu = mean(a); stdev = std(a);
b = mean_SinMod_RR([2],2:end); mub = mean(b); stdevb = std(b);
fprintf('\n     SinMod: %.2f pm %.2f%% and %.2f pm %.2f%%',mu,stdev,mub,stdevb)
a = mean_HARPI_CC([2],2:end); mu = mean(a); stdev = std(a);
b = mean_HARPI_RR([2],2:end); mub = mean(b); stdevb = std(b);
fprintf('\n     HARPI:  %.2f pm %.2f%% and %.2f pm %.2f%%',mu,stdev,mub,stdevb)

fprintf('\n  CC and RR stds:')
a = std_HARP_CC([2],2:end); mu = mean(a); stdev = std(a);
b = std_HARP_RR([2],2:end); mub = mean(b); stdevb = std(b);
fprintf('\n     HARP:   %.2f pm %.2f%% and %.2f pm %.2f%%',mu,stdev,mub,stdevb)
a = std_SinMod_CC([2],2:end); mu = mean(a); stdev = std(a);
b = std_SinMod_RR([2],2:end); mub = mean(b); stdevb = std(b);
fprintf('\n     SinMod: %.2f pm %.2f%% and %.2f pm %.2f%%',mu,stdev,mub,stdevb)
a = std_HARPI_CC([2],2:end); mu = mean(a); stdev = std(a);
b = std_HARPI_RR([2],2:end); mub = mean(b); stdevb = std(b);
fprintf('\n     HARPI:  %.2f pm %.2f%% and %.2f pm %.2f%%\n',mu,stdev,mub,stdevb)