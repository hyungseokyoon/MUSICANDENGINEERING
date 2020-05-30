function [soundOut,gain] = compressor(constants,inSound,threshold,attack,avg_len)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FUNCTION
%    [output,gain] = compressor(constants,inSound,threshold,attack,avg_len)
%
%COMPRESSOR applies variable gain to the inSound vector by limiting the
% level of any audio sample of avg_length with rms power greater than
% threshold according to slope
%
% OUTPUTS
%   soundOut    = The output sound vector
%   gain        = The vector of gains applied to inSound to create soundOut
%
% INPUTS
%   constants   = the constants structure
%   inSound     = The input audio vector
%   threshold   = The level setting to switch between the two gain settings
%   attack      = time over which the gain changes
%   avg_len     = amount of time to average over for the power measurement

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
inSound = inSound./max(abs(inSound));
soundOut = zeros(length(inSound),1);
for i = 1:length(inSound)
    if i < avg_len
        temp = rms(inSound(1:i));
    else
        temp = rms(inSound(i-avg_len+1:i));
    end
    
    if temp > threshold
        ratio = ((temp-threshold)*attack*threshold)/temp;
        soundOut(i) = sqrt(ratio)*inSound(i);
    else
        soundOut(i) = inSound(i);
    end
end
gain = soundOut./inSound;
end


