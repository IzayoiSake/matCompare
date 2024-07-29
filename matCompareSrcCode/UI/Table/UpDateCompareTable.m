function UpDateCompareTable(appSource, compareLog, cmdMode)
    if ~exist('cmdMode', 'var')
        cmdMode = 'all';
    end
    tableHeader = {'左数据名', '右数据名', '变化信息', '合并选项'};
    try
        varName = compareLog.varName;
    catch
        appSource.ColumnName = tableHeader;
        appSource.UserData.tableLog = [];
        appSource.Data = [];
        return;
    end
    changeInfo = compareLog.changeInfo;
    mergeOption = compareLog.mergeOption;

    % 表格内容更新
        varLength = length(varName);
        % try
        %     oldTableLog = appSource.UserData.tableLog;
        %     oldVarName = oldTableLog.varName;
        %     oldChangeInfo = oldTableLog.changeInfo;
        %     oldMergeOption = oldTableLog.mergeOption;
        % catch
        %     oldTableLog = [];
        %     oldVarName = [];
        %     oldChangeInfo = [];
        %     oldMergeOption = [];
        % end
        % oldLength = length(oldVarName);
        % if (varLength ~= oldLength)
        %     changeIndex = ones(varLength, 1);
        %     changeIndex = find(changeIndex);

        %     leftName = cell(varLength, 1);
        %     rightName = cell(varLength, 1);
        %     changeInfoDisplay = cell(varLength, 1);
        %     mergeOptionDisplay = cell(varLength, 1);
        % else
        %     changeIndex = ~cellfun(@isequal, varName, oldVarName);
        %     changeIndex = changeIndex | ~cellfun(@isequal, changeInfo, oldChangeInfo);
        %     changeIndex = changeIndex | ~cellfun(@isequal, mergeOption, oldMergeOption);
        %     changeIndex = find(changeIndex);
        %     try
        %         oldtableDataDisplay = appSource.Data;
        %         leftName = oldtableDataDisplay.leftName;
        %         rightName = oldtableDataDisplay.rightName;
        %         changeInfoDisplay = oldtableDataDisplay.changeInfoDisplay;
        %         mergeOptionDisplay = oldtableDataDisplay.mergeOptionDisplay;
        %     catch
        %         leftName = cell(varLength, 1);
        %         rightName = cell(varLength, 1);
        %         changeInfoDisplay = cell(varLength, 1);
        %         mergeOptionDisplay = cell(varLength, 1);
        %     end
        % end
        changeIndex = ones(varLength, 1);
        changeIndex = find(changeIndex);

        leftName = cell(varLength, 1);
        rightName = cell(varLength, 1);
        changeInfoDisplay = cell(varLength, 1);
        mergeOptionDisplay = cell(varLength, 1);

        changeIndexLength = length(changeIndex);
        % 根据变化信息填充 左右数据名 和 显示的变化信息
        for i = 1:changeIndexLength
            index = changeIndex(i);
            if (changeInfo{index} == changeInfoEnum.Same)
                leftName{index} = varName{index};
                rightName{index} = varName{index};
                changeInfoDisplay{index} = '相同';
            elseif (changeInfo{index} == changeInfoEnum.Different)
                leftName{index} = varName{index};
                rightName{index} = varName{index};
                changeInfoDisplay{index} = '差异';
            elseif (changeInfo{index} == changeInfoEnum.Add)
                rightName{index} = varName{index};
                changeInfoDisplay{index} = '新增';
            elseif (changeInfo{index} == changeInfoEnum.Delete)
                leftName{index} = varName{index};
                changeInfoDisplay{index} = '删除';
            end
        end
        % 根据合并选项填充 显示的合并选项
        for i = 1:changeIndexLength
            index = changeIndex(i);
            if (mergeOption{index} == mergeOptionEnum.right)
                mergeOptionDisplay{index} = '→';
            elseif (mergeOption{index} == mergeOptionEnum.left)
                mergeOptionDisplay{index} = '←';
            end
        end
        tableDataDisplay = table(leftName, rightName, changeInfoDisplay, mergeOptionDisplay);
        appSource.Data = tableDataDisplay;
        appSource.ColumnName = tableHeader;
        appSource.UserData.tableLog = compareLog;
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
        if (strcmp(cmdMode, 'all') || strcmp(cmdMode, 'selection'))
            changeInfoIndex.Diff = cellfun(@(x) x == changeInfoEnum.Different, changeInfo);
            changeInfoIndex.Diff = find(changeInfoIndex.Diff);
            changeInfoIndex.Add = cellfun(@(x) x == changeInfoEnum.Add, changeInfo);
            changeInfoIndex.Add = find(changeInfoIndex.Add);
            changeInfoIndex.Delete = cellfun(@(x) x == changeInfoEnum.Delete, changeInfo);
            changeInfoIndex.Delete = find(changeInfoIndex.Delete);
            changeInfoIndex.Same = cellfun(@(x) x == changeInfoEnum.Same, changeInfo);
            changeInfoIndex.Same = find(changeInfoIndex.Same);
            if strcmp(cmdMode, 'selection')
                % 恢复上次选中的行的背景颜色
                try
                    lastSelection = appSource.UserData.lastSelection;
                catch
                    lastSelection = [];
                end
                if ~isempty(lastSelection)
                    changeInfoIndex.Diff = intersect(lastSelection, changeInfoIndex.Diff);
                    changeInfoIndex.Add = intersect(lastSelection, changeInfoIndex.Add);
                    changeInfoIndex.Delete = intersect(lastSelection, changeInfoIndex.Delete);
                    changeInfoIndex.Same = intersect(lastSelection, changeInfoIndex.Same);
                else
                    changeInfoIndex.Diff = [];
                    changeInfoIndex.Add = [];
                    changeInfoIndex.Delete = [];
                    changeInfoIndex.Same = [];
                end
            end
            % 差异的行标记为红色
            if ~isempty(changeInfoIndex.Diff)
                changeInfoIndex.Diff = changeInfoIndex.Diff(:);
                style = uistyle('BackgroundColor', colorRed);
                addStyle(appSource, style, 'row', changeInfoIndex.Diff);
            end
            % 新增的行标记为绿色
            if ~isempty(changeInfoIndex.Add)
                changeInfoIndex.Add = changeInfoIndex.Add(:);
                style = uistyle('BackgroundColor', colorGreen);
                addStyle(appSource, style, 'row', changeInfoIndex.Add);
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
            mergeOptionLeftIndex = cellfun(@(x) x == mergeOptionEnum.left, mergeOption);
            mergeOptionLeftIndex = find(mergeOptionLeftIndex);
            mergeOptionRightIndex = cellfun(@(x) x == mergeOptionEnum.right, mergeOption);
            mergeOptionRightIndex = find(mergeOptionRightIndex);
            if ~isempty(mergeOptionLeftIndex)
                mergeOptionLeftIndex = mergeOptionLeftIndex(:);
                indexLength = length(mergeOptionLeftIndex);
                pos = zeros(indexLength, 1);
                pos(:) = 4;
                cellIndex = [mergeOptionLeftIndex, pos];
                style = uistyle('HorizontalAlignment', 'left');
                addStyle(appSource, style, 'cell', cellIndex);
            end
            if ~isempty(mergeOptionRightIndex)
                mergeOptionRightIndex = mergeOptionRightIndex(:);
                indexLength = length(mergeOptionRightIndex);
                pos = zeros(indexLength, 1);
                pos(:) = 4;
                cellIndex = [mergeOptionRightIndex, pos];
                style = uistyle('HorizontalAlignment', 'right');
                addStyle(appSource, style, 'cell', cellIndex);
            end
        end
end