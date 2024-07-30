function InitialText(app)
    % 获取app的全部 Fields
    appFields = fieldnames(app);
    % 遍历app的全部 Fields
    for i = 1:length(appFields)
        thisField = appFields{i};
        % 如果是UI组件
        className = class(app.(thisField));
        if contains(className, 'matlab.ui')
            thisComponent = app.(thisField);
            thisComponentFields = fieldnames(thisComponent);
            for j = 1:length(thisComponentFields)
                thisComponentField = thisComponentFields{j};
                try
                    text = thisComponent.(thisComponentField);
                    if ~isempty(text)
                        if (ischar(text) || isstring(text))
                            if contains(text, 'UIText.Text')
                                cmd = text;
                                thisComponent.(thisComponentField) = eval(cmd);
                                thisComponent.UserData.textField = thisComponentField;
                                thisComponent.UserData.textSrc = cmd;
                            end
                        end
                        if iscell(text)
                            isUIText = false;
                            for k = 1:length(text)
                                if (ischar(text{k}) || isstring(text{k}))
                                    if contains(text{k}, 'UIText.Text')
                                        isUIText = true;
                                        break;
                                    end
                                end
                            end
                            if (isUIText)
                                cmd = text{1};
                                for k = 2:length(text)
                                    cmd = [cmd, '; ', text{k}];
                                end
                                cmd = ['{', cmd, '}'];
                                thisComponent.(thisComponentField) = eval(cmd);
                                thisComponent.UserData.textField = thisComponentField;
                                thisComponent.UserData.textSrc = cmd;
                            end
                        end
                    end
                catch Me
                end
            end
        end
    end
end