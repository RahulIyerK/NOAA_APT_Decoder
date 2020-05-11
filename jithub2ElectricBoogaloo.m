%clear all;
close all;
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

x_rekt = abs(x); %magnitude of signal x for AM demod

% figure
% % plot(x(208000:215000));
% % hold on
% plot(x_rekt(208000:215000));

a = x_rekt(208000:215000);%a is a window of values from the rectified signal
z = x(208000:215000);%z is the original signal that corresponds to a

% figure;
% plot(a);
n=100;%god knows
Wn = 0.4;%6dB point of fir filter
b = fir1(n,Wn);%fir filter TF

c = filter(b,1,x_rekt);%FIR filtered message from the AM modulated signal
figure;
plot(c);



num_samples = round(500e-3 * Fs) * 2; % number of samples for two lines

% figure;
% plot(c(400000:400000+num_samples));
% figure;
% plot(c(550000:550000+num_samples));

%create a frame of 2 minutes of APT data
frame_sample_count = 2 * 60 * Fs;
start_pt = 2207000;
end_pt = start_pt + frame_sample_count - 1; % 2 min * 60sec/min * Fs samp/sec

%discretize the colors in the frame
frame = c(start_pt:end_pt);
max_val = max(frame); % black
min_val = min(frame); % white
color_range = max_val - min_val;
color_quantization = color_range/(2^8);
edges = min_val:color_quantization:max_val;
d = discretize(frame, edges);%actual discretization

x_sq = d;
x_sq(x_sq < 200) = 0;

IR_correlation_signal = ideal_sync_IR(Fs);%find the ideal Pulse sequence
                                          %for cross correlation
%IR_corr_minute = ideal_sync_IR_minute(Fs);                                          

figure;
plot(IR_correlation_signal); 
title("Signal to Correlate to");

figure;
plot(x_sq);
title("Squelched discrete signal");




r = xcorr(d,IR_correlation_signal);%cross correlate the signals 
                                   %(Abs Value and FIR filter)
corr_mag_FIR = 6800000; %magnitude of the cross correlation
                        %(determined from data)
start_indices_FIR = find(r>corr_mag_FIR);%select the indices of the
                                         %largest correlation

figure;
plot(d);
title("discretized data");
figure;
plot(r);
title("Correlation with Discretized Data");
figure;
plot(start_indices_FIR);
title("Correlation with Discretized Data");



%cross correlate the signals 
%(Hilbert transform envelope detection)
x_analytic = hilbert(x);


%squelch

%hpf = fir1(8+60, 0.9);
%x_analytic = filter(hpf,1,x_analytic);%FIR filtered message from the AM modulated signal

x_sq2 = abs(x_analytic);
x_sq2(x_sq2 < 0.33) = 0;



figure;
plot(x_sq2);
title("Squelched analytic signal");

r2 = xcorr(x_sq2,IR_correlation_signal);
%r2m = xcorr(abs(x_analytic),IR_corr_minute);
corr_mag_hilbert = 11850; %magnitude of the cross correlation 
                          %(Determined from data)
start_indices = find(r2>corr_mag_hilbert);%select the indices of the
                                          %largest correlation

figure;
plot(abs(x_analytic));
title("Analytic Signal Mangnitude");

figure;
plot(r2);
title("Cross Correlation (Hilbert)");

%figure;
%plot(r2m);
%title("Minute cross correlation");




