clear; close all; clc;

% Add functions path
addpath('utils/')

% HARPI options
undersamplingfac = 1;                   % undersampling factor
avgundersampling = false;               % average undersampling 
interpolation    = 'MultiquadricO3RBF'; % interpolation scheme ('gridfit'/'tpaps')

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
co = [0.0000 0.4470 0.7410
      0.8500 0.3250 0.0980
      0.9290 0.6940 0.1250
      0.4940 0.1840 0.5560
      0.4660 0.6740 0.1880
      0.3010 0.7450 0.9330
      0.6350 0.0780 0.1840];

% Plot settings
api = struct(...
    'AxesFontSize',  20,...
    'AxesLineWidth', 2,...
    'LegendFontSize', 17,...
    'LegendLocation', 'northeast',...
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
for f=[2]%1:4

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
    api.YLabel = true;
    api.YLabelStr = 'nRMSE (\%)';
    api.Axis = [0.5 5.5 3 15];
    api.YAxisTickValues = 0:3:15;
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
    fprintf('HARP mean nRMSE: [%.1f, %.1f, %.1f, %.1f, %.1f, %.1f]\n',squeeze(mean_HARP_mag(f,:)));
    fprintf('HARP std nRMSE:  [%.1f, %.1f, %.1f, %.1f, %.1f, %.1f]\n',squeeze(std_HARP_mag(f,:)))
    fprintf('--------------------------------------------------------\n')
    fprintf('SinMod mean nRMSE: [%.1f, %.1f, %.1f, %.1f, %.1f, %.1f]\n',squeeze(mean_SinMod_mag(f,:)));
    fprintf('SinMod std nRMSE:  [%.1f, %.1f, %.1f, %.1f, %.1f, %.1f]\n',squeeze(std_SinMod_mag(f,:)))
    fprintf('--------------------------------------------------------\n')
    fprintf('HARP-I mean nRMSE: [%.1f, %.1f, %.1f, %.1f, %.1f, %.1f]\n',squeeze(mean_HARPI_mag(f,:)));
    fprintf('HARP-I std nRMSE:  [%.1f, %.1f, %.1f, %.1f, %.1f, %.1f]\n',squeeze(std_HARPI_mag(f,:)))


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
    api.YLabel = true;
    api.YLabelStr = 'DE ($^o$)';
    api.Axis = [0.5 5.5 1.0 6.5];
    api.YAxisTickValues = 0:1:6;
    nice_plot(api);

    % Set current axes
    fig_pos = get(ref_fig,'position');
    set(gcf,'position',fig_pos)
    set(gca,'position',get(ref_ax,'position'))
    
    % Print plots
    print('-depsc','-r600', [figures_dir,sprintf('DE_WL_%02d',WL(f))]);
    print('-dpng','-r600', [figures_dir,sprintf('DE_WL_%02d',WL(f))])

    % Print results
    fprintf('\n\nDE results\n')
    fprintf('--------------------------------------------------------\n')
    fprintf('HARP mean DE: [%.2e, %.2e, %.2e, %.2e, %.2e, %.2e]\n',squeeze(mean_HARP_ang(f,:)));
    fprintf('HARP std DE:  [%.2e, %.2e, %.2e, %.2e, %.2e, %.2e]\n',squeeze(std_HARP_ang(f,:)))
    fprintf('--------------------------------------------------------\n')
    fprintf('SinMod mean DE: [%.2e, %.2e, %.2e, %.2e, %.2e, %.2e]\n',squeeze(mean_SinMod_ang(f,:)));
    fprintf('SinMod std DE:  [%.2e, %.2e, %.2e, %.2e, %.2e, %.2e]\n',squeeze(std_SinMod_ang(f,:)))
    fprintf('--------------------------------------------------------\n')
    fprintf('HARP-I mean DE: [%.2e, %.2e, %.2e, %.2e, %.2e, %.2e]\n',squeeze(mean_HARPI_ang(f,:)));
    fprintf('HARP-I std DE:  [%.2e, %.2e, %.2e, %.2e, %.2e, %.2e]\n',squeeze(std_HARPI_ang(f,:)))


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
    api.YLabel = true;
    api.YLabelStr = 'nRMSE CC (\%)';
    api.Axis = [0.5 5.5 0 60];
    api.YAxisTickValues = 0:10:150;
    nice_plot(api);

    % Get current axes
    fig_pos = get(ref_fig,'position');
    set(gcf,'position',fig_pos)
    set(gca,'position',get(ref_ax,'position'))
    
    % Print plots
    print('-depsc','-r600', [figures_dir,sprintf('CC_WL_%02d',WL(f))]);
    print('-dpng','-r600', [figures_dir,sprintf('CC_WL_%02d',WL(f))])

    % Print results
    fprintf('\n\nCC nRMSE results\n')
    fprintf('--------------------------------------------------------\n')
    fprintf('HARP mean CC: [%.2e, %.2e, %.2e, %.2e, %.2e, %.2e]\n',squeeze(mean_HARP_CC(f,:)));
    fprintf('HARP std CC:  [%.2e, %.2e, %.2e, %.2e, %.2e, %.2e]\n',squeeze(std_HARP_CC(f,:)))
    fprintf('--------------------------------------------------------\n')
    fprintf('SinMod mean CC: [%.2e, %.2e, %.2e, %.2e, %.2e, %.2e]\n',squeeze(mean_SinMod_CC(f,:)));
    fprintf('SinMod std CC:  [%.2e, %.2e, %.2e, %.2e, %.2e, %.2e]\n',squeeze(std_SinMod_CC(f,:)))
    fprintf('--------------------------------------------------------\n')
    fprintf('HARP-I mean CC: [%.2e, %.2e, %.2e, %.2e, %.2e, %.2e]\n',squeeze(mean_HARPI_CC(f,:)));
    fprintf('HARP-I std CC:  [%.2e, %.2e, %.2e, %.2e, %.2e, %.2e]\n',squeeze(std_HARPI_CC(f,:)));

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
    api.YLabel = true;
    api.YLabelStr = 'nRMSE RR (\%)';
    api.Axis = [0.5 5.5 20 95];
    api.YAxisTickValues = 0:10:100;
    nice_plot(api);

    % Get current axes
    fig_pos = get(ref_fig,'position');
    set(gcf,'position',fig_pos)
    set(gca,'position',get(ref_ax,'position'))
    
    % Print plots
    print('-depsc','-r600', [figures_dir,sprintf('RR_WL_%02d',WL(f))]);
    print('-dpng','-r600', [figures_dir,sprintf('RR_WL_%02d',WL(f))])

    % Print results
    fprintf('\n\nRR nRMSE results\n')
    fprintf('--------------------------------------------------------\n')
    fprintf('HARP mean RR: [%.2e, %.2e, %.2e, %.2e, %.2e, %.2e]\n',squeeze(mean_HARP_RR(f,:)));
    fprintf('HARP std RR:  [%.2e, %.2e, %.2e, %.2e, %.2e, %.2e]\n',squeeze(std_HARP_RR(f,:)))
    fprintf('--------------------------------------------------------\n')
    fprintf('SinMod mean RR: [%.2e, %.2e, %.2e, %.2e, %.2e, %.2e]\n',squeeze(mean_SinMod_RR(f,:)));
    fprintf('SinMod std RR:  [%.2e, %.2e, %.2e, %.2e, %.2e, %.2e]\n',squeeze(std_SinMod_RR(f,:)))
    fprintf('--------------------------------------------------------\n')
    fprintf('HARP-I mean RR: [%.2e, %.2e, %.2e, %.2e, %.2e, %.2e]\n',squeeze(mean_HARPI_RR(f,:)));
    fprintf('HARP-I std RR:  [%.2e, %.2e, %.2e, %.2e, %.2e, %.2e]\n',squeeze(std_HARPI_RR(f,:)))

    % Print mean errors
    fprintf('\n\n Average errors and stds across displacements:')
    fprintf('\n  nRMSE and DE means:')
    a = mean_HARP_mag([2],2:end); mu = mean(a); stdev = std(a);
    b = mean_HARP_ang([2],2:end); mub = mean(b); stdevb = std(b);
    fprintf('\n     HARP:   %.1f pm %.1f%% and %.1f pm %.1f°',mu,stdev,mub,stdevb)
    a = mean_SinMod_mag([2],2:end); mu = mean(a); stdev = std(a);
    b = mean_SinMod_ang([2],2:end); mub = mean(b); stdevb = std(b);
    fprintf('\n     SinMod: %.1f pm %.1f%% and %.1f pm %.1f°',mu,stdev,mub,stdevb)
    a = mean_HARPI_mag([2],2:end); mu = mean(a); stdev = std(a);
    b = mean_HARPI_ang([2],2:end); mub = mean(b); stdevb = std(b);
    fprintf('\n     HARPI:  %.1f pm %.1f%% and %.1f pm %.1f°',mu,stdev,mub,stdevb)

    fprintf('\n  nRMSE and DE stds:')
    a = std_HARP_mag([2],2:end); mu = mean(a); stdev = std(a);
    b = std_HARP_ang([2],2:end); mub = mean(b); stdevb = std(b);
    fprintf('\n     HARP:   %.1f pm %.1f%% and %.1f pm %.1f°',mu,stdev,mub,stdevb)
    a = std_SinMod_mag([2],2:end); mu = mean(a); stdev = std(a);
    b = std_SinMod_ang([2],2:end); mub = mean(b); stdevb = std(b);
    fprintf('\n     SinMod: %.1f pm %.1f%% and %.1f pm %.1f°',mu,stdev,mub,stdevb)
    a = std_HARPI_mag([2],2:end); mu = mean(a); stdev = std(a);
    b = std_HARPI_ang([2],2:end); mub = mean(b); stdevb = std(b);
    fprintf('\n     HARPI:  %.1f pm %.1f%% and %.1f pm %.1f°\n',mu,stdev,mub,stdevb)

    fprintf('\n  CC and RR means:')
    a = mean_HARP_CC([2],2:end); mu = mean(a); stdev = std(a);
    b = mean_HARP_RR([2],2:end); mub = mean(b); stdevb = std(b);
    fprintf('\n     HARP:   %.1f pm %.1f%% and %.1f pm %.1f%%',mu,stdev,mub,stdevb)
    a = mean_SinMod_CC([2],2:end); mu = mean(a); stdev = std(a);
    b = mean_SinMod_RR([2],2:end); mub = mean(b); stdevb = std(b);
    fprintf('\n     SinMod: %.1f pm %.1f%% and %.1f pm %.1f%%',mu,stdev,mub,stdevb)
    a = mean_HARPI_CC([2],2:end); mu = mean(a); stdev = std(a);
    b = mean_HARPI_RR([2],2:end); mub = mean(b); stdevb = std(b);
    fprintf('\n     HARPI:  %.1f pm %.1f%% and %.1f pm %.1f%%',mu,stdev,mub,stdevb)

    fprintf('\n  CC and RR stds:')
    a = std_HARP_CC([2],2:end); mu = mean(a); stdev = std(a);
    b = std_HARP_RR([2],2:end); mub = mean(b); stdevb = std(b);
    fprintf('\n     HARP:   %.1f pm %.1f%% and %.1f pm %.1f%%',mu,stdev,mub,stdevb)
    a = std_SinMod_CC([2],2:end); mu = mean(a); stdev = std(a);
    b = std_SinMod_RR([2],2:end); mub = mean(b); stdevb = std(b);
    fprintf('\n     SinMod: %.1f pm %.1f%% and %.1f pm %.1f%%',mu,stdev,mub,stdevb)
    a = std_HARPI_CC([2],2:end); mu = mean(a); stdev = std(a);
    b = std_HARPI_RR([2],2:end); mub = mean(b); stdevb = std(b);
    fprintf('\n     HARPI:  %.1f pm %.1f%% and %.1f pm %.1f%%\n',mu,stdev,mub,stdevb)

end