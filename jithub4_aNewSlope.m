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
%Assume that the audio is a continuous signal, with the part of the signal
%with the highest snr near the center of the recording. 
[M,N] = size(x);
dt = 1/Fs;
t = dt*(0:M-1)';

%%%%%%%%%%%%%%%%%%%%%%%%%%%FIR Filter for AM Demod
n=100;%god knows
Wn = 0.4;%6dB point of fir filter
b = fir1(n,Wn);%fir filter TF

%%%AM Demodulation
x_rekt = abs(x); %magnitude of signal x for AM demod
c = filter(b,1,x_rekt);%FIR filtered message from the AM modulated signal
figure;
plot(c);
title("AM Demodulated Message (no discretization)");

%%%Discretization (color)

%discretize the colors in the frame
length_of_msg = size(c);
frame = c(length_of_msg(1)/3:2*length_of_msg(1)/3);
%use middle third of audio signal to get the ranges for colors
max_val = max(frame); % black
min_val = min(frame); % white
color_range = max_val - min_val;
num_bits = 8;%number of quantized bits
color_quantization = color_range/(2^num_bits);
edges = min_val:color_quantization:max_val;
d = discretize(c, edges);%actual discretization

%Squelching Discretized Color Signal
squelch_threshold = 212;%value below which all signal amplitude is 0 
x_sq = d;
x_sq(x_sq < squelch_threshold) = 0;


%Find the beginning of each APT line
%Need to identify the start sequence of the beginning of the line
%option a: find first peak, read a couple transitions, calculate frequency,
%if correct frequency, then start line, 
%if not, then repeat on next peak


%option b: 

figure;
plot(d);
title("Discretized Data");
figure;
plot(x_sq);
title("Squelched Data");
figure;
plot(r);
title("Correlation with Discretized, Squelched Data");
figure;
plot(start_indices_FIR);
title("Start Indices of Sync Pulses");






