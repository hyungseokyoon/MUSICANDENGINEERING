% HyungSeok Yoon
% This function translates a string of decimal numbers in hexadecimal
% format to a decimal. ex) translates [1, 0] = 256
function [ output ] = b2dec( input )
temp = 0;
input = double(input);
for i = 1:length(input)
    temp = temp + input(i)*256^(length(input)-i);
end
output = temp;


end
