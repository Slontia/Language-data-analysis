function outputResult()
    %drawGraph();
    outputTable();
end

function drawGraph()
    drawLangGraph(3, 2029, "total");
    drawLangGraph(3, 2049, "total");
    drawLangGraph(3, 2069, "total");
    drawLangGraph(13, 2029, "total");
    drawLangGraph(13, 2049, "total");
    drawLangGraph(13, 2069, "total");
end

function drawLangGraph(langId, year, type)
    global regionNum;
    x = [1 : regionNum]';
    if type == "total"
       [~, y] = getTotalLangPop(langId, year);
       bar(x, y);
       
    elseif type == "lang1"
        
    elseif type == "lang2"
        
    end
end

function [sumResult, nodeResult] = getTotalLangPop(langId, years)
    [sumResult1, nodeResult1] = getLang1Pop(langId, years);
    [sumResult2, nodeResult2] = getLang2Pop(langId, years);
    sumResult = sumResult1 + sumResult2;
    nodeResult = nodeResult1 + nodeResult2;
end

function [sumResult, nodeResult] = getLang1Pop(langId, years)
    global regionList;
    global regionNum;
    [yearNum, ~] = size(years);
    sumResult = zeros(yearNum, 1);
    nodeResult = zeros(yearNum, regionNum);
    for reg = 1 : regionNum
       if regionList{reg}.lang == langId
           % store in temp
           tempResult = zeros(yearNum, 1);
           for y = 1 : yearNum
              year = years(y, 1);
              tempResult(y, 1) = ...
                  regionList{reg}.getYearPop(year);
           end
           
           % add temp to result
           sumResult = sumResult + tempResult;
           nodeResult(:, reg) = tempResult;
       end
    end
end

function [sumResult, nodeResult] = getLang2Pop(langId, years)
    global lang2PopMat;
    global lang2RegPops;
    global regionNum;
    global BASE_YEAR;
    [yearNum, ~] = size(years);
    relaYears = years - BASE_YEAR + 1;
    nodeResult = zeros(yearNum, regionNum);
    for y = 1 : yearNum
        relaYear = relaYears(y, 1);
        sumResult = lang2PopMat(relaYears, langId);
        temp = lang2RegPops(:, langId, relaYear);
        nodeResult(y, :) = temp(:, 1);   
    end
end


function outputTable()
    %outputLangPopTable(2019:5:2069);
    %outputLangRankList(2069);
    %outputOfficeLangTable([2025, 2065], 10);
end


function outputLangRankList(years)
    global lang2RankMat;
    global BASE_YEAR;
    relaYears = years - BASE_YEAR + 1;
    outputMat = lang2RankMat(relaYears, :)';
    xlswrite("output.xls", outputMat, "langYearRank");
end


function outputLangPopTable(years)
    global lang2PopMat;
    global BASE_YEAR;
    relaYears = years - BASE_YEAR + 1;
    outputMat = lang2PopMat(relaYears, :)';
    xlswrite("output.xls", outputMat, "langYearPop");
end


function outputOfficeLangTable(years, listSize)
    [yearsNum, ~] = size(years);
    for y = 1 : yearsNum
        year = years(y);
        gdpRegionList = filterGdpRegion(year, listSize);
        [engPopList, otherPopList, otherIdList] = getHotLangMat(gdpRegionList, year);
        table = [gdpRegionList', engPopList, otherPopList, otherIdList];
        xlswrite("output.xls", table, int2str(year));        
    end
end


function [engPopList, otherPopList, otherIdList] = getHotLangMat(regList, year)
    global lang2RegPops;
    global BASE_YEAR;
    global regionList;
    [~, langNameList] = getData("langName");
    engId = find(langNameList == "English"); % get English id
    [~, regNum] = size(regList);
    popMat = lang2RegPops(regList, :, year - BASE_YEAR + 1);
    for reg = 1 : regNum
        region = regionList{regList(1, reg)};
        popMat(reg, region.lang) = popMat(reg, region.lang) + region.getYearPop(year);
    end
    rankMat = getRankMat(popMat, 'descend');
    
    
    otherIdList = zeros(regNum, 1);
    engPopList = zeros(regNum, 1);
    otherPopList = zeros(regNum, 1);
    for reg = 1 : regNum
         % get other the hottest language id
         if rankMat(reg, engId) == 1
             otherId = find(rankMat(reg, :) == 2); 
         else
             otherId = find(rankMat(reg, :) == 1);
         end
         otherIdList(reg, 1) = otherId;
         engPopList(reg, 1) = popMat(reg, engId);
         otherPopList(reg, 1) = popMat(reg, otherId);
    end
end

function gdpRegionList = filterGdpRegion(year, listSize)
    global regionList;
    global regionNum;
    gdpList = zeros(1, regionNum);
    gdpRegionList = zeros(1, listSize);
    for reg = 1 : regionNum;
        gdpList(1, reg) = regionList{reg}.getYearGdp(year);
    end
    gdpRankList = getRankMat(gdpList, 'descend');
    for rank = 1 : listSize
        gdpRegionList(1, rank) = find(gdpRankList == rank); 
    end
end
