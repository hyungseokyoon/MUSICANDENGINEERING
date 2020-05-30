% HyungSeok Yoon
% FFT Analysis
% from ANNEX_D pg2
function [X_f] = fft_analysis(input_mono,delay)
%shift 64 for hanning window
   if delay == 1
       temp = [zeros(64,1);input_mono(1:delay+447)];
   elseif length(input_mono) < delay+384
       temp = [input_mono(delay-64:end);zeros(512-length(input_mono(delay-64:end)),1)]; 
   else 
       temp = input_mono(delay-64:delay+512-64-1);
   end
   
%hanning window
   h = 0.5*(1-cos(2*pi*(0:511)/511));
   h = h';
   temp2 = max(10*log10(abs(fft(temp.*h))/512)*2,-999);
   normalize = 96-max(temp2);
   X_f = temp2+normalize;
end