clear; clc; close all

% Data to be loaded
d = 0;
f = 3;
r = 0;

% Path to file
input_folder = '../data_generation/inputs/';
% filename = sprintf('I_d%02d_f%01d_r%01d_n%01d.mat',d,f,r,0);
% load([input_folder,'noisy_images/',filename]);
filename = sprintf('I_d%02d_f%01d_r%01d.mat',d,f,0);
load([input_folder,'noise_free_images/',filename]);
m = I.complex.RescaleSlope;
b = I.complex.RescaleIntercept;
Ir = m*double(I.real.Image) + double(b);
Ii = 1j*(m*double(I.complex.Image) + double(b));
I = squeeze(Ir + Ii);

% Plots
figure('Visible','off'),
range = 51:150;
for i=[1 6]
    imagesc(abs(I(range,range,1,i)).*abs(I(range,range,2,i)))
    colormap gray
    axis equal off
    caxis([0 1e+05])
    print('-depsc','-r600',sprintf('im_%01d_noise_free',i))
end