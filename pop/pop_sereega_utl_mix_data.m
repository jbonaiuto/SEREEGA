% EEG = pop_sereega_utl_mix_data(EEG)
%
%       Pops up a dialog window that allows you to mix two datasets with a
%       given signal-to-noise ratio.
%
%       The pop_ functions serve only to provide a GUI for some of
%       SEREEGA's functions and are not intended to be used in scripts.
%
% In:
%       EEG - an EEGLAB dataset
%
% Out:  
%       EEG - the mixed EEGLAB dataset
% 
%                    Copyright 2018 Laurens R Krol
%                    Team PhyPA, Biological Psychology and Neuroergonomics,
%                    Berlin Institute of Technology

% 2018-05-03 First version

% This file is part of Simulating Event-Related EEG Activity (SEREEGA).

% SEREEGA is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.

% SEREEGA is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.

% You should have received a copy of the GNU General Public License
% along with SEREEGA.  If not, see <http://www.gnu.org/licenses/>.

function EEG = pop_sereega_utl_mix_data(EEG)


% testing if lead field is present
if ~isfield(EEG.etc, 'sereega') || ~isfield(EEG.etc.sereega, 'epochs') ...
        || isempty(EEG.etc.sereega.leadfield)
    errormsg = 'First configure the epochs.';
    supergui( 'geomhoriz', { 1 1 1 }, 'uilist', { ...
            { 'style', 'text', 'string', errormsg }, { }, ...
            { 'style', 'pushbutton' , 'string', 'OK', 'callback', 'close(gcbf);'} }, ...
            'title', 'Error');
    return
end

% building gui
[~, ~, ~, structout] = inputgui( ...
        'geometry', { 1 1 1 1 1 1 1 1 1 1 [1 1] [1 1] [1 1] 1 1 [1 1]}, ...
        'geomvert', [1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1], ...
        'uilist', { ...
                { 'style', 'text', 'string', 'Mix datasets', 'fontweight', 'bold' }, ...
                { }, ...
                { 'style', 'text', 'string', 'Indicate the signal-to-noise ratio (SNR) as a' }, ...
                { 'style', 'text', 'string', 'scalar between 0 and 1, where (approximately)' }, ...
                { 'style', 'text', 'string', '0    = -Inf dB, noise only' }, ...
                { 'style', 'text', 'string', '1/3 = -6 dB' }, ...
                { 'style', 'text', 'string', '1/2 = 0 dB' }, ...
                { 'style', 'text', 'string', '2/3 = +6 dB' }, ...
                { 'style', 'text', 'string', '1    = +Inf dB, signal only; etc.' }, ...
                { }, ...
                { 'style', 'text', 'string', 'Signal dataset index' }, ...
                { 'style', 'edit', 'string', '', 'tag', 'signal' }, ...
                { 'style', 'text', 'string', 'Noise dataset index' }, ...
                { 'style', 'edit', 'string', '', 'tag', 'noise' }, ...
                { 'style', 'text', 'string', 'SNR (0-1)' }, ...
                { 'style', 'edit', 'string', '', 'tag', 'snr' }, ...
                { }, ...
                { 'style', 'text', 'string', 'Optional: copy SEREEGA info from dataset' }, ...
                { 'style', 'text', 'string', 'Dataset index' }, ...
                { 'style', 'edit', 'string', '', 'tag', 'sereegaidx' }, ...
                }, ... 
        'helpcom', 'pophelp(''utl_mix_data'');', ...
        'title', 'Epoch configuration');

if ~isempty(structout)
    % user pressed OK
    ALLEEG = evalin('base', 'ALLEEG');
    mixdata = utl_mix_data(ALLEEG(str2num(structout.signal)).data, ALLEEG(str2num(structout.noise)).data, str2double(structout.snr));
    EEGmix = utl_create_eeglabdataset(mixdata, EEG.etc.sereega.epochs, EEG.etc.sereega.leadfield);
    EEGmix.setname = 'SEREEGA mixed dataset';
    if ~isempty(str2num(structout.sereegaidx))
        EEGmix.etc.sereega = ALLEEG(str2num(structout.sereegaidx)).etc.sereega;
    end
    [ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEGmix );
    assignin('base', 'ALLEEG', ALLEEG);
    assignin('base', 'EEG', EEG);
    assignin('base', 'CURRENTSET', CURRENTSET);
    eeglab redraw;
end

end

