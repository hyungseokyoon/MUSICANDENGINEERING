function [soundOut] = create_scale( scaleType,temperament, root, constants )
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FUNCTION
%    [ soundOut ] = create_scale( scaleType,temperament, root, constants )
% 
% This function creates the sound output given the desired type of scale
%
% OUTPUTS
%   soundOut = The output sound vector
%
% INPUTS
%   scaleType = Must support 'Major' and 'Minor' at a minimum
%   temperament = may be 'just' or 'equal'
%   root = The Base frequeny (expressed as a letter followed by a number
%       where A4 = 440 (the A above middle C)
%       See http://en.wikipedia.org/wiki/Piano_key_frequencies for note
%       numbers and frequencies
%   constants = the constants structure
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Constants
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TODO: Add all relavant constants 
adjust = 1;
switch scaleType
    case {'Major','major','M','Maj','maj'}
        pattern = [2,2,1,2,2,2];
        pattern = cumsum(pattern);
	case {'Minor','minor','m','Min','min'}
        pattern = [2,1,2,2,1,2];
        pattern = cumsum(pattern);
    case {'Harmonic', 'harmonic', 'Harm', 'harm'}
        pattern = [2,1,2,2,1,2];
        pattern = cumsum(pattern);
    case {'Melodic', 'melodic', 'Mel', 'mel'}
        adjust = 15/8;
        pattern = [2,1,2,2,2,2];
        pattern = cumsum(pattern);
    otherwise
        error('Inproper scale specified');
end

switch temperament
    case {'just','Just'}
        load('JustTemp.mat');
        FreqArray = JustTemp;
        FreqArray(13:24,:) = 2*FreqArray(1:12,:);
        
    case {'equal','Equal'}
        load('EqualTemp.mat');
        FreqArray = repmat(EqualTemp,1,15);
        FreqArray(13:24,:) = 2*FreqArray(1:12,:);
    
    otherwise
        error('Improper temperament specified')
end

shift = 1;
switch root
    case {'C'}
        key = 1;
        place = 1;
    case {'D'}
        key = 2;
        place = 3;
    case {'E'}
        key = 3;
        place = 5;
    case {'F#', 'Fsharp'}
        key = 4;
        place = 7;
    case {'G'}
        key = 5;
        place = 8;
    case {'A'}
        key = 6;
        place = 10;
    case {'B'}
        key = 7;
        place = 12;
    case {'C#', 'Csharp'}
        key = 8;
        place = 2;
    case {'Db', 'Dflat'}
        key = 9;
        place = 2;
    case {'Eb','Eflat'}
        key = 10;
        place = 4;
    case {'F'}
        key = 11;
        place = 6;
    case {'Gb','Gflat'}
        key = 12;
        place = 7;
    case {'Ab', 'Aflat'}
        key = 13;
        place = 9;
    case {'Bb','Bflat'}
        key = 14;
        place = 11;
    case {'Cb','Cflat'}
        key = 15;
        place = 12;
    otherwise
        error('Invalid Root')
end

duration = constants.durationScale * 8 * adjust;    
t = 0:1/constants.fs:duration;
f_vec = zeros(1,8*adjust);
f_vec(1) = FreqArray(place,key);

for i = 1:length(pattern)
    f_vec(i+1) = FreqArray(place+pattern(i),key);
end

f_vec(8) = 2*f_vec(1);
f_vec = f_vec./shift;
w_vec = 2 * pi * f_vec;
x = zeros(1,length(t));


for i = 1:8*adjust
    x(length(t)/8/adjust*(i-1)+1:length(t)/8/adjust*i) = sin(w_vec(i)*t(length(t)/8/adjust*(i-1)+1:length(t)/8/adjust*i));
end


soundOut=x;

end
