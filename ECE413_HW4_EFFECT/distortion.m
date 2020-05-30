function [output]=distortion(constants,inSound,gain,tone,non_lin)
%DISTORTION applies the specified gain to inSound, then applies clipping
%according to internal parameters and filtering according to the specified
%tone parameter
% non_lin selects the non linearity to use.

if nargin < 5
    non_lin = 'erf';
end

% gain before non-linearity
temp = gain*inSound;

% non linearity
switch non_lin
    case{'erf'}
        temp_nl = erf(temp);
    case{'abs'} 
        temp_nl = temp./(1+abs(temp));
end

% tone
filterO = 3;
% kills high frequency
[z,p,k]=butter(filterO,2048/(constants.fs/2),'low');
[b,a]=zp2tf(z,p,k);

% kills low frequency
[z2,p2,k2]=butter(filterO,256/(constants.fs/2),'high');
[b2,a2]=zp2tf(z2,p2,k2);

% tone 0 means bass end => kills high
output=filter(b,a,temp_nl)*(1-tone)+filter(b2,a2,temp_nl)*tone;

end