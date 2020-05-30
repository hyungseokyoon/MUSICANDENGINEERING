% HyungSeok Yoon
% M matrix so that I don't have to compute this over and over again
function [out] = M_matrix()
    out = zeros(32,64);
    for i = 0 : 31
        for k = 0 : 63
            out(i+1,k+1) = cos((2*i+1)*(k-16)*pi/64);
        end
    end
end