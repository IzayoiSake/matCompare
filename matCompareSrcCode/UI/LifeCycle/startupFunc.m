function startupFunc(app)
    app.State = StateEnum.StartUp;
    app.UserData.Temp.tempLeftFile = tempname;
    app.UserData.Temp.tempRightFile = tempname;
end