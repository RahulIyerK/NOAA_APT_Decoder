close all
clear all
[x,Fs] = audioread('090729 1428 noaa-18.wav');
[M,N] = size(x);
dt = 1/Fs;

x_rectified = abs(x);

n=100;
Wn = 0.4;
b = fir1(n,Wn);

c = filter(b,1,x_rectified);
figure;
plot(c);

max_val = max(frame); % black
min_val = min(frame); % white
color_range = max_val - min_val;
color_quantization = color_range/(2^8);
edges = min_val:color_quantization:max_val;

d = discretize(frame, edges);

figure;
plot(d);

IR_correlation_signal = ideal_sync_IR(Fs);

figure; 
plot(IR_correlation_signal);
r = xcorr(d,IR_correlation_signal);

figure;
plot(r);