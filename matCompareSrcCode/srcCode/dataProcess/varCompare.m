function varCompare(var, tempFileLeft, tempFileRight)
    % 使用matlab自带的合并工具进行比较
    % 生成临时mat文件
    [path, name, ext] = fileparts(tempFileLeft);
    tempFileLeft = fullfile(path, [name, '.mat']);
    [path, name, ext] = fileparts(tempFileRight);
    tempFileRight = fullfile(path, [name, '.mat']);

    leftVar = var.leftVar;
    rightVar = var.rightVar;
    save(tempFileLeft, '-struct', 'leftVar');
    save(tempFileRight, '-struct', 'rightVar');

    % 调用matlab自带的比较工具
    try
        visdiff(tempFileLeft, tempFileRight);
    catch
    end
    
end