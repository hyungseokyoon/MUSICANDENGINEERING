% HyungSeok Yoon
% find tone
function [flag tonal non_tonal] = find_tone(fft_result, TABLE, CB_map, CBB);
localmax=[];
flag = zeros(512/2,1);
tonal = [];
non_tonal = [];
% local maxima
j = 1;
for i = 2:250
    if(fft_result(i)>fft_result(i-1) && fft_result(i) >= fft_result(i+1))
        localmax(j,1) = i;
        localmax(j,2) = fft_result(i);
        j=j+1;
    end
end
%tonal component
j = 1;
if ~isempty(localmax)
    for i = 1:length(localmax(:,1))
        k = localmax(i,1);
        if (2 < k && k < 63)
            J = [-2 2];
        elseif (63 <= k && k < 127)
            J = [-3 -2 2 3];
        elseif (127 <= k && k < 250)
            J = [-6:-2, 2:6];
        else
            tone = 0;
            continue;
        end
        % check tonal components
        check = find(~(fft_result(k) - fft_result(k+J) >=7));
        if(isempty(check))
            tone=0;
        else
            tone=1;
        end
        
        if(tone)
            tonal(j,1) = k; %index number k of the spectral line
            tonal(j,2) = 10*log10(10^(fft_result(k-1)/10)+10^(fft_result(k)/10)+10^(fft_result(k+1)/10)); % sound pressure level
            flag(j) = 1; %tonal flag
            flag(k+[J -1,1]) = 3; % flag garbage
            j = j+1;
        end
    end
end
for i = 1:length(CBB)-1
    pl = 0; %pressure level
    power = -999; %initiallize
    for k = TABLE(CBB(i),1):TABLE(CBB(i+1)-1,1)
        if(flag(k)==0)
            power = 10*log10(10^(power/10)+10^(fft_result(k)/10));
            pl=pl+10^(fft_result(k)/10)*(TABLE(CB_map(k), 3) - TABLE(CBB(i),3)); % geometric mean
            flag(k) = 2; %non tonal
        else
            pl = pl;
            power = power;
        end
    end
    index = TABLE(CBB(i),1) + round(pl/10^(power/10)*(TABLE(CBB(i+1),1)-TABLE(CBB(i),1)));
    if(index <1)
        index = 1;
    elseif(index>length(flag))
        index = length(flag);
    elseif(flag(index)==1)
        index = index+1;
    end
   non_tonal(i,1) = index;
   non_tonal(i,2) = power;
   flag(i) = 2;
end
end