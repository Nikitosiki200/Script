local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local player = Players.LocalPlayer

local config = {
    speed = 500,
    targetTilt = 45,
    maxAngularSpeed = 4,
    pGain = 6,
    dGain = 2,
}

local LOCALE = {
    ru = {
        title = "Wheelie Config",
        status = "Y — вкл/выкл",
        speed = "Скорость",
        tilt = "Наклон (°)",
        maxAngular = "Макс. угловая",
        pGain = "P-коэф.",
        dGain = "D-коэф.",
        inputTitle = "Введите число",
        ok = "OK",
        cancel = "Отмена",
        notifTitle = "Wheelie + GUI",
        notifText = "Y — вкл/выкл. Настройки в GUI.",
        langBtn = "EN",
    },
    en = {
        title = "Wheelie Config",
        status = "Y — toggle",
        speed = "Speed",
        tilt = "Tilt (deg)",
        maxAngular = "Max angular",
        pGain = "P gain",
        dGain = "D gain",
        inputTitle = "Enter a number",
        ok = "OK",
        cancel = "Cancel",
        notifTitle = "Wheelie + GUI",
        notifText = "Y — toggle. Settings in GUI.",
        langBtn = "RU",
    },
}

local currentLang = "ru"
local function L(key) return LOCALE[currentLang][key] end

local wheelie = {
    active = false,
    vehicle = nil,
    root = nil,
    forward = nil,
    right = nil,
    lastError = 0,
}

local function getVehicle()
    local char = player.Character
    if not char then return nil end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum or not hum.SeatPart then return nil end
    local seat = hum.SeatPart
    local model = seat:FindFirstAncestorOfClass("Model")
    if model and model ~= char then return model end
    return seat
end

local function getVehicleRoot(model)
    if not model then return nil end
    if model:IsA("BasePart") then return model end
    if model.PrimaryPart then return model.PrimaryPart end
    local best, bestScore = nil, 0
    for _, d in ipairs(model:GetDescendants()) do
        if d:IsA("BasePart") then
            local sz = d.Size
            local score = sz.X * sz.Y * sz.Z
            if score > bestScore then best, bestScore = d, score end
        end
    end
    return best
end

local function startWheelie()
    local veh = getVehicle()
    if not veh then warn("[Wheelie] Не в транспорте") return end
    local root = getVehicleRoot(veh)
    if not root then warn("[Wheelie] Нет корня") return end

    local forward = root.CFrame.LookVector
    forward = Vector3.new(forward.X, 0, forward.Z)
    if forward.Magnitude < 0.01 then forward = Vector3.new(0, 0, -1) end
    forward = forward.Unit

    local worldUp = Vector3.new(0, 1, 0)
    local right = forward:Cross(worldUp).Unit

    wheelie.vehicle = veh
    wheelie.root = root
    wheelie.forward = forward
    wheelie.right = right
    wheelie.lastError = 0
    wheelie.active = true

    print("[Wheelie] On")
end

local function stopWheelie()
    if not wheelie.active then return end
    wheelie.active = false
    wheelie.vehicle = nil
    wheelie.root = nil
    print("[Wheelie] Off")
end

RunService.Heartbeat:Connect(function(dt)
    if not wheelie.active then return end
    local root = wheelie.root
    if not root or not root.Parent then stopWheelie() return end

    local vel = root.AssemblyLinearVelocity
    root.AssemblyLinearVelocity = Vector3.new(
        wheelie.forward.X * config.speed,
        vel.Y,
        wheelie.forward.Z * config.speed
    )

    local up = root.CFrame.UpVector
    local tiltNow = math.asin(math.clamp(up.Y, -1, 1))
    local targetTilt = math.rad(config.targetTilt)

    local error = targetTilt - tiltNow
    local dError = (error - wheelie.lastError) / math.max(dt, 0.001)
    wheelie.lastError = error

    local output = config.pGain * error + config.dGain * dError
    output = math.clamp(output, -config.maxAngularSpeed, config.maxAngularSpeed)

    root.AssemblyAngularVelocity = -wheelie.right * output
end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.Y then
        if wheelie.active then stopWheelie() else startWheelie() end
    end
end)

local gui = Instance.new("ScreenGui")
gui.Name = "WheelieGUI"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 320, 0, 320)
frame.Position = UDim2.new(0, 20, 0, 100)
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
status.Size = UDim2.new(1, -20, 0, 20)
status.Position = UDim2.new(0, 10, 0, 32)
status.BackgroundTransparency = 1
status.Text = L("status")
status.TextColor3 = Color3.fromRGB(180, 180, 180)
status.Font = Enum.Font.Gotham
status.TextSize = 13
status.TextXAlignment = Enum.TextXAlignment.Left
status.Parent = frame

local popup = Instance.new("Frame")
popup.Size = UDim2.new(0, 220, 0, 110)
popup.Position = UDim2.new(0.5, -110, 0.5, -55)
popup.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
popup.BorderSizePixel = 0
popup.Visible = false
popup.ZIndex = 10
popup.Active = true
popup.Draggable = true
popup.Parent = gui

local pCorner = Instance.new("UICorner")
pCorner.CornerRadius = UDim.new(0, 8)
pCorner.Parent = popup

local pStroke = Instance.new("UIStroke")
pStroke.Color = Color3.fromRGB(0, 170, 255)
pStroke.Thickness = 2
pStroke.Parent = popup

local pTitle = Instance.new("TextLabel")
pTitle.Size = UDim2.new(1, 0, 0, 26)
pTitle.BackgroundTransparency = 1
pTitle.Text = L("inputTitle")
pTitle.TextColor3 = Color3.new(1, 1, 1)
pTitle.Font = Enum.Font.GothamBold
pTitle.TextSize = 14
pTitle.ZIndex = 11
pTitle.Parent = popup

local pBox = Instance.new("TextBox")
pBox.Size = UDim2.new(1, -20, 0, 30)
pBox.Position = UDim2.new(0, 10, 0, 30)
pBox.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
pBox.BorderSizePixel = 0
pBox.Text = ""
pBox.TextColor3 = Color3.new(1, 1, 1)
pBox.Font = Enum.Font.Gotham
pBox.TextSize = 14
pBox.ClearTextOnFocus = false
pBox.ZIndex = 11
pBox.Parent = popup

local pbCorner = Instance.new("UICorner")
pbCorner.CornerRadius = UDim.new(0, 4)
pbCorner.Parent = pBox

local pOk = Instance.new("TextButton")
pOk.Size = UDim2.new(0.5, -15, 0, 26)
pOk.Position = UDim2.new(0, 10, 1, -36)
pOk.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
pOk.BorderSizePixel = 0
pOk.Text = L("ok")
pOk.TextColor3 = Color3.new(1, 1, 1)
pOk.Font = Enum.Font.GothamBold
pOk.TextSize = 13
pOk.ZIndex = 11
pOk.Parent = popup

local poCorner = Instance.new("UICorner")
poCorner.CornerRadius = UDim.new(0, 4)
poCorner.Parent = pOk

local pCancel = Instance.new("TextButton")
pCancel.Size = UDim2.new(0.5, -15, 0, 26)
pCancel.Position = UDim2.new(0.5, 5, 1, -36)
pCancel.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
pCancel.BorderSizePixel = 0
pCancel.Text = L("cancel")
pCancel.TextColor3 = Color3.new(1, 1, 1)
pCancel.Font = Enum.Font.GothamBold
pCancel.TextSize = 13
pCancel.ZIndex = 11
pCancel.Parent = popup

local pcCorner = Instance.new("UICorner")
pcCorner.CornerRadius = UDim.new(0, 4)
pcCorner.Parent = pCancel

local currentEdit = nil

local function openInput(value, onApply)
    currentEdit = { apply = onApply }
    pBox.Text = tostring(value)
    popup.Visible = true
    task.wait()
    pBox:CaptureFocus()
end

local function closeInput()
    popup.Visible = false
    currentEdit = nil
end

local function commitInput()
    if not currentEdit then closeInput() return end
    local num = tonumber(pBox.Text)
    if num == nil then
        pBox.TextColor3 = Color3.fromRGB(255, 90, 90)
        task.wait(0.4)
        pBox.TextColor3 = Color3.new(1, 1, 1)
        return
    end
    currentEdit.apply(num)
    closeInput()
end

pOk.MouseButton1Click:Connect(commitInput)
pCancel.MouseButton1Click:Connect(closeInput)
pBox.FocusLost:Connect(function(enter)
    if enter then commitInput() end
end)

local labels = {}

local function makeSetting(yPos, labelKey, key, min, max, step)
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
    valueBtn.Text = tostring(config[key])
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
        valueBtn.Text = tostring(val)
        if updateFill then
            local rel = math.clamp((val - min) / (max - min), 0, 1)
            fill.Size = UDim2.new(rel, 0, 1, 0)
        end
    end

    labels[key] = {
        lbl = lbl,
        labelKey = labelKey,
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

makeSetting(60,  "speed",        "speed",           1, 2000, 1)
makeSetting(110, "tilt",         "targetTilt",      1, 89,   1)
makeSetting(160, "maxAngular",   "maxAngularSpeed", 1, 20,   1)
makeSetting(210, "pGain",        "pGain",           0, 30,   1)
makeSetting(260, "dGain",        "dGain",           0, 20,   1)

local function applyLanguage()
    title.Text = L("title")
    langBtn.Text = L("langBtn")
    status.Text = L("status")
    pTitle.Text = L("inputTitle")
    pOk.Text = L("ok")
    pCancel.Text = L("cancel")

    for key, ref in pairs(labels) do
        ref.lbl.Text = L(ref.labelKey) .. ":"
    end
end

langBtn.MouseButton1Click:Connect(function()
    currentLang = (currentLang == "ru") and "en" or "ru"
    applyLanguage()
end)

game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = L("notifTitle"),
    Text = L("notifText"),
    Duration = 6
})

print("[Wheelie + GUI RU/EN] Loaded.")
