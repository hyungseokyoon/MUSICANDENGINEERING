%each setting
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

%% Question 5 - Delay
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% slapback settings
inSound = cleanGuitarSound(:,1);
delay_time = 0.08; % in seconds
depth = 0.8;
feedback = 0;
[output]=delay(constants,inSound,depth,delay_time,feedback);

% soundsc(inSound,constants.fs)
% disp('Playing the Slapback input')
% soundsc(output,constants.fs)
% disp('Playing the Slapback Output');
% audiowrite('output_slapback.wav',output,fsag);

% cavern echo settings
inSound = guitarSound;
delay_time = 0.4;
depth = 0.8;
feedback = 0.7;
[output]=delay(constants,inSound,depth,delay_time,feedback);

%soundsc(inSound,constants.fs)
disp('Playing the cavern input')
%soundsc(output,constants.fs)
disp('Playing the cavern Output');
%audiowrite('output_cave.wav',output,fsg);


% % delay (to the beat) settings
inSound = guitarSound;
delay_time = 0.18;
depth = 1;
feedback = 1;
[output]=delay(constants,inSound,depth,delay_time,feedback);

%soundsc(inSound,constants.fs)
disp('Playing the delayed on the beat input')
%soundsc(output,constants.fs)
disp('Playing the delayed on the beat Output');
%audiowrite('output_beatdelay.wav',output,constants.fs);

% multi tap delay reverb
inSound = guitarSound;
delay_time = [0.234,0.306];
depth = [0.3,0.3];
feedback = 0.5;
[output_mult]=delay(constants,inSound,depth,delay_time,feedback);

%soundsc(inSound,constants.fs);
disp('Playing the Input for Reverb Effect');
soundsc(output_mult,constants.fs)
disp('Playing the Output with Reverb Effect');