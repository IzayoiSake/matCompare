function [dataName, dataClass, dataValue, dataType] = matDataInfo(matData)

    matDataName = fieldnames(matData);
    dataLength = length(matDataName);
    dataName = cell(dataLength, 1);
    dataClass = cell(dataLength, 1);
    dataValue = cell(dataLength, 1);
    dataType = cell(dataLength, 1);

    for i = 1:dataLength
        dataName{i} = matDataName{i};
    end
    for i = 1:dataLength
        thisName = matDataName{i};
        % 获取参数的Class
        dataClass{i} = class(matData.(thisName));
    end
    for i = 1:dataLength
        thisName = matDataName{i};
        % 获取参数的数值(如果存在的话)
        if isnumeric(matData.(thisName))
            dataValue{i} = matData.(thisName);
            dataValue{i} = num2str(dataValue{i});
        else
            try
                fileds = fieldnames(matData.(thisName));
                if ismember('Value', fileds)
                    dataValue{i} = matData.(thisName).Value;
                    dataValue{i} = num2str(dataValue{i});
                else
                    dataValue{i} = 'N/A';
                end
            catch
                dataValue{i} = 'N/A';
            end
        end
    end
    for i = 1:dataLength
        thisName = matDataName{i};
        % 获取参数的数据类型
        if isnumeric(matData.(thisName))
            dataType{i} = dataClass{i};
        else
            try
                fileds = fieldnames(matData.(thisName));
                if ismember('DataType', fileds)
                    dataType{i} = matData.(thisName).DataType;
                else
                    dataType{i} = 'N/A';
                end
            catch
                dataType{i} = 'N/A';
            end
        end
    end
end


    