function gdpsFit = gdpFit(yearsX, gdpsY)
    global DRAW_GRAPH;
    [yearsX, gdpsY] = initForFit(yearsX, gdpsY);
    gdpsFit = polyfit(yearsX, gdpsY, 2);
    
    if DRAW_GRAPH
        gdpsFitX = 1980:2065;
        gdpsFitY = polyval(gdpsFit, gdpsFitX);
        clf;
        plot(yearsX, gdpsY, '*', gdpsFitX, gdpsFitY)
    end
end