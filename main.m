distMat = [];
lang2Mat = [];
curYear = 2015;

fitData();

function fitData()
    fitDataFromXls("gdp", @gdpFit);
    fitDataFromXls("pop", @popFit);
    fprintf('over\n');
end