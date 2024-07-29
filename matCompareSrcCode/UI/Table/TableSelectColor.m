function TableSelectColor(app, event)
    % 获取源
    source = event.Source;
    % 获取该源选中的内容
    selection = source.Selection;
    selectionType = source.SelectionType;
    % 获取该源的之前选中的内容
    try
        previousSelection = source.UserData.previousSelection;
        previousSelectionType = source.UserData.previousSelectionType;
        % 获取之前的背景颜色style
        styleIndex = ismember(previousSelection, source.StyleConfigurations.TargetIndex);
        newStyle = source.StyleConfigurations.Style(styleIndex);
        % 删除之前的背景颜色style
        newStyle.BackgroundColor = [];
        addStyle(source, newStyle, previousSelectionType, previousSelection);
    catch
    end
    source.UserData.previousSelection = selection;
    source.UserData.previousSelectionType = selectionType;
    % 选中的填充背景颜色(粉色)
    styleIndex = ismember(selection, source.StyleConfigurations.TargetIndex);
    if isempty(styleIndex)
        color = [255, 0, 185];
        newStyle = uistyle('BackgroundColor', color);
    else
        newStyle = source.StyleConfigurations.Style(styleIndex);
        newStyle.BackgroundColor = [255, 0, 185];
    end
    addStyle(source, newStyle, selectionType, selection);
end