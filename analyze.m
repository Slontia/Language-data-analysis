function analyze()
    global MODE;
    normalCapMat();
    combineToLangCapMat();
    %calLang2Prop();
    calLangTotalPop(MODE);
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


function calLangTotalPop(mode)
    global FUTURE_YEAR;
    global BASE_YEAR;
    global regionList;
    global regionNum;
    global langNum;
    global langCapMat;
    global lang2Props;
    % mul pop & cap
    popBases = zeros(regionNum, 1);
    for lang = 1 : regionNum
        if mode == 2
            popBases(lang, 1, :) = regionList{lang}.getYearPop(2010);
        else
            for year = BASE_YEAR : BASE_YEAR+FUTURE_YEAR-1
                popBases(lang, 1, year-BASE_YEAR+1) = regionList{lang}.getYearPop(year);
            end
        end
    end
    popBases = repmat(popBases, 1, langNum);
    % lang2Props = repmat(lang2Props, 1, langNum);
    % lang2RegPops = popBases .* langCapMat(:, :, :) .* lang2Props;
    lang2RegPops = popBases .* langCapMat(:, :, :) .* 0.5;
    lang2Pops = sum(lang2RegPops, 1);
    lang2PopMat = zeros(FUTURE_YEAR, langNum);
    for year = 1 : FUTURE_YEAR
        lang2PopMat(year, :) = lang2Pops(1, :, year); 
    end
    rankMat = getRank(lang2PopMat, 10);
    rankMat(11, :)'
    xlswrite('output.xls', rankMat, "popRank");
end


function rankMat = getRank(mat, rankSize)
    [h ,~] = size(mat);
    rankMat = zeros(h, rankSize);
    for i = 1 : h
        tempSort = sort(mat(i, :), 2, 'descend');
        for r = 1 : rankSize
            [~, reg] = find(mat(i, :) == tempSort(1, r));
            rankMat(i, r) = reg;
        end
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
            %paraMat(eqlPairs(pairCount, 1), lang) = 1;
            %paraMat(eqlPairs(pairCount, 2), lang) = -1;
            solveVec(1, lang) = 0;
            pairCount = pairCount + 1;
        else
            solveVec(1, lang) = solves(lang); 
        end
    end
    
    paraMat = paraMat';
    solveVec = solveVec';
    vari = @(x) sum((paraMat * (atan(x) / pi + 0.5) - solveVec) .^ 2);
    lang2Props = fsolve(vari, zeros(regionNum, 1));
    lang2Props = tan(pi * (lang2Props - 0.5));
    
end

function [solves, eqlPairs] = getEquaData()
    filename = "lang2prop.xlsx";
    solves = xlsread(filename, "solve");
    eqlPairs = xlsread(filename, "eql");
end
