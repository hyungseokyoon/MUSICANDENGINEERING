% HyungSeok Yoon
% Synthesizes sound for MIDI

function [finoutput] = soundsynth(misc,track_info, constants)

% if length(track_info) ~= 1
%     x = length(track_info)-1;
% else
%     x = 1;
%     track_info{2} =track_info{1};
% end
maxdur = 0;
for i = 1:length(track_info)
    if ~track_info{i}.bpmcheck
        tpqn = track_info{1}.timeperqnote;
    else
        tpqn = track_info{i}.timeperqnote;
    end
    bpm = round(60/ tpqn / 1e-6);
    time_in_beats = track_info{i}.timearray / misc.ppqn;
    dur = max(time_in_beats)/bpm * 60; %seconds
    
    if maxdur < ceil(dur*constants.fs)
        maxdur = ceil(dur*constants.fs);
    end
end
    
finoutput = zeros(1,maxdur);
for i = 1:length(track_info)
    if ~track_info{i}.bpmcheck
        tpqn = track_info{1}.timeperqnote;
    else
        tpqn = track_info{i}.timeperqnote;
    end
     
    bpm = round(60/ tpqn / 1e-6);
    time_in_beats = track_info{i}.timearray / misc.ppqn;
    dur = max(time_in_beats)/bpm * 60; %seconds
    freqs = 440.* 2.^((track_info{i}.notearray-69)./12);
    notebank = [time_in_beats; freqs ; track_info{i}.velocityarray];
    output = zeros(1,ceil(dur*constants.fs));
    while(~isempty(notebank))
        offindex = find(sum(notebank(2:3,:)==[notebank(2,1);0])==2,1);
        notedur = notebank(1,offindex) - notebank(1,1); % in beats
        notedur = notedur *tpqn * 1e-6; % inseconds
        notedur = round(notedur * constants.fs);
        initial = 1+ceil(notebank(1,1)*tpqn*1e-6*constants.fs);
        constants.duration = notedur;
        constants.volume = track_info{i}.volume;
        constants.velocity = notebank(3,1);
        output(initial:initial-1 + notedur)= generate_sound(track_info{i}.patch, notebank(2,1), constants);
        notebank = [notebank(:,2:offindex-1),notebank(:,offindex+1:end)];
    end
    
    instrument = track_info{i}.patch;
    switch instrument
        case{0}
            disp(['track ', num2str(i),' grand piano selected as it is not implemented use puretone'])
        case{15,113,115, 117, 119}
            disp(['track ', num2str(i),' bell, or instrument close enough to a bell'])
        case{72, 25, 26}
            disp(['track ', num2str(i),' clarinet, or instrument close enough to clarinet'])
        otherwise
            disp(['track ', num2str(i),' unimplemented device selected, choose puretone']);
    end
    output2 = zeros(1,maxdur);
    output2(1:length(output)) = output;
    finoutput = finoutput + output2;
    
end
end