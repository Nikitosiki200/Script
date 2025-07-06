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
            Border = Color3.fromRGB(60, 60, 70),
            Slider = Color3.fromRGB(80, 80, 90),
            SliderFill = Color3.fromRGB(0, 150, 255),
            TextBox = Color3.fromRGB(40, 40, 50),
            ToggleOff = Color3.fromRGB(80, 80, 90),
            ToggleOn = Color3.fromRGB(0, 200, 100)
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
        Size = Vector2.new(350, 450),
        Position = Vector2.new(100, 100),
        MobileToggle = nil,
        NextElementY = 40
    }
    
    -- Проверка и установка темы
    if not self.Themes[window.CurrentTheme] then
        window.CurrentTheme = "Dark"
        warn("Тема не найдена, используется тема Dark по умолчанию")
    end
    
    local theme = self.Themes[window.CurrentTheme] or self.Themes.Dark
    
    -- Создание элементов окна
    window.Elements.Background = CreateRoundedSquare()
    window.Elements.Background.Visible = window.Visible
    window.Elements.Background.Color = theme.Background
    window.Elements.Background.Size = window.Size
    window.Elements.Background.Position = window.Position
    
    window.Elements.Header = CreateRoundedSquare()
    window.Elements.Header.Visible = window.Visible
    window.Elements.Header.Color = theme.Header
    window.Elements.Header.Size = Vector2.new(window.Size.X, 30)
    window.Elements.Header.Position = window.Position
    
    window.Elements.Title = CreateText()
    window.Elements.Title.Visible = window.Visible
    window.Elements.Title.Text = title
    window.Elements.Title.Color = theme.TextColor
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
        window.MobileToggle.Elements.Background.Color = theme.Accent
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
                    window:SetVisible(not window.Visible)
                end
            end
        end)
        
        game:GetService("UserInputService").InputChanged:Connect(function(input)
            if toggleDrag and input.UserInputType == Enum.UserInputType.Touch then
                local delta = input.Position - dragStart
                window.MobileToggle.Position = window.MobileToggle.Position + delta
                dragStart = input.Position
                
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
    
    -- Обработка ввода
    local userInput = game:GetService("UserInputService")
    
    -- Методы окна
    function window:UpdatePositions()
        if not self.Elements or not self.Elements.Background then return end
        
        self.Elements.Background.Position = self.Position
        self.Elements.Header.Position = self.Position
        self.Elements.Title.Position = self.Position + Vector2.new(10, 5)
        
        if not self.IsMobile and self.Elements.CloseButton then
            self.Elements.CloseButton.Position = self.Position + Vector2.new(self.Size.X - 25, 5)
            if self.Elements.CloseText then
                self.Elements.CloseText.Position = self.Elements.CloseButton.Position + Vector2.new(6, 1)
            end
        end
        
        -- Обновляем позиции всех элементов вкладок
        for _, tab in ipairs(self.Tabs) do
            if tab and tab.UpdateElements then
                tab:UpdateElements()
            end
        end
    end
    
    function window:CreateTab(name)
        local tab = {
            Name = name,
            Buttons = {},
            Sliders = {},
            TextBoxes = {},
            Toggles = {},
            ParentWindow = self,
            Elements = {},
            NextElementY = 40
        }
        
        -- Текст вкладки
        tab.Elements.Text = CreateText()
        tab.Elements.Text.Visible = self.Visible
        tab.Elements.Text.Text = name
        tab.Elements.Text.Color = theme.TextColor
        tab.Elements.Text.Size = 16
        tab.Elements.Text.Position = Vector2.new(self.Position.X + 10 + ((#self.Tabs) * 70), self.Position.Y + 35)
        
        -- Методы вкладки
        function tab:UpdateElements()
            if not self.ParentWindow or not self.ParentWindow.Position then return end
            
            local currentY = self.ParentWindow.Position.Y + 40
            
            -- Обновляем кнопки
            for _, button in ipairs(self.Buttons) do
                if button and button.Elements and button.Elements.Background then
                    button.Elements.Background.Position = Vector2.new(self.ParentWindow.Position.X + 10, currentY)
                    if button.Elements.Text then
                        button.Elements.Text.Position = button.Elements.Background.Position + Vector2.new(10, 5)
                    end
                    currentY = currentY + 40
                end
            end
            
            -- Обновляем слайдеры
            for _, slider in ipairs(self.Sliders) do
                if slider and slider.Elements and slider.Elements.Background then
                    slider.Elements.Background.Position = Vector2.new(self.ParentWindow.Position.X + 10, currentY)
                    if slider.Elements.Fill then
                        slider.Elements.Fill.Position = slider.Elements.Background.Position
                        slider.Elements.Fill.Size = Vector2.new(
                            (slider.Value - slider.Min) / (slider.Max - slider.Min) * slider.Elements.Background.Size.X,
                            slider.Elements.Background.Size.Y
                        )
                    end
                    if slider.Elements.Text then
                        slider.Elements.Text.Position = Vector2.new(slider.Elements.Background.Position.X, currentY - 20)
                    end
                    if slider.Elements.ValueText then
                        slider.Elements.ValueText.Position = Vector2.new(
                            slider.Elements.Background.Position.X + slider.Elements.Background.Size.X - 30, 
                            currentY + 5
                        )
                        slider.Elements.ValueText.Text = tostring(slider.Value)
                    end
                    currentY = currentY + 60
                end
            end
            
            -- Обновляем текстовые поля
            for _, textbox in ipairs(self.TextBoxes) do
                if textbox and textbox.Elements and textbox.Elements.Background then
                    textbox.Elements.Background.Position = Vector2.new(self.ParentWindow.Position.X + 10, currentY)
                    if textbox.Elements.Text then
                        textbox.Elements.Text.Position = textbox.Elements.Background.Position + Vector2.new(10, 5)
                        textbox.Elements.Text.Text = textbox.Text == "" and textbox.Placeholder or textbox.Text
                        textbox.Elements.Text.Color = textbox.Text == "" and Color3.fromRGB(150, 150, 150) or theme.TextColor
                    end
                    currentY = currentY + 40
                end
            end
            
            -- Обновляем переключатели
            for _, toggle in ipairs(self.Toggles) do
                if toggle and toggle.Elements and toggle.Elements.Background then
                    toggle.Elements.Background.Position = Vector2.new(self.ParentWindow.Position.X + 10, currentY)
                    if toggle.Elements.Toggle then
                        toggle.Elements.Toggle.Position = Vector2.new(
                            self.ParentWindow.Position.X + self.ParentWindow.Size.X - 40, 
                            currentY + 5
                        )
                        toggle.Elements.Toggle.Color = toggle.Value and theme.ToggleOn or theme.ToggleOff
                    end
                    if toggle.Elements.Text then
                        toggle.Elements.Text.Position = Vector2.new(self.ParentWindow.Position.X + 15, currentY + 5)
                    end
                    currentY = currentY + 40
                end
            end
        end
        
        function tab:CreateButton(text, callback)
            if not self.ParentWindow or not self.ParentWindow.Themes then return end
            
            local theme = self.ParentWindow.Themes[self.ParentWindow.CurrentTheme] or self.ParentWindow.Themes.Dark
            if not theme then return end
            
            local button = {
                Text = text,
                Callback = callback,
                ParentTab = self,
                Elements = {}
            }
            
            button.Elements.Background = CreateRoundedSquare()
            button.Elements.Background.Visible = self.ParentWindow.Visible
            button.Elements.Background.Color = theme.Button or Color3.fromRGB(50, 50, 60)
            button.Elements.Background.Size = Vector2.new(self.ParentWindow.Size.X - 20, 30)
            button.Elements.Background.Position = Vector2.new(self.ParentWindow.Position.X + 10, self.ParentWindow.Position.Y + self.NextElementY)
            
            button.Elements.Text = CreateText()
            button.Elements.Text.Visible = self.ParentWindow.Visible
            button.Elements.Text.Text = text
            button.Elements.Text.Color = theme.TextColor or Color3.fromRGB(255, 255, 255)
            button.Elements.Text.Size = 16
            button.Elements.Text.Position = button.Elements.Background.Position + Vector2.new(10, 5)
            
            -- Обработка кликов
            userInput.InputBegan:Connect(function(input)
                if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and self.ParentWindow.Visible then
                    local pos = input.Position
                    local btnPos = button.Elements.Background.Position
                    local btnSize = button.Elements.Background.Size
                    
                    if pos.X >= btnPos.X and pos.X <= btnPos.X + btnSize.X and
                       pos.Y >= btnPos.Y and pos.Y <= btnPos.Y + btnSize.Y then
                        button.Elements.Background.Color = theme.Accent or Color3.fromRGB(0, 150, 255)
                        task.wait(0.1)
                        button.Elements.Background.Color = theme.Button or Color3.fromRGB(50, 50, 60)
                        if callback then callback() end
                    end
                end
            end)
            
            self.NextElementY = self.NextElementY + 40
            table.insert(self.Buttons, button)
            return button
        end
        
        function tab:CreateSlider(text, min, max, defaultValue, callback)
            if not self.ParentWindow or not self.ParentWindow.Themes then return end
            
            local theme = self.ParentWindow.Themes[self.ParentWindow.CurrentTheme] or self.ParentWindow.Themes.Dark
            if not theme then return end
            
            local slider = {
                Text = text,
                Min = min,
                Max = max,
                Value = defaultValue or min,
                Callback = callback,
                ParentTab = self,
                Elements = {},
                Dragging = false
            }
            
            slider.Elements.Text = CreateText()
            slider.Elements.Text.Visible = self.ParentWindow.Visible
            slider.Elements.Text.Text = text
            slider.Elements.Text.Color = theme.TextColor
            slider.Elements.Text.Size = 16
            slider.Elements.Text.Position = Vector2.new(self.ParentWindow.Position.X + 10, self.ParentWindow.Position.Y + self.NextElementY)
            
            slider.Elements.Background = CreateRoundedSquare()
            slider.Elements.Background.Visible = self.ParentWindow.Visible
            slider.Elements.Background.Color = theme.Slider
            slider.Elements.Background.Size = Vector2.new(self.ParentWindow.Size.X - 40, 10)
            slider.Elements.Background.Position = Vector2.new(self.ParentWindow.Position.X + 10, self.ParentWindow.Position.Y + self.NextElementY + 25)
            
            slider.Elements.Fill = CreateRoundedSquare()
            slider.Elements.Fill.Visible = self.ParentWindow.Visible
            slider.Elements.Fill.Color = theme.SliderFill
            slider.Elements.Fill.Size = Vector2.new(
                ((slider.Value - slider.Min) / (slider.Max - slider.Min)) * slider.Elements.Background.Size.X,
                slider.Elements.Background.Size.Y
            )
            slider.Elements.Fill.Position = slider.Elements.Background.Position
            
            slider.Elements.ValueText = CreateText()
            slider.Elements.ValueText.Visible = self.ParentWindow.Visible
            slider.Elements.ValueText.Text = tostring(slider.Value)
            slider.Elements.ValueText.Color = theme.TextColor
            slider.Elements.ValueText.Size = 14
            slider.Elements.ValueText.Position = Vector2.new(slider.Elements.Background.Position.X + slider.Elements.Background.Size.X - 30, self.ParentWindow.Position.Y + self.NextElementY + 30)
            
            -- Обработка перетаскивания
            userInput.InputBegan:Connect(function(input)
                if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and self.ParentWindow.Visible then
                    local pos = input.Position
                    local sliderPos = slider.Elements.Background.Position
                    local sliderSize = slider.Elements.Background.Size
                    
                    if pos.X >= sliderPos.X and pos.X <= sliderPos.X + sliderSize.X and
                       pos.Y >= sliderPos.Y and pos.Y <= sliderPos.Y + sliderSize.Y then
                        slider.Dragging = true
                        local percent = math.clamp((pos.X - sliderPos.X) / sliderSize.X, 0, 1)
                        slider.Value = math.floor(min + (max - min) * percent)
                        slider.Elements.ValueText.Text = tostring(slider.Value)
                        slider.Elements.Fill.Size = Vector2.new(sliderSize.X * percent, 10)
                        if callback then callback(slider.Value) end
                    end
                end
            end)
            
            userInput.InputChanged:Connect(function(input)
                if slider.Dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    local pos = input.Position
                    local sliderPos = slider.Elements.Background.Position
                    local sliderSize = slider.Elements.Background.Size
                    local percent = math.clamp((pos.X - sliderPos.X) / sliderSize.X, 0, 1)
                    slider.Value = math.floor(min + (max - min) * percent)
                    slider.Elements.ValueText.Text = tostring(slider.Value)
                    slider.Elements.Fill.Size = Vector2.new(sliderSize.X * percent, 10)
                    if callback then callback(slider.Value) end
                end
            end)
            
            userInput.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    slider.Dragging = false
                end
            end)
            
            self.NextElementY = self.NextElementY + 60
            table.insert(self.Sliders, slider)
            return slider
        end
        
        function tab:CreateTextBox(placeholder, callback)
            if not self.ParentWindow or not self.ParentWindow.Themes then return end
            
            local theme = self.ParentWindow.Themes[self.ParentWindow.CurrentTheme] or self.ParentWindow.Themes.Dark
            if not theme then return end
            
            local textbox = {
                Placeholder = placeholder,
                Text = "",
                Callback = callback,
                ParentTab = self,
                Elements = {},
                Focused = false
            }
            
            textbox.Elements.Background = CreateRoundedSquare()
            textbox.Elements.Background.Visible = self.ParentWindow.Visible
            textbox.Elements.Background.Color = theme.TextBox
            textbox.Elements.Background.Size = Vector2.new(self.ParentWindow.Size.X - 20, 30)
            textbox.Elements.Background.Position = Vector2.new(self.ParentWindow.Position.X + 10, self.ParentWindow.Position.Y + self.NextElementY)
            
            textbox.Elements.Text = CreateText()
            textbox.Elements.Text.Visible = self.ParentWindow.Visible
            textbox.Elements.Text.Text = placeholder
            textbox.Elements.Text.Color = Color3.fromRGB(150, 150, 150)
            textbox.Elements.Text.Size = 16
            textbox.Elements.Text.Position = textbox.Elements.Background.Position + Vector2.new(10, 5)
            
            -- Обработка кликов
            userInput.InputBegan:Connect(function(input)
                if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and self.ParentWindow.Visible then
                    local pos = input.Position
                    local boxPos = textbox.Elements.Background.Position
                    local boxSize = textbox.Elements.Background.Size
                    
                    if pos.X >= boxPos.X and pos.X <= boxPos.X + boxSize.X and
                       pos.Y >= boxPos.Y and pos.Y <= boxPos.Y + boxSize.Y then
                        textbox.Focused = true
                        textbox.Elements.Text.Text = textbox.Text
                        textbox.Elements.Text.Color = theme.TextColor
                    else
                        textbox.Focused = false
                        textbox.Elements.Text.Text = textbox.Text == "" and placeholder or textbox.Text
                        textbox.Elements.Text.Color = textbox.Text == "" and Color3.fromRGB(150, 150, 150) or theme.TextColor
                        if callback then callback(textbox.Text) end
                    end
                end
            end)
            
            -- Обработка ввода текста (для ПК)
            if not MyGuiLib.IsMobile then
                userInput.InputBegan:Connect(function(input)
                    if textbox.Focused and input.KeyCode == Enum.KeyCode.Return then
                        textbox.Focused = false
                        textbox.Elements.Text.Text = textbox.Text == "" and placeholder or textbox.Text
                        textbox.Elements.Text.Color = textbox.Text == "" and Color3.fromRGB(150, 150, 150) or theme.TextColor
                        if callback then callback(textbox.Text) end
                    elseif textbox.Focused and input.KeyCode == Enum.KeyCode.Backspace then
                        textbox.Text = textbox.Text:sub(1, -2)
                        textbox.Elements.Text.Text = textbox.Text
                    end
                end)
                
                userInput.TextBoxInput:Connect(function(input)
                    if textbox.Focused and input.KeyCode ~= Enum.KeyCode.Return then
                        textbox.Text = textbox.Text .. input.Text
                        textbox.Elements.Text.Text = textbox.Text
                    end
                end)
            end
            
            self.NextElementY = self.NextElementY + 40
            table.insert(self.TextBoxes, textbox)
            return textbox
        end
        
        function tab:CreateToggle(text, defaultValue, callback)
            if not self.ParentWindow or not self.ParentWindow.Themes then return end
            
            local theme = self.ParentWindow.Themes[self.ParentWindow.CurrentTheme] or self.ParentWindow.Themes.Dark
            if not theme then return end
            
            local toggle = {
                Text = text,
                Value = defaultValue or false,
                Callback = callback,
                ParentTab = self,
                Elements = {}
            }
            
            toggle.Elements.Background = CreateRoundedSquare()
            toggle.Elements.Background.Visible = self.ParentWindow.Visible
            toggle.Elements.Background.Color = theme.Button
            toggle.Elements.Background.Size = Vector2.new(self.ParentWindow.Size.X - 20, 30)
            toggle.Elements.Background.Position = Vector2.new(self.ParentWindow.Position.X + 10, self.ParentWindow.Position.Y + self.NextElementY)
            
            toggle.Elements.Text = CreateText()
            toggle.Elements.Text.Visible = self.ParentWindow.Visible
            toggle.Elements.Text.Text = text
            toggle.Elements.Text.Color = theme.TextColor
            toggle.Elements.Text.Size = 16
            toggle.Elements.Text.Position = Vector2.new(self.ParentWindow.Position.X + 15, self.ParentWindow.Position.Y + self.NextElementY + 5)
            
            toggle.Elements.Toggle = CreateRoundedSquare()
            toggle.Elements.Toggle.Visible = self.ParentWindow.Visible
            toggle.Elements.Toggle.Color = toggle.Value and theme.ToggleOn or theme.ToggleOff
            toggle.Elements.Toggle.Size = Vector2.new(20, 20)
            toggle.Elements.Toggle.Position = Vector2.new(self.ParentWindow.Position.X + self.ParentWindow.Size.X - 40, self.ParentWindow.Position.Y + self.NextElementY + 5)
            
            -- Обработка кликов
            userInput.InputBegan:Connect(function(input)
                if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and self.ParentWindow.Visible then
                    local pos = input.Position
                    local togglePos = toggle.Elements.Background.Position
                    local toggleSize = toggle.Elements.Background.Size
                    
                    if pos.X >= togglePos.X and pos.X <= togglePos.X + toggleSize.X and
                       pos.Y >= togglePos.Y and pos.Y <= togglePos.Y + toggleSize.Y then
                        toggle.Value = not toggle.Value
                        toggle.Elements.Toggle.Color = toggle.Value and theme.ToggleOn or theme.ToggleOff
                        if callback then callback(toggle.Value) end
                    end
                end
            end)
            
            self.NextElementY = self.NextElementY + 40
            table.insert(self.Toggles, toggle)
            return toggle
        end
        
        table.insert(self.Tabs, tab)
        return tab
    end
    
    function window:SetVisible(state)
        self.Visible = state
        
        -- Обновляем видимость элементов окна
        for _, element in pairs(self.Elements) do
            if element then element.Visible = state end
        end
        
        -- Обновляем видимость элементов вкладок
        for _, tab in ipairs(self.Tabs) do
            if not tab then continue end
            
            -- Обновляем элементы вкладки
            for _, element in pairs(tab.Elements) do
                if element then element.Visible = state end
            end
            
            -- Обновляем кнопки
            for _, button in ipairs(tab.Buttons) do
                if not button or not button.Elements then continue end
                for _, element in pairs(button.Elements) do
                    if element then element.Visible = state end
                end
            end
            
            -- Обновляем слайдеры
            for _, slider in ipairs(tab.Sliders) do
                if not slider or not slider.Elements then continue end
                for _, element in pairs(slider.Elements) do
                    if element then element.Visible = state end
                end
            end
            
            -- Обновляем текстовые поля
            for _, textbox in ipairs(tab.TextBoxes) do
                if not textbox or not textbox.Elements then continue end
                for _, element in pairs(textbox.Elements) do
                    if element then element.Visible = state end
                end
            end
            
            -- Обновляем переключатели
            for _, toggle in ipairs(tab.Toggles) do
                if not toggle or not toggle.Elements then continue end
                for _, element in pairs(toggle.Elements) do
                    if element then element.Visible = state end
                end
            end
        end
        
        -- Мобильная кнопка всегда видима
        if self.MobileToggle then
            for _, element in pairs(self.MobileToggle.Elements) do
                if element then element.Visible = true end
            end
        end
    end
    
    -- Обработка перемещения окна
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
    
    table.insert(self.Windows, window)
    return window
end

return MyGuiLib
