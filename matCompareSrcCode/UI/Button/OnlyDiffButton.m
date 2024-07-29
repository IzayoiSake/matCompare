function OnlyDiffButton(app, event)
    source = event.Source;
    State = app.State;
    
    if (State ~= StateEnum.Merging && State ~= StateEnum.Saved)
        % 警告
        uialert(app.UIFigure, '请先比较开始比较', '警告', 'Icon', 'warning');
        source.Value = false;
        return;
    end

    compareLog = app.UserData.CompareLog;

    buttonValue = source.Value;
    if (buttonValue)
        % 挑选出不是Same的数据
        diffIndex = ~cellfun(@(x) x == changeInfoEnum.Same, compareLog.changeInfo);
        diffLog = compareLog(diffIndex, :);
        UpDateCompareTable(app.UITable_Compare, diffLog);
    else
        UpDateCompareTable(app.UITable_Compare, compareLog);
    end
end


    