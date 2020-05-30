% HyungSeok Yoon
% MIDI information converter

function [ misc, track_info ] = midiparse( input )
fid  = fopen(input);
data = fread(fid, 'uint8');
data = data';

% MThd
index = find(data == 77);
for i = 1:length(index)
    if(data(index(i)+1:index(i)+3) == [84,104,100])
        MThd = index(i); % there should be only one header
        break;
    end
end
MThd_L = MThd + 4;

MThd_bytes = b2dec(data(MThd_L:MThd_L+3));

MThd_data = data(MThd_L + 4 : MThd_L + 4 + MThd_bytes-1);
misc.MIDI_file_format = b2dec(MThd_data(1:2));
misc.N_tracks = b2dec(MThd_data(3:4));
misc.ppqn = b2dec(MThd_data(5:6));


% Mtrk
MTrk = zeros(1,length(index));
for i = 1:length(index)
    if(data(index(i)+1:index(i)+3) == [84,114,107])
        MTrk(i) = index(i);
    end
end

index_MTrk = find(MTrk);
% mtrk parsing
track_info = cell(1,length(index_MTrk));
track_info{1}.name = [];

for i = 1:length(index_MTrk)
    if i ~= length(index_MTrk)
        Mtrk_data = data(MTrk(index_MTrk(i)):(MTrk(index_MTrk(i+1))-1));
    else
        Mtrk_data = data(MTrk(index_MTrk(i)):end); 
    end

%   chunklength = b2dec(Mtrk_data(5:8)); %decided not to use it
    temp = Mtrk_data(9:end);
    time = 0;
    track_info{i}.timearray = [];
    track_info{i}.notearray = [];
    track_info{i}.velocityarray = [];
    track_info{i}.bpmcheck = 0;
    track_info{i}.volume = 1; %default
    track_info{i}.patch = 0; %default
    command = 0;
    override = 0;
%   tempO = temp; % debug purposes
    while(~isempty(temp))
        if size(temp) < 3
            break;
        end
        for iii = 1 %fold code
            oldcommand = command;
            if override == 1
                temp = [0 temp];
            elseif temp(1) > 128
                delta = inv_VLQ(temp(1:2));
                command = temp(3);
                temp = temp(2:end);
            else
                delta = temp(1);
                command = temp(2);
            end
            override = 0;
            switch command
                case {255} %0xFF
                    type = temp(3);
                    switch type
                        case{1} % case of 0x01, Text
                            text_len = temp(4);
                            track_info{i}.text = char(temp(5:5+text_len-1));
                            temp = temp(5+text_len:end);
                        case{2} % case of 0x02 copyright notice
                            text_len = temp(4);
                            track_info{i}.copyright = char(temp(5:5+text_len-1));
                            temp = temp(5+text_len:end);
                        case{3} % case of 0x03, Sequence / Track Name
                            temp2 = find(~temp,2);
                            temp2 = temp2(2);
                            name = temp(4:temp2-1);
                            track_info{i}.name = char(name);
                            temp = temp(temp2:end);
                        case{4} % case of 0x04, Instrument Name
                            temp2 = find(~temp,2);
                            temp2 = temp2(2);
                            name = temp(4:temp2-1);
                            track_info{i}.instr_name = char(name);
                            temp = temp(temp2:end); 
                        case{32} % case pf 0x20 MIDI meta event ignore
                            temp = temp(6:end);
                        case{33} % case of 0x21 MIDI Port
                            if temp(4) ~= 1
                                msg = 'Error with MIDI file, flag: FF 21';
                                error(msg);
                            end
                             track_info{i}.portnum = temp(5);
                             temp = temp(6:end);
                        case{47} % case of 0x2F end of track
                            temp = [];
                        case{81} % case of 0x51 Tempo
                            if temp(4) ~= 3
                                msg = 'Error with MIDI file, flag: FF 51';
                                error(msg);
                            end
                            track_info{i}.timeperqnote = b2dec(temp(5:7)); % microseconds per quarternote
                            temp = temp(8:end);
                            track_info{i}.bpmcheck = 1;
                        case{84} % case of 0x54 SMPTE offset
                            if temp(4) ~= 5
                                msg = 'Error with MIDI file, flag: FF 54';
                                error(msg);
                            end
                            track_info{i}.SMPTE = temp(5:9);
                            temp = temp(10:end);
                        case{88} % case of 0x58 Time Signiture
                            array = temp(4:8);
                            if array(1) ~= 4
                                msg = 'Error with MIDI file, flag: FF 58';
                                error(msg);
                            end
                            track_info{i}.num_timesig = array(2);
                            track_info{i}.den_timesig = array(3);
                            track_info{i}.clicks_per_metronome = array(4);
                            track_info{i}.num_notated_32_p_quart = array(5);
                            temp = temp(9:end);
                        case{89} % case of 0x59 Key Signiture
                            if temp(4) ~= 2
                                msg = 'Error with MIDI file, flag: FF 59';
                                error(msg);
                            end
                            track_info{i}.sf = temp(5); % -N for N flats +N for N sharps
                            track_info{i}.mm = temp(6); % 0 for major 1 for minor
                            temp = temp(7:end);
                    end
                case {240} %0xF0 this is system exclusive dependent on manufacturer. So I'll just ignore it
                    iterator = 3;
                    while temp(iterator) ~= 247
                        iterator = iterator +1;
                    end
                    temp = temp(iterator+1:end);
                case {176,177,178,179,180,181,182,183,184,185,186,187,188,189,190,191} %0xBN Channel Modes
                    track_info{i}.modechannel = command-175;
                    modeval = temp(3);
                    switch modeval
                        case{7} %main volume
                            track_info{i}.volume = rem(temp(4),128)/127;
                            temp = temp(5:end);
                        case{10} % pan
    %                       implement pan here
                            temp = temp(5:end);
                        case{64} % damper pedal (0-63 off 64-127 on)
                            if temp(4)<64
                                temp = temp(5:end);
                            elseif temp(4)>63
    %                           implement damper pedal here
                                temp = temp(5:end);
                            end                        
                        case{91} % effect 1 depth
    %                       implement effect 1 here
                            temp = temp(5:end);
                        case{121} % reset all controllers
                            temp = temp(5:end);
                        otherwise %ignore all
                            temp = temp(5:end);                        
                    end
                case {192,193,194,195,196,197,198,199,200,201,202,203,204,205,206,207} %0xCN Patch Change
                    track_info{i}.patchchannel = command-191;
                    track_info{i}.patch = temp(3);
                    temp = temp(4:end);        
                case {144,145,146,147,148,149,150,151,152,153,154,155,156,157,158,159} %0x90 Note On @ channel
                    track_info{i}.notechannel = command-143;
                    time = time + delta;
                    track_info{i}.timearray = [track_info{i}.timearray time];
                    track_info{i}.notearray = [track_info{i}.notearray temp(3)];
                    track_info{i}.velocityarray = [track_info{i}.velocityarray temp(4)];
                    temp = temp(5:end);
                case {128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,143}
                    track_info{i}.notechannel = command - 127;
                    time = time + delta;
                    track_info{i}.timearray = [track_info{i}.timearray time];
                    track_info{i}.notearray = [track_info{i}.notearray temp(3)];
    %                 track_info{i}.velocityarray =
    %                 [track_info{i}.velocityarray temp(4)]; this is what i
    %                 should do
                    track_info{i}.velocityarray = [track_info{i}.velocityarray 0];
                    temp = temp(5:end);
                otherwise % running status
                    override = 1;
                    command = oldcommand;
            end
        end
%         tempO(18:40)
%         temp(1:10) %debug purposes
    
    end
    
end

end

