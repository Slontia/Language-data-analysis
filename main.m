fitDataFromXls("gdp", @gdpFit);
fitDataFromXls("pop", @popFit);
over = sprintf('over');
disp(over)

function fitDataFromXls(sheetName, fitHandle)
    data = xlsread("data.xlsx", sheetName);
    dataSize = size(data, 1);

    % load year axis
    years = data(1,:);

    % load year axis
    for regionNo = 2:dataSize
        regionDatas = data(regionNo, :);
        fitHandle(years, regionDatas, regionNo); 
        pause(0.3);
    end
end