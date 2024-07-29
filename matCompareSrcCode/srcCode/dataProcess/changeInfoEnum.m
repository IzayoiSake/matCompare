classdef(Enumeration) changeInfoEnum < Simulink.IntEnumType
    enumeration
        Same(0),
        Different(1),
        Add(2),
        Delete(3),
    end
end