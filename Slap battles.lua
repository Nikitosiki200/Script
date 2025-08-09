local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Sosal?",
   Icon = 0, -- Icon in Topbar. Can use Lucide Icons (string) or Roblox Image (number). 0 to use no icon (default).
   LoadingTitle = "Sosal?",
   LoadingSubtitle = "Sosal?",
   ShowText = "Sosal?", -- for mobile users to unhide rayfield, change if you'd like
   Theme = "Default", -- Check https://docs.sirius.menu/rayfield/configuration/themes

   ToggleUIKeybind = "K", -- The keybind to toggle the UI visibility (string like "K" or Enum.KeyCode)

   DisableRayfieldPrompts = false,
   DisableBuildWarnings = false, -- Prevents Rayfield from warning when the script has a version mismatch with the interface

   ConfigurationSaving = {
      Enabled = true,
      FolderName = nil, -- Create a custom folder for your hub/game
      FileName = "SB hub"
   },

   Discord = {
      Enabled = false, -- Prompt the user to join your Discord server if their executor supports it
      Invite = "noinvitelink", -- The Discord invite code, do not include discord.gg/. E.g. discord.gg/ ABCD would be ABCD
      RememberJoins = true -- Set this to false to make them join the discord every time they load it up
   },

   KeySystem = false, -- Set this to true to use our key system
   KeySettings = {
      Title = "key system",
      Subtitle = "Key System",
      Note = "the key is key", -- Use this to tell the user how to get a key
      FileName = "Key", -- It is recommended to use something unique as other scripts using Rayfield may overwrite your key file
      SaveKey = true, -- The user's key will be saved, but if you change the key, they will be unable to use your script
      GrabKeyFromSite = false, -- If this is true, set Key below to the RAW site you would like Rayfield to get the key from
      Key = {"hello"} -- List of keys that will be accepted by the system, can be RAW file links (pastebin, github etc) or simple strings ("hello","key22")
   }
})

local Tab = Window:CreateTab("sosal?", 4483362458) -- Title, Image

local Button = Tab:CreateButton({
   Name = "Sosal?",
   Callback = function()
   -- https://scriptblox.com/script/UPDATE-Slap-Battles-Slap-aura-OP-script-43368

getfenv().SlapAuraConfig = {
    Cooldown = 0.0, -- Change it to the cooldown value you want
    HideUserName = true -- Change to false if you don't want to hide your name.
}

loadstring(game:HttpGet("https://raw.githubusercontent.com/Yuna-ux/Slap-battles/refs/heads/main/Slap_aura.lua"))();
   end,
})

local Tab = Window:CreateTab("Sosal?", 4483362458) -- Title, Image

local Button = Tab:CreateButton({
   Name = "Sosal?",
   Callback = function()
   loadstring(game:HttpGet("https://raw.githubusercontent.com/IncognitoScripts/SlapBattles/main/Edgelord", true))()
   end,
})

local Button = Tab:CreateButton({
   Name = "Sosal?",
   Callback = function()
   loadstring(game:HttpGet("https://raw.githubusercontent.com/IncognitoScripts/SlapBattles/refs/heads/main/InstantGloves"))()
   end,
})

local Button = Tab:CreateButton({
   Name = "Sosal?",
   Callback = function()
   --[[
    Made By drizOn YouTube
    THIS THEME PROBABLY WON'T PLAY CUZ IT'S NEW AND JUST PUBLISHED, 
    Enjoy this is useful for ks servers :D.
]]
getfenv().ConfigDeathGlove = {
    HitboxVisible = false, -- Change to true if you want the hitbox to be visible
    HideUserName = true, -- Change it to false if you want it to not hide your username.
    MusicThemeId = 1837943464
}

loadstring(game:HttpGet("https://raw.githubusercontent.com/Yuna-ux/Slap-battles/refs/heads/main/Death_glove_V4.lua"))();
   end,
})

local Button = Tab:CreateButton({
   Name = "Sosal?",
   Callback = function()
   loadstring(game:HttpGet("https://raw.githubusercontent.com/IncognitoScripts/SlapBattles/main/AutoSlasher", true))()
   end,
})

local Button = Tab:CreateButton({
   Name = "Sosal?",
   Callback = function()
   loadstring(game:HttpGet("https://raw.githubusercontent.com/IncognitoScripts/SlapBattles/main/InstantReflect", true))()
   end,
})

local Button = Tab:CreateButton({
   Name = "Sosal?",
   Callback = function()
   loadstring(game:HttpGet("https://raw.githubusercontent.com/IncognitoScripts/SlapBattles/main/TycoonClicker", true))()
   end,
})

local MiscTab = Window:CreateTab("Sosal?", nil)

local MiscSection = MiscTab:CreateSection("Sosal?")

local PushButton = MiscTab:CreateButton({
	Name = "Sosal?",
	Callback = function()
		local player = game.Players.LocalPlayer
		local character = player.Character or player.CharacterAdded:Wait()
		local humanoid = character:FindFirstChildOfClass("Humanoid")

		if humanoid then
			local animation = Instance.new("Animation")
			animation.AnimationId = "rbxassetid://16389964118" -- Replace with your animation ID
			local animationTrack = humanoid:LoadAnimation(animation)
			animationTrack:Play()
		else
			warn("Sosal?")
		end
	end,
})
local StartButton = MiscTab:CreateButton({
	Name = "Sosal?",
	Callback = function()
		local player = game.Players.LocalPlayer
		local character = player.Character or player.CharacterAdded:Wait()
		local humanoid = character:FindFirstChildOfClass("Humanoid")

		if humanoid then
			local animation = Instance.new("Animation")
			animation.AnimationId = "rbxassetid://111726999347835" -- Replace with your animation ID
			local animationTrack = humanoid:LoadAnimation(animation)
			animationTrack:Play()
		else
			warn("Humanoid not found in character!")
		end
	end,
})
local BoxerButton = MiscTab:CreateButton({
	Name = "Sosal?",
	Callback = function()
		local player = game.Players.LocalPlayer
		local character = player.Character or player.CharacterAdded:Wait()
		local humanoid = character:FindFirstChildOfClass("Humanoid")

		if humanoid then
			local animation = Instance.new("Animation")
			animation.AnimationId = "rbxassetid://73504680385602" -- Replace with your animation ID
			local animationTrack = humanoid:LoadAnimation(animation)
			animationTrack:Play()
		else
			warn("Humanoid not found in character!")
		end
	end,
})

local LightningButton = MiscTab:CreateButton({
	Name = "Sosal?",
	Callback = function()
		local player = game.Players.LocalPlayer
		local character = player.Character or player.CharacterAdded:Wait()
		local humanoid = character:FindFirstChildOfClass("Humanoid")

		if humanoid then
			local animation = Instance.new("Animation")
			animation.AnimationId = "rbxassetid://16144838323" -- Replace with your animation ID
			local animationTrack = humanoid:LoadAnimation(animation)
			animationTrack:Play()
		else
			warn("Humanoid not found in character!")
		end
	end,
})
local SpawnButton = MiscTab:CreateButton({
	Name = "Sosal?",
	Callback = function()
		local player = game.Players.LocalPlayer
		local character = player.Character or player.CharacterAdded:Wait()
		local humanoid = character:FindFirstChildOfClass("Humanoid")

		if humanoid then
			local animation = Instance.new("Animation")
			animation.AnimationId = "rbxassetid://13675136513" -- Replace with your animation ID
			local animationTrack = humanoid:LoadAnimation(animation)
			animationTrack:Play()
		else
			warn("Humanoid not found in character!")
		end
	end,
})
local JumpButton = MiscTab:CreateButton({
	Name = "Sosal?",
	Callback = function()
		local player = game.Players.LocalPlayer
		local character = player.Character or player.CharacterAdded:Wait()
		local humanoid = character:FindFirstChildOfClass("Humanoid")

		if humanoid then
			local animation = Instance.new("Animation")
			animation.AnimationId = "rbxassetid://18506587588" -- Replace with your animation ID 
			local animationTrack = humanoid:LoadAnimation(animation)
			animationTrack:Play()
		else
			warn("Humanoid not found in character!")
		end
	end,
})
local LightningButton = MiscTab:CreateButton({
	Name = "Sosal?",
	Callback = function()
		local player = game.Players.LocalPlayer
		local character = player.Character or player.CharacterAdded:Wait()
		local humanoid = character:FindFirstChildOfClass("Humanoid")

		if humanoid then
			local animation = Instance.new("Animation")
			animation.AnimationId = "rbxassetid://16102418873" -- Replace with your animation ID 
			local animationTrack = humanoid:LoadAnimation(animation)
			animationTrack:Play()
		else
			warn("Humanoid not found in character!")
		end
	end,
})
local CounterButton = MiscTab:CreateButton({
	Name = "Sosal?",
	Callback = function()
		local player = game.Players.LocalPlayer
		local character = player.Character or player.CharacterAdded:Wait()
		local humanoid = character:FindFirstChildOfClass("Humanoid")

		if humanoid then
			local animation = Instance.new("Animation")
			animation.AnimationId = "rbxassetid://13552944381" -- Replace with your animation ID 
			local animationTrack = humanoid:LoadAnimation(animation)
			animationTrack:Play()
		else
			warn("Humanoid not found in character!")
		end
	end,
})

local CounterButton = MiscTab:CreateButton({
	Name = "Sosal?",
	Callback = function()
		local player = game.Players.LocalPlayer
		local character = player.Character or player.CharacterAdded:Wait()
		local humanoid = character:FindFirstChildOfClass("Humanoid")

		if humanoid then
			local animation = Instance.new("Animation")
			animation.AnimationId = "rbxassetid://13538759700" -- Replace with your animation ID 
			local animationTrack = humanoid:LoadAnimation(animation)
			animationTrack:Play()
		else
			warn("Humanoid not found in character!")
		end
	end,
})

local CounterButton = MiscTab:CreateButton({
	Name = "Sosal?",
	Callback = function()
		local player = game.Players.LocalPlayer
		local character = player.Character or player.CharacterAdded:Wait()
		local humanoid = character:FindFirstChildOfClass("Humanoid")

		if humanoid then
			local animation = Instance.new("Animation")
			animation.AnimationId = "rbxassetid://14772482253" -- Replace with your animation ID 
			local animationTrack = humanoid:LoadAnimation(animation)
			animationTrack:Play()
		else
			warn("Humanoid not found in character!")
		end
	end,
})

local TeleportSection = MiscTab:CreateSection("Sosal?")
local TeleportMainIslandButton = MiscTab:CreateButton({
	Name = "Sosal?",
	Callback = function()
		local mainIslandPosition = Vector3.new(0, 50, 0) -- Adjust this position to match your main island's location
		local player = game.Players.LocalPlayer
		if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
			player.Character.HumanoidRootPart.CFrame = CFrame.new(mainIslandPosition)
		else
			warn("Character or HumanoidRootPart not found!")
		end
	end,
})

local Button = Tab:CreateButton({
   Name = "Sosal?",
   Callback = function()
   game:GetService("TeleportService"):Teleport(9426795465, game.Players.LocalPlayer)
   end,
})


local Tab = Window:CreateTab("Sosal?", 4483362458) -- Title, Image
   
local Button = Tab:CreateButton({
   Name = "Execute Sosal?",
   Callback = function()
   loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
   end,
})

local Button = Tab:CreateButton({
   Name = "Edit Sosal? & get Sosal?",
   Callback = function()
   loadstring(game:HttpGet("https://obj.wearedevs.net/2/scripts/Dex%20Explorer.lua"))()
   end,
})
