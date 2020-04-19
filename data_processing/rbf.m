clear; clc; close all

% Radius
ke = 1.0833;
ran = ke*(-100:1:100);
[X,Y] = meshgrid(ran,ran);
r = sqrt(X.^2+Y.^2);

% Evaluate RBF function
RBF = 'Wu';
C0 = feval(sprintf('%sC0',RBF));
C2 = feval(sprintf('%sC2',RBF));
C4 = feval(sprintf('%sC4',RBF));
f_0 = C0.rbf(r,50);
f_2 = C2.rbf(r,50);
f_4 = C4.rbf(r,50);

figure(1)
subplot 131
imagesc(f_0);
subplot 132
imagesc(f_2);
subplot 133
imagesc(f_4);
