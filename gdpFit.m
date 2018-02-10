function gdpFit(yearsX, gdpsY, titleName)
    [yearsX, gdpsY] = initForFit(yearsX, gdpsY);
    gdpsFit = polyfit(yearsX, gdpsY, 2);
    gdpsFitX = 1980:2065;
    gdpsFitY = polyval(gdpsFit, gdpsFitX);
    clf;
    plot(yearsX, gdpsY, '*', gdpsFitX, gdpsFitY)
    title(titleName);
end