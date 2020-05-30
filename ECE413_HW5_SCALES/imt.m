% HyungSeok Yoon
% ANNEX_D.DOC p.5

function [LTt, LTn] = imt(fft_result,tonal, non_tonal, TABLE, CB_map)

if isempty(tonal)
LTt = [];
else
LTt = zeros(length(tonal(:, 1)), length(TABLE(:, 1)))-999;
end
if isempty(non_tonal)
    LTn = [];
else
LTn = zeros(length(non_tonal(:, 1)), length(TABLE(:, 1)))-999;
end

for i = 1:length(TABLE(:, 1))
   zi = TABLE(i, 3);
   if ~(isempty(tonal))
	   for k = 1:length(tonal(:, 1)),
	      j  = tonal(k, 1);
	      zj = TABLE(CB_map(j), 3);
	      dz = zi - zj;	      
	      if (dz >= -3 && dz < 8)
	         % Masking index
	         avtm = -1.525 - 0.275 * zj - 4.5;
	         % Masking function
	         if (-3 <= dz && dz < -1)
	            vf = 17 * (dz + 1) - (0.4 * fft_result(j) + 6);
	         elseif (-1 <= dz && dz < 0)
	            vf = (0.4 * fft_result(j) + 6) * dz;
	         elseif (0 <= dz && dz < 1)
	            vf = -17 * dz;
	         elseif (1 <= dz && dz < 8)
	            vf = - (dz - 1) * (17 - 0.15 * fft_result(j)) - 17;
             end         
	         LTt(k, i) = tonal(k, 2) + avtm + vf;
	      end
      end
   end
   % For each non-tonal component
   if ~(isempty(non_tonal))
   for k = 1:length(non_tonal(:, 1))
      j  = non_tonal(k, 1);
      zj = TABLE(CB_map(j), 3); 
      dz = zi - zj;       
      if (dz >= -3 && dz < 8)
         avnm = -1.525 - 0.175 * zj - 0.5;         
         if (-3 <= dz && dz < -1)
            vf = 17 * (dz + 1) - (0.4 * fft_result(j) + 6);
         elseif (-1 <= dz && dz < 0)
            vf = (0.4 * fft_result(j) + 6) * dz;
         elseif (0 <= dz && dz < 1)
            vf = -17 * dz;
         elseif (1 <= dz && dz < 8)
            vf = - (dz - 1) * (17 - 0.15 * fft_result(j)) - 17;
         end         
         LTn(k, i) = non_tonal(k, 2) + avnm + vf;
      end
   end
   end
   
end