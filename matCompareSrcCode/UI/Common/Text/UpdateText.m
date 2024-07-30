function UpdateText(app)
    % 获取app的全部 Fields
    appFields = fieldnames(app);
    % 遍历app的全部 Fields
    for i = 1:length(appFields)
        try
            textField = app.(appFields{i}).UserData.textField;
            textSrc = app.(appFields{i}).UserData.textSrc;
            if ~isempty(textField) && ~isempty(textSrc)
                cmd = textSrc;
                app.(appFields{i}).(textField) = eval(cmd);
            end
        catch Me
        end
    end
end