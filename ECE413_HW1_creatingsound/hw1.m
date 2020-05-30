%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SCRIPT
% HW 1
% 2019.02.05
%
% HyungSeok Yoon, Music and Engineering
%
% this script is running from Q2 ~ 4 for HW1
% ECE 413 - Music and Engineering
% Prof.Hoerning
%
% This script was adapted from hw1 recevied in 2012
% 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Setup
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
close all
clear functions
clear variables
dbstop if error
warning off

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Constants
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
constants.fs=44100;               % Sampling rate in samples per second
constants.durationScale=0.5;      % Duration of notes in a scale
constants.durationChord=3;        % Duration of chords
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Question 2 - scales
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[soundMajorScaleJust]=create_scale('Major','Just','C',constants);
[soundMajorScaleEqual]=create_scale('Major','Equal','C',constants);
[soundMinorScaleJust]=create_scale('Minor','Just','C',constants);
[soundMinorScaleEqual]=create_scale('Minor','Equal','C',constants);

disp('Playing the Just Tempered Major Scale');
soundsc(soundMajorScaleJust,constants.fs);
disp('Playing the Equal Tempered Major Scale');
soundsc(soundMajorScaleEqual,constants.fs);
disp('Playing the Just Tempered Minor Scale');
soundsc(soundMinorScaleJust,constants.fs);
disp('Playing the Equal Tempered Minor Scale');
soundsc(soundMinorScaleEqual,constants.fs);
fprintf('\n');

% EXTRA CREDIT - Melodic and Harmonic scales
[soundHarmScaleJust]=create_scale('Harmonic','Just','A',constants);
[soundHarmScaleEqual]=create_scale('Harmonic','Equal','A',constants);
[soundMelScaleJust]=create_scale('Melodic','Just','A',constants);
[soundMelScaleEqual]=create_scale('Melodic','Equal','A',constants);

disp('Playing the Just Tempered Harmonic Scale');
soundsc(soundHarmScaleJust,constants.fs);
disp('Playing the Equal Tempered Harmonic Scale');
soundsc(soundHarmScaleEqual,constants.fs);
disp('Playing the Just Tempered Melodic Scale');
soundsc(soundMelScaleJust,constants.fs);
disp('Playing the Equal Tempered Melodic Scale');
soundsc(soundMelScaleEqual,constants.fs);
fprintf('\n');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Question 3 - chords
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fund = 'A'; % stated for convenience, but can be written manually.

% major and minor chords
[soundMajorChordJust]=create_chord('Major','Just',fund,constants);
[soundMajorChordEqual]=create_chord('Major','Equal',fund,constants);
[soundMinorChordJust]=create_chord('Minor','Just',fund,constants);
[soundMinorChordEqual]=create_chord('Minor','Equal',fund,constants);

disp('Playing the Just Tempered Major Chord');
soundsc(soundMajorChordJust,constants.fs);
disp('Playing the Equal Tempered Major Chord');
soundsc(soundMajorChordEqual,constants.fs);
disp('Playing the Just Tempered Minor Chord');
soundsc(soundMinorChordJust,constants.fs);
disp('Playing the Equal Tempered Minor Chord');
soundsc(soundMinorChordEqual,constants.fs);
fprintf('\n');

% assorted other chords
[soundPowerChordJust]=create_chord('Power','Just',fund,constants);
[soundPowerChordEqual]=create_chord('Power','Equal',fund,constants);
[soundSus2ChordJust]=create_chord('Sus2','Just',fund,constants);
[soundSus2ChordEqual]=create_chord('Sus2','Equal',fund,constants);
[soundSus4ChordJust]=create_chord('Sus4','Just',fund,constants);
[soundSus4ChordEqual]=create_chord('Sus4','Equal',fund,constants);
[soundDom7ChordJust]=create_chord('Dom7','Just',fund,constants);
[soundDom7ChordEqual]=create_chord('Dom7','Equal',fund,constants);
[soundMin7ChordJust]=create_chord('Min7','Just',fund,constants);
[soundMin7ChordEqual]=create_chord('Min7','Equal',fund,constants);


disp('Playing the Just Tempered Power Chord');
soundsc(soundPowerChordJust,constants.fs);
disp('Playing the Equal Tempered Power Chord');
soundsc(soundPowerChordEqual,constants.fs);
disp('Playing the Just Tempered Sus2 Chord');
soundsc(soundSus2ChordJust,constants.fs);
disp('Playing the Equal Tempered Sus2 Chord');
soundsc(soundSus2ChordEqual,constants.fs);
disp('Playing the Just Tempered Sus4 Chord');
soundsc(soundSus2ChordJust,constants.fs);
disp('Playing the Equal Tempered Sus4 Chord');
soundsc(soundSus2ChordEqual,constants.fs);
disp('Playing the Just Tempered Dom7 Chord');
soundsc(soundDom7ChordJust,constants.fs);
disp('Playing the Equal Tempered Dom7 Chord');
soundsc(soundDom7ChordEqual,constants.fs);
disp('Playing the Just Tempered Min7 Chord');
soundsc(soundMin7ChordJust,constants.fs);
disp('Playing the Equal Tempered Min7 Chord');
soundsc(soundMin7ChordEqual,constants.fs);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Question 4 - plots
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Recreate Chords for plotting purposes
[soundMajorChordJust_n]=create_chord('Major','Just',fund,constants);
[soundMajorChordEqual_n]=create_chord('Major','Equal',fund,constants);
[soundMinorChordJust_n]=create_chord('Minor','Just',fund,constants);
[soundMinorChordEqual_n]=create_chord('Minor','Equal',fund,constants);

% Fundamental Frequency
f = freqsearch('Just',fund);
T = 1/f; % time for one period
len = ceil(T*constants.fs);
t = 0:1/constants.fs:constants.durationChord;

% Major chords
% Single Wavelength
% Just Temperament
figure(1)
plot(t(1:len),soundMajorChordJust_n(1:len))
title('Figure 1:Single Wavelength of Just Tempered Major Chord')
xlabel('Time Elapsed')
ylabel('Amplitude')
xlim([0,T])

% Equal Temperament
figure(2)
plot(t(1:len),soundMajorChordEqual_n(1:len))
title('Figure 2:Single Wavelength of Equal Tempered Major Chord')
xlabel('Time Elapsed')
ylabel('Amplitude')
xlim([0,T])

% Tens of Wavelengths
% Just Temperament
figure(3)
plot(t(1:20*len),soundMajorChordJust_n(1:20*len))
title('Figure 3:Tens of Wavelength of Just Tempered Major Chord')
xlabel('Time Elapsed')
ylabel('Amplitude')
xlim([0,20*T])

% Equal Temperament
figure(4)
plot(t(1:20*len),soundMajorChordEqual_n(1:20*len))
title('Figure 4:Tens of Wavelength of Equal Tempered Major Chord')
xlabel('Time Elapsed')
ylabel('Amplitude')
xlim([0,20*T])

% Minor chords
% Single Wavelength
% Just Temperament
figure(5)
plot(t(1:len),soundMinorChordJust_n(1:len))
title('Figure 5:Single Wavelength of Just Tempered Minor Chord')
xlabel('Time Elapsed')
ylabel('Amplitude')
xlim([0,T])

% Equal Temperament
figure(6)
plot(t(1:len),soundMinorChordEqual_n(1:len))
title('Figure 6:Single Wavelength of Equal Tempered Minor Chord')
xlabel('Time Elapsed')
ylabel('Amplitude')
xlim([0,T])

% Tens of Wavelengths
% Just Temperament
figure(7)
plot(t(1:20*len),soundMinorChordJust_n(1:20*len))
title('Figure 7:Tens of Wavelength of Just Tempered Minor Chord')
xlabel('Time Elapsed')
ylabel('Amplitude')
xlim([0,20*T])

% Equal Temperament
figure(8)
plot(t(1:20*len),soundMinorChordEqual_n(1:20*len))
title('Figure 8:Tens of Wavelength of Equal Tempered Minor Chord')
xlabel('Time Elapsed')
ylabel('Amplitude')
xlim([0,20*T])