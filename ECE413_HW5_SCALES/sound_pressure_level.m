% HyungSeok Yoon
% Sound Pressure Level Determination
% from ANNEX_D.doc p.2

function [Lsb] = sound_pressure_level(fft_result,scfmax)
    Lsb = zeros(32,1);
    for k = 1:32
        temp = max(fft_result(1+(k-1)*8:8*k));
        % only single sideband is valid due to fft algorithm
        Lsb(k) = max(temp, 20*log10(scfmax(k)*32768)-10);
    end
end