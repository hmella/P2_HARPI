clear; clc; close all

% RBF function
phi_w = @(r,s) (1-r./s).^4.*(4*r./s+1).*(r<=s);
phi_m = @(r,s) (r.^2 + s.^2).^(3/2);
phi_g = @(r,s) exp(-r.^2./s);
phi_i = @(r,s) 1./sqrt(r.^2+s.^2);

% Domain
ke = 1e+03*[2.1666 1.0833 0.7854 0.5417];
ke = ke(4);
ran = ke*(-0.05:1e-04:0.05);
[X,Y] = meshgrid(ran,ran);

% Radius
r = sqrt(X.^2 + Y.^2);
s = 0.15*ke;

% Evaluate RBF function
f_w = phi_w(r,s);
f_m = phi_m(r,s);
f_g = phi_g(r,s);
f_i = phi_i(r,s);
subplot 221
imagesc(f_w); colorbar
subplot 222
imagesc(f_m); colorbar
subplot 223
imagesc(f_g); colorbar
subplot 224
imagesc(f_i); colorbar