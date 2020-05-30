function [soundOut] = attack_decay(input,attack,decay)
% attack indicates what percent of initial wave modified
% decay indicates what percent of decay wave modified

modifier = ones(1,length(input));
attackindex = floor(length(input)*attack/100);
decayindex = ceil(length(input)*(100-decay)/100);
modifier(1:attackindex) = logspace(-2,0,attackindex);
modifier(decayindex+1:end) = logspace(0,-2,length(input)-decayindex);
soundOut = input.*modifier;
end




