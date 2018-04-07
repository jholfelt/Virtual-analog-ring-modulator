classdef diodeN
    %A simple non-linear function approximating the non-linear curve of
    %voltage through a diode. This function avoids numerical solution and
    %look-up tables. It is a static non-linearity and therefore not ideal,
    %but it is good for computation and real-time purposes.
    
    properties
        vb = 0.2;
        vl = 0.4;
        h = 1;
        
        
    end
    
    methods
        function obj = diodeN(h)
           obj.vb = 
        end
    end
    
end

