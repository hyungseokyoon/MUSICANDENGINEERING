% HyungSeok Yoon
% Decimation
% ANNEX_D.DOC p.5
function     [flag_D tonal_D non_tonal_D] = Decimation(tonal, non_tonal, flag, TABLE, CB_map)
flag_D = flag; 
non_tonal_D = [];
if not(isempty(non_tonal))
	for i = 1:length(non_tonal(:, 1)),
	   k = non_tonal(i, 1);
	   if (non_tonal(i, 2) < TABLE(CB_map(k),4)) % if non tonal is below threshold ignore
           flag_D(k) = 3;
		else
		   non_tonal_D = [non_tonal_D; non_tonal(i, :)];
	   end
	end
end
tonal_D = [];
if not(isempty(tonal))
	for i = 1:length(tonal(:, 1)),
	   k = tonal(i, 1);
	   if (tonal(i, 2) < TABLE(CB_map(k),4))% if tonal is below threshold ignore
		   flag_D(k) = 3;
	   else
		   tonal_D = [tonal_D; tonal(i, :)];
	   end
	end
end

if not(isempty(tonal_D))
    i = 1;
    while (i < length(tonal_D(:, 1)))
        k      = tonal_D(i, 1);
        k_next = tonal_D(i + 1, 1);
        if (TABLE(CB_map(k_next), 3) - TABLE(CB_map(k), 3) < 0.5)
            if (tonal_D(i, 2) < tonal_D(i + 1, 2))
                tonal_D = tonal_D([1:i - 1, i + 1:end], :);
                flag_D(k) = 3;
           else
               tonal_D = tonal_D([1:i, i + 2:end], :);
               flag_D(k_next) = 3;
           end
       else
           i = i + 1;
       end
   end
end

