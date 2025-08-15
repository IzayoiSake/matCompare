function Write2BwsButton(app, event)
    % 判断软件状态
    State = app.State;
    if (State ~= StateEnum.Merging && State ~= StateEnum.Saved)
        % 弹出警告框
        uialert(app.UIFigure, UIText.Text('No new merge data'), UIText.Text('Warn'), 'Icon', 'warning');
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

    % 将数据写入 基础工作空间
    for i = 1:logLength
        thisName = compareLog.varName{i};
        try
            assignin('base', thisName, mergeMatData.(thisName));
        catch
        end
    end
end
