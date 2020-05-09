disp("hello there");

disp("GENERAL KENOBI!");

 %drf = loadFile('dasData_secondTry.dat'); % Load RF Data
fid = fopen('dasData_secondTry.dat','rb');
drf = fread(fid,100000000,'uint8=>double');
drf = drf-127;
drf = drf(1:2:end) + i*drf(2:2:end);



 %run this command in command prompt in the folder with the executables
 %rtl_sdr.exe -f 137100000 -g 20 -n 1843200000 -d 1 dasData2.dat
 %will measure for 5 minutes
 
 
 figure(3)
 n = 1 %time to start in seconds
e = 5 %time to listen in seconds

 %msg(drf,n*2048000+1,256,e*2000);
 frq = 137100000;% 137.1 MHz
 fs = 2048000;  % sampling frequency of radio
 dt = 1/fs;    % sampling time
 t = [1:length(drf)]'*dt;  %  time of each of the samples of d
 drf = drf.*exp(-i*2*pi*(-frq)*t);
 
 d = decimate(drf,8,'fir');         % decimate to 256 kHz
 
 %figure(1)
 %msg(d,1,256,512)
 
 dl = d./abs(d);   % Eliminate amplitude variations
 
 
% design the differentiator
%   
hd = firls(30,[0 100000 127000 128000]/128000, [0 1 0 0],'differentiator');
%   
% Plot the filter, and its frequency response> 
%   
figure(2)
subplot(211);
stem(hd);
subplot(212);
f = [-128:127];
plot(f,abs(fftshift(fft([hd zeros(1,256-31)]))));

df = imag(conv(dl,hd,'same').*conj(dl));

dfd = decimate(decimate(df,8,'fir'),2,'fir');
dfd = dfd / max(abs(dfd));

%uncomment to hear the sound
sound(dfd,16000);




audiowrite("satAudio3.wav", dfd, 16000);



