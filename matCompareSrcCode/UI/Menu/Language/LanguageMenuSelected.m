function LanguageMenuSelected(app, event, language)
    % 获取当前选中的语言
    if ~isa(language, 'LanguageEnum')
        language = LanguageEnum(language);
    end
    % 设置当前语言
    UIText.language(language);
    % 更新界面文本
    UpdateText(app);
end