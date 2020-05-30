% HyungSeok Yoon
% ANNEX_C.doc pg 7
function [scfmax,scfindex] = scale_factor_calculation(filter_output,scale_table)
scfmax = zeros(32,1);
scfindex = zeros(32,1);
for i = 1:32
    max_abs = max(filter_output(:,i));
    if max_abs > scale_table(1)
        scfindex(i) = 1;
        scfmax(i) = scale_table(1);
    else
        scfindex(i) = find(scale_table>max_abs,1,'last');
        scfmax(i) = scale_table(scfindex(i));
    end
end
