% Initialize random number generator to get same results every time
% This is done at the beginning of each section so that each section
%   can be run separately
% Seed values 0 and 0 are used in the book

function initializerandomseeds()

%This is mainly used in selecting initial points for algorithms
randn('state', 0);

%This one is used in random sampling of patches from images
rand('state',0);

return;

