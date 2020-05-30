% HW3
% HyungSeok Yoon
% Music and Engineering
% Professor Hoerning
clc; clear all; close all; clear sound;

STDOUT = 1; % Define Standard Output Stream

% variables
input = 'mario.mid';

constants.fs = 44100;
[misc, track_info ]= midiparse(input);
[output] = soundsynth(misc,track_info,constants);

fprintf(STDOUT, 'Playing %s \n', track_info{1}.name);
sound(output, constants.fs); % not soundsc as I do volume control in the synthesis