classdef UIText
    
    properties (Access = private)
    end

    methods
        function obj = UIText()
        end
    end

    % 静态方法
    methods (Access = public, Static)

        function languageOut = language(languageIn)
            persistent language;
            if isempty(language)
                language = LanguageEnum.Chinese;
            end
            languageOut = language;
            if ~nargin
                return;
            end
            if ~isa(languageIn,'LanguageEnum')
                return;
            else
                language = languageIn;
            end
            languageOut = language;
        end

        function text = Text(Index)
            persistent textData;
            persistent indexNum;
            persistent indexStr;
            if isempty(textData)
                textData = readtable('TextData.xlsx');
                indexNum = textData.IndexNum;
                indexStr = textData.IndexStr;
            end
            languageStr = char(UIText.language);
            if (isa(Index, 'char') || isa(Index, 'string'))
                Index = find(strcmp(indexStr, Index));
            else
                Index = find(indexNum == Index);
            end
            text = textData.(languageStr){Index};
        end
    end
end