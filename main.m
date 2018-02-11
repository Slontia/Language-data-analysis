global DRAW_GRAPH;
DRAW_GRAPH = 0;

regionNum = 40;
lang2Mat = zeros(regionNum);

% Weights
global econW;
global poliW;
global migrW;
global distW;
global relDiffW;
global eduW;
econW = 0.5057;      % economy weight
poliW = 0.2329;      % politics weight
migrW = 0.0431;      % migration weight
distW = 0.0459;      % region distance weight
relDiffW = 0.0656;   % relative language difficulty weight
eduW = 0.1067;       % language education weight

readData();
develop();



