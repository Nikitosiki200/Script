-- Полный скрипт Position Saver GUI для Roblox
local Player = game:GetService("Players").LocalPlayer
local UserInputService = game:GetService("UserInputService")

-- Создание основного GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "PositionSaverGUI"
ScreenGui.Parent = game:GetService("CoreGui")

-- Главное окно (перемещаемое)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 300, 0, 250)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -125)
MainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

-- Кнопка переключения GUI (перемещаемая)
local ToggleButton = Instance.new("TextButton")
ToggleButton.Name = "ToggleButton"
ToggleButton.Size = UDim2.new(0, 100, 0, 30)
ToggleButton.Position = UDim2.new(0, 10, 0, 10)
ToggleButton.Text = "Close GUI"
ToggleButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
ToggleButton.TextColor3 = Color3.new(1, 1, 1)
ToggleButton.Parent = ScreenGui

-- Вкладки
local Tabs = Instance.new("Frame")
Tabs.Name = "Tabs"
Tabs.Size = UDim2.new(1, 0, 0, 30)
Tabs.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Tabs.BorderSizePixel = 0
Tabs.Parent = MainFrame

-- Кнопки вкладок
local Tab1Button = Instance.new("TextButton")
Tab1Button.Name = "Tab1Button"
Tab1Button.Size = UDim2.new(0.5, 0, 1, 0)
Tab1Button.Position = UDim2.new(0, 0, 0, 0)
Tab1Button.Text = "Position Saver"
Tab1Button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Tab1Button.TextColor3 = Color3.new(1, 1, 1)
Tab1Button.Parent = Tabs

local Tab2Button = Instance.new("TextButton")
Tab2Button.Name = "Tab2Button"
Tab2Button.Size = UDim2.new(0.5, 0, 1, 0)
Tab2Button.Position = UDim2.new(0.5, 0, 0, 0)
Tab2Button.Text = "Saved Positions"
Tab2Button.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Tab2Button.TextColor3 = Color3.new(1, 1, 1)
Tab2Button.Parent = Tabs

-- Содержимое вкладок
local Tab1 = Instance.new("Frame")
Tab1.Name = "Tab1"
Tab1.Size = UDim2.new(1, 0, 1, -30)
Tab1.Position = UDim2.new(0, 0, 0, 30)
Tab1.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Tab1.Visible = true
Tab1.Parent = MainFrame

local Tab2 = Instance.new("Frame")
Tab2.Name = "Tab2"
Tab2.Size = UDim2.new(1, 0, 1, -30)
Tab2.Position = UDim2.new(0, 0, 0, 30)
Tab2.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Tab2.Visible = false
Tab2.Parent = MainFrame

-- Прокручиваемый фрейм для сохраненных позиций
local SavedPositionsScrolling = Instance.new("ScrollingFrame")
SavedPositionsScrolling.Name = "SavedPositionsScrolling"
SavedPositionsScrolling.Size = UDim2.new(1, -20, 1, -20)
SavedPositionsScrolling.Position = UDim2.new(0, 10, 0, 10)
SavedPositionsScrolling.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
SavedPositionsScrolling.AutomaticCanvasSize = Enum.AutomaticSize.Y
SavedPositionsScrolling.ScrollBarThickness = 5
SavedPositionsScrolling.Parent = Tab2

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = SavedPositionsScrolling
UIListLayout.Padding = UDim.new(0, 5)

-- Элементы первой вкладки
local SavePosButton = Instance.new("TextButton")
SavePosButton.Name = "SavePosButton"
SavePosButton.Size = UDim2.new(1, -20, 0, 40)
SavePosButton.Position = UDim2.new(0, 10, 0, 10)
SavePosButton.Text = "Save Position"
SavePosButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
SavePosButton.TextColor3 = Color3.new(1, 1, 1)
SavePosButton.Parent = Tab1

local TeleportToSavedButton = Instance.new("TextButton")
TeleportToSavedButton.Name = "TeleportToSavedButton"
TeleportToSavedButton.Size = UDim2.new(1, -20, 0, 40)
TeleportToSavedButton.Position = UDim2.new(0, 10, 0, 60)
TeleportToSavedButton.Text = "Teleport to Saved Position"
TeleportToSavedButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
TeleportToSavedButton.TextColor3 = Color3.new(1, 1, 1)
TeleportToSavedButton.Parent = Tab1

local NameTextBox = Instance.new("TextBox")
NameTextBox.Name = "NameTextBox"
NameTextBox.Size = UDim2.new(1, -20, 0, 30)
NameTextBox.Position = UDim2.new(0, 10, 0, 110)
NameTextBox.PlaceholderText = "Enter position name"
NameTextBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
NameTextBox.TextColor3 = Color3.new(1, 1, 1)
NameTextBox.Parent = Tab1

local SaveNamedButton = Instance.new("TextButton")
SaveNamedButton.Name = "SaveNamedButton"
SaveNamedButton.Size = UDim2.new(1, -20, 0, 40)
SaveNamedButton.Position = UDim2.new(0, 10, 0, 150)
SaveNamedButton.Text = "Save Position with Name"
SaveNamedButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
SaveNamedButton.TextColor3 = Color3.new(1, 1, 1)
SaveNamedButton.Parent = Tab1

-- Переменные
local LastSavedPosition = nil
local SavedPositions = {}

-- Функции
local function SavePosition()
    local character = Player.Character
    if character and character:FindFirstChild("HumanoidRootPart") then
        LastSavedPosition = character.HumanoidRootPart.CFrame
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Position Saved",
            Text = "Current position has been saved",
            Duration = 2
        })
    else
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Error",
            Text = "Character not found",
            Duration = 2
        })
    end
end

local function TeleportToSaved()
    if LastSavedPosition then
        local character = Player.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            character.HumanoidRootPart.CFrame = LastSavedPosition
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "Teleported",
                Text = "Teleported to saved position",
                Duration = 2
            })
        else
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "Error",
                Text = "Character not found",
                Duration = 2
            })
        end
    else
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Error",
            Text = "No position saved",
            Duration = 2
        })
    end
end

local function SaveNamedPosition()
    if not LastSavedPosition then
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Error",
            Text = "Save a position first",
            Duration = 2
        })
        return
    end
    
    local name = NameTextBox.Text
    if name == "" then
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Error",
            Text = "Enter a name",
            Duration = 2
        })
        return
    end
    
    SavedPositions[name] = LastSavedPosition
    
    -- Создание кнопки во второй вкладке
    local newButton = Instance.new("TextButton")
    newButton.Name = name
    newButton.Size = UDim2.new(1, -10, 0, 40)
    newButton.Text = name
    newButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    newButton.TextColor3 = Color3.new(1, 1, 1)
    
    newButton.MouseButton1Click:Connect(function()
        local character = Player.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            character.HumanoidRootPart.CFrame = SavedPositions[name]
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "Teleported",
                Text = "Teleported to "..name,
                Duration = 2
            })
        end
    end)
    
    newButton.Parent = SavedPositionsScrolling
    
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Saved",
        Text = "Position saved as "..name,
        Duration = 2
    })
    
    NameTextBox.Text = ""
end

-- Подключение событий
SavePosButton.MouseButton1Click:Connect(SavePosition)
TeleportToSavedButton.MouseButton1Click:Connect(TeleportToSaved)
SaveNamedButton.MouseButton1Click:Connect(SaveNamedPosition)

-- Переключение вкладок
Tab1Button.MouseButton1Click:Connect(function()
    Tab1.Visible = true
    Tab2.Visible = false
    Tab1Button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    Tab2Button.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
end)

Tab2Button.MouseButton1Click:Connect(function()
    Tab1.Visible = false
    Tab2.Visible = true
    Tab1Button.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Tab2Button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
end)

-- Функционал кнопки переключения GUI
local guiVisible = true
ToggleButton.MouseButton1Click:Connect(function()
    guiVisible = not guiVisible
    MainFrame.Visible = guiVisible
    ToggleButton.Text = guiVisible and "Close GUI" or "Open GUI"
end)

-- Механизм перемещения кнопки переключения
local dragging
local dragInput
local dragStart
local startPos

local function update(input)
    local delta = input.Position - dragStart
    ToggleButton.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

ToggleButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = ToggleButton.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

ToggleButton.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)
