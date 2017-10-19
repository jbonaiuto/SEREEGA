% h = plot_source_location(sourceIdx, leadfield, varargin)
%
%       Plots the location of the given sources using EEGLAB's dipfit plot.
%
% In:
%       sourceIdx - 1-by-n array containing the index/indices of the 
%                   source(s) in the leadfield to be plotted
%       leadfield - the leadfield from which to plot the sources
%
% Optional (key-value pairs):
%       newfig - (0|1) whether or not to open a new figure window.
%                default: 1
%       color - cell of color specifications, e.g. {'r', [0 1 0]}. source 
%               colors will rotate through the given colors if the number
%               given is less than the number of sources to plot. default
%               is a pinkish color that varies slightly across sources.
%       view - viewpoint specification in terms of azimuth and elevation,
%              as per MATLAB's view(), e.g.
%              [ 0, 90] = axial
%              [90,  0] = sagittal
%              [ 0,  0] = coronal (default: [90, 0]
%
% Out:  
%       h - handle of the generated figure
%
% Usage example:
%       >> lf = lf_generate_fromnyhead;
%       >> plot_source_location(1:25:size(lf.leadfield, 2), lf);
% 
%                    Copyright 2017 Laurens R Krol
%                    Team PhyPA, Biological Psychology and Neuroergonomics,
%                    Berlin Institute of Technology

% 2017-04-24 First version

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

function h = plot_source_location(sourceIdx, leadfield, varargin)

% parsing input
p = inputParser;

addRequired(p, 'sourceIdx', @isnumeric);
addRequired(p, 'leadfield', @isstruct);

addParameter(p, 'newfig', 1, @isnumeric);
addParameter(p, 'color', {}, @iscell);
addParameter(p, 'view', [90, 0], @isnumeric);

parse(p, sourceIdx, leadfield, varargin{:})

lf = p.Results.leadfield;
sourceIdx = p.Results.sourceIdx;
newfig = p.Results.newfig;
color = p.Results.color;
view = p.Results.view;

if isempty(color)
    % setting default, somewhat varying "brainy" colours
    for i = .5:.025:.9, color = [color, {[1, i, i]}]; end
    color = color([1, 1+randperm(length(color)-1)]);
end

% getting location struct for call to dipplot
locs = struct();
for i = sourceIdx
    locs(i).posxyz = lf.pos(i,:);
    locs(i).momxyz = [0 0 0];
    locs(i).rv = 0;
end

% calling dipplot
if newfig, h = figure; else h = NaN; end
dipplot(locs, 'coordformat', 'MNI', 'color', color, 'gui', 'off', 'dipolesize', 20, 'view', view);

end