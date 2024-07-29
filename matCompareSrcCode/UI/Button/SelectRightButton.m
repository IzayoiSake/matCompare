function SelectRightButton(app, event)
    State = app.State;
    if (State == StateEnum.Merging)
        % 询问是否重新选择文件
        selection = uiconfirm(app.UIFigure, '当前比较尚未保存, 是否丢弃并重新选择文件？', '警告', 'Options', {'是', '否'}, 'DefaultOption', 2, 'CancelOption', 2);
        if strcmp(selection, '否')
            return;
        end
    end
    handle = app.UITable_RightData;

    data = SelectMat();
    if isempty(data)
        return;
    end
    app.UserData.RightData.matData = data;

    handle.Enable = 'off';
    handle.Visible = 'off';
    drawnow;
    handle.Enable = 'on';
    handle.Visible = 'on';
    
    [dataName, dataClass, dataValue, dataType] = matDataInfo(data);

    % 将数据显示到表格中
    tableHeader = {'名字', '类型', '值', '数据类型'};
    dataTable = table(dataName, dataClass, dataValue, dataType);
    handle.ColumnName = tableHeader;
    handle.Data = dataTable;
    handle.SelectionType = 'row';

    app.State = StateEnum.Selecting;
end
