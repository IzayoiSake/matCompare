function [FileName,PathName] = uigetfileNew(varargin)
    f = figure( 'Renderer' , 'painters' , 'Position' , [-100 -100 0 0]);
    [FileName,PathName] = uigetfile(varargin(:));
    delete(f);
end