-- Roblox Teleport GUI Script
-- Creates a movable GUI with teleport buttons

-- Coordinates for teleportation
local teleportLocations = {
    {name = "1", x = -994, y = 1989, z = 383},
    {name = "2", x = -995, y = 1989, z = 673},
    {name = "3", x = -994, y = 1989, z = 1213},
    {name = "4", x = -1095, y = 1989, z = 1355}
}

-- Create the main GUI frame
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local TitleBar = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local CloseButton = Instance.new("TextButton")
local MinimizeButton = Instance.new("TextButton")
local TeleportFrame = Instance.new("Frame")
local UIListLayout = Instance.new("UIListLayout")

-- GUI Properties
ScreenGui.Name = "TeleportGUI"
ScreenGui.Parent = game.CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.3, 0, 0.3, 0)
MainFrame.Size = UDim2.new(0, 200, 0, 150)
MainFrame.Active = true
MainFrame.Draggable = true

TitleBar.Name = "TitleBar"
TitleBar.Parent = MainFrame
TitleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
TitleBar.BorderSizePixel = 0
TitleBar.Size = UDim2.new(1, 0, 0, 25)
TitleBar.Active = true
TitleBar.Draggable = true

Title.Name = "Title"
Title.Parent = TitleBar
Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Title.BackgroundTransparency = 1.0
Title.Size = UDim2.new(0.7, 0, 1, 0)
Title.Font = Enum.Font.SourceSans
Title.Text = "Teleport GUI"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 14.000
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.PaddingLeft = UDim.new(0, 5)

CloseButton.Name = "CloseButton"
CloseButton.Parent = TitleBar
CloseButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
CloseButton.BorderSizePixel = 0
CloseButton.Position = UDim2.new(0.85, 0, 0.1, 0)
CloseButton.Size = UDim2.new(0, 20, 0, 20)
CloseButton.Font = Enum.Font.SourceSans
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 14.000

MinimizeButton.Name = "MinimizeButton"
MinimizeButton.Parent = TitleBar
MinimizeButton.BackgroundColor3 = Color3.fromRGB(50, 50, 255)
MinimizeButton.BorderSizePixel = 0
MinimizeButton.Position = UDim2.new(0.7, 0, 0.1, 0)
MinimizeButton.Size = UDim2.new(0, 20, 0, 20)
MinimizeButton.Font = Enum.Font.SourceSans
MinimizeButton.Text = "_"
MinimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeButton.TextSize = 14.000

TeleportFrame.Name = "TeleportFrame"
TeleportFrame.Parent = MainFrame
TeleportFrame.BackgroundTransparency = 1
TeleportFrame.Position = UDim2.new(0, 0, 0, 25)
TeleportFrame.Size = UDim2.new(1, 0, 1, -25)

UIListLayout.Parent = TeleportFrame
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 5)

-- Create teleport buttons
for i, location in ipairs(teleportLocations) do
    local TeleportButton = Instance.new("TextButton")
    TeleportButton.Name = "TeleportButton_" .. location.name
    TeleportButton.Parent = TeleportFrame
    TeleportButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    TeleportButton.BorderSizePixel = 0
    TeleportButton.Size = UDim2.new(0.9, 0, 0, 25)
    TeleportButton.Font = Enum.Font.SourceSans
    TeleportButton.Text = "Teleport to " .. location.name
    TeleportButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    TeleportButton.TextSize = 14.000
    
    TeleportButton.MouseButton1Click:Connect(function()
        local player = game.Players.LocalPlayer
        if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            player.Character.HumanoidRootPart.CFrame = CFrame.new(location.x, location.y, location.z)
        end
    end)
end

-- Close button functionality
CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Minimize button functionality
local isMinimized = false
local originalSize = MainFrame.Size

MinimizeButton.MouseButton1Click:Connect(function()
    if isMinimized then
        MainFrame.Size = originalSize
        TeleportFrame.Visible = true
    else
        MainFrame.Size = UDim2.new(originalSize.X.Scale, originalSize.X.Offset, 0, 25)
        TeleportFrame.Visible = false
    end
    isMinimized = not isMinimized
end)

-- Make the title bar draggable
local dragging
local dragInput
local dragStart
local startPos

local function update(input)
    local delta = input.Position - dragStart
    MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
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
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)
