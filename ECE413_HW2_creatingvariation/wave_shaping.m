% HyungSeok Yoon
% WaveShaper for Clarinet Sound

function [Soundout] = wave_shaping(t)
Soundout = zeros(length(t(:,1)),length(t));
for ii = 1:length(t(:,1))
    for i = 1:length(t) 
        if t(ii,i)<=200 && t(ii,i)>=0
            Soundout(ii,i) = t(ii,i)/400-1;
        elseif t(ii,i)>200 && t(ii,i)<=312
            Soundout(ii,i) = t(ii,i)/112-256/112;
        elseif t(ii,i)>312 && t(ii,i)<=512
            Soundout(ii,i) = t(ii,i)/398 - 113/398;
        end
    end

end
