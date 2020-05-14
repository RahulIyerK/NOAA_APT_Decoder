close all
clear all
[x,Fs] = audioread('090729 1428 noaa-18.wav');
dt = 1/Fs;


IR_correlation_signal = ideal_sync_IR(Fs);

figure;
x_analytic = hilbert(x);
plot(abs(x_analytic));

sync_corr_output = xcorr(abs(x_analytic),IR_correlation_signal);
figure;
plot(sync_corr_output);

[a,b] = size(x);
[c,d] = size(IR_correlation_signal);

IR_correlation_signal = [IR_correlation_signal; ones(a-c,1)];
sync_corr_output = xcorr(abs(x_analytic), IR_correlation_signal);
figure;
plot(sync_corr_output);

sync_autocorr = xcorr(abs(x_analytic));
figure;
plot(sync_autocorr);
