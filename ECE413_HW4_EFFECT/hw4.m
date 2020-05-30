%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SCRIPT
%    hw4
%
% NAME: HyungSeok Yoon
%
% This script runs questions 1 through 7 of the HW4 from ECE313:Music and
% Engineering.
%
% This script was adapted from hw1 recevied in 2012
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Setup
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
close all
clear functions
clear variables
% dbstop if error

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Constants
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
constants.fs=44100;                     % Sampling rate in samples per second
STDOUT=1;                               % Define the standard output stream
STDERR=2;                               % Define the standard error stream

%% Sound Samples
% claims to be guitar
% source: http://www.traditionalmusic.co.uk/scales/musical-scales.htm
[guitarSound, fsg] = audioread('guitar_C_major.wav');
%wav read has been removed

% sax riff - should be good for compressor
% source: http://www.freesound.org/people/simondsouza/sounds/763
[saxSound, fss] = audioread('sax_riff.wav');

% a fairly clean guitar riff
% http://www.freesound.org/people/ERH/sounds/69949/
[cleanGuitarSound, fsag] = audioread('guitar_riff_acoustic.wav');

% Harmony central drums (just use the first half)
[drumSound, fsd] = audioread('drums.wav');
L = size(drumSound,1);
drumSound = drumSound(1:round(L/2), :);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Common Values 
% may work for some examples, but not all
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
depth=75;
LFO_type='sin';
LFO_rate=0.5;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Question 1 - Compressor
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
threshold = 0.1; % rms power of the normalized signal
slope = 0.1;
avg_len = 1000;
[output,gain]=compressor(constants,saxSound,threshold,slope,avg_len);

% I think it makes sense that it is sound not soundsc. because we are compressing
soundsc(saxSound,constants.fs)
disp('Playing the Compressor input')
soundsc(output,constants.fs)
disp('Playing the Compressor Output');
audiowrite('output_compressor.wav',output,fss);

% PLOTS for Question 1d
t = (1:length(saxSound))/constants.fs;
g = find(gain~=1); % index of some kind of compression
ng = find(gain==1); % index of no compression

saxSound_n = saxSound./max(abs(saxSound));

figure;
subplot(3,1,1);
hold on;
plot(t(g),saxSound_n(g), 'r');  
plot(t(ng),saxSound_n(ng));
hold off; axis([0,11, -1, 1]); title('Input Signal normalized for Compression')

subplot(3,1,2);
hold on;
plot(t(g),output(g), 'r');  
plot(t(ng),output(ng));
hold off; axis([0,11, -1, 1]); title('Output Signal for Compression')

subplot(3,1,3);
plot(t,gain);
xlim([0,11]); title('Gain')

disp('Red is compressed area')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Question 2 - Ring Modulator
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
constants.fs = fsg;
% the input frequency is fairly arbitrary, but should be about an order of
% magnitude higher than the input frequencies to produce a
% consistent-sounding effect
inputFreq = 2500;
depth = 0.7;
[output]=ringmod(constants,guitarSound,inputFreq,depth);

soundsc(guitarSound,constants.fs)
disp('Playing the RingMod input')
soundsc(output,constants.fs)
disp('Playing the RingMod Output');
audiowrite('output_ringmod.wav',output,fsg);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Question 3 - Stereo Tremolo
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
LFO_type = 'sin';
LFO_rate = 5;
% lag is specified in number of samples
% the lag becomes very noticeable one the difference is about 1/10 sec
lag = constants.fs/10;
depth = 0.8;
[output]=tremolo(constants,guitarSound,LFO_type,LFO_rate,lag,depth);

LFO_type2 = 'triangle';
[output_triangle]=tremolo(constants,guitarSound,LFO_type2,LFO_rate,lag,depth);
LFO_type3 = 'square';
[output_square]=tremolo(constants,guitarSound,LFO_type3,LFO_rate,lag,depth);


soundsc(guitarSound,constants.fs)
disp('Playing the Tremolo input')
soundsc(output,constants.fs)
disp('Playing the Tremolo Output - Sine Wave LFO');
audiowrite('output_tremelo.wav',output,fsg);

% for reference. Sounds weird / bad
soundsc(output_triangle,constants.fs)
disp('Playing the Tremolo Output - Triangle Wave LFO');
soundsc(output_square,constants.fs)
disp('Playing the Tremolo Output - Square Wave LFO');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Question 4 - Distortion
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
gain = 20;
inSound = cleanGuitarSound(:,1);
tone = 0.6;
[output]=distortion(constants,inSound,gain,tone,'abs');

soundsc(inSound,constants.fs)
disp('Playing the Distortion input')
soundsc(output,constants.fs)
disp('Playing the Distortion Output');
audiowrite('output_distortion.wav',output,fsag);

% % look at what distortion does to the spectrum
L = 10000;
n = 1:L;
sinSound = sin(2*pi*440*(n/fsag));
[output_s]=distortion(constants,sinSound,gain,tone,'abs');
figure;
subplot(2,1,1)
plot(n,sinSound);
xlim([0,1000]);
title('Original 440Hz tone');
subplot(2,1,2)
plot(n,output_s);
xlim([0,1000]);
title('Distorted 440Hz tone');

% (d)
figure
t = (1:length(inSound))/constants.fs;

subplot(2,2,1)
plot(t,inSound);
title('Original - no distortion'); xlabel('time (s)'); ylim([-0.8, 0.8]);

subplot(2,2,2)
plot(t,distortion(constants,inSound,2,tone,'abs'));
title('gain 3'); xlabel('time (s)'); ylim([-0.8, 0.8]);

subplot(2,2,3)
plot(t,distortion(constants,inSound,5,tone,'abs'));
title('gain 6'); xlabel('time (s)'); ylim([-0.8, 0.8]);

subplot(2,2,4)
plot(t,output);
title('gain 12 - the sample'); xlabel('time (s)'); ylim([-0.8, 0.8]);

% (e) in the write up


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Question 5 - Delay
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% slapback settings
inSound = cleanGuitarSound(:,1);
delay_time = 0.08; % in seconds
depth = 0.8;
feedback = 0;
[output]=delay(constants,inSound,depth,delay_time,feedback);

soundsc(inSound,constants.fs)
disp('Playing the Slapback input')
soundsc(output,constants.fs)
disp('Playing the Slapback Output');
audiowrite('output_slapback.wav',output,fsag);

% cavern echo settings
inSound = guitarSound;
delay_time = 0.4;
depth = 0.8;
feedback = 0.7;
[output]=delay(constants,inSound,depth,delay_time,feedback);

soundsc(inSound,constants.fs)
disp('Playing the cavern input')
soundsc(output,constants.fs)
disp('Playing the cavern Output');
audiowrite('output_cave.wav',output,fsg);


% delay (to the beat) settings
inSound = guitarSound;
delay_time = 0.18;
depth = 1;
feedback = 1;
[output]=delay(constants,inSound,depth,delay_time,feedback);

soundsc(inSound,constants.fs)
disp('Playing the delayed on the beat input')
soundsc(output,constants.fs)
disp('Playing the delayed on the beat Output');
audiowrite('output_beatdelay.wav',output,constants.fs);

% multi tap delay reverb
inSound = guitarSound;
delay_time = [0.234,0.306];
depth = [0.3,0.3];
feedback = 0.5;
[output_mult]=delay(constants,inSound,depth,delay_time,feedback);

soundsc(inSound,constants.fs);
disp('Playing the Input for Reverb Effect');
soundsc(output_mult,constants.fs)
disp('Playing the Output with Reverb Effect');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Question 6 - Flanger
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
inSound = drumSound; 
constants.fs = fsd;
depth = 0.8;
delay = .005;   
width = .001;   
LFO_Rate = 0.25;   
LFO_type='sin';
[output_sin]=flanger(constants,inSound,depth,delay,width,LFO_Rate,LFO_type);
LFO_type = 'triangle';
[output_triangle]=flanger(constants,inSound,depth,delay,width,LFO_Rate,LFO_type);

soundsc(inSound,constants.fs)
disp('Playing the Flanger input')
soundsc(output_sin,constants.fs)
disp('Playing the Flanger Output Sine Wave LFO');
soundsc(output_triangle,constants.fs)
disp('Playing the Flanger Output Triangle Wave LFO');
audiowrite('output_flanger.wav',output_triangle,fsd);

% flanger with feedback
feedback = 0.4;
[output_feedback]=flanger_feedback(constants,inSound,depth,delay,width,LFO_Rate,LFO_type,feedback);
soundsc(output_feedback,constants.fs)
disp('Playing the Flanger Output with Feedback');
audiowrite('output_flanger_feedback.wav',output_feedback,fsd); 
% it gives me a warning but no big deal


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Question 7 - Chorus
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
inSound = guitarSound(:,1);
depth = 0.8;
delay = 0.030;
width = 0.01;
LFO_Rate = 0.5;
LFO_type = 'triangle';
constants.fs = fsg;
% depth = 0.9;
% delay = .03;   
% width = 0.1;   
% LFO_Rate = 0.5; % irrelevant if width = 0
[output]=flanger(constants,inSound,depth,delay,width,LFO_Rate,LFO_type);

soundsc(inSound,constants.fs)
disp('Playing the Chorus input')
soundsc(output,constants.fs)
disp('Playing the Chorus Output');
audiowrite('output_chorus.wav',output,fsg);

