close all
[x,Fs] = audioread('090729 1428 noaa-18.wav');
[M,N] = size(x);
dt = 1/Fs;
t = dt*(0:M-1)';

x_rekt = abs(x);

figure
plot(x(208000:215000));
hold on
plot(x_rekt(208000:215000));

% num_samples = round(500e-3 * Fs) + 100;
% 
% figure;
% plot(x(400000:400000+2*num_samples));
% figure;
% plot(x(550000:550000+2*num_samples));
% figure;
% plot(x(1:1+2*num_samples));