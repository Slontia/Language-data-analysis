function develop()
    global curYear;
    global capMat;
    global distMat;
    global absCapMat;
    global sameLangMat;
    global regionList;
    global regionNum;
    capMat = zeros(regionNum, regionNum, 60);
    for curYear = 2015 : 2065
        Region.update();
        emisPMat = zeros(regionNum);
        for i = 1 : regionNum
            emisPMat(i, :) = regionList{i}.emisP;
        end
%         emisPMat
%         distMat
%         absCapMat
        capMat(:, :, curYear-2014) = (emisPMat + distMat + absCapMat) .* sameLangMat;
        fprintf("%d\n", curYear-2015);
    end
end