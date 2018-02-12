function fitWeight()
    variExpr();
    options = optimset('TolX',1)
    result = fsolve(@vari, [0.1;0.4;0.6;0.5;0.3;2], options)
    result = sumNormal(abs(result), 1)
end

function result = vari(paras)
    global variExpr;
    result = setValue(variExpr, paras);
end


function variExpr()
    global variExpr;

    global distMat;
    global absCapMat;
    global sameLangMat;
    global curYear;
    global regionList;
    global regionNum;
    curYear = 2010;
    Region.update();
    for j = 1 : regionNum
        emisPMat(:, j) = regionList{j}.emisP;
    end
    capMatT = (emisPMat + distMat + absCapMat) .* sameLangMat;
    
    capMatT = normalCapMat(capMatT);
    langCapMatT = combineToLangCapMat(capMatT);
    [lang2PopsT, lang2PopsAct] = calLangTotalPop(langCapMatT);
    
    %variExpr = sum((lang2PopsT - lang2PopsAct) .^ 2);
    variExpr = 1 / 1000 * sum((lang2PopsT - lang2PopsAct) .^ 2) + ...
        1 * sum(...
        exp(...
        abs(...
            turnRank(lang2PopsT) - turnRank(lang2PopsAct)...
        )));
end


function mat = setValue(mat, paras)
    paras = abs(paras);
    paras = sumNormal(paras, 1);
    syms econW poliW migrW distW relDiffW eduW
    mat = subs(mat, econW, paras(1));
    mat = subs(mat, poliW, paras(2));
    mat = subs(mat, migrW, paras(3));
    mat = subs(mat, distW, paras(4));
    mat = subs(mat, relDiffW, paras(5));
    mat = subs(mat, eduW, paras(6));
    mat = double(mat);
end

function capMatT = normalCapMat(capMatT)
    capMatT = sumNormal(capMatT, 2);
end


function mat = sumNormal(mat, dimen)
    sumMat = sum(mat, dimen);
    mat = mat ./ sumMat;
end


function langCapMatT = combineToLangCapMat(capMatT)
    global regionNum;
    global langNum;
    langs = getData("lang");
    langNum = max(langs);
    for lang = 1 : langNum
        [sameLangRegs, ~] = find(langs == lang);
        langCapMatT(1:regionNum, lang) = sum(capMatT(:, sameLangRegs), 2);
    end
end


function [lang2PopsT, lang2PopsAct] = calLangTotalPop(langCapMatT)
    global regionList;
    global regionNum;
    global langNum;
    %langCapMatT = setValue(langCapMatT, zeros(6,1));
    % mul pop & cap
    for lang = 1 : regionNum
        popBasesT(lang, 1) = regionList{lang}.getYearPop(2010);
    end
    popBasesT = repmat(popBasesT, 1, langNum);
    %sym (lang2PopsT, [regionNum, 1]);
    %lang2RegPopsT = popBasesT .* langCapMat(:, :, :) .* (atan(lang2PopsT) / pi + 0.5);
    lang2RegPopsT = popBasesT .* langCapMatT(:, :) .* 0.5;
    lang2PopsT = sum(lang2RegPopsT, 1);
    lang2PopsT = lang2PopsT';
    lang2PopsAct = xlsread("lang2prop.xlsx", "solve");
    [validLang, ~] = find(~isnan(lang2PopsAct));
    lang2PopsT = lang2PopsT(validLang, 1);
    lang2PopsAct = lang2PopsAct(validLang, 1);    
end


function mat = turnRank(mat)
    [validSize, ~] = size(mat);
    matSort = sort(mat, 1);
    for r = 1 : validSize
        [lang, ~] = find(mat == matSort(r, 1));
    	mat(lang, 1) = r;
    end
end