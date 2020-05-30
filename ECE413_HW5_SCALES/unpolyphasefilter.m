% HyungSeok Yoon
% MPEG reconstruction
% ANNEX_AB.DOC pg2

function [V,reconstruction] = unpolyphasefilter(V, Scale,D,N)
reconstruction = zeros(32,1);
% shifting in new samples
    U = zeros(512,1);
    for i = 1024:-1:65
        V(i) = V(i-64);
    end
    V(1:64) = N'*Scale;
    for i = 0:7
        for j = 0:31
            U(i*64+(j+1)) = V(128*i+j+1);
            U(i*64+32+(j+1)) = V(128*i+96+j+1);
        end
    end
    W = U.*D;
    for i = 1:32
        reconstruction(i) = sum(W(i:32:end));
    end
end
