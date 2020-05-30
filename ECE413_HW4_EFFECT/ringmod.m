function [output] = ringmod(constants,inSound,inputFreq,depth)
%RINGMOD applies ring modulator effect to inSound
dim = size(inSound);
n = 1:length(inSound);
temp = sin(2*pi*inputFreq.*n'/constants.fs);
modulated = inSound.*repmat(temp,1,dim(2));
output = inSound + depth*modulated;
end
