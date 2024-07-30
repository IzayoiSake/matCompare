function closeFunc(app, event)

    try
        % 删除临时文件, 即使没有也不报警告
        if exist(app.UserData.Temp.tempLeftFile, 'file')
            delete(app.UserData.Temp.tempLeftFile);
        end
        if exist(app.UserData.Temp.tempRightFile, 'file')
            delete(app.UserData.Temp.tempRightFile);
        end
    catch
    end
    clear UIText;
end