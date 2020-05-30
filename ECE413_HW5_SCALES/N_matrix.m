% HyungSeok Yoon
% N matrix so that I don't have to compute this over and over again
function [out] = N_matrix()
    out = zeros(32,64);
    for i = 0 : 31
        for k = 0 : 63
            out(i+1,k+1) = cos((16+k)*(2*i+1)*pi/64);
        end
    end
end