function value = map(value, mode)
    if (mode == "map")
        value = atan(value) / pi + 0.5;
    elseif (mode == "unmap")
        value = tan(pi * (value - 0.5))
    end
end