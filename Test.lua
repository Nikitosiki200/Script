-- Rayfield Interface Setup
local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Rayfield/main/source'))()
local Window = Rayfield:CreateWindow({
    Name = "Checkpoint Teleporter",
    LoadingTitle = "Checkpoint Teleportation System",
    LoadingSubtitle = "by YourName",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = nil,
        FileName = "CheckpointTeleporter"
    },
    Discord = {
        Enabled = false,
        Invite = "noinvitelink",
        RememberJoins = true
    }
})

-- Main variables
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local checkpoints = {}
local currentCheckpoint = 1
local teleporting = false
local teleportDelay = 0.5 -- Delay between teleports in seconds

-- Function to find checkpoints in the workspace
local function findCheckpoints()
    checkpoints = {}
    
    -- This looks for parts named "Checkpoint" with a circular/spiral pattern
    -- Adjust this based on how your checkpoints are named/organized
    for _, part in ipairs(workspace:GetDescendants()) do
        if part:IsA("BasePart") and (part.Name:match("Checkpoint") or part.Name:match("CP")) then
            table.insert(checkpoints, part)
        end
    end
    
    -- Sort checkpoints by name (assuming they're named in order)
    table.sort(checkpoints, function(a, b)
        return a.Name < b.Name
    end)
    
    return #checkpoints > 0
end

-- Teleport function
local function teleportToCheckpoint(index)
    if not checkpoints[index] then return end
    
    local checkpoint = checkpoints[index]
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    
    if humanoid then
        -- Teleport to slightly above the checkpoint to avoid getting stuck
        character:SetPrimaryPartCFrame(CFrame.new(checkpoint.Position + Vector3.new(0, 3, 0)))
    end
end

-- Main teleportation loop
local teleportThread
local function startTeleportation()
    if teleporting then return end
    teleporting = true
    
    teleportThread = coroutine.create(function()
        while teleporting and #checkpoints > 0 do
            teleportToCheckpoint(currentCheckpoint)
            
            -- Move to next checkpoint (circular pattern)
            currentCheckpoint = currentCheckpoint % #checkpoints + 1
            
            wait(teleportDelay)
        end
    end)
    
    coroutine.resume(teleportThread)
end

local function stopTeleportation()
    teleporting = false
    if teleportThread then
        coroutine.close(teleportThread)
    end
end

-- GUI Elements
local MainTab = Window:CreateTab("Main", 4483362458) -- Replace with your preferred icon ID

-- Checkpoint Finder Section
MainTab:CreateSection("Checkpoint Management")
local findButton = MainTab:CreateButton({
    Name = "Find Checkpoints",
    Callback = function()
        if findCheckpoints() then
            Rayfield:Notify({
                Title = "Checkpoints Found",
                Content = "Found " .. #checkpoints .. " checkpoints!",
                Duration = 3,
                Image = 4483362458,
                Actions = {
                    Ignore = {
                        Name = "Okay",
                        Callback = function()
                        end
                    },
                },
            })
        else
            Rayfield:Notify({
                Title = "No Checkpoints Found",
                Content = "Couldn't find any checkpoints in the workspace.",
                Duration = 3,
                Image = 4483362458,
                Actions = {
                    Ignore = {
                        Name = "Okay",
                        Callback = function()
                        end
                    },
                },
            })
        end
    end,
})

-- Teleportation Controls
MainTab:CreateSection("Teleportation Controls")
local startButton = MainTab:CreateButton({
    Name = "Start Teleporting",
    Callback = function()
        if #checkpoints == 0 then
            Rayfield:Notify({
                Title = "No Checkpoints",
                Content = "Please find checkpoints first!",
                Duration = 3,
                Image = 4483362458,
                Actions = {
                    Ignore = {
                        Name = "Okay",
                        Callback = function()
                        end
                    },
                },
            })
            return
        end
        startTeleportation()
    end,
})

local stopButton = MainTab:CreateButton({
    Name = "Stop Teleporting",
    Callback = function()
        stopTeleportation()
    end,
})

-- Manual Teleportation
MainTab:CreateSection("Manual Teleportation")
local checkpointSlider = MainTab:CreateSlider({
    Name = "Checkpoint Selector",
    Range = {1, 10},
    Increment = 1,
    Suffix = "checkpoints",
    CurrentValue = 1,
    Flag = "CheckpointSelector",
    Callback = function(value)
        if #checkpoints == 0 then return end
        currentCheckpoint = math.clamp(math.floor(value), 1, #checkpoints)
        teleportToCheckpoint(currentCheckpoint)
    end,
})

-- Update slider max when checkpoints are found
findButton:Callback(function()
    checkpointSlider.Range = {1, math.max(10, #checkpoints)}
    checkpointSlider.CurrentValue = 1
    checkpointSlider:Update()
end)

-- Settings Tab
local SettingsTab = Window:CreateTab("Settings", 4483362458) -- Replace with your preferred icon ID

SettingsTab:CreateSection("Teleportation Settings")
local delaySlider = SettingsTab:CreateSlider({
    Name = "Teleport Delay",
    Range = {0.1, 2},
    Increment = 0.1,
    Suffix = "seconds",
    CurrentValue = teleportDelay,
    Flag = "TeleportDelay",
    Callback = function(value)
        teleportDelay = value
    end,
})

-- Initialize
if findCheckpoints() then
    checkpointSlider.Range = {1, math.max(10, #checkpoints)}
    checkpointSlider:Update()
end

-- Character handling
player.CharacterAdded:Connect(function(newChar)
    character = newChar
end)

-- Keybind for quick start/stop (optional)
local teleportToggle = MainTab:CreateKeybind({
    Name = "Toggle Teleportation",
    CurrentKeybind = "T",
    HoldToInteract = false,
    Flag = "TeleportToggleKeybind",
    Callback = function()
        if teleporting then
            stopTeleportation()
        else
            if #checkpoints > 0 then
                startTeleportation()
            end
        end
    end,
})

Rayfield:LoadConfiguration()
