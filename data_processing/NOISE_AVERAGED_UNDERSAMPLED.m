clear; close all; clc;

% HARPI options
% undersamplingfac = 2;           % undersampling factor
% avgundersampling = false;       % average undersampling 
interpolation    = 'MultiquadraticRBF';   % interpolation scheme ('gridfit'/'tpaps')
smoothingfac     = 0.85;        % smoothing factor (0.85/0.98)

% Colors
co = [0.0000 0.4470 0.7410
    0.8500 0.3250 0.0980
    0.9290 0.6940 0.1250
    0.4940 0.1840 0.5560
    0.4660 0.6740 0.1880
    0.3010 0.7450 0.9330
    0.6350 0.0780 0.1840];

% Sizes and widths
plot_line_width = 2;
plot_marker_size = 5;
axis_line_width = 2;
axis_font_size  = 20;
legend_font_size = 11;

% Plots visibility
visibility = 'on';

% Experiments and tag spacings
experiments = {'twist','radial','both'};
WL = [3 6 12];

% Data to be plotted
spa_ = 2;
noi_ = 4;

% Pixel size
pxsz = 0.001;
dr = 0;

% Cardiac phases
cp = [NaN 1 2 3 4 5 ];

% Create figure
figure('Visible',visibility)

for undersamplingfac=[1,2,3,4,5,6]

    % Copy underampling factor
    i = undersamplingfac;

    fprintf('Undersampling factor %d:\n',i)    
    
    for j=[false,true]
        
        % Averaged CC
        avgundersampling = j;
        
        % HARPI output folder
        a_output = '../../data/results/noise/';
        if avgundersampling
            harpi_output = [a_output,sprintf('%s/avg/%dX/',interpolation,undersamplingfac)];
        else
            harpi_output = [a_output,sprintf('%s/no_avg/%dX/',interpolation,undersamplingfac)];
        end
        figures_dir = '/home/hernan/hmella@uc.cl/Inkscape/Paper 2/';

        % Load workspace
        load([harpi_output,'/workspace.mat'],...
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

        %% CC ERROR
        % Plot HARP-I
        if ~j
            plot(cp(2:end),squeeze(mean_HARPI_CC(spa_,noi_,2:end)),'-',...
                    'Color',co(i,:),'MarkerSize',plot_marker_size,'MarkerFaceColor',co(i,:),'LineWidth',plot_line_width); hold on;
        else
            if i > 1           
                plot(cp(2:end),squeeze(mean_HARPI_CC(spa_,noi_,2:end)),'--',...
                        'Color',co(i,:),'MarkerSize',plot_marker_size,'MarkerFaceColor',co(i,:),'LineWidth',plot_line_width); hold on;
            end
        end

        % Print information
        mean = squeeze(mean_HARPI_CC(spa_,noi_,2:end))';
        std  = squeeze(std_HARPI_CC(spa_,noi_,2:end))';
        fprintf('mean nRMSE CC: [%.1f, %.1f, %.1f, %.1f, %.1f]\n',mean(:));
        fprintf('std nRMSE CC:  [%.1f, %.1f, %.1f, %.1f, %.1f]\n',std(:))
        
    end
    
    fprintf('---------------------------------------------\n\n')
        
end

% Plot SinMod
plot(cp(2:end),squeeze(mean_SinMod_CC(spa_,noi_,2:end)),'s',...
            'Color','k','MarkerSize',plot_marker_size,'MarkerFaceColor','k',...
            'MarkerEdgeColor','k'); hold on;


% Make plot nice
nice_plot_avg_uCC(axis_font_size,axis_line_width,legend_font_size,[0.5 5.5 5 40])%[0.5 5.5 5 65])

% Turn off plots
hold off

% Print plots
print('-depsc','-r600', [figures_dir,'Figure_7_']);
print('-dpng','-r600', [figures_dir,'Figure_7_'])