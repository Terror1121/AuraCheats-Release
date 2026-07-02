print("🔧 Загрузка AuraCheats v" .. "2.2.0")

-- ============================================
-- 1. ПРОВЕРКА ИНЖЕКТОРА
-- ============================================
print("📌 [1/6] Проверка инжектора...")

local INJECTORS = {
    ["Pluto"]=true,["Subzero"]=true,["LX63"]=true,["Drift"]=true,
    ["Valex"]=true,["Bunni"]=true,["Ronix"]=true,["JJSploit"]=true,
    ["Solara"]=true,["Xeno"]=true,["Zenith"]=true,["Wave"]=true,
    ["Volcano"]=true,["Velocity"]=true,["SirHurt"]=true,
    ["Lovreware"]=true,["Swift"]=true,
    ["Delta"]=true,["KRNL"]=true,["Fluxus"]=true,
    ["Hydrogen"]=true,["Arceus X"]=true,
    ["Opiumware"]=true,["Synapse Mac"]=true,["Macsploit"]=true,
    ["Synapse X"]=true,["Krnl"]=true,["ScriptWare"]=true,
    ["Vega X"]=true,["Oxygen U"]=true,
    ["Celery"]=true,["Coco"]=true,["Electron"]=true,
    ["Evon"]=true,["Kiwi X"]=true,["Mystic"]=true,
    ["Nova"]=true,["Owlware"]=true,["Raccoon"]=true,
    ["Skisploit"]=true,["Tora"]=true,["W-Proxy"]=true
}

local function checkInjector()
    local execName = getexecutorname and getexecutorname() or "Unknown"
    if not INJECTORS[execName] then
        print("🚫 Инжектор не поддерживается: " .. execName)
        return false
    end
    print("✅ Инжектор: " .. execName)
    return true
end

if not checkInjector() then
    while true do task.wait(999999) end
end

-- ============================================
-- 2. ПРОВЕРКА ВРЕМЕНИ
-- ============================================
print("📌 [2/6] Проверка времени...")

local function checkSystemTime()
    local currentTime = os.time()
    if currentTime < os.time({year=2023, month=1, day=1}) then
        print("🚫 Обман времени!")
        return false
    end
    print("✅ Системное время: " .. os.date("%Y-%m-%d %H:%M:%S", currentTime))
    return true
end

if not checkSystemTime() then
    while true do task.wait(999999) end
end

-- ============================================
-- 3. ЗАЩИТА ОТ МОДИФИКАЦИИ (УПРОЩЕННАЯ)
-- ============================================
print("📌 [3/6] Проверка целостности...")

-- Просто проверяем, что функции существуют
local function checkIntegrity()
    if type(checkInjector) ~= "function" then
        print("🚫 checkInjector не функция!")
        return false
    end
    if type(checkSystemTime) ~= "function" then
        print("🚫 checkSystemTime не функция!")
        return false
    end
    return true
end

if not checkIntegrity() then
    print("🔴 Нарушение целостности!")
    while true do task.wait(999999) end
end

print("✅ Защита целостности: OK")

-- ============================================
-- 4. АНТИ-ДЕБАГ (УПРОЩЕННЫЙ)
-- ============================================
print("📌 [4/6] Анти-дебаг...")

local function checkDebug()
    -- Простая проверка
    if debug and debug.getinfo then
        local success, info = pcall(function()
            return debug.getinfo(3)
        end)
        if success and info and info.name and info.name:find("debug") then
            return false
        end
    end
    return true
end

if not checkDebug() then
    print("🚫 Обнаружена попытка отладки!")
    while true do task.wait(999999) end
end
print("✅ Анти-дебаг: OK")

-- ============================================
-- 5. ПРОВЕРКА ВЕРСИИ
-- ============================================
print("📌 [5/6] Проверка версии...")

local CURRENT_VERSION = "2.2.0"
local VERSION_URL = "https://raw.githubusercontent.com/Terror1121/AuraCheats-Release/main/version.txt"

local function checkVersion()
    local success, response = pcall(function()
        return game:HttpGet(VERSION_URL)
    end)
    
    if not success then
        print("⚠️ Не удалось проверить версию")
        return true
    end
    
    local latestVersion = response:gsub("%s+", "")
    
    local function splitVersion(v)
        local parts = {}
        for part in v:gmatch("[^.]+") do
            table.insert(parts, tonumber(part) or 0)
        end
        return parts
    end
    
    local current = splitVersion(CURRENT_VERSION)
    local latest = splitVersion(latestVersion)
    
    for i = 1, math.max(#current, #latest) do
        local c = current[i] or 0
        local l = latest[i] or 0
        if c ~= l then
            return c > l
        end
    end
    
    return true
end

if not checkVersion() then
    print("🚫 ВЕРСИЯ УСТАРЕЛА!")
    while true do task.wait(999999) end
end

print("✅ Версия актуальна: " .. CURRENT_VERSION)

-- ============================================
-- 6. ДАЛЬНЕЙШИЙ КОД
-- ============================================
print("📌 [6/6] Загрузка системы ключей...")

local KEY_CONFIG = {
    BOT_URL = "https://aura-cheats-bot.onrender.com/activate",
    MAIN_URL = "https://raw.githubusercontent.com/Terror1121/AuraCheats-Release/main/main.lua",
    VALIDITY_DAYS = 7,
    SAVE_FILE = "AuraCheatsKeyData",
    MAX_ATTEMPTS = 3,
    ENCRYPT_KEY = "AuraCheats2024"
}

local keyData = {
    isValid = false,
    activationDate = nil,
    expirationDate = nil,
    key = nil
}

local function parseDate(dateString)
    if not dateString then return nil end
    local year, month, day, hour, minute, second = dateString:match("(%d+)-(%d+)-(%d+)_(%d+):(%d+):(%d+)")
    if year and month and day and hour and minute and second then
        return os.time({
            year = tonumber(year),
            month = tonumber(month),
            day = tonumber(day),
            hour = tonumber(hour),
            min = tonumber(minute),
            sec = tonumber(second)
        })
    end
    return nil
end

local function saveKeyData(data)
    local success, json = pcall(function()
        return game:GetService("HttpService"):JSONEncode(data)
    end)
    if success and json then
        writefile(KEY_CONFIG.SAVE_FILE, json)
        return true
    end
    return false
end

local function loadKeyData()
    if isfile(KEY_CONFIG.SAVE_FILE) then
        local success, data = pcall(function()
            return game:GetService("HttpService"):JSONDecode(readfile(KEY_CONFIG.SAVE_FILE))
        end)
        if success and data then
            return data
        end
    end
    return nil
end

local function activateKeyThroughBot(key)
    local player = game.Players.LocalPlayer
    local url = KEY_CONFIG.BOT_URL .. "?key=" .. key .. "&user=" .. player.Name
    
    local success, response = pcall(function()
        return game:HttpGet(url)
    end)
    
    if not success then
        return false, nil, nil, "❌ Ошибка подключения"
    end
    
    local data = game:GetService("HttpService"):JSONDecode(response)
    
    if data.status == "success" then
        local expTime = parseDate(data.expires)
        if expTime then
            local activationTime = expTime - (KEY_CONFIG.VALIDITY_DAYS * 86400)
            return true, activationTime, expTime, "✅ Ключ активирован!"
        end
        return true, os.time(), os.time() + (KEY_CONFIG.VALIDITY_DAYS * 86400), "✅ Ключ активирован!"
    elseif data.status == "active" then
        local expTime = parseDate(data.expires)
        if expTime and os.time() < expTime then
            local activationTime = expTime - (KEY_CONFIG.VALIDITY_DAYS * 86400)
            return true, activationTime, expTime, "✅ Ключ активен"
        end
        return false, nil, nil, "❌ Срок истек"
    else
        return false, nil, nil, data.message or "❌ Ошибка"
    end
end

local function decrypt(data, key)
    local decrypted = ""
    for i = 1, #data do
        local char = data:sub(i, i)
        local charCode = string.byte(char)
        local keyCode = string.byte(key:sub((i-1) % #key + 1, (i-1) % #key + 1))
        local code = (charCode - keyCode) % 256
        decrypted = decrypted .. string.char(code)
    end
    return decrypted
end

local function loadMainScript()
    print("📥 Загрузка основного скрипта...")
    
    local success, encryptedContent = pcall(function()
        return game:HttpGet(KEY_CONFIG.MAIN_URL)
    end)
    
    if not success then
        print("❌ Ошибка загрузки основного скрипта")
        return
    end
    
    if #encryptedContent < 100 then
        print("❌ Загруженный файл поврежден")
        return
    end
    
    local decrypted = decrypt(encryptedContent, KEY_CONFIG.ENCRYPT_KEY)
    
    if not decrypted or #decrypted < 100 then
        print("❌ Ошибка расшифровки")
        return
    end
    
    local func, err = loadstring(decrypted)
    if not func then
        print("❌ Ошибка компиляции: " .. (err or "неизвестно"))
        return
    end
    
    print("✅ Основной скрипт загружен")
    pcall(func, keyData)
end

local function showKeyWindow()
    local player = game.Players.LocalPlayer
    if not player or not player.PlayerGui then
        print("❌ Не удалось создать GUI")
        return
    end
    
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "AuraKeySystem"
    screenGui.Parent = player.PlayerGui
    screenGui.ResetOnSpawn = false
    
    local overlay = Instance.new("Frame")
    overlay.Size = UDim2.new(1, 0, 1, 0)
    overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    overlay.BackgroundTransparency = 0.6
    overlay.Parent = screenGui
    
    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 450, 0, 380)
    mainFrame.Position = UDim2.new(0.5, -225, 0.5, -190)
    mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
    mainFrame.BorderSizePixel = 2
    mainFrame.BorderColor3 = Color3.fromRGB(100, 100, 255)
    mainFrame.Parent = screenGui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = mainFrame
    
    local icon = Instance.new("TextLabel")
    icon.Size = UDim2.new(0, 60, 0, 60)
    icon.Position = UDim2.new(0.5, -30, 0, 10)
    icon.BackgroundTransparency = 1
    icon.Text = "🔐"
    icon.TextSize = 40
    icon.Font = Enum.Font.Gotham
    icon.Parent = mainFrame
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 40)
    title.Position = UDim2.new(0, 0, 0, 75)
    title.BackgroundTransparency = 1
    title.Text = "Активация AuraCheats"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextSize = 24
    title.Font = Enum.Font.GothamBold
    title.Parent = mainFrame
    
    local subtitle = Instance.new("TextLabel")
    subtitle.Size = UDim2.new(1, -40, 0, 20)
    subtitle.Position = UDim2.new(0, 20, 0, 120)
    subtitle.BackgroundTransparency = 1
    subtitle.Text = "Введите ключ для активации"
    subtitle.TextColor3 = Color3.fromRGB(180, 180, 200)
    subtitle.TextSize = 14
    subtitle.Font = Enum.Font.Gotham
    subtitle.Parent = mainFrame
    
    local infoLabel = Instance.new("TextLabel")
    infoLabel.Size = UDim2.new(1, -40, 0, 20)
    infoLabel.Position = UDim2.new(0, 20, 0, 145)
    infoLabel.BackgroundTransparency = 1
    infoLabel.Text = "Срок действия: " .. KEY_CONFIG.VALIDITY_DAYS .. " дней"
    infoLabel.TextColor3 = Color3.fromRGB(150, 150, 180)
    infoLabel.TextSize = 12
    infoLabel.Font = Enum.Font.Gotham
    infoLabel.Parent = mainFrame
    
    local inputBox = Instance.new("TextBox")
    inputBox.Size = UDim2.new(1, -40, 0, 45)
    inputBox.Position = UDim2.new(0, 20, 0, 175)
    inputBox.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    inputBox.BorderSizePixel = 2
    inputBox.BorderColor3 = Color3.fromRGB(80, 80, 200)
    inputBox.Text = ""
    inputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    inputBox.TextSize = 18
    inputBox.Font = Enum.Font.Gotham
    inputBox.PlaceholderText = "Введите ключ..."
    inputBox.ClearTextOnFocus = false
    inputBox.Parent = mainFrame
    
    local inputCorner = Instance.new("UICorner")
    inputCorner.CornerRadius = UDim.new(0, 8)
    inputCorner.Parent = inputBox
    
    local statusLabel = Instance.new("TextLabel")
    statusLabel.Size = UDim2.new(1, -40, 0, 25)
    statusLabel.Position = UDim2.new(0, 20, 0, 225)
    statusLabel.BackgroundTransparency = 1
    statusLabel.Text = "Введите ключ"
    statusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    statusLabel.TextSize = 12
    statusLabel.Font = Enum.Font.Gotham
    statusLabel.Parent = mainFrame
    
    local supportLabel = Instance.new("TextLabel")
    supportLabel.Size = UDim2.new(1, -40, 0, 20)
    supportLabel.Position = UDim2.new(0, 20, 0, 255)
    supportLabel.BackgroundTransparency = 1
    supportLabel.Text = "По вопросам: discord.gg/XPwdHN4jHf"
    supportLabel.TextColor3 = Color3.fromRGB(150, 150, 180)
    supportLabel.TextSize = 11
    supportLabel.Font = Enum.Font.Gotham
    supportLabel.Parent = mainFrame
    
    local activateBtn = Instance.new("TextButton")
    activateBtn.Size = UDim2.new(0, 180, 0, 45)
    activateBtn.Position = UDim2.new(0.5, -90, 0, 290)
    activateBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 200)
    activateBtn.BorderSizePixel = 0
    activateBtn.Text = "Активировать"
    activateBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    activateBtn.TextSize = 16
    activateBtn.Font = Enum.Font.GothamBold
    activateBtn.Parent = mainFrame
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = activateBtn
    
    activateBtn.MouseEnter:Connect(function()
        activateBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 220)
    end)
    activateBtn.MouseLeave:Connect(function()
        activateBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 200)
    end)
    
    local attempts = 0
    
    local function activateKey()
        local key = inputBox.Text
        if key == "" then
            statusLabel.Text = "❌ Введите ключ!"
            statusLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
            return
        end
        
        statusLabel.Text = "⏳ Проверка ключа..."
        statusLabel.TextColor3 = Color3.fromRGB(255, 255, 100)
        activateBtn.Active = false
        activateBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
        
        task.spawn(function()
            local valid, activationTime, expTime, message = activateKeyThroughBot(key)
            
            if valid then
                statusLabel.Text = message
                statusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
                keyData.isValid = true
                keyData.key = key
                keyData.activationDate = activationTime
                keyData.expirationDate = expTime
                saveKeyData({
                    key = key,
                    activationDate = activationTime,
                    expirationDate = expTime
                })
                task.wait(1.5)
                screenGui:Destroy()
                loadMainScript()
            else
                attempts = attempts + 1
                statusLabel.Text = message or "❌ Ошибка"
                statusLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
                activateBtn.Active = true
                activateBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 200)
                if attempts >= KEY_CONFIG.MAX_ATTEMPTS then
                    statusLabel.Text = "❌ Превышено попыток!"
                    activateBtn.Active = false
                    activateBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
                end
            end
        end)
    end
    
    activateBtn.MouseButton1Click:Connect(activateKey)
    inputBox.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            activateKey()
        end
    end)
end

local function checkSavedKey()
    local savedData = loadKeyData()
    if not savedData then
        return false
    end
    if not savedData.key or not savedData.expirationDate then
        return false
    end
    if os.time() >= savedData.expirationDate then
        print("⚠️ Срок действия ключа истек")
        return false
    end
    keyData.isValid = true
    keyData.key = savedData.key
    keyData.activationDate = savedData.activationDate
    keyData.expirationDate = savedData.expirationDate
    return true
end

print("✅ Система ключей загружена")

if checkSavedKey() then
    local daysLeft = math.floor((keyData.expirationDate - os.time()) / 86400)
    print("✅ Ключ загружен из сохранения")
    print("📅 Осталось дней: " .. daysLeft)
    loadMainScript()
else
    print("🔑 Требуется активация ключа")
    showKeyWindow()
end
