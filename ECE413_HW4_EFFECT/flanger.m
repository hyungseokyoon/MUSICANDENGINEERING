function [soundOut]=flanger(constants,inSound,depth,delay,width,LFO_Rate, LFO_type)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FUNCTION
%    [soundOut]=flanger(constants,inSound,depth,delay,width,LFO_Rate)
%
% This function creates the sound output from the flanger effect
%
% OUTPUTS
%   soundOut = The output sound vector
%
% INPUTS
%   constants   = the constants structure
%   inSound     = The input audio vector
%   depth       = depth setting
%   delay       = minimum time delay in seconds
%   width       = total variation of the time delay from the minimum to the maximum
%   LFO_Rate    = The frequency of the Low Frequency oscillator in Hz
%   LFO_type    = Type of LFO either sin or triangle
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
k = 4; %up sample by what?
in=interp1(1:length(inSound),inSound,1:1/k:length(inSound));
fs_new = constants.fs*k; %upsample by 4 to smooth

delay_n = ceil(delay*fs_new);
width_n = ceil(width*fs_new);

n = 1:length(in);
phi = 2*pi*LFO_Rate*n./fs_new-pi/2;
switch LFO_type
    case{'sin'}
        lfo = sin(phi);
    case{'triangle'}
        lfo = sawtooth(phi+pi/2);
end

delayn = floor(lfo*width_n/2 + delay_n + width_n/2);
soundOut = zeros(length(in),1);
soundOut(1:delay_n) = in(1:delay_n);
for i = delay_n+1:length(in)
    soundOut(i) = in(i) + depth*in(i-delayn(i-delay_n));
end

soundOut = downsample(soundOut,k);

end