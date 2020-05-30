% HyungSeok Yoon
% ANNEX_D.DOC pg 6
% the equation is impossible to make sense. it has double plus sign.
function LTg = gmt(AT, LTt, LTn)
N = length(AT);
if not(isempty(LTt))
   m = length(LTt(:, 1));
end
if not(isempty(LTn))

    n = length(LTn(:, 1));
end
for i = 1:N
   % Threshold in quiet
   temp = 10^(AT(i) / 10);
   % Contribution of the tonal component
   if not(isempty(LTt))
	   for j = 1:m
	      temp = temp + 10^(LTt(j, i) / 10);
      end
   end
   % Contribution of the noise components
if not(isempty(LTn))

   for j = 1:n
      temp = temp + 10^(LTn(j, i) / 10);
   end
   end
   LTg(i) = 10 * log10(temp);
end
