function CompareTableDoubleClicked(app, event)
    State = app.State;
    source = app.UITable_Compare;
    if (State ~= StateEnum.Merging && State ~= StateEnum.Saved)
        % 弹出警告框
        uialert(app.UIFigure, UIText.Text('Start compare first'), UIText.Text('Warn'), 'Icon', 'warning');
        return;
    end
    displayRow = event.InteractionInformation.DisplayRow;
    displayColumn = event.InteractionInformation.DisplayColumn;
    if isempty(displayRow)
        return;
    end

    % 获取当前行的数据名
    tableLog = source.UserData.tableLog;
    for i = 1:length(displayRow)
        varName{i} = tableLog.varName{displayRow(i)};
    end
    
    leftData = app.UserData.LeftData.matData;
    rightData = app.UserData.RightData.matData;
    var.leftVar = struct();
    var.rightVar = struct();

    for i = 1:length(varName)
        thisName = varName{i};
        try
            var.leftVar.(thisName) = leftData.(thisName);
        catch
        end
        try
            var.rightVar.(thisName) = rightData.(thisName);
        catch
        end
    end
    tempFileLeft = app.UserData.Temp.tempLeftFile;
    tempFileRight = app.UserData.Temp.tempRightFile;
    varCompare(var, tempFileLeft, tempFileRight);
end