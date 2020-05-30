% HyungSeok Yoon
% MPEG Audio Filter band computation
% from Pan Handout
function [S,X] = polyphasefilter(input_mono,X,index, C , M)
% shifting in new samples
%     temp = input_mono(max(1,index-480):index+31);
%     X(end-length(temp)+1:end) = temp;
    for i = 512:-1:33
        X(i) = X(i-32);
    end
    %FIFO
    X(32:-1:1) = input_mono(index:index+31);
% window samples
    Z = X.*C;
% partial calculation
    Y = zeros(64,1);
    for ii = 1:64
        Y(ii) = sum(Z(ii:64:end));
    end
% 32 sample calculation
    S = M*Y;
    S = S.';
end
