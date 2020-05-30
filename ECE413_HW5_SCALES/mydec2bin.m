% HyungSeok Yoon

function [answer] = mydec2bin(val,bits)
if bits == 0
    answer = 'nothing';
else
    if val < 0
        answer = '1';
        val = 1+val;
    else
        answer = '0';
    end
    for i = 1:bits-1
        if (val - 2^(-i))>0
            val = val - 2^(-i);
            answer = [answer, '1'];
        else
            answer = [answer, '0'];
        end
    end

    
    
end


end
    
