function gdpFit(yearsX, gdpsY, titleName)
    [yearsX, gdpsY] = initForFit(yearsX, gdpsY);
    gdpFunc = polyfit(yearsX, gdpsY, 2);
    gdpsFitX = 1980:2065;
    gdpsFitY = polyval(gdpFunc, gdpsFitX);
    clf;
    plot(yearsX, gdpsY, '*', gdpsFitX, gdpsFitY)
    title(titleName);
end