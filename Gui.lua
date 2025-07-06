local MyGuiLib = {
    Windows = {},
    Themes = {
        Dark = {
            Background = Color3.fromRGB(30, 30, 40),
            Header = Color3.fromRGB(25, 25, 35),
            TextColor = Color3.fromRGB(255, 255, 255),
            Accent = Color3.fromRGB(0, 150, 255),
            Button = Color3.fromRGB(50, 50, 60),
            ButtonHover = Color3.fromRGB(70, 70, 80),
            Border = Color3.fromRGB(60, 60, 70)
        }
    },
    IsMobile = (table.find({Enum.Platform.IOS, Enum.Platform.Android}, game:GetService("UserInputService"):GetPlatform()) ~= nil)
}

-- Вспомогательные функции
local function CreateRoundedSquare()
    local square = Drawing.new("Square")
    square.Thickness = 1
    square.Filled = true
    return square
end

local function CreateText()
    local text = Drawing.new("Text")
    text.Center = false
    text.Outline = true
    text.OutlineColor = Color3.new(0, 0, 0)
    return text
end

-- Основные функции библиотеки
function MyGuiLib:CreateWindow(title, options)
    options = options or {}
    local window = {
        Title = title,
        Tabs = {},
        CurrentTheme = options.Theme or "Dark",
        Elements = {},
        Visible = true,
        Dragging = false,
        DragOffset = Vector2.new(0, 0),
        TabHeight = 30,
        TabPadding = 5,
        MobileToggle = nil
    }
    
    -- Размеры и позиция окна
    window.Size = Vector2.new(300, 400)
    window.Position = Vector2.new(100, 100)
    
    -- Создаем фон окна с закругленными углами
    window.Elements.Background = CreateRoundedSquare()
    window.Elements.Background.Visible = window.Visible
    window.Elements.Background.Color = self.Themes[window.CurrentTheme].Background
    window.Elements.Background.Size = window.Size
    window.Elements.Background.Position = window.Position
    
    -- Заголовок окна
    window.Elements.Header = CreateRoundedSquare()
    window.Elements.Header.Visible = window.Visible
    window.Elements.Header.Color = self.Themes[window.CurrentTheme].Header
    window.Elements.Header.Size = Vector2.new(window.Size.X, 30)
    window.Elements.Header.Position = window.Position
    
    -- Текст заголовка
    window.Elements.Title = CreateText()
    window.Elements.Title.Visible = window.Visible
    window.Elements.Title.Text = title
    window.Elements.Title.Color = self.Themes[window.CurrentTheme].TextColor
    window.Elements.Title.Size = 18
    window.Elements.Title.Position = window.Position + Vector2.new(10, 5)
    
    -- Кнопка закрытия (только для ПК)
    if not self.IsMobile then
        window.Elements.CloseButton = CreateRoundedSquare()
        window.Elements.CloseButton.Visible = window.Visible
        window.Elements.CloseButton.Color = Color3.fromRGB(200, 50, 50)
        window.Elements.CloseButton.Size = Vector2.new(20, 20)
        window.Elements.CloseButton.Position = window.Position + Vector2.new(window.Size.X - 25, 5)
        
        window.Elements.CloseText = CreateText()
        window.Elements.CloseText.Visible = window.Visible
        window.Elements.CloseText.Text = "X"
        window.Elements.CloseText.Color = Color3.new(1, 1, 1)
        window.Elements.CloseText.Size = 16
        window.Elements.CloseText.Position = window.Elements.CloseButton.Position + Vector2.new(6, 1)
    end
    
    -- Для мобильных устройств - кнопка переключения
    if self.IsMobile then
        window.MobileToggle = {
            Elements = {},
            Position = Vector2.new(20, 20),
            Size = Vector2.new(50, 50)
        }
        
        window.MobileToggle.Elements.Background = CreateRoundedSquare()
        window.MobileToggle.Elements.Background.Visible = true
        window.MobileToggle.Elements.Background.Color = self.Themes[window.CurrentTheme].Accent
        window.MobileToggle.Elements.Background.Size = window.MobileToggle.Size
        window.MobileToggle.Elements.Background.Position = window.MobileToggle.Position
        
        window.MobileToggle.Elements.Text = CreateText()
        window.MobileToggle.Elements.Text.Visible = true
        window.MobileToggle.Elements.Text.Text = "GUI"
        window.MobileToggle.Elements.Text.Color = Color3.new(1, 1, 1)
        window.MobileToggle.Elements.Text.Size = 16
        window.MobileToggle.Elements.Text.Position = window.MobileToggle.Position + Vector2.new(15, 15)
        
        -- Обработка перемещения кнопки
        local dragStart, toggleDrag = nil, false
        game:GetService("UserInputService").InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Touch then
                local pos = input.Position
                local togglePos = window.MobileToggle.Position
                local toggleSize = window.MobileToggle.Size
                
                if pos.X >= togglePos.X and pos.X <= togglePos.X + toggleSize.X and
                   pos.Y >= togglePos.Y and pos.Y <= togglePos.Y + toggleSize.Y then
                    toggleDrag = true
                    dragStart = pos
                end
            end
        end)
        
        game:GetService("UserInputService").InputChanged:Connect(function(input)
            if toggleDrag and input.UserInputType == Enum.UserInputType.Touch then
                local delta = input.Position - dragStart
                window.MobileToggle.Position = window.MobileToggle.Position + delta
                dragStart = input.Position
                
                -- Обновляем позицию элементов
                window.MobileToggle.Elements.Background.Position = window.MobileToggle.Position
                window.MobileToggle.Elements.Text.Position = window.MobileToggle.Position + Vector2.new(15, 15)
            end
        end)
        
        game:GetService("UserInputService").InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Touch then
                toggleDrag = false
            end
        end)
    end
    
    -- Обработка перемещения окна
    local userInput = game:GetService("UserInputService")
    userInput.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            local pos = input.Position
            local headerPos = window.Position
            local headerSize = Vector2.new(window.Size.X, 30)
            
            if pos.X >= headerPos.X and pos.X <= headerPos.X + headerSize.X and
               pos.Y >= headerPos.Y and pos.Y <= headerPos.Y + headerSize.Y then
                window.Dragging = true
                window.DragOffset = pos - headerPos
            end
            
            -- Обработка клика по кнопке закрытия
            if not self.IsMobile and window.Elements.CloseButton then
                local closePos = window.Elements.CloseButton.Position
                local closeSize = window.Elements.CloseButton.Size
                
                if pos.X >= closePos.X and pos.X <= closePos.X + closeSize.X and
                   pos.Y >= closePos.Y and pos.Y <= closePos.Y + closeSize.Y then
                    window:SetVisible(false)
                end
            end
            
            -- Обработка клика по мобильной кнопке
            if self.IsMobile and window.MobileToggle then
                local togglePos = window.MobileToggle.Position
                local toggleSize = window.MobileToggle.Size
                
                if pos.X >= togglePos.X and pos.X <= togglePos.X + toggleSize.X and
                   pos.Y >= togglePos.Y and pos.Y <= togglePos.Y + toggleSize.Y then
                    window:SetVisible(not window.Visible)
                end
            end
        end
        
        -- Горячая клавиша Ctrl для ПК
        if not self.IsMobile and input.KeyCode == Enum.KeyCode.LeftControl then
            window:SetVisible(not window.Visible)
        end
    end)
    
    userInput.InputChanged:Connect(function(input)
        if window.Dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            window.Position = input.Position - window.DragOffset
            window:UpdatePositions()
        end
    end)
    
    userInput.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            window.Dragging = false
        end
    end)
    
    -- Методы окна
    function window:UpdatePositions()
        -- Обновляем позиции всех элементов
        self.Elements.Background.Position = self.Position
        self.Elements.Header.Position = self.Position
        self.Elements.Title.Position = self.Position + Vector2.new(10, 5)
        
        if not self.IsMobile and self.Elements.CloseButton then
            self.Elements.CloseButton.Position = self.Position + Vector2.new(self.Size.X - 25, 5)
            self.Elements.CloseText.Position = self.Elements.CloseButton.Position + Vector2.new(6, 1)
        end
        
        -- Обновляем позиции вкладок и их элементов
        local tabY = self.Position.Y + 35
        for i, tab in ipairs(self.Tabs) do
            if tab.Elements and tab.Elements.Text then
                tab.Elements.Text.Position = Vector2.new(self.Position.X + 10 + ((i-1) * 70), self.Position.Y + 35)
            end
            
            -- Обновляем позиции кнопок
            local buttonY = tabY + 10
            for _, button in ipairs(tab.Buttons) do
                if button.Elements and button.Elements.Background then
                    button.Elements.Background.Position = Vector2.new(self.Position.X + 10, buttonY)
                    button.Elements.Text.Position = button.Elements.Background.Position + Vector2.new(10, 5)
                    buttonY = buttonY + 40
                end
            end
        end
    end
    
    function window:CreateTab(name)
        local tab = {
            Name = name,
            Buttons = {},
            ParentWindow = self,
            Elements = {},
            ButtonYOffset = 40
        }
        
        -- Текст вкладки
        tab.Elements.Text = CreateText()
        tab.Elements.Text.Visible = self.Visible
        tab.Elements.Text.Text = name
        tab.Elements.Text.Color = self.Themes[self.CurrentTheme].TextColor
        tab.Elements.Text.Size = 16
        tab.Elements.Text.Position = Vector2.new(self.Position.X + 10 + ((#self.Tabs) * 70), self.Position.Y + 35)
        
        -- Методы вкладки
        function tab:CreateButton(text, callback)
            local button = {
                Text = text,
                Callback = callback,
                ParentTab = self,
                Elements = {}
            }
            
            -- Фон кнопки
            button.Elements.Background = CreateRoundedSquare()
            button.Elements.Background.Visible = self.ParentWindow.Visible
            button.Elements.Background.Color = self.Themes[self.ParentWindow.CurrentTheme].Button
            button.Elements.Background.Size = Vector2.new(self.ParentWindow.Size.X - 20, 30)
            
            -- Позиционируем кнопку
            button.Elements.Background.Position = Vector2.new(self.ParentWindow.Position.X + 10, 
                self.ParentWindow.Position.Y + 60 + (#self.Buttons * 40))
            
            -- Текст кнопки
            button.Elements.Text = CreateText()
            button.Elements.Text.Visible = self.ParentWindow.Visible
            button.Elements.Text.Text = text
            button.Elements.Text.Color = self.Themes[self.ParentWindow.CurrentTheme].TextColor
            button.Elements.Text.Size = 16
            button.Elements.Text.Position = button.Elements.Background.Position + Vector2.new(10, 5)
            
            -- Граница кнопки
            button.Elements.Border = CreateRoundedSquare()
            button.Elements.Border.Visible = self.ParentWindow.Visible
            button.Elements.Border.Color = self.Themes[self.ParentWindow.CurrentTheme].Border
            button.Elements.Border.Filled = false
            button.Elements.Border.Size = button.Elements.Background.Size
            button.Elements.Border.Position = button.Elements.Background.Position
            
            -- Обработка кликов
            userInput.InputBegan:Connect(function(input)
                if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and self.ParentWindow.Visible then
                    local pos = input.Position
                    local btnPos = button.Elements.Background.Position
                    local btnSize = button.Elements.Background.Size
                    
                    if pos.X >= btnPos.X and pos.X <= btnPos.X + btnSize.X and
                       pos.Y >= btnPos.Y and pos.Y <= btnPos.Y + btnSize.Y then
                        -- Анимация нажатия
                        button.Elements.Background.Color = self.Themes[self.ParentWindow.CurrentTheme].Accent
                        task.wait(0.1)
                        button.Elements.Background.Color = self.Themes[self.ParentWindow.CurrentTheme].Button
                        
                        callback()
                    end
                end
            end)
            
            -- Анимация наведения (только для ПК)
            if not MyGuiLib.IsMobile then
                local connection
                connection = game:GetService("RunService").RenderStepped:Connect(function()
                    if not button.Elements.Background or not self.ParentWindow.Visible then 
                        connection:Disconnect()
                        return
                    end
                    
                    local mouse = userInput:GetMouseLocation()
                    local btnPos = button.Elements.Background.Position
                    local btnSize = button.Elements.Background.Size
                    local isHovering = mouse.X >= btnPos.X and mouse.X <= btnPos.X + btnSize.X and
                                      mouse.Y >= btnPos.Y and mouse.Y <= btnPos.Y + btnSize.Y
                    
                    if isHovering then
                        button.Elements.Background.Color = self.Themes[self.ParentWindow.CurrentTheme].ButtonHover
                    else
                        button.Elements.Background.Color = self.Themes[self.ParentWindow.CurrentTheme].Button
                    end
                end)
            end
            
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

return MyGuiLib
