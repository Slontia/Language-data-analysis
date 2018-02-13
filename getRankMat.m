function rankMat = getRankMat(mat, sortMode)
    [height, weight] = size(mat);
    sortedMat = sort(mat, 2, sortMode);
    rankMat = zeros(height, weight);
    for h = 1 : height
        for w = 1 : weight
            rankMat(h, w) = max(find(sortedMat(h, :) == mat(h, w))); 
        end
    end
end