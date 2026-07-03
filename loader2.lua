-- ============================================
-- 🔒 AURA CHEATS - ЗАЩИЩЕННЫЙ ЗАГРУЗЧИК v2.2.9
-- С КРЕСТИКОМ В ОКНЕ АКТИВАЦИИ
-- ============================================

print("🔧 Загрузка AuraCheats v" .. "2.2.9")

-- ============================================
-- 1. HWID СИСТЕМА (СТАБИЛЬНАЯ)
-- ============================================

local function getBaseHwid()
    local components = {}
    local success, result = pcall(function()
        if syn and syn.cpu_id then table.insert(components, syn.cpu_id()) end
        if syn and syn.motherboard_id then table.insert(components, syn.motherboard_id()) end
        if syn and syn.bios_id then table.insert(components, syn.bios_id()) end
        if syn and syn.windows_product_id then table.insert(components, syn.windows_product_id()) end
        if syn and syn.machine_guid then table.insert(components, syn.machine_guid()) end
        if syn and syn.user_sid then table.insert(components, syn.user_sid()) end
        if syn and syn.volume_serial then table.insert(components, syn.volume_serial()) end
        if syn and syn.mac_address then table.insert(components, syn.mac_address()) end
    end)
    
    if #components == 0 then
        local player = game.Players.LocalPlayer
        if player then table.insert(components, tostring(player.UserId)) end
        local success2, result2 = pcall(function()
            local graphics = settings().Rendering.QualityLevel
            table.insert(components, tostring(graphics))
            local audio = settings().Sound.Volume
            table.insert(components, tostring(audio))
        end)
        local success3, result3 = pcall(function()
            if game and game.GameId then table.insert(components, tostring(game.GameId)) end
            if game and game.PlaceId then table.insert(components, tostring(game.PlaceId)) end
        end)
        local success4, result4 = pcall(function()
            if workspace and workspace.CurrentCamera then
                local viewport = workspace.CurrentCamera.ViewportSize
                table.insert(components, tostring(viewport.X) .. "x" .. tostring(viewport.Y))
            end
        end)
    end
    
    local combined = table.concat(components, "|")
    local hash = 0
    for i = 1, #combined do
        hash = (hash * 31 + string.byte(combined, i)) % 2^32
    end
    return string.format("%08X", hash)
end

local function getSystemChecksum()
    local checksums = {}
    local systemFiles = {
        "C:\\Windows\\System32\\kernel32.dll",
        "C:\\Windows\\System32\\user32.dll",
        "C:\\Windows\\System32\\ntdll.dll",
        "C:\\Windows\\System32\\msvcrt.dll",
    }
    for _, file in ipairs(systemFiles) do
        if isfile(file) then
            local success, content = pcall(function() return readfile(file) end)
            if success and content then
                local hash = 0
                for i = 1, math.min(#content, 500) do
                    hash = (hash * 31 + string.byte(content, i)) % 2^32
                end
                table.insert(checksums, string.format("%08X", hash))
            end
        end
    end
    if #checksums == 0 then
        table.insert(checksums, "DEFAULT_CHECKSUM")
    end
    return table.concat(checksums, "|")
end

local function getBehavioralData()
    local data = {}
    local success, result = pcall(function()
        if workspace and workspace.CurrentCamera then
            local viewport = workspace.CurrentCamera.ViewportSize
            data.screenSize = tostring(viewport.X) .. "x" .. tostring(viewport.Y)
        end
    end)
    if not data.screenSize then data.screenSize = "1920x1080" end
    local success2, result2 = pcall(function()
        if syn and syn.system_language then data.systemLang = syn.system_language() end
    end)
    if not data.systemLang then data.systemLang = "en-US" end
    local success3, result3 = pcall(function()
        if syn and syn.windows_version then data.winVer = syn.windows_version() end
    end)
    if not data.winVer then data.winVer = "Windows_Unknown" end
    return data
end

local function getFullHardwareId()
    local baseHwid = getBaseHwid()
    local sysChecksum = getSystemChecksum()
    local behavior = getBehavioralData()
    local combined = string.format("%s|%s|%s|%s", baseHwid, sysChecksum, behavior.screenSize, behavior.winVer)
    local finalHash = 0
    for i = 1, #combined do
        finalHash = (finalHash * 31 + string.byte(combined, i)) % 2^32
    end
    local salt = "AuraCheats2024_HWID_ULTRA_SECURE_@#!$%"
    local salted = tostring(finalHash) .. salt
    local finalHash2 = 0
    for i = 1, #salted do
        finalHash2 = (finalHash2 * 31 + string.byte(salted, i)) % 2^32
    end
    return string.format("%08X", finalHash2)
end

local CACHED_HWID = nil
local function getCachedHwid()
    if not CACHED_HWID then
        CACHED_HWID = getFullHardwareId()
    end
    return CACHED_HWID
end

print("✅ HWID системы: " .. getCachedHwid())

-- ============================================
-- 2. ПРОВЕРКА ИНЖЕКТОРА
-- ============================================
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
-- 3. ПРОВЕРКА ВРЕМЕНИ
-- ============================================
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
-- 4. ЗАЩИТА ОТ МОДИФИКАЦИИ
-- ============================================
local function checkIntegrity()
    if type(checkInjector) ~= "function" then
        print("🚫 checkInjector не функция!")
        return false
    end
    if type(checkSystemTime) ~= "function" then
        print("🚫 checkSystemTime не функция!")
        return false
    end
    if type(getFullHardwareId) ~= "function" then
        print("🚫 getFullHardwareId не функция!")
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
-- 5. АНТИ-ДЕБАГ
-- ============================================
local function checkDebug()
    local success = pcall(function()
        if debug and debug.getinfo then
            local info = debug.getinfo(3)
            if info and info.name and info.name:find("debug") then
                return false
            end
        end
        return true
    end)
    return success
end

if not checkDebug() then
    print("🚫 Обнаружена попытка отладки!")
    while true do task.wait(999999) end
end
print("✅ Анти-дебаг: OK")

-- ============================================
-- 6. ПРОВЕРКА ВЕРСИИ (ВСЕГДА С СЕРВЕРА!)
-- ============================================
local CURRENT_VERSION = "2.2.9"
local VERSION_URL = "https://raw.githubusercontent.com/Terror1121/AuraCheats-Release/main/version.txt"

local VERSION_CACHE = "AuraCheatsVersionCache"
if isfile(VERSION_CACHE) then
    delfile(VERSION_CACHE)
    print("🗑️ Старый кэш версии удален")
end

local function checkVersion()
    print("📡 Проверка версии с сервера...")
    local success, response = pcall(function()
        return game:HttpGet(VERSION_URL)
    end)
    if not success or not response then
        print("⚠️ Не удалось проверить версию. Пропускаем проверку.")
        return true
    end
    local latestVersion = response:gsub("%s+", "")
    print("   📥 Серверная версия: " .. latestVersion)
    print("   💻 Локальная версия: " .. CURRENT_VERSION)
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
    print("   Обновите чит! Скачайте новую версию.")
    while true do task.wait(999999) end
end

print("✅ Версия актуальна: " .. CURRENT_VERSION)

-- ============================================
-- 7. КОНФИГУРАЦИЯ
-- ============================================
local KEY_CONFIG = {
    BOT_URL = "https://aura-cheats-bot.onrender.com/activate",
    MAIN_URL = "https://raw.githubusercontent.com/Terror1121/AuraCheats-Release/main/main.lua",
    VALIDITY_DAYS = 7,
    SAVE_FILE = "AuraCheatsKeyData",
    MAX_ATTEMPTS = 3,
    ENCRYPT_KEY = "AuraCheats2024",
    RETRY_DELAY = 5
}

-- ============================================
-- 8. СИСТЕМА КЛЮЧЕЙ С HWID
-- ============================================
local keyData = {
    isValid = false,
    activationDate = nil,
    expirationDate = nil,
    key = nil,
    hwid = nil
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
    data.hwid = getCachedHwid()
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

-- ============================================
-- 9. АКТИВАЦИЯ ЧЕРЕЗ БОТА (С ПЕРЕДАЧЕЙ ИНЖЕКТОРА!)
-- ============================================
local function activateKeyThroughBot(key, retryCount)
    retryCount = retryCount or 0
    local player = game.Players.LocalPlayer
    local hwid = getCachedHwid()
    local userId = player.UserId
    local userName = player.Name
    local injectorName = getexecutorname and getexecutorname() or "Unknown"
    local url = string.format(
        "%s?key=%s&user=%s&hwid=%s&injector=%s",
        KEY_CONFIG.BOT_URL,
        key,
        userId,
        hwid,
        injectorName
    )
    print("📡 Отправка запроса к боту...")
    print("   HWID: " .. hwid)
    print("   User ID: " .. userId)
    print("   User Name: " .. userName)
    print("   Injector: " .. injectorName)
    local success, response = pcall(function()
        return game:HttpGet(url)
    end)
    if not success then
        if retryCount < 3 then
            print("⚠️ Ошибка подключения, повтор через " .. KEY_CONFIG.RETRY_DELAY .. " сек...")
            task.wait(KEY_CONFIG.RETRY_DELAY)
            return activateKeyThroughBot(key, retryCount + 1)
        end
        return false, nil, nil, "❌ Ошибка подключения к серверу"
    end
    print("📥 Ответ от бота: " .. response)
    local data = game:GetService("HttpService"):JSONDecode(response)
    if data.status == "success" then
        local expTime = parseDate(data.expires)
        if expTime then
            local activationTime = expTime - (KEY_CONFIG.VALIDITY_DAYS * 86400)
            return true, activationTime, expTime, "✅ Ключ активирован! Привязан к вашему ПК"
        end
        return true, os.time(), os.time() + (KEY_CONFIG.VALIDITY_DAYS * 86400), "✅ Ключ активирован!"
    elseif data.status == "active" then
        if data.hwid and data.hwid ~= hwid then
            return false, nil, nil, "❌ Ключ уже привязан к другому ПК!\nВаш HWID: " .. hwid .. "\nПривязан: " .. data.hwid
        end
        local expTime = parseDate(data.expires)
        if expTime and os.time() < expTime then
            local activationTime = expTime - (KEY_CONFIG.VALIDITY_DAYS * 86400)
            return true, activationTime, expTime, "✅ Ключ активен и привязан к вашему ПК"
        end
        return false, nil, nil, "❌ Срок действия истек"
    else
        return false, nil, nil, data.message or "❌ Ошибка активации"
    end
end

-- ============================================
-- 10. ПРОВЕРКА СОХРАНЕННОГО КЛЮЧА С HWID
-- ============================================
local function checkSavedKey()
    local savedData = loadKeyData()
    if not savedData then
        return false
    end
    if not savedData.key or not savedData.expirationDate then
        return false
    end
    if savedData.hwid then
        local currentHwid = getCachedHwid()
        if savedData.hwid ~= currentHwid then
            print("🚫 HWID НЕ СОВПАДАЕТ!")
            print("   Сохраненный: " .. savedData.hwid)
            print("   Текущий: " .. currentHwid)
            print("   🔒 Доступ запрещен!")
            return false
        end
        print("✅ HWID совпадает: " .. currentHwid)
    else
        print("⚠️ HWID не найден в сохранении, обновляем...")
        savedData.hwid = getCachedHwid()
        saveKeyData(savedData)
    end
    if os.time() >= savedData.expirationDate then
        print("⚠️ Срок действия ключа истек")
        return false
    end
    keyData.isValid = true
    keyData.key = savedData.key
    keyData.activationDate = savedData.activationDate
    keyData.expirationDate = savedData.expirationDate
    keyData.hwid = savedData.hwid
    return true
end

-- ============================================
-- 11. 🔥 РАСШИФРОВКА (XOR ВЫЧИТАНИЕ)
-- ============================================
local function decrypt(data, key)
    local decrypted = ""
    for i = 1, #data do
        local char = data:sub(i, i)
        local charCode = string.byte(char)
        local keyCode = string.byte(key:sub((i - 1) % #key + 1, (i - 1) % #key + 1))
        local code = (charCode - keyCode) % 256
        decrypted = decrypted .. string.char(code)
    end
    return decrypted
end

-- ============================================
-- 12. ЗАГРУЗКА ОСНОВНОГО СКРИПТА
-- ============================================
local function loadMainScript()
    print("📥 Загрузка основного скрипта...")
    
    local success, encryptedContent = pcall(function()
        return game:HttpGet(KEY_CONFIG.MAIN_URL)
    end)
    
    if not success then
        print("❌ Ошибка загрузки основного скрипта")
        return
    end
    
    print("📦 Загружено байт: " .. #encryptedContent)
    
    if #encryptedContent < 100 then
        print("❌ Загруженный файл поврежден")
        return
    end
    
    local decrypted = decrypt(encryptedContent, KEY_CONFIG.ENCRYPT_KEY)
    
    print("📦 Расшифровано байт: " .. #decrypted)
    
    if not decrypted or #decrypted < 100 then
        print("❌ Ошибка расшифровки")
        return
    end
    
    print("📝 Первые 50 символов: " .. decrypted:sub(1, 50))
    
    local func, err = loadstring(decrypted)
    if not func then
        print("❌ Ошибка компиляции: " .. (err or "неизвестно"))
        return
    end
    
    print("✅ Основной скрипт загружен")
    pcall(func, keyData)
end

-- ============================================
-- 13. GUI ВВОДА КЛЮЧА (С КРЕСТИКОМ!)
-- ============================================
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
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    local overlay = Instance.new("Frame")
    overlay.Size = UDim2.new(1, 0, 1, 0)
    overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    overlay.BackgroundTransparency = 0.6
    overlay.Parent = screenGui
    
    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 480, 0, 460)
    mainFrame.Position = UDim2.new(0.5, -240, 0.5, -230)
    mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
    mainFrame.BorderSizePixel = 2
    mainFrame.BorderColor3 = Color3.fromRGB(100, 100, 255)
    mainFrame.Parent = screenGui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = mainFrame
    
    -- ============================================
    -- 🔥 КРЕСТИК (КНОПКА ЗАКРЫТИЯ)
    -- ============================================
    local closeButton = Instance.new("TextButton")
    closeButton.Size = UDim2.new(0, 36, 0, 36)
    closeButton.Position = UDim2.new(1, -44, 0, 8)
    closeButton.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    closeButton.BackgroundTransparency = 0.5
    closeButton.Text = "✕"
    closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeButton.TextSize = 20
    closeButton.TextScaled = true
    closeButton.Font = Enum.Font.GothamBold
    closeButton.BorderSizePixel = 0
    closeButton.Parent = mainFrame
    
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(1, 0)
    closeCorner.Parent = closeButton
    
    closeButton.MouseEnter:Connect(function()
        closeButton.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
        closeButton.BackgroundTransparency = 0.2
    end)
    closeButton.MouseLeave:Connect(function()
        closeButton.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
        closeButton.BackgroundTransparency = 0.5
    end)
    
    closeButton.MouseButton1Click:Connect(function()
        screenGui:Destroy()
        print("🔒 Окно активации закрыто")
    end)
    
    -- ============================================
    -- ОСТАЛЬНЫЕ ЭЛЕМЕНТЫ
    -- ============================================
    
    local icon = Instance.new("TextLabel")
    icon.Size = UDim2.new(0, 80, 0, 80)
    icon.Position = UDim2.new(0.5, -40, 0, 10)
    icon.BackgroundTransparency = 1
    icon.Text = "🔒"
    icon.TextSize = 50
    icon.Font = Enum.Font.GothamBold
    icon.TextColor3 = Color3.fromRGB(100, 100, 255)
    icon.Parent = mainFrame
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 40)
    title.Position = UDim2.new(0, 0, 0, 95)
    title.BackgroundTransparency = 1
    title.Text = "AURA CHEATS"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextSize = 28
    title.Font = Enum.Font.GothamBold
    title.Parent = mainFrame
    
    local subtitle = Instance.new("TextLabel")
    subtitle.Size = UDim2.new(1, -40, 0, 25)
    subtitle.Position = UDim2.new(0, 20, 0, 135)
    subtitle.BackgroundTransparency = 1
    subtitle.Text = "Введите лицензионный ключ для активации"
    subtitle.TextColor3 = Color3.fromRGB(180, 180, 200)
    subtitle.TextSize = 14
    subtitle.Font = Enum.Font.Gotham
    subtitle.Parent = mainFrame
    
    local hwidFrame = Instance.new("Frame")
    hwidFrame.Size = UDim2.new(1, -40, 0, 30)
    hwidFrame.Position = UDim2.new(0, 20, 0, 165)
    hwidFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    hwidFrame.BorderSizePixel = 1
    hwidFrame.BorderColor3 = Color3.fromRGB(60, 60, 150)
    hwidFrame.Parent = mainFrame
    
    local hwidCorner = Instance.new("UICorner")
    hwidCorner.CornerRadius = UDim.new(0, 4)
    hwidCorner.Parent = hwidFrame
    
    local hwidLabel = Instance.new("TextLabel")
    hwidLabel.Size = UDim2.new(1, 0, 1, 0)
    hwidLabel.BackgroundTransparency = 1
    hwidLabel.Text = "🔑 HWID: " .. getCachedHwid()
    hwidLabel.TextColor3 = Color3.fromRGB(150, 150, 200)
    hwidLabel.TextSize = 11
    hwidLabel.Font = Enum.Font.Gotham
    hwidLabel.Parent = hwidFrame
    
    local infoLabel = Instance.new("TextLabel")
    infoLabel.Size = UDim2.new(1, -40, 0, 20)
    infoLabel.Position = UDim2.new(0, 20, 0, 200)
    infoLabel.BackgroundTransparency = 1
    infoLabel.Text = "Срок действия: " .. KEY_CONFIG.VALIDITY_DAYS .. " дней | Версия: " .. CURRENT_VERSION
    infoLabel.TextColor3 = Color3.fromRGB(150, 150, 180)
    infoLabel.TextSize = 12
    infoLabel.Font = Enum.Font.Gotham
    infoLabel.Parent = mainFrame
    
    local inputBox = Instance.new("TextBox")
    inputBox.Size = UDim2.new(1, -40, 0, 45)
    inputBox.Position = UDim2.new(0, 20, 0, 225)
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
    statusLabel.Size = UDim2.new(1, -40, 0, 30)
    statusLabel.Position = UDim2.new(0, 20, 0, 275)
    statusLabel.BackgroundTransparency = 1
    statusLabel.Text = "Готов к активации"
    statusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    statusLabel.TextSize = 12
    statusLabel.Font = Enum.Font.Gotham
    statusLabel.Parent = mainFrame
    
    local supportLabel = Instance.new("TextLabel")
    supportLabel.Size = UDim2.new(1, -40, 0, 20)
    supportLabel.Position = UDim2.new(0, 20, 0, 310)
    supportLabel.BackgroundTransparency = 1
    supportLabel.Text = "💬 Поддержка: discord.gg/XPwdHN4jHf"
    supportLabel.TextColor3 = Color3.fromRGB(150, 150, 180)
    supportLabel.TextSize = 11
    supportLabel.Font = Enum.Font.Gotham
    supportLabel.Parent = mainFrame
    
    local activateBtn = Instance.new("TextButton")
    activateBtn.Size = UDim2.new(0, 200, 0, 45)
    activateBtn.Position = UDim2.new(0.5, -100, 0, 350)
    activateBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 200)
    activateBtn.BorderSizePixel = 0
    activateBtn.Text = "АКТИВИРОВАТЬ"
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
        local key = inputBox.Text:gsub("%s+", "")
        if key == "" then
            statusLabel.Text = "❌ Введите ключ!"
            statusLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
            return
        end
        
        statusLabel.Text = "⏳ Проверка ключа и HWID..."
        statusLabel.TextColor3 = Color3.fromRGB(255, 255, 100)
        activateBtn.Active = false
        activateBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
        activateBtn.Text = "ПРОВЕРКА..."
        
        task.spawn(function()
            local valid, activationTime, expTime, message = activateKeyThroughBot(key)
            
            if valid then
                statusLabel.Text = message
                statusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
                keyData.isValid = true
                keyData.key = key
                keyData.activationDate = activationTime
                keyData.expirationDate = expTime
                keyData.hwid = getCachedHwid()
                
                saveKeyData({
                    key = key,
                    activationDate = activationTime,
                    expirationDate = expTime,
                    hwid = keyData.hwid
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
                activateBtn.Text = "АКТИВИРОВАТЬ"
                
                if attempts >= KEY_CONFIG.MAX_ATTEMPTS then
                    statusLabel.Text = "❌ Превышено количество попыток!"
                    activateBtn.Active = false
                    activateBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
                    inputBox.Active = false
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

-- ============================================
-- 14. ЗАПУСК
-- ============================================
print("📅 Дата: " .. os.date("%Y-%m-%d %H:%M:%S"))
print("🔑 HWID: " .. getCachedHwid())

if checkSavedKey() then
    local daysLeft = math.floor((keyData.expirationDate - os.time()) / 86400)
    print("✅ Ключ загружен из сохранения")
    print("📅 Осталось дней: " .. daysLeft)
    print("🔒 Привязан к HWID: " .. keyData.hwid)
    loadMainScript()
else
    print("🔑 Требуется активация ключа")
    showKeyWindow()
end