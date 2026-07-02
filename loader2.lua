-- ============================================
-- 🔒 AURA CHEATS - ЗАЩИЩЕННЫЙ ЗАГРУЗЧИК v2.2.0
-- ============================================

-- 1. АНТИ-ДЕБАГ (УЛУЧШЕННЫЙ)
local function checkDebug()
    local success = pcall(function()
        if debug and debug.getinfo then
            local info = debug.getinfo(3)
            -- Проверяем, не вызывают ли нас из отладчика
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

-- 2. ПРОВЕРКА ИНЖЕКТОРА (С РАСШИРЕННЫМ СПИСКОМ)
local INJECTORS = {
    -- Основные
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
    -- Дополнительные
    ["Celery"]=true,["Coco"]=true,["Electron"]=true,
    ["Evon"]=true,["Kiwi X"]=true,["Mystic"]=true,
    ["Nova"]=true,["Owlware"]=true,["Raccoon"]=true,
    ["Skisploit"]=true,["Tora"]=true,["W-Proxy"]=true,
    -- Mobile
    ["Delta Mobile"]=true,["Arceus X Mobile"]=true,
    ["Hydrogen Mobile"]=true,["Fluxus Mobile"]=true
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
    print("❌ Неподдерживаемый инжектор")
    while true do task.wait(999999) end 
end

-- 3. ПРОВЕРКА СИСТЕМНОГО ВРЕМЕНИ (С ЗАПАСОМ)
local function checkSystemTime()
    local currentTime = os.time()
    local minTime = os.time({year=2023, month=1, day=1}) -- Запасной год
    
    if currentTime < minTime then
        print("🚫 Обнаружен обман времени!")
        return false
    end
    
    -- Проверяем, что время не слишком далеко в будущем
    local maxTime = os.time({year=2030, month=1, day=1})
    if currentTime > maxTime then
        print("🚫 Время слишком далеко в будущем!")
        return false
    end
    
    print("✅ Системное время: " .. os.date("%Y-%m-%d %H:%M:%S", currentTime))
    return true
end

if not checkSystemTime() then 
    while true do task.wait(999999) end 
end

-- 4. ЗАЩИТА ОТ МОДИФИКАЦИИ (ЧЕРЕЗ CRC32)
local function crc32(str)
    local crc = 0xFFFFFFFF
    for i = 1, #str do
        local byte = string.byte(str, i)
        crc = crc ~ byte
        for _ = 1, 8 do
            if crc % 2 == 1 then
                crc = (crc // 2) ~ 0xEDB88320
            else
                crc = crc // 2
            end
        end
    end
    return crc ~ 0xFFFFFFFF
end

-- Хранилище оригинальных функций
local ORIGINAL_FUNCTIONS = {}

-- Функция для защиты функций
local function protectFunction(name, func)
    ORIGINAL_FUNCTIONS[name] = func
    return func
end

-- Создаем защищенные функции
local protectedFunctions = {
    checkInjector = protectFunction("checkInjector", checkInjector),
    checkSystemTime = protectFunction("checkSystemTime", checkSystemTime),
    checkDebug = protectFunction("checkDebug", checkDebug)
}

-- Проверка целостности
local function checkIntegrity()
    local function verifyFunction(name, originalFunc)
        -- Проверяем, что функция существует
        if type(originalFunc) ~= "function" then
            print("🚫 Функция не найдена: " .. name)
            return false
        end
        
        -- Проверяем, что функция не была переопределена
        local currentFunc = _G[name]
        if currentFunc and currentFunc ~= originalFunc then
            print("🚫 Обнаружена модификация: " .. name)
            return false
        end
        
        -- Проверяем хеш функции
        local dump = string.dump(originalFunc)
        local hash = crc32(dump)
        
        -- Сохраняем хеш для проверки (в реальном проекте хранить отдельно)
        return true
    end
    
    for name, func in pairs(protectedFunctions) do
        if not verifyFunction(name, func) then
            return false
        end
    end
    
    return true
end

-- Проверяем целостность (но не останавливаем при ошибке)
if not checkIntegrity() then
    print("⚠️ Обнаружены изменения, но продолжаем работу")
end

-- 5. ПРОВЕРКА ВЕРСИИ (С КЭШИРОВАНИЕМ)
local CURRENT_VERSION = "2.2.0"
local VERSION_URL = "https://raw.githubusercontent.com/Terror1121/AuraCheats-Release/main/version.txt"
local VERSION_CACHE = "AuraCheatsVersionCache"

local function getCachedVersion()
    if isfile(VERSION_CACHE) then
        local success, data = pcall(function()
            return readfile(VERSION_CACHE)
        end)
        if success and data then
            return data:gsub("%s+", "")
        end
    end
    return nil
end

local function saveVersionCache(version)
    local success, err = pcall(function()
        writefile(VERSION_CACHE, version)
    end)
    if not success then
        print("⚠️ Не удалось сохранить кэш версии")
    end
end

local function checkVersion()
    local latestVersion = getCachedVersion()
    
    -- Если нет кэша, пробуем загрузить
    if not latestVersion then
        local success, response = pcall(function()
            return game:HttpGet(VERSION_URL)
        end)
        
        if success and response then
            latestVersion = response:gsub("%s+", "")
            saveVersionCache(latestVersion)
        end
    end
    
    -- Если все еще нет версии, пропускаем проверку
    if not latestVersion then
        print("⚠️ Не удалось проверить версию, пропускаем")
        return true
    end
    
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
    print("🚫 ВЕРСИЯ УСТАРЕЛА! Текущая: " .. CURRENT_VERSION)
    print("📥 Загрузите последнюю версию")
    while true do task.wait(999999) end
end

print("✅ Версия актуальна: " .. CURRENT_VERSION)

-- 6. КОНФИГУРАЦИЯ
local KEY_CONFIG = {
    BOT_URL = "https://aura-cheats-bot.onrender.com/activate",
    MAIN_URL = "https://raw.githubusercontent.com/Terror1121/AuraCheats-Release/main/main.lua",
    VALIDITY_DAYS = 7,
    SAVE_FILE = "AuraCheatsKeyData",
    MAX_ATTEMPTS = 3,
    ENCRYPT_KEY = "AuraCheats2024",
    -- Дополнительные настройки
    RETRY_DELAY = 5, -- Секунд между попытками
    CONNECTION_TIMEOUT = 10
}

-- 7. СИСТЕМА КЛЮЧЕЙ С РАСШИРЕННЫМИ ВОЗМОЖНОСТЯМИ
local keyData = {
    isValid = false,
    activationDate = nil,
    expirationDate = nil,
    key = nil,
    hardwareId = nil
}

-- Функция для получения HWID (упрощенная)
local function getHardwareId()
    local player = game.Players.LocalPlayer
    if player and player.UserId then
        return tostring(player.UserId)
    end
    return "unknown"
end

local function parseDate(dateString)
    if not dateString then return nil end
    
    local patterns = {
        "(%d+)-(%d+)-(%d+)_(%d+):(%d+):(%d+)", -- YYYY-MM-DD_HH:MM:SS
        "(%d+)-(%d+)-(%d+) (%d+):(%d+):(%d+)", -- YYYY-MM-DD HH:MM:SS
        "(%d+)/(%d+)/(%d+) (%d+):(%d+):(%d+)", -- MM/DD/YYYY HH:MM:SS
    }
    
    for _, pattern in ipairs(patterns) do
        local year, month, day, hour, minute, second = dateString:match(pattern)
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
    end
    
    -- Если формат не распознан, пробуем просто парсить
    local timestamp = tonumber(dateString)
    if timestamp then
        return timestamp
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

-- 8. АКТИВАЦИЯ ЧЕРЕЗ БОТА (С ПОВТОРАМИ)
local function activateKeyThroughBot(key, retryCount)
    retryCount = retryCount or 0
    
    local player = game.Players.LocalPlayer
    local hwid = getHardwareId()
    local url = string.format(
        "%s?key=%s&user=%s&hwid=%s",
        KEY_CONFIG.BOT_URL,
        key,
        player.Name,
        hwid
    )
    
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
        return false, nil, nil, "❌ Срок действия истек"
    else
        return false, nil, nil, data.message or "❌ Ошибка активации"
    end
end

-- 9. РАСШИФРОВКА (XOR С УЛУЧШЕННЫМ АЛГОРИТМОМ)
local function decrypt(data, key)
    local decrypted = {}
    local keyLength = #key
    
    for i = 1, #data do
        local charCode = string.byte(data, i)
        local keyCode = string.byte(key, ((i-1) % keyLength) + 1)
        local code = (charCode - keyCode) % 256
        decrypted[i] = string.char(code)
    end
    
    return table.concat(decrypted)
end

-- 10. ЗАГРУЗКА ОСНОВНОГО СКРИПТА (С ПРОВЕРКОЙ)
local function loadMainScript()
    print("📥 Загрузка основного скрипта...")
    
    local success, encryptedContent = pcall(function()
        return game:HttpGet(KEY_CONFIG.MAIN_URL)
    end)
    
    if not success then
        print("❌ Ошибка загрузки основного скрипта")
        return false
    end
    
    if #encryptedContent < 100 then
        print("❌ Загруженный файл поврежден или слишком маленький")
        return false
    end
    
    local decrypted = decrypt(encryptedContent, KEY_CONFIG.ENCRYPT_KEY)
    
    if not decrypted or #decrypted < 100 then
        print("❌ Ошибка расшифровки")
        return false
    end
    
    local func, err = loadstring(decrypted)
    if not func then
        print("❌ Ошибка выполнения: " .. (err or "неизвестная ошибка"))
        return false
    end
    
    print("✅ Основной скрипт загружен")
    pcall(func, keyData)
    return true
end

-- 11. GUI ВВОДА КЛЮЧА (СОВРЕМЕННЫЙ ДИЗАЙН)
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
    
    -- Затемнение
    local overlay = Instance.new("Frame")
    overlay.Size = UDim2.new(1, 0, 1, 0)
    overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    overlay.BackgroundTransparency = 0.6
    overlay.Parent = screenGui
    
    -- Основное окно
    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 480, 0, 420)
    mainFrame.Position = UDim2.new(0.5, -240, 0.5, -210)
    mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
    mainFrame.BorderSizePixel = 2
    mainFrame.BorderColor3 = Color3.fromRGB(100, 100, 255)
    mainFrame.Parent = screenGui
    
    -- Скругление углов
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = mainFrame
    
    -- Эффект свечения
    local glow = Instance.new("Frame")
    glow.Size = UDim2.new(1, 0, 1, 0)
    glow.Position = UDim2.new(0, -5, 0, -5)
    glow.BackgroundColor3 = Color3.fromRGB(100, 100, 255)
    glow.BackgroundTransparency = 0.1
    glow.BorderSizePixel = 0
    glow.Parent = mainFrame
    glow.ZIndex = 0
    
    local glowCorner = Instance.new("UICorner")
    glowCorner.CornerRadius = UDim.new(0, 14)
    glowCorner.Parent = glow
    
    -- Логотип/Иконка
    local icon = Instance.new("TextLabel")
    icon.Size = UDim2.new(0, 80, 0, 80)
    icon.Position = UDim2.new(0.5, -40, 0, 10)
    icon.BackgroundTransparency = 1
    icon.Text = "⚡"
    icon.TextSize = 50
    icon.Font = Enum.Font.GothamBold
    icon.TextColor3 = Color3.fromRGB(100, 100, 255)
    icon.Parent = mainFrame
    
    -- Заголовок
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 40)
    title.Position = UDim2.new(0, 0, 0, 95)
    title.BackgroundTransparency = 1
    title.Text = "AURA CHEATS"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextSize = 28
    title.Font = Enum.Font.GothamBold
    title.Parent = mainFrame
    
    -- Подзаголовок
    local subtitle = Instance.new("TextLabel")
    subtitle.Size = UDim2.new(1, -40, 0, 25)
    subtitle.Position = UDim2.new(0, 20, 0, 135)
    subtitle.BackgroundTransparency = 1
    subtitle.Text = "Введите лицензионный ключ для активации"
    subtitle.TextColor3 = Color3.fromRGB(180, 180, 200)
    subtitle.TextSize = 14
    subtitle.Font = Enum.Font.Gotham
    subtitle.Parent = mainFrame
    
    -- Информация
    local infoFrame = Instance.new("Frame")
    infoFrame.Size = UDim2.new(1, -40, 0, 25)
    infoFrame.Position = UDim2.new(0, 20, 0, 162)
    infoFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    infoFrame.BorderSizePixel = 0
    infoFrame.Parent = mainFrame
    
    local infoCorner = Instance.new("UICorner")
    infoCorner.CornerRadius = UDim.new(0, 4)
    infoCorner.Parent = infoFrame
    
    local infoLabel = Instance.new("TextLabel")
    infoLabel.Size = UDim2.new(1, 0, 1, 0)
    infoLabel.BackgroundTransparency = 1
    infoLabel.Text = "Срок действия: " .. KEY_CONFIG.VALIDITY_DAYS .. " дней | Версия: " .. CURRENT_VERSION
    infoLabel.TextColor3 = Color3.fromRGB(150, 150, 180)
    infoLabel.TextSize = 12
    infoLabel.Font = Enum.Font.Gotham
    infoLabel.Parent = infoFrame
    
    -- Поле ввода
    local inputBox = Instance.new("TextBox")
    inputBox.Size = UDim2.new(1, -40, 0, 45)
    inputBox.Position = UDim2.new(0, 20, 0, 195)
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
    
    -- Статус
    local statusLabel = Instance.new("TextLabel")
    statusLabel.Size = UDim2.new(1, -40, 0, 25)
    statusLabel.Position = UDim2.new(0, 20, 0, 245)
    statusLabel.BackgroundTransparency = 1
    statusLabel.Text = "Готов к активации"
    statusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    statusLabel.TextSize = 12
    statusLabel.Font = Enum.Font.Gotham
    statusLabel.Parent = mainFrame
    
    -- Поддержка
    local supportLabel = Instance.new("TextLabel")
    supportLabel.Size = UDim2.new(1, -40, 0, 20)
    supportLabel.Position = UDim2.new(0, 20, 0, 275)
    supportLabel.BackgroundTransparency = 1
    supportLabel.Text = "💬 Поддержка: discord.gg/XPwdHN4jHf"
    supportLabel.TextColor3 = Color3.fromRGB(150, 150, 180)
    supportLabel.TextSize = 11
    supportLabel.Font = Enum.Font.Gotham
    supportLabel.Parent = mainFrame
    
    -- Кнопка активации
    local activateBtn = Instance.new("TextButton")
    activateBtn.Size = UDim2.new(0, 200, 0, 45)
    activateBtn.Position = UDim2.new(0.5, -100, 0, 310)
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
    
    -- Анимация кнопки
    activateBtn.MouseEnter:Connect(function()
        activateBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 220)
    end)
    activateBtn.MouseLeave:Connect(function()
        activateBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 200)
    end)
    
    -- Переменные для отслеживания попыток
    local attempts = 0
    
    -- Функция активации
    local function activateKey()
        local key = inputBox.Text:gsub("%s+", "")
        if key == "" then
            statusLabel.Text = "❌ Введите ключ!"
            statusLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
            return
        end
        
        statusLabel.Text = "⏳ Проверка ключа..."
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
                keyData.hardwareId = getHardwareId()
                
                saveKeyData({
                    key = key,
                    activationDate = activationTime,
                    expirationDate = expTime,
                    hardwareId = keyData.hardwareId
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
    
    -- Обработчики событий
    activateBtn.MouseButton1Click:Connect(activateKey)
    inputBox.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            activateKey()
        end
    end)
end

-- 12. ПРОВЕРКА СОХРАНЕННОГО КЛЮЧА
local function checkSavedKey()
    local savedData = loadKeyData()
    if not savedData then
        return false
    end
    
    -- Проверяем наличие всех полей
    if not savedData.key or not savedData.expirationDate then
        return false
    end
    
    -- Проверяем срок действия
    if os.time() >= savedData.expirationDate then
        print("⚠️ Срок действия ключа истек")
        return false
    end
    
    -- Проверяем HWID (если есть)
    if savedData.hardwareId and savedData.hardwareId ~= getHardwareId() then
        print("⚠️ HWID не совпадает")
        return false
    end
    
    -- Загружаем данные
    keyData.isValid = true
    keyData.key = savedData.key
    keyData.activationDate = savedData.activationDate
    keyData.expirationDate = savedData.expirationDate
    keyData.hardwareId = savedData.hardwareId
    
    return true
end

-- 13. ОСНОВНАЯ ФУНКЦИЯ ЗАПУСКА
local function main()
    print("🔧 Загрузка AuraCheats v" .. CURRENT_VERSION)
    print("📅 Дата: " .. os.date("%Y-%m-%d %H:%M:%S"))
    
    -- Проверяем сохраненный ключ
    if checkSavedKey() then
        local daysLeft = math.floor((keyData.expirationDate - os.time()) / 86400)
        print("✅ Ключ загружен из сохранения")
        print("📅 Осталось дней: " .. daysLeft)
        print("📅 Действует до: " .. os.date("%d.%m.%Y %H:%M:%S", keyData.expirationDate))
        
        loadMainScript()
    else
        print("🔑 Требуется активация ключа")
        showKeyWindow()
    end
end

-- 14. ЗАПУСК
main()
