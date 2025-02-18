classdef Features
    properties (Constant = true)
        TotalEnergy = 1;
        StandardDeviation = 2;
        MaxAmplitude = 3;
        ZeroCrossingRate = 4;
        Duration = 5;
    endproperties

    methods (Static)
        function range = enum()
            range = Features.TotalEnergy : Features.Duration;
        endfunction

        function string = get_string(value)
            switch (value)
            case Features.TotalEnergy
              result = "Total Energy";
            case StandardDeviation
              result = "Standard Deviation";
            case MaxAmplitude
              result = "Max Amplitude";
            case ZeroCrossingRate
              result = "Zero Crossing Rate";
            case Duration
              result = "Duration";
            otherwise
              result = "";
            endswitch
        endfunction
    endmethods
endclassdef
