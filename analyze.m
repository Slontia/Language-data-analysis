function analyze()
    normalCapMat();
    combineToLangCapMat();
    calLang2Prop();
end


function normalCapMat()
    global capMat;
    capMat = sumNormal(capMat, 2);
end


function mat = sumNormal(mat, dimen)
    sumMat = sum(mat, dimen);
    mat = mat ./ sumMat;
end


function combineToLangCapMat()
    global FUTURE_YEAR;
    global langCapMat;
    global capMat;
    global regionNum;
    global langNum;
    langs = getData("lang");
    langNum = max(langs);
    langCapMat = zeros(regionNum, langNum, FUTURE_YEAR);
    for lang = 1 : langNum
        [sameLangRegs, ~] = find(langs == lang);
        langCapMat(:, lang, :) = sum(capMat(:, sameLangRegs, :), 2);
    end
end


function calLang2Prop()
    global BASE_YEAR;
    global FUTURE_YEAR;
    global lang2Props;
    global regionList;
    global regionNum;
    global langNum;
    global langCapMat;
    % mul pop & cap
    popBases = zeros(regionNum, 1);
    for lang = 1 : regionNum
        popBases(lang, 1) = regionList{lang}.getYearPop(2010);
    end
    popBases = repmat(popBases, 1, langNum);
    paraMat = popBases .* langCapMat(:, :, 2010-BASE_YEAR);
    
    solveVec = zeros(1, regionNum);
    % read file
    pairCount = 1;
    [solves, eqlPairs] = getEquaData();
    [solvesSize, ~] = size(solves);
    for lang = 1 : regionNum
        if lang > solvesSize || isnan(solves(lang))
            paraMat(:, lang) = 0;
            paraMat(eqlPairs(pairCount, 1), lang) = 1;
            paraMat(eqlPairs(pairCount, 2), lang) = -1;
            solveVec(1, lang) = 0;
            pairCount = pairCount + 1;
        else
            solveVec(1, lang) = solves(lang); 
        end
    end
    
    lang2Props = paraMat \ solveVec;
    
end

function [solves, eqlPairs] = getEquaData()
    filename = "lang2prop.xlsx";
    solves = xlsread(filename, "solve");
    eqlPairs = xlsread(filename, "eql");
end
