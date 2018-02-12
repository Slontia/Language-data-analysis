% dbstop if error

global DRAW_GRAPH;
DRAW_GRAPH = 0;
global FUTURE_YEAR;
FUTURE_YEAR = 70;
global BASE_YEAR;
BASE_YEAR = 2000;
global MODE;
MODE = 3;

regionNum = 40;
lang2Mat = zeros(regionNum);

% Weights
global econW;
global poliW;
global migrW;
global distW;
global relDiffW;
global eduW;

if MODE == 0
    syms econW poliW migrW distW relDiffW eduW;
elseif MODE == 1
    econW = 0.5057;      % economy weight
    poliW = 0.2329;      % politics weight
    migrW = 0.0431;      % migration weight
    distW = 0.0459;      % region distance weight
    relDiffW = 0.0656;   % relative language difficulty weight
    eduW = 0.1067;       % language education weight
elseif MODE == 2
    econW = 0.5490;      % economy weight
    poliW = 0.2360;      % politics weight
    migrW = 0;      % migration weight
    distW = 0.0441;      % region distance weight
    relDiffW = 0.0680;   % relative language difficulty weight
    eduW = 0.1030;       % language education weight
else
    econW = 0.3314;      % economy weight
    poliW = 0.2249;      % politics weight
    migrW = 0.0746;           % migration weight
    distW = 0.0480;      % region distance weight
    relDiffW = 0.0556;   % relative language difficulty weight
    eduW = 0.2655;       % language education weight    
end

readData();
if (MODE == 0)
    fitWeight();
else
    develop();
    analyze();
end


