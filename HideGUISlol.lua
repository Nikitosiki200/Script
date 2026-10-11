local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

local player = Players.LocalPlayer

local GUI_NAMES = {
    "RampSpawnerGUI",
    "BoostGUI",
    "WheelieGUI",
}

local LOCALE = {
    ru = {
        title = "GUI Manager",
        showAll = "Показать все",
        hideAll = "Скрыть все",
        toggleKey = "Клавиша:",
        status = "Управление окнами",
        notifTitle = "GUI Manager",
        notifText = "Все GUI скрыты. Нажми ещё раз чтобы показать.",
        langBtn = "EN",
    },
    en = {
        title = "GUI Manager",
        showAll = "Show all",
        hideAll = "Hide all",
        toggleKey = "Key:",
        status = "Window control",
        notifTitle = "GUI Manager",
        notifText = "All GUIs hidden. Press again to show.",
        langBtn = "RU",
    },
}

local currentLang = "ru"
local function L(key) return LOCALE[currentLang][key] end

local guiStates = {}
local allHidden = false

local function getGUI(name)
    local pg = player:FindFirstChild("PlayerGui")
    if not pg then return nil end
    return pg:FindFirstChild(name)
end

local function setGUIEnabled(name, enabled)
    local g = getGUI(name)
    if not g then return false end
    g.Enabled = enabled
    guiStates[name] = enabled
    return true
end

local function hideAll()
    for _, name in ipairs(GUI_NAMES) do
        setGUIEnabled(name, false)
    end
    allHidden = true
end

local function showAll()
    for _, name in ipairs(GUI_NAMES) do
        setGUIEnabled(name, true)
    end
    allHidden = false
end

local gui = Instance.new("ScreenGui")
gui.Name = "GUIManager"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 260, 0, 220)
frame.Position = UDim2.new(0, 20, 0, 450)
frame.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
frame.BackgroundTransparency = 0.1
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = frame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -60, 0, 30)
title.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
title.BorderSizePixel = 0
title.Text = L("title")
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.TextSize = 15
title.Parent = frame

local tCorner = Instance.new("UICorner")
tCorner.CornerRadius = UDim.new(0, 8)
tCorner.Parent = title

local langBtn = Instance.new("TextButton")
langBtn.Size = UDim2.new(0, 50, 0, 30)
langBtn.Position = UDim2.new(1, -55, 0, 0)
langBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
langBtn.BorderSizePixel = 0
langBtn.Text = L("langBtn")
langBtn.TextColor3 = Color3.new(1, 1, 1)
langBtn.Font = Enum.Font.GothamBold
langBtn.TextSize = 14
langBtn.Parent = frame

local lCorner = Instance.new("UICorner")
lCorner.CornerRadius = UDim.new(0, 8)
lCorner.Parent = langBtn

local status = Instance.new("TextLabel")
status.Size = UDim2.new(1, -20, 0, 18)
status.Position = UDim2.new(0, 10, 0, 32)
status.BackgroundTransparency = 1
status.Text = L("status")
status.TextColor3 = Color3.fromRGB(180, 180, 180)
status.Font = Enum.Font.Gotham
status.TextSize = 12
status.TextXAlignment = Enum.TextXAlignment.Left
status.Parent = frame

local toggleAllBtn = Instance.new("TextButton")
toggleAllBtn.Size = UDim2.new(1, -20, 0, 32)
toggleAllBtn.Position = UDim2.new(0, 10, 0, 55)
toggleAllBtn.BackgroundColor3 = Color3.fromRGB(0, 130, 200)
toggleAllBtn.BorderSizePixel = 0
toggleAllBtn.Text = L("hideAll")
toggleAllBtn.TextColor3 = Color3.new(1, 1, 1)
toggleAllBtn.Font = Enum.Font.GothamBold
toggleAllBtn.TextSize = 13
toggleAllBtn.Parent = frame

local tabCorner = Instance.new("UICorner")
tabCorner.CornerRadius = UDim.new(0, 5)
tabCorner.Parent = toggleAllBtn

local toggleButtons = {}

local function makeToggle(yPos, guiName)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -20, 0, 28)
    btn.Position = UDim2.new(0, 10, 0, yPos)
    btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    btn.BorderSizePixel = 0
    btn.Text = guiName
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 13
    btn.Parent = frame

    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 5)
    c.Parent = btn

    local function refresh()
        local g = getGUI(guiName)
        if not g then
            btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            btn.Text = guiName .. " (нет)"
            return
        end
        if g.Enabled then
            btn.BackgroundColor3 = Color3.fromRGB(40, 160, 90)
            btn.Text = guiName .. " ●"
        else
            btn.BackgroundColor3 = Color3.fromRGB(120, 50, 50)
            btn.Text = guiName .. " ○"
        end
    end

    btn.MouseButton1Click:Connect(function()
        local g = getGUI(guiName)
        if not g then return end
        g.Enabled = not g.Enabled
        refresh()
    end)

    refresh()
    table.insert(toggleButtons, refresh)
end

makeToggle(95,  "RampSpawnerGUI")
makeToggle(128, "BoostGUI")
makeToggle(161, "WheelieGUI")

local function refreshAll()
    for _, fn in ipairs(toggleButtons) do fn() end
    if allHidden then
        toggleAllBtn.Text = L("showAll")
    else
        toggleAllBtn.Text = L("hideAll")
    end
end

toggleAllBtn.MouseButton1Click:Connect(function()
    if allHidden then
        showAll()
    else
        hideAll()
    end
    refreshAll()
end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.H then
        if allHidden then
            showAll()
        else
            hideAll()
        end
        refreshAll()
    end
end)

task.spawn(function()
    while gui.Parent do
        refreshAll()
        task.wait(0.3)
    end
end)

local function applyLanguage()
    title.Text = L("title")
    langBtn.Text = L("langBtn")
    status.Text = L("status")
    if allHidden then
        toggleAllBtn.Text = L("showAll")
    else
        toggleAllBtn.Text = L("hideAll")
    end
end

langBtn.MouseButton1Click:Connect(function()
    currentLang = (currentLang == "ru") and "en" or "ru"
    applyLanguage()
end)

game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = L("notifTitle"),
    Text = L("notifText"),
    Duration = 5
})

print("[GUI Manager] Loaded. H — hide/show all.")
