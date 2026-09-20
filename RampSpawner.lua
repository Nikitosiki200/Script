local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

local config = {
    height = 10,
    length = 20,
    width  = 15,
    distance = 100,
    lifetime = 10,
    underFeet = 3,
}

local LOCALE = {
    ru = {
        title = "Ramp Spawner (G)",
        height = "Высота",
        length = "Длина",
        width  = "Ширина",
        distance = "Расстояние",
        underFeet = "Ниже ног",
        lifetime = "Удалить через",
        lifetimeSuffix = " сек",
        inputTitle = "Введите число",
        inputPlaceholder = "например: 123",
        ok = "OK",
        cancel = "Отмена",
        notifTitle = "Ramp Spawner v4",
        notifText = "G — рампа. Клик по числу — ручной ввод.",
        langBtn = "EN",
    },
    en = {
        title = "Ramp Spawner (G)",
        height = "Height",
        length = "Length",
        width  = "Width",
        distance = "Distance",
        underFeet = "Below feet",
        lifetime = "Delete after",
        lifetimeSuffix = " s",
        inputTitle = "Enter a number",
        inputPlaceholder = "e.g. 123",
        ok = "OK",
        cancel = "Cancel",
        notifTitle = "Ramp Spawner v4",
        notifText = "G — ramp. Click a number to type a custom value.",
        langBtn = "RU",
    },
}

local currentLang = "ru"
local function L(key) return LOCALE[currentLang][key] end

local labels = {}

local function createRamp(position, lookVector)
    local model = Instance.new("Model")
    model.Name = "CustomRamp"

    local wedge = Instance.new("WedgePart")
    wedge.Size = Vector3.new(config.width, config.height, config.length)
    wedge.Anchored = true
    wedge.CanCollide = true
    wedge.Material = Enum.Material.Plastic
    wedge.BrickColor = BrickColor.new("Bright red")
    wedge.TopSurface = Enum.SurfaceType.Smooth
    wedge.BottomSurface = Enum.SurfaceType.Smooth
    wedge.Parent = model

    local flatLook = Vector3.new(lookVector.X, 0, lookVector.Z)
    if flatLook.Magnitude < 0.01 then flatLook = Vector3.new(0, 0, -1) end
    flatLook = flatLook.Unit

    local basePos = position + flatLook * config.distance
    basePos = basePos - Vector3.new(0, config.underFeet, 0)

    local facing = -flatLook
    local lookCF = CFrame.lookAt(basePos, basePos + facing)

    wedge.CFrame = lookCF + Vector3.new(0, config.height / 2, 0)
    model.PrimaryPart = wedge
    model.Parent = workspace

    if config.lifetime > 0 then
        task.delay(config.lifetime, function()
            if model and model.Parent then model:Destroy() end
        end)
    end
    return model
end

local gui = Instance.new("ScreenGui")
gui.Name = "RampSpawnerGUI"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 320, 0, 340)
frame.Position = UDim2.new(0, 20, 0, 100)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BackgroundTransparency = 0.15
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = frame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -60, 0, 30)
title.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
title.BorderSizePixel = 0
title.Text = L("title")
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.Parent = frame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 8)
titleCorner.Parent = title

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

local langCorner = Instance.new("UICorner")
langCorner.CornerRadius = UDim.new(0, 8)
langCorner.Parent = langBtn

local inputPopup = Instance.new("Frame")
inputPopup.Size = UDim2.new(0, 220, 0, 110)
inputPopup.Position = UDim2.new(0.5, -110, 0.5, -55)
inputPopup.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
inputPopup.BorderSizePixel = 0
inputPopup.Visible = false
inputPopup.ZIndex = 10
inputPopup.Active = true
inputPopup.Draggable = true
inputPopup.Parent = gui

local ipCorner = Instance.new("UICorner")
ipCorner.CornerRadius = UDim.new(0, 8)
ipCorner.Parent = inputPopup

local ipStroke = Instance.new("UIStroke")
ipStroke.Color = Color3.fromRGB(0, 170, 255)
ipStroke.Thickness = 2
ipStroke.Parent = inputPopup

local ipTitle = Instance.new("TextLabel")
ipTitle.Size = UDim2.new(1, 0, 0, 26)
ipTitle.BackgroundTransparency = 1
ipTitle.Text = L("inputTitle")
ipTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
ipTitle.Font = Enum.Font.GothamBold
ipTitle.TextSize = 14
ipTitle.ZIndex = 11
ipTitle.Parent = inputPopup

local ipBox = Instance.new("TextBox")
ipBox.Size = UDim2.new(1, -20, 0, 30)
ipBox.Position = UDim2.new(0, 10, 0, 30)
ipBox.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
ipBox.BorderSizePixel = 0
ipBox.Text = ""
ipBox.PlaceholderText = L("inputPlaceholder")
ipBox.TextColor3 = Color3.fromRGB(255, 255, 255)
ipBox.PlaceholderColor3 = Color3.fromRGB(120, 120, 120)
ipBox.Font = Enum.Font.Gotham
ipBox.TextSize = 14
ipBox.ClearTextOnFocus = false
ipBox.ZIndex = 11
ipBox.Parent = inputPopup

local ipBoxCorner = Instance.new("UICorner")
ipBoxCorner.CornerRadius = UDim.new(0, 4)
ipBoxCorner.Parent = ipBox

local ipOk = Instance.new("TextButton")
ipOk.Size = UDim2.new(0.5, -15, 0, 26)
ipOk.Position = UDim2.new(0, 10, 1, -36)
ipOk.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
ipOk.BorderSizePixel = 0
ipOk.Text = L("ok")
ipOk.TextColor3 = Color3.new(1, 1, 1)
ipOk.Font = Enum.Font.GothamBold
ipOk.TextSize = 13
ipOk.ZIndex = 11
ipOk.Parent = inputPopup

local ipOkCorner = Instance.new("UICorner")
ipOkCorner.CornerRadius = UDim.new(0, 4)
ipOkCorner.Parent = ipOk

local ipCancel = Instance.new("TextButton")
ipCancel.Size = UDim2.new(0.5, -15, 0, 26)
ipCancel.Position = UDim2.new(0.5, 5, 1, -36)
ipCancel.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
ipCancel.BorderSizePixel = 0
ipCancel.Text = L("cancel")
ipCancel.TextColor3 = Color3.new(1, 1, 1)
ipCancel.Font = Enum.Font.GothamBold
ipCancel.TextSize = 13
ipCancel.ZIndex = 11
ipCancel.Parent = inputPopup

local ipCancelCorner = Instance.new("UICorner")
ipCancelCorner.CornerRadius = UDim.new(0, 4)
ipCancelCorner.Parent = ipCancel

local currentEdit = nil

local function openInput(currentValue, onApply)
    currentEdit = { apply = onApply }
    ipBox.Text = tostring(currentValue)
    inputPopup.Visible = true
    inputPopup.ZIndex = 10
    task.wait()
    ipBox:CaptureFocus()
end

local function closeInput()
    inputPopup.Visible = false
    currentEdit = nil
end

local function commitInput()
    if not currentEdit then closeInput() return end
    local num = tonumber(ipBox.Text)
    if num == nil then
        ipBox.TextColor3 = Color3.fromRGB(255, 90, 90)
        task.wait(0.4)
        ipBox.TextColor3 = Color3.fromRGB(255, 255, 255)
        return
    end
    currentEdit.apply(num)
    closeInput()
end

ipOk.MouseButton1Click:Connect(commitInput)
ipCancel.MouseButton1Click:Connect(closeInput)

ipBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then commitInput() end
end)

local function makeSetting(yPos, labelKey, key, min, max, step, suffixKey)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, -20, 0, 45)
    row.Position = UDim2.new(0, 10, 0, yPos)
    row.BackgroundTransparency = 1
    row.Parent = frame

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0.6, 0, 0, 20)
    lbl.BackgroundTransparency = 1
    lbl.Text = L(labelKey) .. ":"
    lbl.TextColor3 = Color3.fromRGB(220, 220, 220)
    lbl.Font = Enum.Font.Gotham
    lbl.TextSize = 14
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = row

    local valueBtn = Instance.new("TextButton")
    valueBtn.Size = UDim2.new(0.4, 0, 0, 20)
    valueBtn.Position = UDim2.new(0.6, 0, 0, 0)
    valueBtn.BackgroundTransparency = 1
    valueBtn.Text = tostring(config[key]) .. (suffixKey and L(suffixKey) or "")
    valueBtn.TextColor3 = Color3.fromRGB(0, 200, 255)
    valueBtn.Font = Enum.Font.GothamBold
    valueBtn.TextSize = 14
    valueBtn.TextXAlignment = Enum.TextXAlignment.Right
    valueBtn.AutoButtonColor = false
    valueBtn.Parent = row

    local slider = Instance.new("Frame")
    slider.Size = UDim2.new(1, 0, 0, 18)
    slider.Position = UDim2.new(0, 0, 0, 22)
    slider.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    slider.BorderSizePixel = 0
    slider.Parent = row

    local sCorner = Instance.new("UICorner")
    sCorner.CornerRadius = UDim.new(0, 4)
    sCorner.Parent = slider

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new(math.clamp((config[key] - min) / (max - min), 0, 1), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    fill.BorderSizePixel = 0
    fill.Parent = slider

    local fCorner = Instance.new("UICorner")
    fCorner.CornerRadius = UDim.new(0, 4)
    fCorner.Parent = fill

    local function setValue(val, updateFill)
        config[key] = val
        valueBtn.Text = tostring(val) .. (suffixKey and L(suffixKey) or "")
        if updateFill then
            local rel = math.clamp((val - min) / (max - min), 0, 1)
            fill.Size = UDim2.new(rel, 0, 1, 0)
        end
    end

    labels[key] = {
        lbl = lbl,
        valueBtn = valueBtn,
        labelKey = labelKey,
        suffixKey = suffixKey,
    }

    valueBtn.MouseButton1Click:Connect(function()
        openInput(config[key], function(num)
            setValue(num, true)
        end)
    end)

    local dragging = false
    local function updateFromX(x)
        local rel = math.clamp((x - slider.AbsolutePosition.X) / slider.AbsoluteSize.X, 0, 1)
        local val = min + (max - min) * rel
        val = math.floor(val / step + 0.5) * step
        setValue(val, true)
    end

    slider.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            updateFromX(input.Position.X)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch) then
            updateFromX(input.Position.X)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
end

makeSetting(35,  "height",     "height",   1, 100, 1)
makeSetting(85,  "length",     "length",   1, 200, 1)
makeSetting(135, "width",      "width",    1, 200, 1)
makeSetting(185, "distance",   "distance", 5, 500, 5)
makeSetting(235, "underFeet",  "underFeet",0, 30,  1)
makeSetting(285, "lifetime",   "lifetime", 0, 60,  1, "lifetimeSuffix")

local function applyLanguage()
    title.Text = L("title")
    langBtn.Text = L("langBtn")
    ipTitle.Text = L("inputTitle")
    ipBox.PlaceholderText = L("inputPlaceholder")
    ipOk.Text = L("ok")
    ipCancel.Text = L("cancel")

    for key, ref in pairs(labels) do
        ref.lbl.Text = L(ref.labelKey) .. ":"
        local suffix = ref.suffixKey and L(ref.suffixKey) or ""
        ref.valueBtn.Text = tostring(config[key]) .. suffix
    end
end

langBtn.MouseButton1Click:Connect(function()
    currentLang = (currentLang == "ru") and "en" or "ru"
    applyLanguage()
end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if inputPopup.Visible then return end
    if input.KeyCode ~= Enum.KeyCode.G then return end

    local char = player.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    createRamp(hrp.Position, hrp.CFrame.LookVector)
end)

player.CharacterAdded:Connect(function(newChar)
    character = newChar
end)

game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = L("notifTitle"),
    Text = L("notifText"),
    Duration = 6
})

print("[Ramp Spawner v4] Loaded / Загружено.")
