% HW3
% HyungSeok Yoon
% Creates sound v2 for MIDI

function [soundSample]=generate_sound(instrument,freqs, constants)
t = 1:constants.duration;
t = t/ constants.fs;

switch instrument
    case{0}
%       disp('grand piano selected as it is not implemented use puretone')
        soundSample = constants.volume*sin(2*pi*freqs.*t);
        soundSample = attack_decay(soundSample,40*(127-constants.velocity)/127,20);
    case{72,25,26}
%       disp('clarinet')
        envelope = ones(1,constants.duration);
        amplitude_waveshape = 255;
        risetime = .085;
        decaytime = .64;
        envelope(1:floor(risetime*constants.duration)) = linspace(0,1,floor(risetime*constants.duration));
        envelope(end-floor(decaytime*constants.duration)+1:end) = linspace(1,0,floor(decaytime*constants.duration));
        envelope = envelope*amplitude_waveshape;
        wave= repmat(envelope,length(freqs),1).*sin(2*pi*freqs'*t);
        wave = wave + 256;
        waveshaped = wave_shape(wave);
        soundSample = constants.volume*sum(waveshaped,1);
    case{15,113,115, 117, 119}
        Amplitude = [1,0.67,1,1.8,2.67,1.67,1.46,1.33,1.33,1,1.33];
        Durations_mult = [1,0.9,0.65,0.55,0.325,0.35,0.25,0.2,0.15,0.1,0.075];
        Frequencies_mult = [0.56,0.56,0.92,0.92,1.19,1.7,2,2.74,3,3.76,4.07];
        Frequencies_add = [0,1,0,1.7,0,0,0,0,0,0,0];
        envelope = zeros(length(Amplitude),constants.duration);
        for i = 1:length(Amplitude)
            envelope(i,1:floor(constants.duration*Durations_mult(i))) = Amplitude(i)*logspace(0,-10/log2(10),floor(constants.duration*Durations_mult(i)));
        end
        Frequencies = Frequencies_mult.'*freqs + repmat(Frequencies_add.',1,length(freqs));
        sinewave = zeros(length(Amplitude),length(freqs),constants.duration);
        for i = 1:length(freqs)
            sinewave(:,i,:) = sin(2*pi*Frequencies(:,i)*t);
        end
        final = sinewave.*permute(repmat(envelope,1,1,length(freqs)),[1,3,2]);
        final = squeeze(sum(final,1));
        if length(freqs)>1
            final = sum(final,1);
        end
        soundSample = final;
    otherwise
%         disp('unimplemented device selected, choose puretone');
        soundSample = constants.volume*sin(2*pi*freqs.*t);
        soundSample = attack_decay(soundSample,40*(127-constants.velocity)/127,20);
end

end
