 function IR_corr_sig = ideal_sync_IR(Fs)
     %clear all
     %close all
     %Fs = 11025;
    %square wave
    %832 Hz seven cycles white and black

    num_seconds = 1/832 * 7;
    num_samples = floor(num_seconds * Fs);

    square_wave_period = 1/832;

    t = linspace(0,2*pi*7,num_samples)';
    x = 256.*(square(t+pi)./2 + 0.5);
    % plot(square_wave_period/(2*pi) * t,x);



    x_size = size(x);

%     ones_arr = ones(x_size(1)+floor(x_size(1))+floor(x_size(1)/4),1);
%     ones_arr = 256.* ones_arr;
%     ones_arr(x_size(1)+floor(x_size(1)):x_size(1)+floor(x_size(1))+floor(x_size(1)/4)) = floor(256/2)
%     ones_arr(1:x_size(1)) = x;

    IR_corr_sig = x;
%     plot(IR_corr_sig);
 end