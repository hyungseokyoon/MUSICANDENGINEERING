function [freq] = freqsearch(temperament,root)
switch temperament
    case {'just','Just'}
        load('JustTemp.mat');
        FreqArray = JustTemp;
        FreqArray(13:24,:) = 2*FreqArray(1:12,:);
        
    case {'equal','Equal'}
        load('EqualTemp.mat');
        FreqArray = repmat(EqualTemp,1,15);
        FreqArray(13:24,:) = 2*FreqArray(1:12,:);
    
    otherwise
        error('Improper temperament specified')
end

shift = 1;
switch root
    case {'C'}
        key = 1;
        place = 1;
    case {'D'}
        key = 2;
        place = 3;
    case {'E'}
        key = 3;
        place = 5;
    case {'F#', 'Fsharp'}
        key = 4;
        place = 7;
    case {'G'}
        key = 5;
        place = 8;
    case {'A'}
        key = 6;
        place = 10;
    case {'B'}
        key = 7;
        place = 12;
    case {'C#', 'Csharp'}
        key = 8;
        place = 2;
    case {'Db', 'Dflat'}
        key = 9;
        place = 2;
    case {'Eb','Eflat'}
        key = 10;
        place = 4;
    case {'F'}
        key = 11;
        place = 6;
    case {'Gb','Gflat'}
        key = 12;
        place = 7;
    case {'Ab', 'Aflat'}
        key = 13;
        place = 9;
    case {'Bb','Bflat'}
        key = 14;
        place = 11;
    case {'Cb','Cflat'}
        key = 15;
        place = 12;
    otherwise
        error('Invalid Root')
end

freq = FreqArray(place,key);
end

