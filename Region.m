classdef Region
    properties
        id;
        name;
        language;
        popsFitLine;    % the changes of population
        gdpsFitLine;    % the changes of GDP
        policyPower;    % policy power
        lang2Prop;      % the proportion of L2
        
        Stress
        Strain
    end
 
    properties (Dependent)
        redia;  % rediation
        recep;  % receptance
        
    end   
   
    % constuctor
    methods 
        function region = Region()
            
        end
    end
    
    methods
        function beRediatedBy(originRegion, dist)
            
        end
    end
    

end