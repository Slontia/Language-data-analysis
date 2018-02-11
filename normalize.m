function data = normalize(data, type, edge)    
    if type == "upper"
        if ~isnan(edge)
           data(data > edge) = edge; 
        end
        data = upperNormal(data);
    elseif type == "lower"
        if ~isnan(edge)
            data(data < edge) = edge;
        end
        data = lowerNormal(data);
    end
end


function data = lowerNormal(data)
    for i = 1:ndims(data)
        minValue = min(data);
    end
    data = minValue ./ data;
end


function data = upperNormal(data)
    for i = 1:ndims(data)
        maxValue = max(data);
    end
    data = data ./ maxValue;
end
