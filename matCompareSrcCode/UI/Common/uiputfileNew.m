function [FileName,PathName] = uiputfileNew(varargin)
    f = figure( 'Renderer' , 'painters' , 'Position' , [-100 -100 0 0]);
    % 用户选择一个.mat后缀的要保存的文件
    [FileName,PathName] = uiputfile('*.mat', '选择保存的.mat文件名');
    delete(f);
end