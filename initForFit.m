function [yearsX, datasY] = initForFit(yearsX, datasY)
    % turn to col   
    if size(yearsX, 2) > 1
        yearsX = yearsX';
    end
    if size(datasY, 2) > 1
        datasY = datasY';
    end
    
    % remove NAN
    valid = find(~isnan(datasY));
    yearsX = yearsX(valid);
    datasY = datasY(valid);
end