classdef(Enumeration) StateEnum < Simulink.IntEnumType
    enumeration
        StartUp(0),
        Selecting(1),
        Merging(2),
        Saved(3),
    end
end