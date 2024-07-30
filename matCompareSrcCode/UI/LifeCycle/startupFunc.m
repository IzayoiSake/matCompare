function startupFunc(app)
    app.State = StateEnum.StartUp;
    app.UserData.Temp.tempLeftFile = tempname;
    app.UserData.Temp.tempRightFile = tempname;
    
    UIText.language(LanguageEnum.Chinese);
    InitialText(app);
    
end