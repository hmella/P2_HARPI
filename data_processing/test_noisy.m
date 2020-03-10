close all; clear;

% Colors for plots
co = [0.0000 0.4470 0.7410
      0.8500 0.3250 0.0980
      0.9290 0.6940 0.1250
      0.4940 0.1840 0.5560
      0.4660 0.6740 0.1880
      0.3010 0.7450 0.9330
      0.6350 0.0780 0.1840];

%% PATHS
% Inputs path
input_folder = '../data_generation/inputs/';
addpath(input_folder)

% functions paths
addpath(genpath('utils'))
addpath(genpath('/home/hernan/cardiac-motion'))
addpath(genpath('/home/hernan/HARPIanalysis'))

% Output folder
outputs = {'outputs/noisy/HARPI/',
           'outputs/noisy/Exact/',
           'outputs/noisy/HARP/',
           'outputs/noisy/SinMod/'};
for i=1:numel(outputs)
   mkdir(outputs{i});
end
   
%% INPUT DATA
% Analysis to be performed
RUN_EXACT   = true;
RUN_SinMod  = true;
RUN_HARP    = true;
RUN_HARPI   = true;
RUN_TAGGING = RUN_SinMod || RUN_HARP || RUN_HARPI;
RUN_ERROR   = true;

% Errors to be estimated
SinMod_ERROR = true;
HARP_ERROR = true;
HARPI_ERROR = true;

% Number of cardiac phases
fr  = 1:6;
Nfr = numel(fr);

%% FILTERS SPECS (for image processing)
% Filter specs
KSpaceFilter = 'Transmission';
BTW_cutoff = [1 1 1 1];
BTW_order  = [];
KSpaceFollowing = false;

% KSpaceFilter = 'Butterworth';
% BTW_cutoff = [12, 10, 9, 7];
% BTW_order  = 10;
% KSpaceFollowing = false;


%% IMAGING PARAMETERS
% Resolutions
pxsz = [0.001,0.001];
FOV  = [0.1 0.1];
resolution = FOV./pxsz;

% Encoding frequencies
tag_spac = [2.9*pxsz(1) 5.8*pxsz(1) 8*pxsz(1) 11.6*pxsz(1)]; % [m]
ke_spamm = 2*pi./tag_spac;                                   % [rad/m]

%% HARPI INTERPOLATION SPECS
% HARPI options
undersamplingfac = 1;                   % undersampling factor
avgundersampling = false;               % average undersampling 
interpolation    = 'MultiquadricO3RBF';   % interpolation scheme ('gridfit'/'tpaps')
% RBFFactors       = 0.05*ke_spamm;
% smoothingfac     = 1e-4;
RBFFactors       = 0.05*ke_spamm;
smoothingfac     = 1e-4;

% HARPI output folder
if avgundersampling
  harpi_output = [outputs{1},sprintf('%s/avg/%dX/',interpolation,undersamplingfac)];
else
  harpi_output = [outputs{1},sprintf('%s/no_avg/%dX/',interpolation,undersamplingfac)];    
end
mkdir(harpi_output)

%% MAIN CODE
% Data to be analyzed
data = 0:9;
bias_EXACT  = [];                                      % Corrupted exact data
bias_SinMod = [];                                      % Corrupted C-SPAMM data
bias_HARP   = [];                                      % Corrupted C-SPAMM data
bias = [bias_SinMod, bias_HARP, bias_EXACT];
data(bias) = [];

% Sizes
nos = numel(tag_spac);      % number of tag spacings
nod = numel(data);

%% ERRORS
tmp = NaN([nod nos Nfr]);
nRMSE = struct(...
    'HARPI',    tmp,...
    'SinMod',   tmp,...
    'HARP',     tmp);
MDE = struct(...
    'HARPI',    tmp,...
    'SinMod',   tmp,...
    'HARP',     tmp);
nRMSE_CC = struct(...
    'HARPI',    tmp,...
    'SinMod',   tmp,...
    'HARP',     tmp);
nRMSE_RR = struct(...
    'HARPI',    tmp,...
    'SinMod',   tmp,...
    'HARP',     tmp);

% Peak, min and mean strain
tmp = NaN([nod nos Nfr]);
max_values = struct(...
        'CC_HARPI', tmp,...
        'CC_HARP', tmp,...
        'CC_SinMod', tmp,...
        'CC_EXACT', tmp,...
        'RR_HARPI', tmp,...
        'RR_HARP', tmp,...
        'RR_SinMod', tmp,...
        'RR_EXACT', tmp);
min_values = struct(...
        'CC_HARPI', tmp,...
        'CC_HARP', tmp,...
        'CC_SinMod', tmp,...
        'CC_EXACT', tmp,...
        'RR_HARPI', tmp,...
        'RR_HARP', tmp,...
        'RR_SinMod', tmp,...
        'RR_EXACT', tmp);
mean_values = struct(...
        'CC_HARPI', tmp,...
        'CC_HARP', tmp,...
        'CC_SinMod', tmp,...
        'CC_EXACT', tmp,...
        'RR_HARPI', tmp,...
        'RR_HARP', tmp,...
        'RR_SinMod', tmp,...
        'RR_EXACT', tmp);

%% EXACT ANALYSIS
if RUN_EXACT
    for d=1:nod
        for f=1:nos


            % Load data
            filename = sprintf('I_d%02d_f%01d_r%01d.mat',d-1,f-1,0);
            load([input_folder,'reference_images/',filename]);
            load([input_folder,'masks/',filename]);

            % Debug
            fprintf('\n Processing EXACT data (%d/%d)',d-1,nod)

            % Rescale data
            m = I.complex.RescaleSlope;
            b = I.complex.RescaleIntercept;
            Ir = m*double(I.real.Image) + double(b);
            Ii = 1j*(m*double(I.complex.Image) + double(b));
            I = Ir + Ii;

            % Squeeze images
            range = 1:100;
            I = squeeze(I(range,range,1,:,:));
            M = squeeze(M(range,range,1,1,:));

            %
            for i=1:Nfr
                I(:,:,1,i) = I(:,:,1,i)';
                I(:,:,2,i) = I(:,:,2,i)';
                M(:,:,i) = M(:,:,i)';
            end
            
            % Remove outer pixels
            M = removeOuterPixels(M, 1);
            
            % Image size
            Isz = size(M);            
            
            % Get displacements in pixels
            ue = -0.01*angle(I)/0.001;

            % figure(1)
            % subplot 221
            % imagesc(abs(I(:,:,1,6)))
            % subplot 222
            % imagesc(ue(:,:,1,6)); caxis(0.05*[-pi,pi])
            % subplot 223
            % imagesc(abs(I(:,:,2,6)))
            % subplot 224
            % imagesc(ue(:,:,2,6)); caxis(0.05*[-pi,pi])
            % pause
            
            % Displacement
            ux_EXACT = squeeze(ue(:,:,1,:));
            uy_EXACT = squeeze(ue(:,:,2,:));                
            dxe = ux_EXACT(:,:,fr);    % millimeters
            dye = uy_EXACT(:,:,fr);    % millimeters
            dxe(~repmat(M(:,:,1),[1 1 Nfr])) = nan;
            dye(~repmat(M(:,:,1),[1 1 Nfr])) = nan;

            % Strain
            [X, Y] = meshgrid(1:size(ux_EXACT,2), 1:size(ux_EXACT,1));
            options = struct(...
                'X', X,...
                'Y', Y,...
                'mask',M(:,:,1),...
                'times',1:Nfr,...
                'dx', dxe,...
                'dy', dye,...
                'Origin', [],...
                'Orientation', []);
            st = mypixelstrain(options);
            RR_EXACT = NaN([Isz(1) Isz(2) Nfr]);
            CC_EXACT = NaN([Isz(1) Isz(2) Nfr]);
            RR_EXACT(repmat(st.maskimage(:,:,1),[1 1 Nfr])) = st.RR(:);
            CC_EXACT(repmat(st.maskimage(:,:,1),[1 1 Nfr])) = st.CC(:);

            % figure(1)
            % subplot 121;
            % imagesc(CC_EXACT(:,:,end)); colorbar; %caxis([-0.2 0.2])
            % subplot 122;
            % imagesc(RR_EXACT(:,:,end)); colorbar; %caxis([-0.2 0.2])
            % pause(0.1)
            
            % Write exact displacement and strain
            mask_exact = st.maskimage(:,:,1);
            save([outputs{2},filename(1:11),'_n0.mat'],'dxe','dye','RR_EXACT','CC_EXACT','mask_exact');
        end
    end
end


%% SinMod AND HARP ANALYSIS
if RUN_TAGGING

    for f=1:nos

        % SPAMM encoding frequency
        ke = [ke_spamm(f) ke_spamm(f)];

        for d=1:nod

            % Load data
            filename = sprintf('I_d%02d_f%01d_r%01d_n0.mat',d-1,f-1,0);
            load([input_folder,'noisy_images/',filename]);
            load([input_folder,'masks/',filename(1:11),'.mat']);
            
            % Rescale data
            m = I.complex.RescaleSlope;
            b = I.complex.RescaleIntercept;
            Ir = m*double(I.real.Image) + double(b);
            Ii = 1j*(m*double(I.complex.Image) + double(b));
            I = Ir + Ii;
            
            % Squeeze data
            range = 1:100;
            I = squeeze(I(range,range,1,:,:));
            M = squeeze(M(range,range,1,1,:));

            %
            for i=1:Nfr
                M(:,:,i) = M(:,:,i)';
                I(:,:,1,i) = I(:,:,1,i)';
                I(:,:,2,i) = I(:,:,2,i)';
%                 figure(10)
%                 imagesc(abs(I(:,:,1,i)).*abs(I(:,:,2,i))); colormap(gray)
%                 pause
            end

            % Remove outer pixels
            M = removeOuterPixels(M, 1);
            
            % Debug
            fprintf('\n Processing data %d, lambda %d',d-1,f-1)

            % Image size
            Isz = size(I);

            % SinMod Displacement
            if RUN_SinMod

                % Displacement
                options = struct(...
                    'Mask',              M,...
                    'ke',                ke*pxsz(1),...
                    'FOV',               Isz(1:2),...
                    'PixelSize',         [1 1],...
                    'SearchWindow',      [3,3],...
                    'Frames',            1:Nfr,...
                    'show',              false,...
                    'theta',             deg2rad([0 90]),...
                    'UnwrapPhase',       false,...
                    'Seed',              'auto',...
                    'Connectivity',      8,...
                    'CheckQuality',      true,...
                    'QualityPower',      8,...
                    'QualityFilterSize', 15,...
                    'Window',            false,...
                    'Frame2Frame',       true,...
                    'KSpaceFilter',      KSpaceFilter,...
                    'BTW_cutoff',        BTW_cutoff(f),...
                    'BTW_order',         BTW_order,...
                    'KSpaceFollowing',   KSpaceFollowing);
                [us] = get_SinMod_motion(I, options);
                dxs = squeeze(us(:,:,1,:));
                dys = squeeze(us(:,:,2,:));

                % SinMod Strain
                [X, Y] = meshgrid(1:size(dxs,2), 1:size(dys,1));
                options = struct(...
                    'X', X,...
                    'Y', Y,...
                    'mask',M(:,:,1),...
                    'times',1:Nfr,...
                    'dx', dxs,...
                    'dy', dys,...
                    'Origin', [],...
                    'Orientation', []);
                st = mypixelstrain(options);
                RR_SinMod = NaN([Isz(1) Isz(2) Nfr]);
                CC_SinMod = NaN([Isz(1) Isz(2) Nfr]);
                RR_SinMod(repmat(st.maskimage(:,:,1),[1 1 Nfr])) = st.RR(:);
                CC_SinMod(repmat(st.maskimage(:,:,1),[1 1 Nfr])) = st.CC(:);

                % figure(1)
                % imagesc(CC_SinMod(:,:,end))
                % axis off equal
                % colormap jet
                % pause

                % Write displacement and strain
                mask_sinmod = st.maskimage(:,:,1);
                save([outputs{4},filename],'dxs','dys','RR_SinMod','CC_SinMod','mask_sinmod');

            end

            % HARP displacement
            if RUN_HARP
                args = struct(...
                        'Mask',             M,...
                        'ke',               ke*pxsz(1),...
                        'FOV',              Isz(1:2),...
                        'PixelSize',        [1 1],...
                        'Frames',           fr,...
                        'tol',              1e-2,...
                        'maxiter',          30,...
                        'GradientEval',     5,...
                        'SearchWindow',     [3,3],...
                        'PhaseWindow',      [2,2],...
                        'show',             false,...
                        'ShowConvergence',  false,...
                        'Seed',             'auto',...
                        'theta',            [0 pi/2],...
                        'Connectivity',     8,...
                        'KSpaceFilter',     KSpaceFilter,...
                        'BTW_cutoff',       BTW_cutoff(f),...
                        'BTW_order',        BTW_order,...
                        'KSpaceFollowing',  KSpaceFollowing);
                [ux_HARP, uy_HARP] = HARPTracking(I, args);
                dxh = ux_HARP;    % pixels
                dyh = uy_HARP;    % pixels

                % HARP strain
                % TODO: ELIMINAR OPCION ADICIONAL AÑADIDA A mypixelstrain
                [X, Y] = meshgrid(1:size(ux_HARP,2), 1:size(ux_HARP,1));
                options = struct(...
                    'X', X,...
                    'Y', Y,...
                    'mask',M(:,:,1),...
                    'times',1:Nfr,...
                    'dx', ux_HARP,...
                    'dy', uy_HARP,...
                    'Origin', [],...
                    'checknans',  false,...
                    'Orientation', []);
                st = mypixelstrain(options);
                RR_HARP = NaN([Isz(1) Isz(2) Nfr]);
                CC_HARP = NaN([Isz(1) Isz(2) Nfr]);
                RR_HARP(repmat(st.maskimage(:,:,1),[1 1 Nfr])) = st.RR(:);
                CC_HARP(repmat(st.maskimage(:,:,1),[1 1 Nfr])) = st.CC(:);

                % figure(1)
                % subplot 121
                % imagesc(CC_HARP(:,:,end)); colorbar
                % subplot 122
                % imagesc(RR_HARP(:,:,end)); colorbar
                % pause(0.1)

                % Write displacement and strain
                mask_harp = st.maskimage(:,:,1);
                save([outputs{3},filename],...
                     'dxh','dyh','RR_HARP','CC_HARP','mask_harp');

            end

            % HARPI displacement
            if RUN_HARPI

                % Seed points
                seeds_mask = bwmorph(M(:,:,1),'skel',Inf);
                [X,Y] = meshgrid(1:Isz(2),1:Isz(1));
                xi = X(seeds_mask); xi = xi(2:3:end);
                yi = Y(seeds_mask); yi = yi(2:3:end);

                args = struct(...
                        'Mask',             M,...
                        'ke',               ke.*pxsz,...
                        'FOV',              Isz(1:2),...
                        'PixelSize',        [1 1],...
                        'SearchWindow',     [3,3],...
                        'PhaseWindow',      [2,2],...
                        'Frames',           1:Nfr,...
                        'theta',            deg2rad([0 90]),...
                        'show',             false,...
                        'ShowConvergence',  false,...
                        'tol',              1e-8,...
                        'Method',           interpolation,...
                        'RBFFactor',        [1 1.75]*RBFFactors(f),...
                        'RBFFacDist',       'DecreasingLinear',...
                        'SpatialSmoothing', smoothingfac,...
                        'UndersamplingFac', undersamplingfac,...
                        'AvgUndersampling', avgundersampling,...
                        'Seed',             'auto',...
                        'Connectivity',     8,...
                        'TrackingPoint',    [xi,yi],...
                        'KSpaceFilter',     KSpaceFilter,...
                        'BTW_cutoff',       BTW_cutoff(f),...
                        'BTW_order',        BTW_order,...
                        'KSpaceFollowing',  KSpaceFollowing,...
                        'PeakCombination',  false,...
                        'RefPhaseSmoothing',true);
                try
                    metadata = HARPI(I, args);
                catch
                    args.TrackingSupport = true;
                    metadata = HARPI(I, args);
                end
                ux_HARPI = metadata.arraydx;
                uy_HARPI = metadata.arraydy;
                dxi = ux_HARPI;%*pxsz(1);    % pixels to meters
                dyi = uy_HARPI;%*pxsz(2);    % pixels to meters

                % HARP strain
                % TODO: ELIMINAR OPCION ADICIONAL AÑADIDA A mypixelstrain
                [X, Y] = meshgrid(1:size(ux_HARPI,2), 1:size(ux_HARPI,1));
                options = struct(...
                    'X', X,...
                    'Y', Y,...
                    'mask',M(:,:,1),...
                    'times',1:Nfr,...
                    'dx', ux_HARPI,...
                    'dy', uy_HARPI,...
                    'Origin', [],...
                    'checknans',  false,...
                    'Orientation', []);
                st = mypixelstrain(options);
                RR_HARPI = NaN([Isz(1) Isz(2) Nfr]);
                CC_HARPI = NaN([Isz(1) Isz(2) Nfr]);
                RR_HARPI(repmat(st.maskimage(:,:,1),[1 1 Nfr])) = st.RR(:);
                CC_HARPI(repmat(st.maskimage(:,:,1),[1 1 Nfr])) = st.CC(:);

                % figure(1)
                % subplot 121
                % imagesc(CC_HARPI(:,:,end)); colorbar; colormap(jet)
                % subplot 122
                % imagesc(RR_HARPI(:,:,end)); colorbar; colormap(jet)
                % pause(0.1)

                % Write displacement and strain
                mask_harpi = st.maskimage(:,:,1);
                save([harpi_output,filename],...
                     'dxi','dyi','RR_HARPI','CC_HARPI','mask_harpi');
            end                

        end
    end
end


%% ERROR ANALYSIS
if RUN_ERROR
    for f=1:nos         % spacing
        
        % Mean values
        mean_h = zeros([nod Nfr]);
        mean_s = zeros([nod Nfr]); 
        mean_i = zeros([nod Nfr]); 
        mean_e = zeros([nod Nfr]);            

        for d=1:nod

            % Load global data
            filename = sprintf('I_d%02d_f%01d_r%01d_n0.mat',d-1,f-1,0);
            load(['outputs/noisy/Exact/',filename]);
            load([input_folder,'masks/',filename(1:11),'.mat']);

            % Squeeze mask
            M = squeeze(M(:,:,1,1,:));
            for i=1:size(M,3)
                M(:,:,i) = M(:,:,i)';
            end

            % Debug
            fprintf('\n Estimating error metrics in data %d, tag spacing %d',d-1,f-1)
            
            %% Errors estimation                   
            % Reference mask
            m = mask_exact; 
            N = sum(m(:));           
            for l=1:Nfr

                % References
                dx_exact = dxe(:,:,l);  % x-displacement
                dy_exact = dye(:,:,l);  % y-displacement
                CC_EXACT_ = CC_EXACT(:,:,l);  % CC strain component
                RR_EXACT_ = RR_EXACT(:,:,l);  % RR strain component
                me = sqrt(dx_exact(m).^2 + dy_exact(m).^2);   % displacement magnitude
                min_values.CC_HARP(d,f,l) = min(CC_EXACT_(m));
                max_values.CC_HARP(d,f,l)  = max(CC_EXACT_(m));
                min_values.RR_HARP(d,f,l) = min(RR_EXACT_(m));
                max_values.RR_HARP(d,f,l)  = max(RR_EXACT_(m));
                mean_values.RR_HARP(d,f,l) = mean(RR_EXACT_(m));
                mean_values.CC_HARP(d,f,l) = mean(CC_EXACT_(m));
                
                % HARP errors
                if HARP_ERROR
                    load(['outputs/noisy/HARP/',filename]);
                    dx_harp = dxh(:,:,l);  % x-displacement
                    dy_harp = dyh(:,:,l);  % y-displacement
                    CC_HARP_ = CC_HARP(:,:,l);  % CC strain component
                    RR_HARP_ = RR_HARP(:,:,l);  % RR strain component
                    mh = sqrt(dx_harp(m).^2 + dy_harp(m).^2);   % displacement magnitude
                    angle_HARP = rad2deg(acos(abs(dx_harp(m).*dx_exact(m) + ...
                                dy_harp(m).*dy_exact(m))./(mh.*me)));  % directional error
                    MDE.HARP(d,f,l)  = (1/N)*sum(angle_HARP(:));    % mean directional error
                    nRMSE.HARP(d,f,l)  = 1/(max(me)*sqrt(N))*sqrt(sum((dx_harp(m)-dx_exact(m)).^2 + (dy_harp(m)-dy_exact(m)).^2));
                    nRMSE_CC.HARP(d,f,l)  = 1/(max(abs(CC_EXACT_(m)))*sqrt(N))*sqrt(sum((CC_HARP_(m) - CC_EXACT_(m)).^2));
                    nRMSE_RR.HARP(d,f,l)  = 1/(max(abs(RR_EXACT_(m)))*sqrt(N))*sqrt(sum((RR_HARP_(m) - RR_EXACT_(m)).^2));
                    min_values.CC_HARP(d,f,l) = min(CC_HARP_(m));
                    max_values.CC_HARP(d,f,l)  = max(CC_HARP_(m));
                    min_values.RR_HARP(d,f,l) = min(RR_HARP_(m));
                    max_values.RR_HARP(d,f,l)  = max(RR_HARP_(m));
                    mean_values.RR_HARP(d,f,l) = mean(RR_HARP_(m));
                    mean_values.CC_HARP(d,f,l) = mean(CC_HARP_(m));
                end

              % SinMod errors
              if SinMod_ERROR
                  load(['outputs/noisy/SinMod/',filename]);
                  dx_sinmod = dxs(:,:,l);  % x-displacement
                  dy_sinmod = dys(:,:,l);  % y-displacement
                  CC_SinMod_ = CC_SinMod(:,:,l);  % CC strain component
                  RR_SinMod_ = RR_SinMod(:,:,l);  % RR strain component
                  ms = sqrt(dx_sinmod(m).^2 + dy_sinmod(m).^2);   % displacement magnitude
                  angle_SinMod  = rad2deg(acos(abs(dx_sinmod(m).*dx_exact(m) + ...
                                dy_sinmod(m).*dy_exact(m))./(ms.*me)));  % directional error
                  MDE.SinMod(d,f,l)  = (1/N)*sum(angle_SinMod(:));    % mean directional error
                  nRMSE.SinMod(d,f,l)  = 1/(max(me)*sqrt(N))*sqrt(sum((dx_sinmod(m)-dx_exact(m)).^2 + (dy_sinmod(m)-dy_exact(m)).^2));
                  nRMSE_CC.SinMod(d,f,l)  = 1/(max(abs(CC_EXACT_(m)))*sqrt(N))*sqrt(sum((CC_SinMod_(m) - CC_EXACT_(m)).^2));
                  nRMSE_RR.SinMod(d,f,l)  = 1/(max(abs(RR_EXACT_(m)))*sqrt(N))*sqrt(sum((RR_SinMod_(m) - RR_EXACT_(m)).^2));
                  min_values.CC_SinMod(d,f,l) = min(CC_SinMod_(m));
                  max_values.CC_SinMod(d,f,l)  = max(CC_SinMod_(m));
                  min_values.RR_SinMod(d,f,l) = min(RR_SinMod_(m));
                  max_values.RR_SinMod(d,f,l)  = max(RR_SinMod_(m));
                  mean_values.RR_SinMod(d,f,l) = mean(RR_SinMod_(m));
                  mean_values.CC_SinMod(d,f,l) = mean(CC_SinMod_(m));
              end

              % HARPI errors
              if HARPI_ERROR
                  load([harpi_output,filename]);    
                  dx_harpi = dxi(:,:,l);  % x-displacement
                  dy_harpi = dyi(:,:,l);  % y-displacement
                  CC_HARPI_ = CC_HARPI(:,:,l);  % CC strain component
                  RR_HARPI_ = RR_HARPI(:,:,l);  % RR strain component
                  mi = sqrt(dx_harpi(m).^2 + dy_harpi(m).^2);   % displacement magnitude
                  angle_HARPI  = rad2deg(acos(abs(dx_harpi(m).*dx_exact(m) + ...
                                dy_harpi(m).*dy_exact(m))./(mi.*me)));  % directional error
                  MDE.HARPI(d,f,l)  = (1/N)*sum(angle_HARPI(:));    % mean directional error
                  nRMSE.HARPI(d,f,l)  = 1/(max(me)*sqrt(N))*sqrt(sum((dx_harpi(m)-dx_exact(m)).^2 + (dy_harpi(m)-dy_exact(m)).^2));
                  nRMSE_CC.HARPI(d,f,l)  = 1/(max(abs(CC_EXACT_(m)))*sqrt(N))*sqrt(sum((CC_HARPI_(m) - CC_EXACT_(m)).^2));
                  nRMSE_RR.HARPI(d,f,l)  = 1/(max(abs(RR_EXACT_(m)))*sqrt(N))*sqrt(sum((RR_HARPI_(m) - RR_EXACT_(m)).^2));
                  min_values.CC_HARPI(d,f,l) = min(CC_HARPI_(m));
                  max_values.CC_HARPI(d,f,l)  = max(CC_HARPI_(m));
                  min_values.RR_HARPI(d,f,l) = min(RR_HARPI_(m));
                  max_values.RR_HARPI(d,f,l)  = max(RR_HARPI_(m));
                  mean_values.RR_HARPI(d,f,l) = mean(RR_HARPI_(m));
                  mean_values.CC_HARPI(d,f,l) = mean(CC_HARPI_(m));
                  
                  % if l==6
                  %     figure(1)
                  %     subplot 121;
                  %     imagesc(CC_EXACT_); colorbar; caxis([min(CC_EXACT_(:)) max(CC_EXACT_(:))])
                  %     subplot 122;
                  %     imagesc(CC_HARPI_); colorbar; caxis([min(CC_EXACT_(:)) max(CC_EXACT_(:))])
                  %     pause(0.1)
                  % end
                  
              end
                
            end
        end
    end

    %% Errors
    [mean_HARPI_mag, std_HARPI_mag]   = meanstd(100*nRMSE.HARPI,1);
    [mean_SinMod_mag, std_SinMod_mag] = meanstd(100*nRMSE.SinMod,1);
    [mean_HARP_mag, std_HARP_mag]     = meanstd(100*nRMSE.HARP,1);

    [mean_HARPI_ang, std_HARPI_ang]   = meanstd(MDE.HARPI,1);
    [mean_SinMod_ang, std_SinMod_ang] = meanstd(MDE.SinMod,1);
    [mean_HARP_ang, std_HARP_ang]     = meanstd(MDE.HARP,1);    

    [mean_HARPI_CC, std_HARPI_CC]   = meanstd(100*nRMSE_CC.HARPI,1);
    [mean_SinMod_CC, std_SinMod_CC] = meanstd(100*nRMSE_CC.SinMod,1);
    [mean_HARP_CC, std_HARP_CC]     = meanstd(100*nRMSE_CC.HARP,1);

    [mean_HARPI_RR, std_HARPI_RR]   = meanstd(100*nRMSE_RR.HARPI,1);
    [mean_SinMod_RR, std_SinMod_RR] = meanstd(100*nRMSE_RR.SinMod,1);
    [mean_HARP_RR, std_HARP_RR]     = meanstd(100*nRMSE_RR.HARP,1);    
        
    %% Save workspace
    save([harpi_output,'workspace.mat']);

end


%% plots
spa = 1;
figure,
subplot 221
errorbar(mean_HARP_mag(spa,2:end),std_HARP_mag(spa,2:end),'LineWidth',2); hold on
errorbar(mean_HARPI_mag(spa,2:end),std_HARPI_mag(spa,2:end),'LineWidth',2); hold on
errorbar(mean_SinMod_mag(spa,2:end),std_SinMod_mag(spa,2:end),'LineWidth',2); hold off
legend('HARP','HARPI','SinMod')
axis([0 6 0 25])
xlabel('displacement (in wavelengths)', 'interpreter', 'LaTeX');
ylabel('nRMSE (\%)', 'interpreter', 'LaTeX')
ax = gca;
ax.XAxis.TickLabels = [0.1 0.2 0.3 0.4 0.5];
ax.XAxis.TickValues = [1 2 3 4 5];
ax.YAxis.TickValues = [0 5 10 15 20 25];

subplot 222
errorbar(mean_HARP_ang(spa,2:end),std_HARP_ang(spa,2:end),'LineWidth',2); hold on
errorbar(mean_HARPI_ang(spa,2:end),std_HARPI_ang(spa,2:end),'LineWidth',2); hold on
errorbar(mean_SinMod_ang(spa,2:end),std_SinMod_ang(spa,2:end),'LineWidth',2); hold off
legend('HARP','HARPI','SinMod')
axis([0 6 0 10])
xlabel('displacement (in wavelengths)', 'interpreter', 'LaTeX');
ylabel('DE ($^o$)', 'interpreter', 'LaTeX')
ax = gca;
ax.XAxis.TickLabels = [0.1 0.2 0.3 0.4 0.5];
ax.XAxis.TickValues = [1 2 3 4 5];
ax.YAxis.TickValues = [0 2 4 6 8 10];

subplot 223
errorbar(mean_HARP_CC(spa,2:end),std_HARP_CC(spa,2:end),'LineWidth',2); hold on
errorbar(mean_HARPI_CC(spa,2:end),std_HARPI_CC(spa,2:end),'LineWidth',2); hold on
errorbar(mean_SinMod_CC(spa,2:end),std_SinMod_CC(spa,2:end),'LineWidth',2); hold off
legend('HARP','HARPI','SinMod')
axis([0 6 0 160])
xlabel('displacement (in wavelengths)', 'interpreter', 'LaTeX');
ylabel('CC nRMSE (\%)', 'interpreter', 'LaTeX')
ax = gca;
ax.XAxis.TickLabels = [0.1 0.2 0.3 0.4 0.5];
ax.XAxis.TickValues = [1 2 3 4 5];
ax.YAxis.TickValues = [0 20 40 60 80 100 120 140 160];

subplot 224
errorbar(mean_HARP_RR(spa,2:end),std_HARP_RR(spa,2:end),'LineWidth',2); hold on
errorbar(mean_HARPI_RR(spa,2:end),std_HARPI_RR(spa,2:end),'LineWidth',2); hold on
errorbar(mean_SinMod_RR(spa,2:end),std_SinMod_RR(spa,2:end),'LineWidth',2); hold off
legend('HARP','HARPI','SinMod')
axis([0 6 0 250])
xlabel('displacement (in wavelengths)', 'interpreter', 'LaTeX');
ylabel('RR nRMSE (\%)', 'interpreter', 'LaTeX')
ax = gca;
ax.XAxis.TickLabels = [0.1 0.2 0.3 0.4 0.5];
ax.XAxis.TickValues = [1 2 3 4 5];
ax.YAxis.TickValues = [0 40 80 120 160 200 240];