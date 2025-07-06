local MyGuiLib = {
    Windows = {},
    Themes = {
        Dark = {
            Background = Color3.fromRGB(30, 30, 30),
            TextColor = Color3.fromRGB(255, 255, 255),
            Accent = Color3.fromRGB(0, 120, 215),
            Button = Color3.fromRGB(60, 60, 60),
            ButtonHover = Color3.fromRGB(80, 80, 80)
        }
    }
}

-- Основные функции библиотеки
function MyGuiLib:CreateWindow(title, options)
    options = options or {}
    local window = {
        Title = title,
        Tabs = {},
        CurrentTheme = options.Theme or "Dark",
        Elements = {}, -- Для хранения Drawing объектов
        Visible = true
    }
    
    -- Создаем фон окна
    window.Elements.Background = Drawing.new("Square")
    window.Elements.Background.Visible = window.Visible
    window.Elements.Background.Filled = true
    window.Elements.Background.Color = self.Themes[window.CurrentTheme].Background
    window.Elements.Background.Size = Vector2.new(300, 400)
    window.Elements.Background.Position = Vector2.new(100, 100)
    
    -- Заголовок окна
    window.Elements.Title = Drawing.new("Text")
    window.Elements.Title.Visible = window.Visible
    window.Elements.Title.Text = title
    window.Elements.Title.Color = self.Themes[window.CurrentTheme].TextColor
    window.Elements.Title.Size = 18
    window.Elements.Title.Position = Vector2.new(110, 110)
    
    -- Методы окна
    function window:CreateTab(name)
        local tab = {
            Name = name,
            Buttons = {},
            ParentWindow = self,
            Elements = {} -- Добавляем таблицу для элементов вкладки
        }
        
        -- Создаем текст вкладки
        tab.Elements.Text = Drawing.new("Text")
        tab.Elements.Text.Visible = self.Visible
        tab.Elements.Text.Text = name
        tab.Elements.Text.Color = MyGuiLib.Themes[self.CurrentTheme].TextColor
        tab.Elements.Text.Size = 16
        tab.Elements.Text.Position = Vector2.new(110, 140 + (#self.Tabs * 20))
        
        -- Методы вкладки
        function tab:CreateButton(text, callback)
            local button = {
                Text = text,
                Callback = callback,
                ParentTab = self,
                Elements = {}
            }
            
            -- Создаем визуал кнопки
            button.Elements.Background = Drawing.new("Square")
            button.Elements.Background.Visible = self.ParentWindow.Visible
            button.Elements.Background.Filled = true
            button.Elements.Background.Color = MyGuiLib.Themes[self.ParentWindow.CurrentTheme].Button
            button.Elements.Background.Size = Vector2.new(150, 30)
            
            -- Позиционируем кнопку относительно других элементов
            local yPos = 150 + (#self.Buttons * 40)
            button.Elements.Background.Position = Vector2.new(110, yPos)
            
            button.Elements.Text = Drawing.new("Text")
            button.Elements.Text.Visible = self.ParentWindow.Visible
            button.Elements.Text.Text = text
            button.Elements.Text.Color = MyGuiLib.Themes[self.ParentWindow.CurrentTheme].TextColor
            button.Elements.Text.Size = 16
            button.Elements.Text.Position = Vector2.new(115, yPos + 5)
            
            -- Обработка кликов
            local userInput = game:GetService("UserInputService")
            userInput.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    local mouse = userInput:GetMouseLocation()
                    local btnPos = button.Elements.Background.Position
                    local btnSize = button.Elements.Background.Size
                    
                    if mouse.X >= btnPos.X and mouse.X <= btnPos.X + btnSize.X and
                       mouse.Y >= btnPos.Y and mouse.Y <= btnPos.Y + btnSize.Y then
                        callback()
                    end
                end
            end)
            
            -- Анимация наведения
            local connection
            connection = game:GetService("RunService").RenderStepped:Connect(function()
                if not button.Elements.Background then 
                    connection:Disconnect()
                    return
                end
                
                local mouse = userInput:GetMouseLocation()
                local btnPos = button.Elements.Background.Position
                local btnSize = button.Elements.Background.Size
                local isHovering = mouse.X >= btnPos.X and mouse.X <= btnPos.X + btnSize.X and
                                  mouse.Y >= btnPos.Y and mouse.Y <= btnPos.Y + btnSize.Y
                
                if isHovering then
                    button.Elements.Background.Color = MyGuiLib.Themes[self.ParentWindow.CurrentTheme].ButtonHover
                else
                    button.Elements.Background.Color = MyGuiLib.Themes[self.ParentWindow.CurrentTheme].Button
                end
            end)
            
            table.insert(self.Buttons, button)
            return button
        end
        
        table.insert(self.Tabs, tab)
        return tab
    end
    
    function window:SetVisible(state)
        self.Visible = state
        for _, element in pairs(self.Elements) do
            if element then
                element.Visible = state
            end
        end
        for _, tab in ipairs(self.Tabs) do
            for _, element in pairs(tab.Elements) do
                if element then
                    element.Visible = state
                end
            end
            for _, button in ipairs(tab.Buttons) do
                for _, element in pairs(button.Elements) do
                    if element then
                        element.Visible = state
                    end
                end
            end
        end
    end
    
    table.insert(self.Windows, window)
    return window
end

-- Дополнительные функции библиотеки
function MyGuiLib:SetTheme(themeName)
    for _, window in ipairs(self.Windows) do
        window.CurrentTheme = themeName
        -- Обновляем цвета всех элементов
        for _, element in pairs(window.Elements) do
            if element then
                if element.Color then
                    element.Color = self.Themes[themeName].Background
                end
            end
        end
        -- Дополнительные обновления цветов для других элементов
    end
end

return MyGuiLib
