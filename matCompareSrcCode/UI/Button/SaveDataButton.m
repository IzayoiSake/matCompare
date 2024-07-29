function SaveDataButton(app, event)
    % 判断软件状态
    State = app.State;
    if (State ~= StateEnum.Merging && State ~= StateEnum.Saved)
        % 弹出警告框
        uialert(app.UIFigure, '还没有进行新的数据合并', '警告', 'Icon', 'warning');
        return;
    end

    compareLog = app.UserData.CompareLog;
    logLength = length(compareLog.varName);
    
    mergeMatData = struct();
    for i = 1:logLength
        thisName = compareLog.varName{i};
        thisMergeOption = compareLog.mergeOption{i};
        if (thisMergeOption == mergeOptionEnum.left)
            try
                mergeMatData.(thisName) = app.UserData.LeftData.matData.(thisName);
            catch
            end
        elseif (thisMergeOption == mergeOptionEnum.right)
            try
                mergeMatData.(thisName) = app.UserData.RightData.matData.(thisName);
            catch
            end
        end
    end

    [file, path] = uiputfileNew('*.mat', '选择保存的.mat文件名');
    if isequal(file, 0)
        return;
    end
    save(fullfile(path, file), '-struct', 'mergeMatData');

    app.State = StateEnum.Saved;
end