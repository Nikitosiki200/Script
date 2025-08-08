-- Rayfield GUI Script
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "Get Down! [troll stairs] Auto Farm | Авто Фарм",
    LoadingTitle = "Auto Farm | Авто Фарм",
    LoadingSubtitle = "Nikitosiki2000",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = nil,
        FileName = "AutoFarmPROPlusPlusConfig"
    },
    Discord = {
        Enabled = true,
        Invite = "t.me/pueon",
        RememberJoins = true
    },
    KeySystem = false
})

-- Auto Farm Tab | Вкладка автофарма
local AutoFarmTab = Window:CreateTab("Auto Farm | Авто Фарм", 4483362458)

-- Speed Slider | Ползунок скорости
local Slider = AutoFarmTab:CreateSlider({
    Name = "Speed | Скорость",
    Range = {20, 300},
    Increment = 1,
    Suffix = "studs/sec | блоков/сек",
    CurrentValue = 100,
    Flag = "MoveSpeed",
    Callback = function(Value)
        _G.MoveSpeed = Value
    end,
})

-- Toggle Switch | Переключатель
local Toggle = AutoFarmTab:CreateToggle({
    Name = "Enable Auto Farm | Включить авто фарм",
    CurrentValue = false,
    Flag = "AutoFarmToggle",
    Callback = function(Value)
        _G.AutoFarmEnabled = Value
        if Value then
            startAutoFarm()
        end
    end,
})

-- Path Points | Точки маршрута
local points = {
    Vector3.new(-438, 377, 53),  -- First point (instant) | Первая точка (мгновенно)
    Vector3.new(177, 21, 54),    -- Second point | Вторая точка
    Vector3.new(222, -4, 2)      -- Third point | Третья точка
}

-- Enhanced Respawn Wait | Улучшенное ожидание возрождения
local function waitForRespawn(player)
    local startTime = os.clock()
    
    -- Wait for valid character | Ожидание валидного персонажа
    repeat
        task.wait()
        if not _G.AutoFarmEnabled then return nil end
    until player.Character and 
          player.Character:FindFirstChild("Humanoid") and 
          player.Character.Humanoid.Health > 0 and
          (os.clock() - startTime) >= 3
    
    return player.Character
end

-- Movement Function | Функция перемещения
local function moveToPoint(character, point, instant)
    if not character or not character:FindFirstChild("HumanoidRootPart") then
        return false
    end
    
    if instant then
        character.HumanoidRootPart.CFrame = CFrame.new(point)
        return true
    end
    
    local startPos = character.HumanoidRootPart.Position
    local distance = (point - startPos).Magnitude
    local duration = distance / _G.MoveSpeed
    local startTime = os.clock()
    
    while os.clock() - startTime < duration and _G.AutoFarmEnabled do
        if not character or not character:FindFirstChild("HumanoidRootPart") then
            return false
        end
        
        local progress = (os.clock() - startTime) / duration
        character.HumanoidRootPart.CFrame = CFrame.new(startPos:Lerp(point, progress))
        task.wait()
    end
    
    if character and character:FindFirstChild("HumanoidRootPart") then
        character.HumanoidRootPart.CFrame = CFrame.new(point)
        return true
    end
    return false
end

-- Main Auto Farm Function | Основная функция автофарма
function startAutoFarm()
    spawn(function()
        local player = game.Players.LocalPlayer
        local restartAttempts = 0
        local maxAttempts = 5
        
        while _G.AutoFarmEnabled do
            local character = player.Character or player.CharacterAdded:Wait()
            character = waitForRespawn(player)
            
            if not character then
                restartAttempts += 1
                if restartAttempts >= maxAttempts then
                    Rayfield:Notify({
                        Title = "Error | Ошибка",
                        Content = "Failed to respawn after "..maxAttempts.." attempts | Не удалось возродиться после "..maxAttempts.." попыток",
                        Duration = 5,
                        Image = 4483362458,
                    })
                    break
                end
                task.wait(1)
                continue
            end
            
            restartAttempts = 0
            
            -- Execute path | Выполнение маршрута
            for i, point in ipairs(points) do
                if not _G.AutoFarmEnabled then break end
                
                -- Check character state | Проверка состояния
                if not character or not character:FindFirstChild("Humanoid") or character.Humanoid.Health <= 0 then
                    character = waitForRespawn(player)
                    if not character then break end
                    i = 1 -- Restart from first point | Начать с первой точки
                end
                
                local success = moveToPoint(character, point, i == 1)
                
                -- Auto-restart if failed | Авто-рестарт при ошибке
                if not success then
                    task.wait(1)
                    break
                end
                
                if i > 1 then
                    task.wait(0.1)
                end
            end
            
            -- Kill character at path end | Убить персонажа в конце
            if _G.AutoFarmEnabled and character and character:FindFirstChild("Humanoid") then
                character.Humanoid.Health = 0
            end
        end
    end)
end

-- Tools Tab | Вкладка инструментов
local ToolsTab = Window:CreateTab("Tools | Инструменты", 4483362458)

-- Infinite Yield Reborn
ToolsTab:CreateButton({
    Name = "Load Infinite Yield Reborn | Загрузить IY Reborn",
    Callback = function()
        loadstring(game:HttpGet("https://github.com/mxsynry/infiniteyield-reborn/raw/refs/heads/master/source"))()
        Rayfield:Notify({
            Title = "Success | Успешно",
            Content = "Infinite Yield Reborn loaded! | IY Reborn загружен!",
            Duration = 3,
            Image = 4483362458,
        })
    end,
})

-- Infinite Yield
ToolsTab:CreateButton({
    Name = "Load Infinite Yield | Загрузить Infinite Yield",
    Callback = function()
        loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
        Rayfield:Notify({
            Title = "Success | Успешно",
            Content = "Infinite Yield loaded! | Infinite Yield загружен!",
            Duration = 3,
            Image = 4483362458,
        })
    end,
})

-- Initialization | Инициализация
_G.MoveSpeed = Slider.CurrentValue
