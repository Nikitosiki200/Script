-- Roblox Teleport GUI in Table Style
local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- Create main GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "TeleportGUI"
ScreenGui.Parent = game.CoreGui or player:WaitForChild("PlayerGui")

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.Size = UDim2.new(0, 300, 0, 250)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -125)
MainFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
MainFrame.Active = true
MainFrame.Draggable = true

-- Title Bar
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Parent = MainFrame
TitleBar.Size = UDim2.new(1, 0, 0, 30)
TitleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Parent = TitleBar
Title.Size = UDim2.new(0.7, 0, 1, 0)
Title.Text = "Teleport GUI"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.BackgroundTransparency = 1
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Position = UDim2.new(0, 10, 0, 0)

local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Parent = TitleBar
CloseButton.Size = UDim2.new(0, 25, 0, 25)
CloseButton.Position = UDim2.new(1, -30, 0, 2)
CloseButton.Text = "X"
CloseButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)

-- Teleport Locations
local teleportLocations = {
    {name = "Location 1", x = -994, y = 1989, z = 383},
    {name = "Location 2", x = -995, y = 1989, z = 673},
    {name = "Location 3", x = -994, y = 1989, z = 1213},
    {name = "Location 4", x = -1095, y = 1989, z = 1355}
}

-- Create teleport buttons in table style
local TeleportFrame = Instance.new("Frame")
TeleportFrame.Name = "TeleportFrame"
TeleportFrame.Parent = MainFrame
TeleportFrame.Size = UDim2.new(1, -20, 1, -50)
TeleportFrame.Position = UDim2.new(0, 10, 0, 40)
TeleportFrame.BackgroundTransparency = 1

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = TeleportFrame
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIListLayout.Padding = UDim.new(0, 5)

-- Header
local Header = Instance.new("Frame")
Header.Name = "Header"
Header.Parent = TeleportFrame
Header.Size = UDim2.new(1, 0, 0, 30)
Header.BackgroundColor3 = Color3.fromRGB(60, 60, 60)

local HeaderText = Instance.new("TextLabel")
HeaderText.Name = "HeaderText"
HeaderText.Parent = Header
HeaderText.Size = UDim2.new(1, 0, 1, 0)
HeaderText.Text = "TELEPORTS"
HeaderText.TextColor3 = Color3.fromRGB(255, 255, 255)
HeaderText.BackgroundTransparency = 1
HeaderText.Font = Enum.Font.SourceSansBold

-- Create teleport buttons
for _, loc in ipairs(teleportLocations) do
    local btnFrame = Instance.new("Frame")
    btnFrame.Name = "BtnFrame_"..loc.name
    btnFrame.Parent = TeleportFrame
    btnFrame.Size = UDim2.new(1, 0, 0, 35)
    btnFrame.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    
    local btn = Instance.new("TextButton")
    btn.Name = "Btn_"..loc.name
    btn.Parent = btnFrame
    btn.Size = UDim2.new(1, -10, 1, -5)
    btn.Position = UDim2.new(0, 5, 0, 2)
    btn.Text = loc.name
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    
    btn.MouseButton1Click:Connect(function()
        local char = player.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            char.HumanoidRootPart.CFrame = CFrame.new(loc.x, loc.y, loc.z)
        end
    end)
end

-- Close functionality
CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Dragging functionality
local dragging, dragInput, dragStart, startPos

TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

TitleBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end
end)
