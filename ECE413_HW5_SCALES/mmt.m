% HyungSeok Yoon
% ANNEX_D.DOC pg.6
function     LTmin = mmt(LTg, CB_map)
for n = 1:32
   LTmin(n) = min(LTg(CB_map((n-1)*8+1:8*n)));
end
