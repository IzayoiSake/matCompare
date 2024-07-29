function LastDiffButton(app, event)
    State = app.State;
    if (State ~= StateEnum.Merging && State ~= StateEnum.Saved)
        % 警告
        uialert(app.UIFigure, '请先比较开始合并', '警告', 'Icon', 'warning');
        return;
    end
end
