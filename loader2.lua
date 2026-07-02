-- ============================================
-- AURACHEATS ЗАЩИЩЕННЫЙ ЗАГРУЗЧИК v2.2
-- ============================================

-- ============================================
-- 1. АНТИ-ДЕБАГ
-- ============================================

if debug and debug.getinfo then
    local function checkDebug()
        local info = debug.getinfo(2)
        if info and info.func then
            return true
        end
        return false
    end
    
    if checkDebug() then
        print("🚫 Обнаружена попытка отладки!")
        while true do
            task.wait(999999)
        end
    end
end

-- ============================================
-- 2. ПРОВЕРКА ИНЖЕКТОРА (ПОЛНЫЙ СПИСОК)
-- ============================================

local function checkInjector()
    local execName = getexecutorname and getexecutorname() or "Unknown"
    
    local allowed = {
        -- PC
        ["Pluto"] = true,
        ["Subzero"] = true,
        ["LX63"] = true,
        ["Drift"] = true,
        ["Valex"] = true,
        ["Bunni"] = true,
        ["Ronix"] = true,
        ["JJSploit"] = true,
        ["Solara"] = true,
        ["Xeno"] = true,
        ["Zenith"] = true,
        ["Wave"] = true,
        ["Volcano"] = true,
        ["Velocity"] = true,
        ["SirHurt"] = true,
        ["Lovreware"] = true,
        ["Swift"] = true,
        
        -- Mobile
        ["Delta"] = true,
        ["KRNL"] = true,
        ["Fluxus"] = true,
        ["Hydrogen"] = true,
        ["Arceus X"] = true,
        
        -- Mac
        ["Opiumware"] = true,
        ["Synapse Mac"] = true,
        ["Macsploit"] = true,
        
        -- Запасные варианты
        ["Synapse X"] = true,
        ["Krnl"] = true,
        ["ScriptWare"] = true,
        ["Vega X"] = true,
        ["Oxygen U"] = true,
    }
    
    if not allowed[execName] then
        print("🚫 Инжектор не поддерживается!")
        print("Используйте один из поддерживаемых инжекторов:")
        print("PC: Pluto, Subzero, LX63, Drift, Valex, Bunni, Ronix, JJSploit, Solara, Xeno, Zenith, Wave, Volcano, Velocity, SirHurt, Lovreware, Swift")
        print("Mobile: Delta, KRNL, Fluxus, Hydrogen, Arceus X")
        print("Mac: Opiumware, Synapse Mac, Macsploit")
        return false
    end
    
    return true
end

if not checkInjector() then
    while true do
        task.wait(999999)
    end
end

-- ============================================
-- 3. ПРОВЕРКА СИСТЕМНОГО ВРЕМЕНИ
-- ============================================

local function checkSystemTime()
    local currentTime = os.time()
    local minDate = os.time({year=2024, month=1, day=1})
    
    if currentTime < minDate then
        print("🚫 Обнаружена попытка обмана времени!")
        return false
    end
    
    return true
end

if not checkSystemTime() then
    while true do
        task.wait(999999)
    end
end

-- ============================================
-- 4. ЗАЩИТА ОТ МОДИФИКАЦИИ
-- ============================================

local function checkIntegrity()
    local protectedFunctions = {
        "checkInjector",
        "checkSystemTime",
        "activateKeyThroughBot",
        "loadMainScript",
        "checkVersion"
    }
    
    for _, funcName in ipairs(protectedFunctions) do
        if not _G[funcName] then
            print("🚫 Обнаружена модификация скрипта!")
            return false
        end
    end
    
    return true
end

if not checkIntegrity() then
    while true do
        task.wait(999999)
    end
end

-- ============================================
-- 5. ПРОВЕРКА ВЕРСИИ (САМОУНИЧТОЖЕНИЕ)
-- ============================================

local CURRENT_VERSION = "2.2.0"
local VERSION_URL = "https://raw.githubusercontent.com/Terror1121/AuraCheats-Release/refs/heads/main/versions.txt"

local function checkVersion()
    local success, response = pcall(function()
        return game:HttpGet(VERSION_URL)
    end)
    
    if not success then
        print("⚠️ Не удалось проверить версию. Пропускаем...")
        return true
    end
    
    local latestVersion = response:gsub("%s+", "")
    
    local function compareVersions(v1, v2)
        local function split(v)
            local parts = {}
            for part in v:gmatch("[^.]+") do
                table.insert(parts, tonumber(part) or 0)
            end
            return parts
        end
        
        local p1 = split(v1)
        local p2 = split(v2)
        
        for i = 1, math.max(#p1, #p2) do
            local n1 = p1[i] or 0
            local n2 = p2[i] or 0
            if n1 ~= n2 then
                return n1 > n2
            end
        end
        return true
    end
    
    if not compareVersions(CURRENT_VERSION, latestVersion) then
        print("🚫 ВЕРСИЯ УСТАРЕЛА!")
        print("📌 Текущая: " .. CURRENT_VERSION)
        print("📌 Актуальная: " .. latestVersion)
        print("🔄 Скачайте новую версию с официального источника!")
        
        while true do
            task.wait(999999)
        end
    end
    
    print("✅ Версия актуальна: " .. CURRENT_VERSION)
    return true
end

if not checkVersion() then
    while true do
        task.wait(999999)
    end
end

-- ============================================
-- 6. КОНФИГУРАЦИЯ КЛЮЧЕЙ (БЕЗ ПРЯМОЙ ССЫЛКИ НА keys.txt)
-- ============================================

local KEY_CONFIG = {
    BOT_URL = "https://aura-cheats-bot.onrender.com/activate",
    MAIN_URL = "https://raw.githubusercontent.com/Terror1121/AuraCheats-Release/main/main.lua",
    VALIDITY_DAYS = 7,
    SAVE_FILE = "AuraCheatsKeyData",
    MAX_ATTEMPTS = 3,
    ENCRYPT_KEY = "AuraCheats2024"
}

-- ============================================
-- 7. СИСТЕМА КЛЮЧЕЙ
-- ============================================

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
    end
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

-- ============================================
-- 8. АКТИВАЦИЯ КЛЮЧА ЧЕРЕЗ БОТА (ЕДИНСТВЕННЫЙ СПОСОБ)
-- ============================================

local function activateKeyThroughBot(key)
    local player = game.Players.LocalPlayer
    local url = KEY_CONFIG.BOT_URL .. "?key=" .. key .. "&user=" .. player.Name
    
    local success, response = pcall(function()
        return game:HttpGet(url)
    end)
    
    if not success then
        return false, nil, nil, "❌ Ошибка подключения к серверу"
    end
    
    local data = game:GetService("HttpService"):JSONDecode(response)
    
    if data.status == "success" then
        local expTime = parseDate(data.expires)
        if expTime then
            local activationTime = expTime - (KEY_CONFIG.VALIDITY_DAYS * 86400)
            return true, activationTime, expTime, "✅ Ключ активирован! Действует " .. KEY_CONFIG.VALIDITY_DAYS .. " дней"
        end
        return true, os.time(), os.time() + (KEY_CONFIG.VALIDITY_DAYS * 86400), "✅ Ключ активирован!"
    elseif data.status == "active" then
        local expTime = parseDate(data.expires)
        if expTime and os.time() < expTime then
            local activationTime = expTime - (KEY_CONFIG.VALIDITY_DAYS * 86400)
            return true, activationTime, expTime, "✅ Ключ активен"
        end
        return false, nil, nil, "❌ Срок действия ключа истек"
    else
        return false, nil, nil, data.message or "❌ Ошибка активации"
    end
end

-- ============================================
-- 9. ФУНКЦИЯ ДЛЯ РАСШИФРОВКИ (XOR)
-- ============================================

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

-- ============================================
-- 10. ЗАГРУЗКА И РАСШИФРОВКА ОСНОВНОГО СКРИПТА
-- ============================================

local function loadMainScript()
    local success, encryptedContent = pcall(function()
        return game:HttpGet(KEY_CONFIG.MAIN_URL)
    end)
    
    if not success then
        print("❌ Ошибка загрузки основного скрипта")
        return
    end
    
    local decrypted = decrypt(encryptedContent, KEY_CONFIG.ENCRYPT_KEY)
    local func = loadstring(decrypted)
    if func then
        pcall(func, keyData)
    else
        print("❌ Ошибка расшифровки основного скрипта")
    end
end

-- ============================================
-- 11. GUI ДЛЯ ВВОДА КЛЮЧА
-- ============================================

local function showKeyWindow()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "KeySystem"
    screenGui.Parent = game.Players.LocalPlayer.PlayerGui
    screenGui.ResetOnSpawn = false

    local overlay = Instance.new("Frame")
    overlay.Size = UDim2.new(1, 0, 1, 0)
    overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    overlay.BackgroundTransparency = 0.5
    overlay.Parent = screenGui

    local background = Instance.new("Frame")
    background.Size = UDim2.new(0, 450, 0, 380)
    background.Position = UDim2.new(0.5, -225, 0.5, -190)
    background.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    background.BackgroundTransparency = 0.05
    background.BorderSizePixel = 2
    background.BorderColor3 = Color3.fromRGB(100, 100, 255)
    background.Parent = screenGui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = background

    local icon = Instance.new("TextLabel")
    icon.Size = UDim2.new(0, 60, 0, 60)
    icon.Position = UDim2.new(0.5, -30, 0, 10)
    icon.BackgroundTransparency = 1
    icon.Text = "🔐"
    icon.TextSize = 40
    icon.Font = Enum.Font.Gotham
    icon.Parent = background

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 40)
    title.Position = UDim2.new(0, 0, 0, 70)
    title.BackgroundTransparency = 1
    title.Text = "Активация AuraCheats"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextSize = 24
    title.Font = Enum.Font.GothamBold
    title.Parent = background

    local subtitle = Instance.new("TextLabel")
    subtitle.Size = UDim2.new(1, -40, 0, 20)
    subtitle.Position = UDim2.new(0, 20, 0, 115)
    subtitle.BackgroundTransparency = 1
    subtitle.Text = "Введите ключ для активации чита"
    subtitle.TextColor3 = Color3.fromRGB(180, 180, 200)
    subtitle.TextSize = 14
    subtitle.Font = Enum.Font.Gotham
    subtitle.Parent = background

    local infoLabel = Instance.new("TextLabel")
    infoLabel.Size = UDim2.new(1, -40, 0, 20)
    infoLabel.Position = UDim2.new(0, 20, 0, 140)
    infoLabel.BackgroundTransparency = 1
    infoLabel.Text = "Срок действия: " .. KEY_CONFIG.VALIDITY_DAYS .. " дней с момента активации"
    infoLabel.TextColor3 = Color3.fromRGB(150, 150, 180)
    infoLabel.TextSize = 12
    infoLabel.Font = Enum.Font.Gotham
    infoLabel.Parent = background

    local inputBox = Instance.new("TextBox")
    inputBox.Size = UDim2.new(1, -40, 0, 45)
    inputBox.Position = UDim2.new(0, 20, 0, 170)
    inputBox.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    inputBox.BorderSizePixel = 1
    inputBox.BorderColor3 = Color3.fromRGB(80, 80, 200)
    inputBox.Text = ""
    inputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    inputBox.TextSize = 18
    inputBox.Font = Enum.Font.Gotham
    inputBox.PlaceholderText = "Введите ключ..."
    inputBox.ClearTextOnFocus = false
    inputBox.Parent = background

    local inputCorner = Instance.new("UICorner")
    inputCorner.CornerRadius = UDim.new(0, 8)
    inputCorner.Parent = inputBox

    local statusLabel = Instance.new("TextLabel")
    statusLabel.Size = UDim2.new(1, -40, 0, 25)
    statusLabel.Position = UDim2.new(0, 20, 0, 220)
    statusLabel.BackgroundTransparency = 1
    statusLabel.Text = "Введите ключ для активации"
    statusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    statusLabel.TextSize = 12
    statusLabel.Font = Enum.Font.Gotham
    statusLabel.Parent = background

    local supportLabel = Instance.new("TextLabel")
    supportLabel.Size = UDim2.new(1, -40, 0, 20)
    supportLabel.Position = UDim2.new(0, 20, 0, 245)
    supportLabel.BackgroundTransparency = 1
    supportLabel.Text = "По вопросам ключей: discord.gg/XPwdHN4jHf"
    supportLabel.TextColor3 = Color3.fromRGB(150, 150, 180)
    supportLabel.TextSize = 11
    supportLabel.Font = Enum.Font.Gotham
    supportLabel.Parent = background

    local activateBtn = Instance.new("TextButton")
    activateBtn.Size = UDim2.new(0, 180, 0, 45)
    activateBtn.Position = UDim2.new(0.5, -90, 0, 280)
    activateBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 200)
    activateBtn.BorderSizePixel = 0
    activateBtn.Text = "Активировать"
    activateBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    activateBtn.TextSize = 16
    activateBtn.Font = Enum.Font.GothamBold
    activateBtn.Parent = background

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

    activateBtn.MouseButton1Click:Connect(function()
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

                local saveData = {
                    key = key,
                    activationDate = activationTime,
                    expirationDate = expTime
                }
                saveKeyData(saveData)

                task.wait(1.5)
                screenGui:Destroy()
                loadMainScript()
            else
                attempts = attempts + 1
                statusLabel.Text = message or "❌ Ошибка активации"
                statusLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
                activateBtn.Active = true
                activateBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 200)

                if attempts >= KEY_CONFIG.MAX_ATTEMPTS then
                    statusLabel.Text = "❌ Превышено количество попыток!"
                    activateBtn.Active = false
                    activateBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
                end
            end
        end)
    end)

    inputBox.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            activateBtn.MouseButton1Click:Fire()
        end
    end)
end

-- ============================================
-- 12. ПРОВЕРКА СОХРАНЕННОГО КЛЮЧА
-- ============================================

local function checkSavedKey()
    local savedData = loadKeyData()
    if savedData and savedData.key and savedData.expirationDate then
        local currentTime = os.time()
        if currentTime < savedData.expirationDate then
            keyData.isValid = true
            keyData.key = savedData.key
            keyData.activationDate = savedData.activationDate
            keyData.expirationDate = savedData.expirationDate
            return true
        end
    end
    return false
end

-- ============================================
-- 13. ЗАПУСК
-- ============================================

if checkSavedKey() then
    print("✅ Ключ загружен из сохранения")
    print("📅 Действует до: " .. os.date("%d.%m.%Y %H:%M:%S", keyData.expirationDate))
    loadMainScript()
else
    print("🔑 Требуется активация ключа")
    showKeyWindow()
end
