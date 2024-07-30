function SelectLeftButton(app, event)
    State = app.State;
    if (State == StateEnum.Merging)
        % 询问是否重新选择文件
        selection = uiconfirm(app.UIFigure, UIText.Text('Discard and restart'), UIText.Text('Warn'), 'Options', {UIText.Text('Yes'), UIText.Text('No')}, 'DefaultOption', 2, 'CancelOption', 2);
        if strcmp(selection, UIText.Text('No'))
            return;
        end
    end
    handle = app.UITable_LeftData;

    data = SelectMat();
    if isempty(data)
        return;
    end
    app.UserData.LeftData.matData = data;

    handle.Enable = 'off';
    handle.Visible = 'off';
    drawnow;
    handle.Enable = 'on';
    handle.Visible = 'on';
    
    [dataName, dataClass, dataValue, dataType] = matDataInfo(data);

    % 将数据显示到表格中
    dataTable = table(dataName, dataClass, dataValue, dataType);
    handle.Data = dataTable;
    handle.SelectionType = 'row';

    app.State = StateEnum.Selecting;
end
