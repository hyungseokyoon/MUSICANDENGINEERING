% HyungSeok Yoon
% This function translates a variable-length quantity into correct decimal
% works only for two bytes cases
function [ output ] = inv_VLQ( input )
output = 128*(input(1)-128) + input(2);
end