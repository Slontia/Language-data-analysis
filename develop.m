function develop()
    global curYear;
    global capMat;
    global FUTURE_YEAR;
    global BASE_YEAR;
    global distMat;
    global absCapMat;
    global sameLangMat;
    global regionList;
    global regionNum;
    capMat = zeros(regionNum, regionNum, FUTURE_YEAR);
    for curYear = BASE_YEAR : BASE_YEAR+FUTURE_YEAR-1
        Region.update();
        emisPMat = zeros(regionNum);
        for j = 1 : regionNum
            emisPMat(:, j) = regionList{j}.emisP;
        end
%         emisPMat
%         distMat
%         absCapMat
        capMat(:, :, curYear-BASE_YEAR+1) = (emisPMat + distMat + absCapMat) .* sameLangMat;
        fprintf("%d\n", curYear);
    end
end