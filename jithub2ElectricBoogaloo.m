% given audio file

% we use a filter designed to detect minute markers to identify the first
% clearly decipherable minute marker (i.e the first satellite transmission
% with high SNR)

% we then start scanning at the sample corresponding to this first minute
% marker to identify start sync sequence for the beginning of a line
% We use a second filter designed to remove noise but preseve the sync
% sequences and generate the color vector corresponding to each line

% each sync sequence corresponds to the start of a new image line
% aggregate a 2d matrix of images lines

% plot the 2d matrix somehow... to create the image



close all
[x,Fs] = audioread('090729 1428 noaa-18.wav');
[M,N] = size(x);
dt = 1/Fs;
t = dt*(0:M-1)';

x_rekt = abs(x);

% figure
% % plot(x(208000:215000));
% % hold on
% plot(x_rekt(208000:215000));

a = x_rekt(208000:215000);
z = x(208000:215000);
figure;
plot(a);
n=100;
Wn = 0.4;
b = fir1(n,Wn);

c = filter(b,1,x_rekt);
figure;
plot(c);



num_samples = round(500e-3 * Fs) * 2; % two lines

% figure;
% plot(c(400000:400000+num_samples));
% figure;
% plot(c(550000:550000+num_samples));


frame_sample_count = 2 * 60 * Fs;
start_pt = 2207000;
end_pt = start_pt + frame_sample_count - 1; % 2 min * 60sec/min * Fs samp/sec

frame = c(start_pt:end_pt);
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