function [output]=delay(constants,inSound,depth,delay_time,feedback)
%DELAY applies a delay effect to inSound which is delayed by delay_time 
% then added to the original signal according to depth and passed back as
% feedback with the feedback gain specified

if(~iscolumn(depth))
    depth = depth.';
end
if(~iscolumn(delay_time))
    delay_time = delay_time.';
end
n_delay = ceil(constants.fs*delay_time);
n_channel = size(inSound);
n_channel = n_channel(2);
it = 0;
temp = [inSound; zeros(max(n_delay),n_channel)];
delayarray = zeros(length(temp),n_channel,length(n_delay));
for i = 1:length(n_delay)
    delayarray(:,:,i) = [zeros(n_delay(i),n_channel) ; inSound; zeros(max(n_delay)-n_delay(i),n_channel)];
end
temp = temp + sum(permute(repmat(depth,1,length(temp),n_channel),[2,3,1]).*delayarray,3);
feeded = temp*feedback;
feedback = feedback^2;
it = it+1; %in case feedback is 0

while(feedback > 0.001 && it <40)
temp = [temp; zeros(max(n_delay),n_channel)];
delayarray = zeros(length(temp),n_channel, length(n_delay));
for i = 1:length(n_delay)
    delayarray(:,:,i) = [zeros(n_delay(i),n_channel) ; feeded; zeros(max(n_delay)-n_delay(i),n_channel)];
end
temp = temp + sum(permute(repmat(depth,1,length(temp),n_channel),[2,3,1]).*delayarray,3);
feeded = temp*feedback;
feedback = feedback^2;
it = it+1; %in case feedback is 0
end

output = temp;
    
end