function LastDiffButton(app, event)
    State = app.State;
    if (State ~= StateEnum.Merging && State ~= StateEnum.Saved)
        % 警告
        uialert(app.UIFigure, UIText.Text('Start compare first'), UIText.Text('Warn'), 'Icon', 'warning');
        return;
    end
end
