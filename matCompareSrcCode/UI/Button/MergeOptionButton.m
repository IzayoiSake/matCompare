function MergeOptionButton(app, event, option)
    % 判断软件状态
    State = app.State;
    if (State ~= StateEnum.Merging && State ~= StateEnum.Saved)
        % 警告还没有数据
        uialert(app.UIFigure, UIText.Text('Start compare first'), UIText.Text('Warn'), 'Icon', 'warning');
        return;
    end
    % 如果option不是mergeOptionEnum类型
    if ~isa(option, 'mergeOptionEnum')
        % 警告不是正确的option
        uialert(app.UIFigure, UIText.Text('Not correct merge option'), UIText.Text('Warn'), 'Icon', 'warning');
        return;
    end
    % 获取UITable_Compare当前的选中
    selection = app.UITable_Compare.Selection;
    if isempty(selection)
        % 警告还没有选择数据
        uialert(app.UIFigure, UIText.Text('Select compare data first'), UIText.Text('Warn'), 'Icon', 'warning');
        return;
    end
    % 获取选择的行的名字
    tableLog = app.UITable_Compare.UserData.tableLog;
    selectedLog = tableLog(selection, :);
    selectedName = selectedLog.varName;
    % 更新数据的 mergeOption
    compareLog = app.UserData.CompareLog;
    for i = 1:length(selectedName)
        thisName = selectedName{i};
        thisIndex = find(ismember(compareLog.varName, thisName));
        compareLog.mergeOption{thisIndex} = option;
        compareLog.merged{thisIndex} = true;
    end
    % 更新表格
    for i = 1:length(selection)
        tableLog.mergeOption{selection(i)} = option;
        tableLog.merged{selection(i)} = true;
    end
    UpDateCompareTable(app.UITable_Compare, tableLog, 'mergeOption');

    app.UserData.CompareLog = compareLog;
    app.State = StateEnum.Merging;
end
    

        
    
