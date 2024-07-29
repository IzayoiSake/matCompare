function CompareTableSelection(app, event)
    % 获取选中的行
    source = event.Source;
    selection = source.Selection;
    if isempty(selection)
        tableLog = app.UITable_Compare.UserData.tableLog;
        UpDateCompareTable(app.UITable_Compare, tableLog);
        return;
    end
    if (length(selection) > 1)
        selectionOne = selection(end);
    else
        selectionOne = selection;
    end
    % 获取选中的数据
    selectedLog = app.UITable_Compare.Data(selectionOne, :);
    varName = [selectedLog.leftName; selectedLog.rightName];
    varName = varName(~cellfun('isempty', varName));
    varName = unique(varName);
    
    try
        leftDataTable = app.UITable_LeftData.Data;
        rightDataTable = app.UITable_RightData.Data;
        leftName = leftDataTable.dataName;
        rightName = rightDataTable.dataName;
        % 找到左右数据的索引
        leftIndex = find(ismember(leftName, varName));
        rightIndex = find(ismember(rightName, varName));
        
        % 将Table的该行设置为粉色, 字体加粗, 并滚动到该行
        removeStyle(app.UITable_LeftData);
        if ~isempty(leftIndex)
            scroll(app.UITable_LeftData, 'row', leftIndex);
            style = uistyle('BackgroundColor', [1, 0.8, 1], 'FontWeight', 'bold');
            addStyle(app.UITable_LeftData, style, 'row', leftIndex);
            app.UITable_Compare.focus;
        end
        removeStyle(app.UITable_RightData);
        if ~isempty(rightIndex)
            scroll(app.UITable_RightData, 'row', rightIndex);
            style = uistyle('BackgroundColor', [1, 0.8, 1], 'FontWeight', 'bold');
            addStyle(app.UITable_RightData, style, 'row', rightIndex);
            app.UITable_Compare.focus;
        end
        % 将选中的行设置为粉色, 字体加粗
        tableLog = app.UITable_Compare.UserData.tableLog;
        UpDateCompareTable(app.UITable_Compare, tableLog, 'selection');
        drawnow;
    catch
        
    end
    drawnow;
    
    % 聚焦回比较表
    app.UITable_Compare.focus;
end