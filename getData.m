function [digitData, textData] = getData(name)
    [digitData, textData] = xlsread("data.xlsx", name);
end