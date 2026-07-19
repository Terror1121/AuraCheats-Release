-- ============================================
-- 🔒 AURA CHEATS - PRIVATE SCRIPT SYSTEM v11.1
-- FIX: ПОКАЗЫВАЕТ ОКНО АКТИВАЦИИ
-- ============================================

print("🔧 [1] Загрузка AuraCheats v11.1")

local player = game.Players.LocalPlayer
if not player then
    print("❌ [2] Нет игрока")
    return
end
print("✅ [3] Игрок: " .. player.Name .. " (ID: " .. player.UserId .. ")")

-- ============================================
-- 1. КОНФИГУРАЦИЯ
-- ============================================
print("🔧 [4] Загрузка конфигурации...")
local CONFIG = {
    API_URL = "https://aura-cheats-bot.onrender.com/api/v6",
    SAVE_FILE = "AuraCheatsKeyData",
    ENCRYPT_KEY = "AuraCheats2024",
    VERSION = "2.2.25",
    LAUNCHER_VERSION = "5.2.1",
}
print("✅ [5] Конфигурация загружена")

-- ============================================
-- 2. ДАННЫЕ МОДУЛЕЙ
-- ============================================
print("🔧 [6] Загрузка модулей...")
local MODULES = {
    {
        id = "main",
        name = "Main",
        icon = "🎯",
        shortDesc = "Универсальный модуль",
        fullDesc = "Основной модуль AuraCheats с полным набором функций",
        features = {"ESP", "Chams", "Aimbot", "Fly", "Speed", "Noclip", "Infinite Jump"},
        status = "online",
        needsAuth = true,
        version = "5.2.1",
    },
    {
        id = "testing",
        name = "Testing",
        icon = "🧪",
        shortDesc = "Отладка и тестирование",
        fullDesc = "Тестовый модуль для разработки и отладки новых функций",
        features = {"Debug", "Test", "Sandbox", "Console", "Log Viewer"},
        status = "online",
        needsAuth = false,
        version = "0.1.0",
    },
    {
        id = "prison_life",
        name = "Prison Life",
        icon = "🔒",
        shortDesc = "Автоматизация Prison Life",
        fullDesc = "Полный набор функций для Prison Life: фарм, эскейп, телепорты",
        features = {"AutoFarm", "ESP", "Teleport", "Escape", "AutoDig", "Guard Bypass"},
        status = "online",
        needsAuth = false,
        version = "2.0.0",
    },
    {
        id = "blox_fruits",
        name = "Blox Fruits",
        icon = "🍎",
        shortDesc = "Фарм ресурсов и квестов",
        fullDesc = "Автоматический фарм фруктов, квестов и телепорты по карте",
        features = {"AutoFarm", "Teleport", "ESP", "AutoQuest", "Fruit Finder", "Boss Farm"},
        status = "online",
        needsAuth = false,
        version = "3.1.0",
    },
    {
        id = "bedwars",
        name = "BedWars",
        icon = "🛏️",
        shortDesc = "PvP модуль для BedWars",
        fullDesc = "Продвинутый аимбот и ESP для BedWars с автостройкой",
        features = {"Aimbot", "ESP", "AutoBridge", "AntiFall", "AutoBuy", "Bed Defend"},
        status = "wip",
        needsAuth = false,
        version = "1.8.0",
    },
    {
        id = "arsenal",
        name = "Arsenal",
        icon = "🔫",
        shortDesc = "Шутер модуль",
        fullDesc = "Аимбот, триггербот и ESP для Arsenal с автоспавном",
        features = {"Aimbot", "Triggerbot", "ESP", "AutoRespawn", "Silent Aim", "Aim Assist"},
        status = "wip",
        needsAuth = false,
        version = "0.9.0",
    },
}
print("✅ [7] Модулей загружено: " .. #MODULES)

-- ============================================
-- 3. УНИВЕРСАЛЬНЫЕ ФУНКЦИИ
-- ============================================
print("🔧 [8] Загрузка функций...")

local function writeFileUniversal(path, data)
    if syn and syn.writefile then
        local success, result = pcall(function() return syn.writefile(path, data) end)
        if success and result then return true end
    end
    if writefile then
        local success, result = pcall(function() return writefile(path, data) end)
        if success and result then return true end
    end
    if secure_call then
        local success, result = pcall(function() return secure_call(function() return writefile(path, data) end) end)
        if success and result then return true end
    end
    return false
end

local function readFileUniversal(path)
    if syn and syn.readfile then
        local success, result = pcall(function() return syn.readfile(path) end)
        if success and result then return result end
    end
    if readfile then
        local success, result = pcall(function() return readfile(path) end)
        if success and result then return result end
    end
    if secure_call then
        local success, result = pcall(function() return secure_call(function() return readfile(path) end) end)
        if success and result then return result end
    end
    return nil
end

local function isFileUniversal(path)
    if syn and syn.isfile then
        local success, result = pcall(function() return syn.isfile(path) end)
        if success and result then return result end
    end
    if isfile then
        local success, result = pcall(function() return isfile(path) end)
        if success and result then return result end
    end
    if secure_call then
        local success, result = pcall(function() return secure_call(function() return isfile(path) end) end)
        if success and result then return result end
    end
    return false
end

local function saveData(data)
    _G.AuraCheatsKeyData = data
    local success, json = pcall(function()
        return game:GetService("HttpService"):JSONEncode(data)
    end)
    if success and json then
        writeFileUniversal(CONFIG.SAVE_FILE, json)
    end
    return true
end

local function loadData()
    if _G.AuraCheatsKeyData then
        return _G.AuraCheatsKeyData
    end
    if isFileUniversal(CONFIG.SAVE_FILE) then
        local content = readFileUniversal(CONFIG.SAVE_FILE)
        if content then
            local success, data = pcall(function()
                return game:GetService("HttpService"):JSONDecode(content)
            end)
            if success and data then
                _G.AuraCheatsKeyData = data
                return data
            end
        end
    end
    return nil
end

local function parseDate(dateString)
    if not dateString then return nil end
    local year, month, day, hour, minute, second = dateString:match("(%d+)-(%d+)-(%d+)[T ](%d+):(%d+):(%d+)")
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

-- ============================================
-- 4. HTTP GET (РАБОТАЕТ НА ВСЕХ!)
-- ============================================

local function httpGet(url)
    print("📡 GET: " .. url)
    
    local success, result = pcall(function()
        return game:HttpGet(url)
    end)
    
    if success and result then
        print("✅ GET успешно")
        return result
    end
    
    if syn and syn.request then
        local success2, response = pcall(function()
            return syn.request({
                Url = url,
                Method = "GET",
                Timeout = 30,
                Headers = { ["User-Agent"] = "Mozilla/5.0" }
            })
        end)
        if success2 and response and response.StatusCode == 200 then
            print("✅ GET через syn.request")
            return response.Body
        end
    end
    
    print("❌ Все методы GET не удались!")
    return nil
end

-- ============================================
-- 5. АКТИВАЦИЯ КЛЮЧА (ЧЕРЕЗ GET)
-- ============================================
local function activateKey(key)
    print("📡 Активация ключа...")
    
    local userId = player.UserId
    local userName = player.Name
    local executor = getexecutorname and getexecutorname() or "Unknown"
    
    local url = CONFIG.API_URL .. "/activate?key=" .. key .. 
                "&userId=" .. userId ..
                "&userName=" .. userName ..
                "&executor=" .. executor ..
                "&version=" .. CONFIG.VERSION ..
                "&gameId=" .. (game.GameId or 0) ..
                "&placeId=" .. (game.PlaceId or 0)
    
    local response_str = httpGet(url)
    
    if not response_str then
        return false, "❌ Ошибка подключения к серверу"
    end
    
    local response = game:GetService("HttpService"):JSONDecode(response_str)
    
    if not response then
        return false, "❌ Ошибка парсинга ответа"
    end
    
    if response.status == "success" then
        print("✅ Ключ активирован!")
        if response.session_token then
            saveData({
                key = key,
                userId = userId,
                expires_at = response.expires_at,
                session_token = response.session_token,
                activationDate = os.time(),
                expirationDate = parseDate(response.expires_at) or (os.time() + 86400 * 7)
            })
        end
        return true, response
    elseif response.status == "error" and response.message == "Key already activated" then
        print("✅ Ключ уже активирован, создаем сессию...")
        local sessionToken = createSession()
        if sessionToken then
            saveData({
                key = key,
                userId = userId,
                session_token = sessionToken,
                activationDate = os.time(),
                expirationDate = os.time() + 86400 * 7
            })
            return true, { session_token = sessionToken }
        else
            return false, "❌ Ошибка создания сессии"
        end
    else
        return false, response.message or "❌ Неизвестная ошибка"
    end
end

-- ============================================
-- 6. СОЗДАНИЕ СЕССИИ (ЧЕРЕЗ GET)
-- ============================================
local function createSession()
    print("📡 Создание сессии...")
    
    local userId = player.UserId
    local executor = getexecutorname and getexecutorname() or "Unknown"
    
    local url = CONFIG.API_URL .. "/session?user_id=" .. userId ..
                "&executor=" .. executor ..
                "&version=" .. CONFIG.VERSION ..
                "&gameId=" .. (game.GameId or 0) ..
                "&placeId=" .. (game.PlaceId or 0)
    
    local response_str = httpGet(url)
    
    if not response_str then
        print("❌ Ошибка создания сессии")
        return nil
    end
    
    local response = game:GetService("HttpService"):JSONDecode(response_str)
    
    if response and response.status == "success" and response.session then
        print("✅ Сессия создана: " .. response.session)
        return response.session
    end
    
    print("❌ Ошибка создания сессии: " .. (response and response.message or "unknown"))
    return nil
end

-- ============================================
-- 7. ЗАГРУЗКА СКРИПТА
-- ============================================
local function loadScriptFromServer(session_token, userId, moduleId)
    if not moduleId or moduleId == "" then
        moduleId = "main"
        print("⚠️ moduleId был nil, установлен 'main'")
    end
    
    local url = CONFIG.API_URL .. "/script?session=" .. session_token .. "&user_id=" .. userId .. "&script_name=" .. moduleId
    
    print("📥 Загрузка модуля: " .. moduleId)
    print("   📡 " .. url)
    
    task.spawn(function()
        local raw_response = httpGet(url)
        
        if not raw_response then
            print("❌ Ошибка загрузки модуля (пустой ответ)")
            return
        end
        
        if raw_response:find('"detail":"Invalid session"') or raw_response:find('"status":"error"') then
            print("❌ Сессия невалидна, создаём новую...")
            local newSession = createSession()
            if newSession then
                local saved = loadData()
                if saved then
                    saved.session_token = newSession
                    saveData(saved)
                end
                raw_response = httpGet(CONFIG.API_URL .. "/script?session=" .. newSession .. "&user_id=" .. userId .. "&script_name=" .. moduleId)
                if not raw_response then
                    print("❌ Ошибка загрузки после создания сессии")
                    return
                end
            else
                print("❌ Не удалось создать новую сессию")
                return
            end
        end
        
        local response_data = nil
        local success, result = pcall(function()
            return game:GetService("HttpService"):JSONDecode(raw_response)
        end)
        
        if success and result then
            response_data = result
        else
            print("❌ Ошибка парсинга JSON: " .. tostring(result))
            return
        end
        
        if response_data.status ~= "success" then
            print("❌ Сервер вернул ошибку: " .. (response_data.message or "unknown"))
            return
        end
        
        local encrypted_b64 = response_data.script
        if not encrypted_b64 then
            print("❌ Нет поля 'script'")
            return
        end
        
        print("📦 Декодируем Base64...")
        
        local encrypted_bytes = nil
        if crypt and crypt.base64decode then
            local success, result = pcall(function() return crypt.base64decode(encrypted_b64) end)
            if success then encrypted_bytes = result end
        end
        if not encrypted_bytes and syn and syn.crypt and syn.crypt.base64 and syn.crypt.base64.decode then
            local success, result = pcall(function() return syn.crypt.base64.decode(encrypted_b64) end)
            if success then encrypted_bytes = result end
        end
        if not encrypted_bytes and base64 and base64.decode then
            local success, result = pcall(function() return base64.decode(encrypted_b64) end)
            if success then encrypted_bytes = result end
        end
        
        if not encrypted_bytes then
            print("❌ Ошибка декодирования Base64")
            return
        end
        
        print("📦 Расшифровываем XOR... (" .. #encrypted_bytes .. " байт)")
        local key = CONFIG.ENCRYPT_KEY .. tostring(userId)
        local decrypted = ""
        for i = 1, #encrypted_bytes do
            local byte = string.byte(encrypted_bytes, i)
            local keyByte = string.byte(key, (i - 1) % #key + 1)
            decrypted = decrypted .. string.char(bit32.bxor(byte, keyByte))
        end
        
        local saved = loadData()
        local keyData = nil
        
        if saved then
            keyData = {
                isValid = true,
                key = saved.key,
                userId = saved.userId,
                activationDate = saved.activationDate,
                expirationDate = saved.expirationDate,
                session_token = session_token
            }
        else
            local currentTime = os.time()
            keyData = {
                isValid = true,
                key = "Unknown",
                userId = userId,
                activationDate = currentTime,
                expirationDate = currentTime + (86400 * 7),
                session_token = session_token
            }
        end
        
        local func, err = loadstring(decrypted)
        if not func then
            print("❌ Ошибка компиляции: " .. tostring(err))
            return
        end
        
        print("✅ Модуль загружен!")
        pcall(func, keyData)
        
        if _G.AuraLoadingHide then
            task.wait(0.5)
            _G.AuraLoadingHide()
        end
    end)
end

print("✅ [9] Функции загружены")

-- ============================================
-- 8. GUI ВВОДА КЛЮЧА
-- ============================================
local function showGUI(errorMessage)
    if not player then return end
    
    local oldGui = player.PlayerGui:FindFirstChild("AuraKeySystem")
    if oldGui then oldGui:Destroy() end
    
    local gui = Instance.new("ScreenGui")
    gui.Name = "AuraKeySystem"
    gui.Parent = player.PlayerGui
    gui.ResetOnSpawn = false
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.DisplayOrder = 999
    
    local bg = Instance.new("Frame")
    bg.Size = UDim2.new(1, 0, 1, 0)
    bg.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    bg.BackgroundTransparency = 0.5
    bg.Parent = gui
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 400, 0, 320)
    frame.Position = UDim2.new(0.5, -200, 0.5, -160)
    frame.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
    frame.BorderSizePixel = 0
    frame.Parent = gui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = frame
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 50)
    title.Position = UDim2.new(0, 0, 0, 10)
    title.BackgroundTransparency = 1
    title.Text = "🔒 AURA CHEATS"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextSize = 24
    title.Font = Enum.Font.GothamBold
    title.Parent = frame
    
    local userLabel = Instance.new("TextLabel")
    userLabel.Size = UDim2.new(1, -40, 0, 25)
    userLabel.Position = UDim2.new(0, 20, 0, 65)
    userLabel.BackgroundTransparency = 1
    userLabel.Text = "👤 " .. player.Name .. " (ID: " .. player.UserId .. ")"
    userLabel.TextColor3 = Color3.fromRGB(150, 150, 200)
    userLabel.TextSize = 12
    userLabel.Font = Enum.Font.Gotham
    userLabel.Parent = frame
    
    local input = Instance.new("TextBox")
    input.Size = UDim2.new(1, -40, 0, 45)
    input.Position = UDim2.new(0, 20, 0, 100)
    input.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
    input.BorderSizePixel = 2
    input.BorderColor3 = Color3.fromRGB(80, 80, 200)
    input.Text = ""
    input.TextColor3 = Color3.fromRGB(255, 255, 255)
    input.TextSize = 16
    input.Font = Enum.Font.Gotham
    input.PlaceholderText = "Введите ключ..."
    input.Parent = frame
    
    local inputCorner = Instance.new("UICorner")
    inputCorner.CornerRadius = UDim.new(0, 8)
    inputCorner.Parent = input
    
    local status = Instance.new("TextLabel")
    status.Size = UDim2.new(1, -40, 0, 30)
    status.Position = UDim2.new(0, 20, 0, 155)
    status.BackgroundTransparency = 1
    status.Text = errorMessage or "Готов к активации"
    status.TextColor3 = errorMessage and Color3.fromRGB(255, 80, 80) or Color3.fromRGB(180, 180, 200)
    status.TextSize = 12
    status.Font = Enum.Font.Gotham
    status.Parent = frame
    
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 200, 0, 45)
    btn.Position = UDim2.new(0.5, -100, 0, 205)
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 200)
    btn.BorderSizePixel = 0
    btn.Text = "АКТИВИРОВАТЬ"
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 16
    btn.Font = Enum.Font.GothamBold
    btn.Parent = frame
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = btn
    
    local support = Instance.new("TextLabel")
    support.Size = UDim2.new(1, -40, 0, 20)
    support.Position = UDim2.new(0, 20, 0, 270)
    support.BackgroundTransparency = 1
    support.Text = "💬 discord.gg/XPwdHN4jHf"
    support.TextColor3 = Color3.fromRGB(150, 150, 180)
    support.TextSize = 11
    support.Font = Enum.Font.Gotham
    support.Parent = frame
    
    local attempts = 0
    
    local function doActivate()
        local key = input.Text:gsub("%s+", "")
        if key == "" then
            status.Text = "❌ Введите ключ!"
            status.TextColor3 = Color3.fromRGB(255, 80, 80)
            return
        end
        
        status.Text = "⏳ Проверка..."
        status.TextColor3 = Color3.fromRGB(255, 255, 100)
        btn.Active = false
        btn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
        btn.Text = "ПРОВЕРКА..."
        
        task.spawn(function()
            local ok, result = activateKey(key)
            
            if ok then
                status.Text = "✅ Ключ активирован!"
                status.TextColor3 = Color3.fromRGB(100, 255, 100)
                
                if result and result.session_token then
                    local exp = parseDate(result.expires_at)
                    saveData({
                        key = key,
                        userId = result.userId or player.UserId,
                        expires_at = result.expires_at,
                        session_token = result.session_token,
                        activationDate = os.time(),
                        expirationDate = exp or (os.time() + 86400 * 7)
                    })
                    
                    task.wait(0.5)
                    gui:Destroy()
                    loadScriptFromServer(result.session_token, player.UserId, "main")
                else
                    status.Text = "❌ Не получен session_token!"
                    status.TextColor3 = Color3.fromRGB(255, 80, 80)
                    btn.Active = true
                    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 200)
                    btn.Text = "АКТИВИРОВАТЬ"
                end
            else
                attempts = attempts + 1
                status.Text = "❌ " .. tostring(result)
                status.TextColor3 = Color3.fromRGB(255, 80, 80)
                btn.Active = true
                btn.BackgroundColor3 = Color3.fromRGB(50, 50, 200)
                btn.Text = "АКТИВИРОВАТЬ"
                
                if attempts >= 3 then
                    status.Text = "❌ Превышено количество попыток!"
                    btn.Active = false
                    btn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
                end
            end
        end)
    end
    
    btn.MouseButton1Click:Connect(doActivate)
    input.FocusLost:Connect(function(enter)
        if enter then doActivate() end
    end)
end

-- ============================================
-- 9. GUI — ЛАУНЧЕР
-- ============================================
print("🔴 [10] Вызов showScriptSelector()...")

local function showScriptSelector()
    print("🔴 [11] showScriptSelector() начата")
    
    -- 🔥 ПРОВЕРЯЕМ СОХРАНЁННЫЙ КЛЮЧ
    local saved = loadData()
    
    -- ✅ ЕСЛИ КЛЮЧА НЕТ — ПОКАЗЫВАЕМ ОКНО АКТИВАЦИИ!
    if not saved or not saved.key then
        print("🔑 Ключ не найден, показываем окно активации")
        showGUI()
        return
    end
    
    print("✅ Найден сохранённый ключ: " .. saved.key)
    
    -- Если есть ключ, но нет сессии — создаём
    if not saved.session_token then
        print("🔄 Сессии нет, создаём...")
        local sessionToken = createSession()
        if sessionToken then
            saved.session_token = sessionToken
            saveData(saved)
            print("✅ Сессия создана: " .. sessionToken)
        else
            print("❌ Ошибка создания сессии")
            showGUI("❌ Ошибка создания сессии")
            return
        end
    end
    
    -- Если есть ключ и сессия — загружаем скрипт
    print("✅ Загрузка основного скрипта...")
    loadScriptFromServer(saved.session_token, player.UserId, "main")
    return
end

-- ============================================
-- 10. ЗАПУСК
-- ============================================
print("📅 [56] " .. os.date("%Y-%m-%d %H:%M:%S"))
print("👤 [57] User: " .. player.Name .. " (ID: " .. player.UserId .. ")")

print("🔴 [58] Вызов showScriptSelector()...")
local success, err = pcall(showScriptSelector)

if success then
    print("✅ [59] showScriptSelector() выполнен успешно!")
else
    print("❌❌❌ [60] ОШИБКА: " .. tostring(err))
end

print("✅ [61] Private Script System v11.1 запущен!")