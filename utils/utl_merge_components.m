% component = utl_merge_components(comp1, comp2)
%
%       Merges two components that have equal sources. The resulting
%       component will have the same sources as either one of the original
%       components, their combined signals, and the mean of their
%       orientation (and orientationDv).
%
% In:
%       comp1 - 1x1 struct, the first component
%       comp2 - 1x1 struct, the second component
%
% Out:  
%       component - the combined component
% 
%                    Copyright 2017 Laurens R Krol
%                    Team PhyPA, Biological Psychology and Neuroergonomics,
%                    Berlin Institute of Technology

% 2017-12-01 First version

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

function component = utl_merge_components(comp1, comp2)

if numel(comp1) > 1 || numel(comp2) > 1
    error('SEREEGA:utl_merge_components:criterionError', 'can only merge two components at once');
end

if all(sort(comp1.source) == sort(comp2.source))
    component = struct();
    component.source = comp1.source;
    
    % merging signals, removing duplicates
    component.signal = [comp1.signal, comp2.signal];
    for s = 1:numel(component.signal)
        if sum(cellfun(@(x) isequal(x, component.signal{s}), component.signal)) > 1
            % setting first appearance of structs that appear more than once to []
            component.signal{s} = [];
        end
    end
    % removing all cells that contain []
    component.signal(cellfun(@(x) isequal(x, []), component.signal)) = [];
    
    % taking mean orientation
    component.orientation(:,:,1) = comp1.orientation;
    component.orientation(:,:,2) = comp2.orientation;
    component.orientation = mean(component.orientation, 3);
    
    % taking mean orientationDv
    component.orientationDv(:,:,1) = comp1.orientationDv;
    component.orientationDv(:,:,2) = comp2.orientationDv;
    component.orientationDv = mean(component.orientationDv, 3);
else
    error('SEREEGA:utl_merge_components:criterionError', 'cannot merge components with different source(s)');
end

end