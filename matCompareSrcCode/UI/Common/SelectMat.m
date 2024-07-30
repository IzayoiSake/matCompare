function data = SelectMat()

    % 打开文件选择对话框, 选择.mat文件
    [file, path] = uigetfileNew('*.mat', UIText.Text('Select mat File'));
    if isequal(file, 0)
        data = '';
        return;
    end
    data = load(fullfile(path, file));
end
