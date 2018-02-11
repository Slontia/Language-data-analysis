regionNum = 40;
lang2Mat = zeros(regionNum);

% Matrixs
global capMat;
global absCapMat;
global distMat;
capMat = zeros(regionNum);        % C   (contr & lang)
absCapMat = zeros(regionNum);     % AC  (contr & lang)
distMat = zeros(regionNum);       % D   (contr & contr)

% Weights
global econW;
global poliW;
global migrW;
global distW;
global relDiffW;
global eduW;
econW = 0.1;      % economy weight
poliW = 0.1;      % politics weight
migrW = 0.1;      % migration weight
distW = 0.1;      % region distance weight
relDiffW = 0.1;   % relative language difficulty weight
eduW = 0.1;       % language education weight

% Other
global curYear;

readData();
for curYear = 2015:2065
    develop();
end



