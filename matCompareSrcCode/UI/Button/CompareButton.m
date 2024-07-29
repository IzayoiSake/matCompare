function data = CompareButton(app, event)
    State = app.State;
    if (State == StateEnum.Merging)
        % 询问是否重新比较
        selection = uiconfirm(app.UIFigure, '是否重新比较？(如果存在未保存数据, 将会丢失)', '警告', 'Options', {'是', '否'}, 'DefaultOption', 2, 'CancelOption', 2);
        if strcmp(selection, '否')
            return;
        end
    end
    
    try
        leftData = app.UserData.LeftData.matData;
        rightData = app.UserData.RightData.matData;
    catch
        % 弹出警告框
        uialert(app.UIFigure, '请先选择左右数据', '警告', 'Icon', 'warning');
        UpDateCompareTable(app.UITable_Compare, []);
        return;
    end
    app.UITable_Compare.Enable = 'on';
    app.UITable_Compare.Visible = 'on';

    leftDataName = fieldnames(leftData);
    rightDataName = fieldnames(rightData);
    leftDataLength = length(leftDataName);
    rightDataLength = length(rightDataName);
    % unique找出二者的并集
    uniqueDataName = [leftDataName; rightDataName];
    uniqueDataName = uniqueDataName(~cellfun('isempty', uniqueDataName));
    uniqueDataName = unique(uniqueDataName);
    varLength = length(uniqueDataName);

    % 初始化比较表格, 记录变量名, 变量状态, 合并选项, 索引是变量名
    varName = uniqueDataName;
    changeInfo = cell(varLength, 1);
    mergeOption = cell(varLength, 1);

    for i = 1:varLength
        % 初始化为合并右边, 记录在 mergeOption
        mergeOption{i} = mergeOptionEnum.right;
        thisName = varName{i};
        isInLeft = ismember(thisName, leftDataName);
        isInRight = ismember(thisName, rightDataName);
        % 判断左右数据差异状态, 记录在 changeInfo
        if (isInLeft && isInRight)
            leftValue = leftData.(thisName);
            rightValue = rightData.(thisName);
            if isequal(leftValue, rightValue)
                changeInfo{i} = changeInfoEnum.Same;
            else
                changeInfo{i} = changeInfoEnum.Different;
            end
        elseif (isInRight && ~isInLeft)
            changeInfo{i} = changeInfoEnum.Add;
        else
            changeInfo{i} = changeInfoEnum.Delete;
        end
    end
    
    compareLog = table(varName, changeInfo, mergeOption);
    
    UpDateCompareTable(app.UITable_Compare, compareLog);

    % 刷新页面
    dataTemp = app.UITable_Compare.Data;
    selectionTemp = app.UITable_Compare.Selection;
    app.UITable_Compare.Data = [];
    drawnow;
    app.UITable_Compare.Data = dataTemp;
    app.UITable_Compare.Selection = selectionTemp;

    app.UserData.CompareLog = compareLog;
    app.State = StateEnum.Merging;
end
