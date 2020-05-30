function [output] = tremolo(constants,inSound,LFO_type,LFO_rate,lag,depth)
%TREMOLO applies a stereo tremelo effect to inSound by multiplying the
%signal by a low frequency oscillator specified by LFO_type and LFO_rate. 
% depth determines the prevalence of the tremeloed signal in the output,
% and lag determines the delay between the left and right tracks. 
dim = size(inSound);
if dim(2) == 1
    input = repmat(inSound,1,2);
else
    input = inSound;
end

lag_n = ceil(lag/1000*constants.fs);
n = 1:length(inSound);

left_n = 2*pi*LFO_rate/constants.fs*n';
right_n = 2*pi*LFO_rate/constants.fs*(n'+lag_n);

switch LFO_type
    case{'sin'}
        left_LFO = sin(left_n);
        right_LFO = sin(right_n);
    case{'triangle'}
        left_LFO = sawtooth(left_n);
        right_LFO = sawtooth(right_n);
    case{'square'}
        left_LFO = square(left_n);
        right_LFO = square(right_n);
end

left_OUT = input(:,1).*(1-depth*depth*left_LFO);
right_OUT = input(:,2).*(1-depth*depth*right_LFO);
output = [left_OUT,right_OUT];
end