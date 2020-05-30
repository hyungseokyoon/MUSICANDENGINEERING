function [soundOut]=flanger_feedback(constants,inSound,depth,delay,width,LFO_Rate, LFO_type, feedback)
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
%   feedback    = how much feedback gain
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
    org_temp = zeros(length(in),1);
    org_temp(1:delay_n) = in(1:delay_n);
    for i = delay_n+1:length(in)
        org_temp(i) = in(i) + depth*in(i-delayn(i-delay_n));
    end
    it =0;
while(feedback > 0.001 && it <40)
    it = it+1;
    temp = org_temp*feedback;
    temp2 = zeros(length(in),1);
    temp2(1:delay_n) = temp(1:delay_n);
    for i = delay_n+1:length(temp)
        temp2(i) = temp(i) + depth*temp(i-delayn(i-delay_n));
    end
    feedback = feedback*feedback;
    org_temp = org_temp + temp2;
end
    soundOut = downsample(org_temp,k);
    soundOUt = soundOut./max(soundOut);

end