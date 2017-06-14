% signal = erp_generate_signal_fromclass(class, epochs, epochNumber)
%
%       Takes an ERP activation class, determines single parameters given
%       the deviations/slopes in the class, and returns a signal generated
%       using those parameters.
%
% In:
%       class - 1x1 struct, the class variable
%       epochs - 1x1 struct, an epoch configuration struct
%       epochNumber - current epoch number (required for slope calculation)
%
% Out:  
%       signal - the generated simulated ERP activation signal
%
% Usage example:
%       >> epochs.n = 100; epochs.srate = 500; epochs.length = 1000;
%       >> erp.peakLatency = 300; erp.peakWidth = 100; erp.peakAmplitude = 1;
%       >> erp = utl_check_class(erp, 'type', 'erp');
%       >> signal = erp_generate_signal_fromclass(erp, epochs, 1);
% 
%                    Copyright 2017 Laurens R Krol
%                    Team PhyPA, Biological Psychology and Neuroergonomics,
%                    Berlin Institute of Technology

% 2017-06-13 First version

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

function signal = erp_generate_signal_fromclass(class, epochs, epochNumber)

% obtaining specific instances of peak latencies
peakLatency = zeros(1, numel(class.peakLatency));
for p = 1:length(class.peakLatency)
    peakLatency(p) = utl_apply_dvslope(class.peakLatency(p), class.peakLatencyDv(p), class.peakLatencySlope, epochNumber, epochs.n);
end

% peak widths
peakWidth = zeros(1, numel(class.peakWidth));
for p = 1:length(class.peakWidth)
    peakWidth(p) = utl_apply_dvslope(class.peakWidth(p), class.peakWidthDv(p), class.peakWidthSlope, epochNumber, epochs.n);
    if peakWidth(p) == 0, peakWidth(p) = 1; end
    if peakWidth(p) < 0, peakWidth(p) = -peakWidth(p); end
end

% peak amplitudes
peakAmplitude = zeros(1, numel(class.peakAmplitude));
for p = 1:length(class.peakAmplitude)
    peakAmplitude(p) = utl_apply_dvslope(class.peakAmplitude(p), class.peakAmplitudeDv(p), class.peakAmplitudeSlope, epochNumber, epochs.n);
end

% checking probability
if rand() < class.probability + class.probabilitySlope * epochNumber / epochs.n
    % generating signal
    signal = erp_generate_signal(peakLatency, peakWidth, peakAmplitude, epochs.srate, epochs.length);
else
    % returning flatline
    signal = zeros(1, floor((epochs.length/1000)*epochs.srate));
end

end