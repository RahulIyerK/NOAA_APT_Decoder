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
[x,Fs] = audioread('5-19-LONG.wav');
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
frame = c(length_of_msg(1)/4:length_of_msg(1)/3);%play with this to remove noise
%use middle third of audio signal to get the ranges for colors
max_val = max(frame); % black
min_val = min(frame); % white
color_range = max_val - min_val;
num_bits = 8;%number of quantized bits
color_quantization = color_range/(2^num_bits);
edges = min_val:color_quantization:max_val;
d = discretize(c, edges);%actual discretization

%Squelching Discretized Color Signal
squelch_threshold = 213;%value below which all signal amplitude is 0 
x_sq = d;
x_sq(x_sq < squelch_threshold) = 0;


%Find the beginning of each APT line
%Need to identify the start sequence of the beginning of the line
%option a: find first peak, read a couple transitions, calculate frequency,
%if correct frequency, then start line, 
%if not, then repeat on next peak


size_sig = size(x_sq)
lineStarts = zeros(size_sig);
index = 1;
count = 1;
IR_correlation_signal = ideal_sync_IR(Fs);%find the ideal Pulse sequence
figure;
plot(IR_correlation_signal);
correlationThreshold = 10000;
skipStep = ceil(0.499/dt)
while index < (size_sig(1)-floor((7*(1/832))/dt))
    peak_thresh = 220;
    if(x_sq(index) > peak_thresh)
        %detect the square wave
        %view the length of the sync sequence. 
        numSamples = floor((7*(1/832))/dt);%look at 1 sync worth of data
        syncSig = x_sq(index:index+numSamples);
        %plot(syncSig);
        r = xcorr(syncSig,IR_correlation_signal);
        i = max(r);
        %plot(r);
        if(r(2) >= correlationThreshold)
            lineStarts(count) = index;
            %plot(r)
            count = count+1;
            index = index + skipStep;%skip forward about 0.5 s
        end
    end
    index = index+1;
end

sync_array = lineStarts(1:(count-1),1);
%option b: 

figure;
plot(d);
title("Discretized Data");
figure;
plot(x_sq);
title("Squelched Data");
hold on;
graphArr = 256.*ones(size(sync_array));
scatter(sync_array, graphArr);
hold off;


%sync_array contains the indices of the start frames of each sync sequence.
%

sync_array_trunc = sync_array(round(count/6):round(count * 5/6));
sync_diff = diff(sync_array_trunc);

[num_sync_diff_rows,num_sync_diff_cols] = size(sync_diff);
filter_len = 2 * num_sync_diff_rows;
num_points_per_image_row = filter_len + ceil(filter_len/min(sync_diff));

A = zeros(num_sync_diff_rows, num_points_per_image_row);
for i = 2:num_sync_diff_rows-1
    tsout = round(resample(d(sync_array_trunc(i,1):sync_array_trunc(i+1,1)),filter_len,sync_diff(i,1)));
    K = mat2gray(tsout,[0 256]);
    A(i,1:num_points_per_image_row) = K';
    
end

figure;
imshow(A);






