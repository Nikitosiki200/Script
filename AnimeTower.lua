local player = game:GetService("Players").LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local rootPart = character:WaitForChild("HumanoidRootPart")

local targetPosition = Vector3.new(-41, 364, 878)
local teleportDelay = 60 -- секунд
local autoTeleportEnabled = true
local remainingTime = teleportDelay
local isTeleporting = false

-- Создаем GUI
local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local TextLabel = Instance.new("TextLabel")
local TimeLabel = Instance.new("TextLabel")
local TeleportButton = Instance.new("TextButton")
local ToggleButton = Instance.new("TextButton")

ScreenGui.Name = "TeleportTimerGUI"
ScreenGui.Parent = game:GetService("CoreGui") or player:WaitForChild("PlayerGui")

Frame.Name = "MainFrame"
Frame.Parent = ScreenGui
Frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Frame.BorderSizePixel = 0
Frame.Position = UDim2.new(0.5, -100, 0, 10)
Frame.Size = UDim2.new(0, 200, 0, 120)
Frame.Active = true
Frame.Draggable = true

TextLabel.Name = "Title"
TextLabel.Parent = Frame
TextLabel.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
TextLabel.BorderSizePixel = 0
TextLabel.Position = UDim2.new(0, 0, 0, 0)
TextLabel.Size = UDim2.new(1, 0, 0, 30)
TextLabel.Font = Enum.Font.SourceSansBold
TextLabel.Text = "Авто-телепорт"
TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TextLabel.TextSize = 18

TimeLabel.Name = "Timer"
TimeLabel.Parent = Frame
TimeLabel.BackgroundTransparency = 1
TimeLabel.Position = UDim2.new(0, 0, 0, 30)
TimeLabel.Size = UDim2.new(1, 0, 0, 30)
TimeLabel.Font = Enum.Font.SourceSansBold
TimeLabel.Text = "До телепортации: "..remainingTime.." сек"
TimeLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TimeLabel.TextSize = 20

TeleportButton.Name = "TeleportBtn"
TeleportButton.Parent = Frame
TeleportButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
TeleportButton.BorderSizePixel = 0
TeleportButton.Position = UDim2.new(0.05, 0, 0.5, 0)
TeleportButton.Size = UDim2.new(0.9, 0, 0, 30)
TeleportButton.Font = Enum.Font.SourceSansBold
TeleportButton.Text = "Телепортироваться"
TeleportButton.TextColor3 = Color3.fromRGB(200, 200, 200)
TeleportButton.TextSize = 16
TeleportButton.AutoButtonColor = true

ToggleButton.Name = "ToggleBtn"
ToggleButton.Parent = Frame
ToggleButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
ToggleButton.BorderSizePixel = 0
ToggleButton.Position = UDim2.new(0.05, 0, 0.8, 0)
ToggleButton.Size = UDim2.new(0.9, 0, 0, 30)
ToggleButton.Font = Enum.Font.SourceSansBold
ToggleButton.Text = "Авто-телепорт: ВКЛ"
ToggleButton.TextColor3 = Color3.fromRGB(50, 255, 50)
ToggleButton.TextSize = 16
ToggleButton.AutoButtonColor = true

-- Функция для обновления таймера
local function updateTimer(seconds)
    remainingTime = seconds
    TimeLabel.Text = "До телепортации: "..seconds.." сек"
    
    -- Меняем цвет в зависимости от оставшегося времени
    if seconds < 10 then
        TimeLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
    else
        TimeLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    end
    
    -- Обновляем состояние кнопки телепортации
    if remainingTime == 0 and not isTeleporting then
        TeleportButton.BackgroundColor3 = Color3.fromRGB(30, 120, 30)
        TeleportButton.Text = "ТЕЛЕПОРТИРОВАТЬСЯ!"
        TeleportButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    else
        TeleportButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        TeleportButton.Text = "Телепортироваться"
        TeleportButton.TextColor3 = Color3.fromRGB(200, 200, 200)
    end
end

-- Функция телепортации
local function performTeleport()
    if character and character:FindFirstChild("HumanoidRootPart") then
        isTeleporting = true
        rootPart.CFrame = CFrame.new(targetPosition)
        print("Телепортирован на позицию:", targetPosition)
        remainingTime = teleportDelay
        updateTimer(remainingTime)
        isTeleporting = false
    else
        -- Переподключение если персонаж умер
        character = player.CharacterAdded:Wait()
        rootPart = character:WaitForChild("HumanoidRootPart")
    end
end

-- Обработчики кнопок
TeleportButton.MouseButton1Click:Connect(function()
    if remainingTime == 0 and not isTeleporting then
        performTeleport()
    end
end)

ToggleButton.MouseButton1Click:Connect(function()
    autoTeleportEnabled = not autoTeleportEnabled
    ToggleButton.Text = "Авто-телепорт: "..(autoTeleportEnabled and "ВКЛ" or "ВЫКЛ")
    ToggleButton.TextColor3 = autoTeleportEnabled and Color3.fromRGB(50, 255, 50) or Color3.fromRGB(255, 50, 50)
end)

-- Независимый таймер
spawn(function()
    while true do
        if remainingTime > 0 then
            updateTimer(remainingTime - 1)
        elseif autoTeleportEnabled and not isTeleporting then
            performTeleport()
        end
        wait(1)
    end
end)

-- Обработчик смены персонажа
player.CharacterAdded:Connect(function(newChar)
    character = newChar
    rootPart = character:WaitForChild("HumanoidRootPart")
end)
