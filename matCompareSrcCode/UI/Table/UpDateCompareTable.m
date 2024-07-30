function UpDateCompareTable(appSource, tableLog, cmdMode)
    if ~exist('cmdMode', 'var')
        cmdMode = 'all';
    end
    try
        varName = tableLog.varName;
    catch
        appSource.UserData.tableLog = [];
        appSource.Data = [];
        return;
    end
    changeInfo = tableLog.changeInfo;
    mergeOption = tableLog.mergeOption;
    merged = tableLog.merged;

    % 表格内容更新
        varLength = length(varName);
        changeIndex = ones(varLength, 1);
        changeIndex = find(changeIndex);

        leftName = cell(varLength, 1);
        rightName = cell(varLength, 1);
        changeInfoDisplay = cell(varLength, 1);
        mergeOptionDisplay = cell(varLength, 1);

        changeIndexLength = length(changeIndex);

        if (strcmp(cmdMode, 'all') || strcmp(cmdMode, 'mergeOption'))
            % 根据变化信息填充 左右数据名 和 显示的变化信息
            for i = 1:changeIndexLength
                index = changeIndex(i);
                if (changeInfo{index} == changeInfoEnum.Same)
                    leftName{index} = varName{index};
                    rightName{index} = varName{index};
                    changeInfoDisplay{index} = UIText.Text('ChangeInfo Same');
                elseif (changeInfo{index} == changeInfoEnum.Different)
                    leftName{index} = varName{index};
                    rightName{index} = varName{index};
                    changeInfoDisplay{index} = UIText.Text('ChangeInfo Different');
                elseif (changeInfo{index} == changeInfoEnum.New)
                    rightName{index} = varName{index};
                    changeInfoDisplay{index} = UIText.Text('ChangeInfo New');
                elseif (changeInfo{index} == changeInfoEnum.Delete)
                    leftName{index} = varName{index};
                    changeInfoDisplay{index} = UIText.Text('ChangeInfo Delete');
                end
            end
            % 根据合并选项填充 显示的合并选项
            for i = 1:changeIndexLength
                index = changeIndex(i);
                if (mergeOption{index} == mergeOptionEnum.right)
                    mergeOptionDisplay{index} = UIText.Text('Option right');
                elseif (mergeOption{index} == mergeOptionEnum.left)
                    mergeOptionDisplay{index} = UIText.Text('Option left');
                end
            end
            tableDataDisplay = table(leftName, rightName, changeInfoDisplay, mergeOptionDisplay);
            appSource.Data = tableDataDisplay;
            appSource.UserData.tableLog = tableLog;
        end
    % 表格样式更新
        if strcmp(cmdMode, 'all')
            removeStyle(appSource);
            appSource.RowStriping = 'off';
            color = [1, 1, 1];
            appSource.BackgroundColor = color;
        end
        % 根据 变化信息 修改该行的背景颜色
        colorRed = [1, 0.8, 0.8];
        colorGreen = [0.8, 1, 0.8];
        colorYellow = [1, 1, 0.8];
        colorWhite = [1, 1, 1];
        colorDeepPink = [1, 0, 1];
        colorGray = [0.8, 0.8, 0.8];
        if (strcmp(cmdMode, 'all') || strcmp(cmdMode, 'selection'))
            % 计算基础索引
            changeInfoIndex.Same = zeros(varLength, 1);
            changeInfoIndex.Diff = zeros(varLength, 1);
            changeInfoIndex.New = zeros(varLength, 1);
            changeInfoIndex.Delete = zeros(varLength, 1);
            for i = 1:varLength
                if (changeInfo{i} == changeInfoEnum.Same)
                    changeInfoIndex.Same(i) = 1;
                elseif (changeInfo{i} == changeInfoEnum.Different)
                    changeInfoIndex.Diff(i) = 1;
                elseif (changeInfo{i} == changeInfoEnum.New)
                    changeInfoIndex.New(i) = 1;
                elseif (changeInfo{i} == changeInfoEnum.Delete)
                    changeInfoIndex.Delete(i) = 1;
                end
            end
            changeInfoIndex.Same = find(changeInfoIndex.Same);
            changeInfoIndex.Diff = find(changeInfoIndex.Diff);
            changeInfoIndex.New = find(changeInfoIndex.New);
            changeInfoIndex.Delete = find(changeInfoIndex.Delete);
            mergedIndex = find([merged{:}]);
            % 如果是选择模式, 则只需要 选择索引 与 基础索引 的交集
            if strcmp(cmdMode, 'selection')
                try
                    lastSelection = appSource.UserData.lastSelection;
                catch
                    lastSelection = [];
                end
                if ~isempty(lastSelection)
                    changeInfoIndex.Diff = intersect(lastSelection, changeInfoIndex.Diff);
                    changeInfoIndex.New = intersect(lastSelection, changeInfoIndex.New);
                    changeInfoIndex.Delete = intersect(lastSelection, changeInfoIndex.Delete);
                    changeInfoIndex.Same = intersect(lastSelection, changeInfoIndex.Same);
                    mergedIndex = intersect(lastSelection, mergedIndex);
                else
                    changeInfoIndex.Diff = [];
                    changeInfoIndex.New = [];
                    changeInfoIndex.Delete = [];
                    changeInfoIndex.Same = [];
                    mergedIndex = [];
                end
            end
            % 差异的行标记为红色
            if ~isempty(changeInfoIndex.Diff)
                changeInfoIndex.Diff = changeInfoIndex.Diff(:);
                style = uistyle('BackgroundColor', colorRed);
                addStyle(appSource, style, 'row', changeInfoIndex.Diff);
            end
            % 新增的行标记为绿色
            if ~isempty(changeInfoIndex.New)
                changeInfoIndex.New = changeInfoIndex.New(:);
                style = uistyle('BackgroundColor', colorGreen);
                addStyle(appSource, style, 'row', changeInfoIndex.New);
            end
            % 删除的行标记为黄色
            if ~isempty(changeInfoIndex.Delete)
                changeInfoIndex.Delete = changeInfoIndex.Delete(:);
                style = uistyle('BackgroundColor', colorYellow);
                addStyle(appSource, style, 'row', changeInfoIndex.Delete);
            end
            % 相同的行标记为白色
            if ~isempty(changeInfoIndex.Same)
                changeInfoIndex.Same = changeInfoIndex.Same(:);
                style = uistyle('BackgroundColor', colorWhite);
                addStyle(appSource, style, 'row', changeInfoIndex.Same);
            end
            % merged 为 true 的行标记为灰色
            if ~isempty(mergedIndex)
                mergedIndex = mergedIndex(:);
                style = uistyle('BackgroundColor', colorGray);
                addStyle(appSource, style, 'row', mergedIndex);
            end

        end

        % 选中的行标记为粉色, 字体加粗
        if (strcmp(cmdMode, 'all') || strcmp(cmdMode, 'selection'))
            try
                lastSelection = appSource.UserData.lastSelection;
            catch
                lastSelection = [];
            end
            % 取消上次选中的行的字体样式
            if ~isempty(lastSelection)
                style = uistyle('FontWeight', 'normal');
                addStyle(appSource, style, 'row', lastSelection);
            end
            selection = appSource.Selection;
            if ~isempty(selection)
                style = uistyle('BackgroundColor', colorDeepPink, 'FontWeight', 'bold');
                addStyle(appSource, style, 'row', selection);
            end
            appSource.UserData.lastSelection = selection;
        end

        % 根据 合并选项 修改该单元格的文本位置
        if (strcmp(cmdMode, 'all') || strcmp(cmdMode, 'mergeOption'))
            mergeOptionIndex.Left = zeros(varLength, 1);
            mergeOptionIndex.Right = zeros(varLength, 1);
            for i = 1:varLength
                if (mergeOption{i} == mergeOptionEnum.left)
                    mergeOptionIndex.Left(i) = 1;
                elseif (mergeOption{i} == mergeOptionEnum.right)
                    mergeOptionIndex.Right(i) = 1;
                end
            end
            mergeOptionIndex.Left = find(mergeOptionIndex.Left);
            mergeOptionIndex.Right = find(mergeOptionIndex.Right);
            
            if ~isempty(mergeOptionIndex.Left)
                mergeOptionIndex.Left = mergeOptionIndex.Left(:);
                indexLength = length(mergeOptionIndex.Left);
                pos = zeros(indexLength, 1);
                pos(:) = 4;
                cellIndex = [mergeOptionIndex.Left, pos];
                style = uistyle('HorizontalAlignment', 'left');
                addStyle(appSource, style, 'cell', cellIndex);
            end
            if ~isempty(mergeOptionIndex.Right)
                mergeOptionIndex.Right = mergeOptionIndex.Right(:);
                indexLength = length(mergeOptionIndex.Right);
                pos = zeros(indexLength, 1);
                pos(:) = 4;
                cellIndex = [mergeOptionIndex.Right, pos];
                style = uistyle('HorizontalAlignment', 'right');
                addStyle(appSource, style, 'cell', cellIndex);
            end
        end
end