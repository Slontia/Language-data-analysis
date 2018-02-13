%clear all,
dbstop if error

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

if MODE == -1
    fprintf("====== weights ======\n");
    weights = getData("weight")
    econW = weights(1, 1);      % economy weight
    poliW = weights(2, 1);      % politics weight
    migrW = weights(3, 1);      % migration weight
    distW = weights(4, 1);      % region distance weight
    relDiffW = weights(5, 1);   % relative language difficulty weight
    eduW = weights(6, 1);       % language education weight    
    
elseif MODE == 0
    syms econW poliW migrW distW relDiffW eduW;
elseif MODE == 1
    econW = 0.5057;      % economy weight
    poliW = 0.2329;      % politics weight
    migrW = 0.0431;      % migration weight
    distW = 0.0459;      % region distance weight
    relDiffW = 0.0656;   % relative language difficulty weight
    eduW = 0.1067;       % language education weight
elseif MODE == 2
    econW = 0.3358;      % economy weight
    poliW = 0.1865;      % politics weight
    migrW = 0;      % migration weight
    distW = 0.0523;      % region distance weight
    relDiffW = 0.0554;   % relative language difficulty weight
    eduW = 0.3076;       % language education weight
else
    econW = 0.3358;      % economy weight
    poliW = 0.1865;      % politics weight
    migrW = 0.0623;      % migration weight
    distW = 0.0523;      % region distance weight
    relDiffW = 0.0554;   % relative language difficulty weight
    eduW = 0.3076;       % language education weight    
end

readData();
if (MODE == 0)
    fitWeight();
else
    develop();
    analyze();
    outputResult();
end


