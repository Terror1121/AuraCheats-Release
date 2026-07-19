-- ============================================
-- 🔒 AURA CHEATS - PRIVATE SCRIPT SYSTEM v12.3
-- FIX: ПАНЕЛЬ ИНФОРМАЦИИ + ПОЛОСКА
-- ============================================

print("🔧 [1] Загрузка AuraCheats v12.3")

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
-- 5. ПРОВЕРКА КЛЮЧА НА СЕРВЕРЕ (ЧЕРЕЗ GET)
-- ============================================
local function checkKeyOnServer(key)
    print("📡 Проверка ключа на сервере...")
    
    local url = CONFIG.API_URL .. "/check?key=" .. key .. "&userId=" .. player.UserId
    
    local response_str = httpGet(url)
    
    if not response_str then
        print("⚠️ Сервер недоступен, используем локальные данные")
        return true, nil
    end
    
    local response = game:GetService("HttpService"):JSONDecode(response_str)
    
    if not response then
        print("❌ Ошибка парсинга ответа")
        return false, "Ошибка парсинга"
    end
    
    print("📥 Статус: " .. (response.status or "unknown"))
    
    if response.status == "active" then
        print("✅ Ключ активен!")
        return true, response
    elseif response.status == "expired" then
        print("❌ Ключ истек!")
        return false, "Срок действия ключа истек"
    elseif response.status == "inactive" then
        print("❌ Ключ не активирован!")
        return false, "Ключ не активирован"
    else
        return false, response.message or "Неизвестная ошибка"
    end
end

-- ============================================
-- 6. АКТИВАЦИЯ КЛЮЧА (ЧЕРЕЗ GET)
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
-- 7. СОЗДАНИЕ СЕССИИ (ЧЕРЕЗ GET)
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
-- 8. ЗАГРУЗКА СКРИПТА
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
-- 9. GUI ВВОДА КЛЮЧА
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
    local activeKey = nil
    
    local function doActivate()
        local key = input.Text:gsub("%s+", "")
        if key == "" then
            status.Text = "❌ Введите ключ!"
            status.TextColor3 = Color3.fromRGB(255, 80, 80)
            return
        end
        
        activeKey = key
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
                    if not selectedModuleId or selectedModuleId == "" then
                        selectedModuleId = "main"
                        print("⚠️ selectedModuleId был nil, установлен 'main'")
                    end
                    loadScriptFromServer(result.session_token, player.UserId, selectedModuleId)
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
-- 10. ЗАГРУЗКА ЧЕРЕЗ СОХРАНЁННЫЙ КЛЮЧ
-- ============================================
local function loadWithSavedKey()
    local saved = loadData()
    
    if not saved or not saved.key then
        print("🔑 Ключ не найден, показываем окно активации")
        showGUI()
        return
    end
    
    print("🔑 Найден сохранённый ключ: " .. saved.key)
    
    -- Проверяем ключ на сервере
    local ok, result = checkKeyOnServer(saved.key)
    
    if not ok then
        print("❌ Ключ невалиден: " .. tostring(result))
        if isFileUniversal(CONFIG.SAVE_FILE) then
            pcall(function()
                if syn and syn.delfile then syn.delfile(CONFIG.SAVE_FILE) end
                if delfile then delfile(CONFIG.SAVE_FILE) end
            end)
        end
        _G.AuraCheatsKeyData = nil
        showGUI(tostring(result))
        return
    end
    
    print("✅ Ключ валиден на сервере!")
    
    -- Проверяем сессию
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
    
    -- ✅ ФИКС: проверяем selectedModuleId
    if not selectedModuleId or selectedModuleId == "" then
        selectedModuleId = "main"
        print("⚠️ selectedModuleId был nil, установлен 'main'")
    end
    
    print("📥 Загрузка модуля: " .. selectedModuleId)
    loadScriptFromServer(saved.session_token, player.UserId, selectedModuleId)
end

-- ============================================
-- 11. ЛАУНЧЕР С ВЫБОРОМ СКРИПТА
-- ============================================
local selectedModuleId = "main"
local selectedModule = 1

print("🔴 [10] Создание лаунчера...")

local function showLauncher()
    print("🔴 [11] showLauncher() начата")
    
    local oldGui = player.PlayerGui:FindFirstChild("AuraLauncher")
    if oldGui then
        oldGui:Destroy()
        print("🔴 [12] Старый GUI удален")
    end
    
    print("🔴 [13] Создаем ScreenGui...")
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "AuraLauncher"
    screenGui.Parent = player.PlayerGui
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.DisplayOrder = 999
    print("✅ [14] ScreenGui создан")
    
    print("🔴 [15] Создаем фон...")
    local bg = Instance.new("Frame")
    bg.Size = UDim2.new(1, 0, 1, 0)
    bg.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    bg.BackgroundTransparency = 0.75
    bg.Parent = screenGui
    print("✅ [16] Фон создан")
    
    print("🔴 [17] Создаем контейнер...")
    local container = Instance.new("Frame")
    container.Size = UDim2.new(0, 780, 0, 560)
    container.Position = UDim2.new(0.5, -390, 0.5, -280)
    container.BackgroundColor3 = Color3.fromRGB(15, 15, 28)
    container.BorderSizePixel = 0
    container.Parent = screenGui
    container.ClipsDescendants = true
    print("✅ [18] Контейнер создан")
    
    print("🔴 [19] Создаем тень...")
    local shadow = Instance.new("Frame")
    shadow.Size = UDim2.new(1, 40, 1, 40)
    shadow.Position = UDim2.new(0, -20, 0, -20)
    shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    shadow.BackgroundTransparency = 0.7
    shadow.BorderSizePixel = 0
    shadow.Parent = container
    shadow.ZIndex = 0
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 14)
    corner.Parent = container
    print("✅ [20] Тень и угол созданы")
    
    print("🔴 [21] Создаем заголовок...")
    local header = Instance.new("Frame")
    header.Size = UDim2.new(1, 0, 0, 75)
    header.BackgroundColor3 = Color3.fromRGB(15, 15, 28)
    header.BackgroundTransparency = 1
    header.Parent = container
    
    local logo = Instance.new("TextLabel")
    logo.Size = UDim2.new(0, 50, 1, 0)
    logo.Position = UDim2.new(0, 20, 0, 0)
    logo.BackgroundTransparency = 1
    logo.Text = "⚡"
    logo.TextColor3 = Color3.fromRGB(255, 255, 255)
    logo.TextSize = 28
    logo.Font = Enum.Font.GothamBold
    logo.TextXAlignment = Enum.TextXAlignment.Left
    logo.Parent = header
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(0, 200, 0, 28)
    title.Position = UDim2.new(0, 55, 0, 14)
    title.BackgroundTransparency = 1
    title.Text = "AURA CHEATS"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextSize = 24
    title.Font = Enum.Font.GothamBold
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = header
    
    local subtitle = Instance.new("TextLabel")
    subtitle.Size = UDim2.new(0, 200, 0, 16)
    subtitle.Position = UDim2.new(0, 55, 0, 44)
    subtitle.BackgroundTransparency = 1
    subtitle.Text = "PRIVATE SCRIPT SYSTEM"
    subtitle.TextColor3 = Color3.fromRGB(120, 120, 150)
    subtitle.TextSize = 11
    subtitle.Font = Enum.Font.Gotham
    subtitle.TextXAlignment = Enum.TextXAlignment.Left
    subtitle.Parent = header
    print("✅ [22] Заголовок создан")
    
    print("🔴 [23] Создаем левую панель...")
    local listFrame = Instance.new("Frame")
    listFrame.Size = UDim2.new(0, 290, 0, 400)
    listFrame.Position = UDim2.new(0, 10, 0, 85)
    listFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 28)
    listFrame.BackgroundTransparency = 1
    listFrame.Parent = container
    listFrame.ClipsDescendants = true
    
    local scroll = Instance.new("ScrollingFrame")
    scroll.Size = UDim2.new(1, 0, 1, 0)
    scroll.BackgroundColor3 = Color3.fromRGB(15, 15, 28)
    scroll.BackgroundTransparency = 1
    scroll.BorderSizePixel = 0
    scroll.ScrollBarThickness = 3
    scroll.ScrollBarImageColor3 = Color3.fromRGB(128, 87, 255)
    scroll.Parent = listFrame
    scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    print("✅ [24] Левая панель создана")
    
    print("🔴 [25] Создаем правую панель...")
    local infoPanel = Instance.new("Frame")
    infoPanel.Size = UDim2.new(0, 430, 0, 400)
    infoPanel.Position = UDim2.new(0, 320, 0, 85)
    infoPanel.BackgroundColor3 = Color3.fromRGB(30, 30, 55)
    infoPanel.BorderSizePixel = 0
    infoPanel.Parent = container
    infoPanel.ClipsDescendants = true
    
    local panelCorner = Instance.new("UICorner")
    panelCorner.CornerRadius = UDim.new(0, 12)
    panelCorner.Parent = infoPanel
    
    local accentLine = Instance.new("Frame")
    accentLine.Size = UDim2.new(0, 3, 1, 0)
    accentLine.BackgroundColor3 = Color3.fromRGB(128, 87, 255)
    accentLine.BorderSizePixel = 0
    accentLine.Parent = infoPanel
    
    -- ============================================
    -- ИНФОРМАЦИЯ О МОДУЛЕ (ОБНОВЛЯЕТСЯ)
    -- ============================================
    local infoIcon = Instance.new("TextLabel")
    infoIcon.Size = UDim2.new(0, 56, 0, 56)
    infoIcon.Position = UDim2.new(0, 24, 0, 24)
    infoIcon.BackgroundTransparency = 1
    infoIcon.Text = "📋"
    infoIcon.TextSize = 40
    infoIcon.Font = Enum.Font.GothamBold
    infoIcon.TextXAlignment = Enum.TextXAlignment.Left
    infoIcon.Parent = infoPanel
    
    local infoTitle = Instance.new("TextLabel")
    infoTitle.Size = UDim2.new(0, 200, 0, 26)
    infoTitle.Position = UDim2.new(0, 92, 0, 22)
    infoTitle.BackgroundTransparency = 1
    infoTitle.Text = "Выберите скрипт"
    infoTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    infoTitle.TextSize = 20
    infoTitle.Font = Enum.Font.GothamBold
    infoTitle.TextXAlignment = Enum.TextXAlignment.Left
    infoTitle.Parent = infoPanel
    
    local infoStatus = Instance.new("TextLabel")
    infoStatus.Size = UDim2.new(0, 100, 0, 18)
    infoStatus.Position = UDim2.new(0, 92, 0, 50)
    infoStatus.BackgroundTransparency = 1
    infoStatus.Text = ""
    infoStatus.TextColor3 = Color3.fromRGB(180, 180, 200)
    infoStatus.TextSize = 12
    infoStatus.Font = Enum.Font.GothamBold
    infoStatus.TextXAlignment = Enum.TextXAlignment.Left
    infoStatus.Parent = infoPanel
    
    local infoVersion = Instance.new("TextLabel")
    infoVersion.Size = UDim2.new(0, 80, 0, 18)
    infoVersion.Position = UDim2.new(0, 180, 0, 50)
    infoVersion.BackgroundTransparency = 1
    infoVersion.Text = ""
    infoVersion.TextColor3 = Color3.fromRGB(128, 87, 255)
    infoVersion.TextSize = 12
    infoVersion.Font = Enum.Font.GothamBold
    infoVersion.TextXAlignment = Enum.TextXAlignment.Left
    infoVersion.Parent = infoPanel
    
    local infoDesc = Instance.new("TextLabel")
    infoDesc.Size = UDim2.new(1, -32, 0, 38)
    infoDesc.Position = UDim2.new(0, 16, 0, 95)
    infoDesc.BackgroundTransparency = 1
    infoDesc.Text = "Нажмите на карточку слева,\nчтобы увидеть информацию о скрипте"
    infoDesc.TextColor3 = Color3.fromRGB(180, 180, 200)
    infoDesc.TextSize = 13
    infoDesc.Font = Enum.Font.Gotham
    infoDesc.TextXAlignment = Enum.TextXAlignment.Left
    infoDesc.TextWrapped = true
    infoDesc.Parent = infoPanel
    
    local descDivider = Instance.new("Frame")
    descDivider.Size = UDim2.new(1, -32, 0, 1)
    descDivider.Position = UDim2.new(0, 16, 0, 143)
    descDivider.BackgroundColor3 = Color3.fromRGB(40, 40, 70)
    descDivider.BorderSizePixel = 0
    descDivider.Parent = infoPanel
    
    local featuresTitle = Instance.new("TextLabel")
    featuresTitle.Size = UDim2.new(1, -32, 0, 20)
    featuresTitle.Position = UDim2.new(0, 16, 0, 153)
    featuresTitle.BackgroundTransparency = 1
    featuresTitle.Text = "ВОЗМОЖНОСТИ"
    featuresTitle.TextColor3 = Color3.fromRGB(128, 87, 255)
    featuresTitle.TextSize = 11
    featuresTitle.Font = Enum.Font.GothamBold
    featuresTitle.TextXAlignment = Enum.TextXAlignment.Left
    featuresTitle.Parent = infoPanel
    
    local featuresList = Instance.new("Frame")
    featuresList.Size = UDim2.new(1, -32, 0, 125)
    featuresList.Position = UDim2.new(0, 16, 0, 178)
    featuresList.BackgroundColor3 = Color3.fromRGB(30, 30, 55)
    featuresList.BackgroundTransparency = 1
    featuresList.Parent = infoPanel
    
    local featureLabels = {}
    print("✅ [28] Информация о модуле создана")
    
    print("🔴 [29] Создаем footer...")
    local footer = Instance.new("Frame")
    footer.Size = UDim2.new(1, -40, 0, 24)
    footer.Position = UDim2.new(0, 20, 1, -28)
    footer.BackgroundColor3 = Color3.fromRGB(15, 15, 28)
    footer.BackgroundTransparency = 1
    footer.Parent = container
    
    local footerText = Instance.new("TextLabel")
    footerText.Size = UDim2.new(1, 0, 1, 0)
    footerText.BackgroundTransparency = 1
    footerText.Text = "AuraCheats v" .. CONFIG.LAUNCHER_VERSION .. "  •  User: " .. player.Name .. "  •  Discord: Connected"
    footerText.TextColor3 = Color3.fromRGB(80, 80, 100)
    footerText.TextSize = 10
    footerText.Font = Enum.Font.Gotham
    footerText.TextXAlignment = Enum.TextXAlignment.Center
    footerText.Parent = footer
    print("✅ [30] Footer создан")
    
    print("🔴 [31] Создаем карточки модулей...")
    local buttons = {}
    local buttonData = {}
    local yOffset = 5
    local cardHeight = 56
    local spacing = 6
    
    for i, moduleData in ipairs(MODULES) do
        print("🔴 [32] Создаем карточку " .. i .. ": " .. moduleData.name)
        local button = Instance.new("TextButton")
        button.Size = UDim2.new(1, 0, 0, cardHeight)
        button.Position = UDim2.new(0, 0, 0, yOffset)
        button.BackgroundColor3 = Color3.fromRGB(30, 30, 55)
        button.BorderSizePixel = 0
        button.Text = ""
        button.AutoButtonColor = false
        button.Parent = scroll
        
        local btnCorner2 = Instance.new("UICorner")
        btnCorner2.CornerRadius = UDim.new(0, 8)
        btnCorner2.Parent = button
        
        local line = Instance.new("Frame")
        line.Size = UDim2.new(0, 3, 0, 28)
        line.Position = UDim2.new(0, 8, 0.5, -14)
        line.BackgroundColor3 = Color3.fromRGB(128, 87, 255)
        line.BackgroundTransparency = 1
        line.BorderSizePixel = 0
        line.Parent = button
        
        local icon = Instance.new("TextLabel")
        icon.Size = UDim2.new(0, 28, 1, 0)
        icon.Position = UDim2.new(0, 18, 0, 0)
        icon.BackgroundTransparency = 1
        icon.Text = moduleData.icon
        icon.TextSize = 18
        icon.Font = Enum.Font.GothamBold
        icon.Parent = button
        
        local name = Instance.new("TextLabel")
        name.Size = UDim2.new(0, 110, 0, 18)
        name.Position = UDim2.new(0, 54, 0, 8)
        name.BackgroundTransparency = 1
        name.Text = moduleData.name
        name.TextColor3 = Color3.fromRGB(255, 255, 255)
        name.TextSize = 14
        name.Font = Enum.Font.GothamBold
        name.TextXAlignment = Enum.TextXAlignment.Left
        name.Parent = button
        
        local desc = Instance.new("TextLabel")
        desc.Size = UDim2.new(0, 140, 0, 14)
        desc.Position = UDim2.new(0, 54, 0, 28)
        desc.BackgroundTransparency = 1
        desc.Text = moduleData.shortDesc
        desc.TextColor3 = Color3.fromRGB(140, 140, 170)
        desc.TextSize = 10
        desc.Font = Enum.Font.Gotham
        desc.TextXAlignment = Enum.TextXAlignment.Left
        desc.Parent = button
        
        local statusDot = Instance.new("TextLabel")
        statusDot.Size = UDim2.new(0, 12, 0, 12)
        statusDot.Position = UDim2.new(1, -20, 0.5, -6)
        statusDot.BackgroundTransparency = 1
        statusDot.Text = moduleData.status == "online" and "🟢" or "🟡"
        statusDot.TextSize = 10
        statusDot.Font = Enum.Font.GothamBold
        statusDot.Parent = button
        
        buttonData[button] = {
            index = i,
            id = moduleData.id,
            needsAuth = moduleData.needsAuth,
            name = moduleData.name,
            icon = moduleData.icon,
            shortDesc = moduleData.shortDesc,
            fullDesc = moduleData.fullDesc,
            features = moduleData.features,
            status = moduleData.status,
            version = moduleData.version,
        }
        
        button.MouseEnter:Connect(function()
            if selectedModule ~= i then
                button.BackgroundColor3 = Color3.fromRGB(40, 40, 70)
            end
        end)
        button.MouseLeave:Connect(function()
            if selectedModule ~= i then
                button.BackgroundColor3 = Color3.fromRGB(30, 30, 55)
            end
        end)
        
        button.MouseButton1Click:Connect(function()
            if selectedModule == i then return end
            
            -- ✅ УБИРАЕМ ПОЛОСКУ У СТАРОГО
            local oldBtn = buttons[selectedModule]
            if oldBtn then
                oldBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 55)
                local oldLine = oldBtn:FindFirstChild("line")
                if oldLine then oldLine.BackgroundTransparency = 1 end
            end
            
            -- ✅ СТАВИМ ПОЛОСКУ У НОВОГО
            selectedModule = i
            button.BackgroundColor3 = Color3.fromRGB(40, 40, 70)
            line.BackgroundTransparency = 0
            
            -- ✅ ОБНОВЛЯЕМ ПАНЕЛЬ
            updateInfoPanel(buttonData[button])
            selectedModuleId = moduleData.id
            print("🔴 Выбран модуль: " .. moduleData.id)
        end)
        
        button.Size = UDim2.new(1, 0, 0, 0)
        local delay = i * 0.04
        task.spawn(function()
            task.wait(0.3 + delay)
            for j = 1, 10 do
                local progress = j / 10
                button.Size = UDim2.new(1, 0, 0, cardHeight * progress)
                task.wait(0.015)
            end
            button.Size = UDim2.new(1, 0, 0, cardHeight)
        end)
        
        buttons[i] = button
        yOffset = yOffset + cardHeight + spacing
    end
    
    scroll.CanvasSize = UDim2.new(0, 0, 0, yOffset + 10)
    print("✅ [33] Карточки модулей созданы")
    
    -- ============================================
    -- ФУНКЦИЯ ОБНОВЛЕНИЯ ПАНЕЛИ
    -- ============================================
    local function updateInfoPanel(data)
        infoIcon.Text = data.icon
        infoTitle.Text = data.name
        infoStatus.Text = data.status == "online" and "● ONLINE" or "● WIP"
        infoStatus.TextColor3 = data.status == "online" and Color3.fromRGB(59, 255, 122) or Color3.fromRGB(255, 200, 50)
        infoVersion.Text = "v" .. data.version
        infoDesc.Text = data.fullDesc
        
        for _, label in ipairs(featureLabels) do
            label:Destroy()
        end
        featureLabels = {}
        
        local yPos = 0
        for _, feature in ipairs(data.features) do
            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(1, 0, 0, 24)
            label.Position = UDim2.new(0, 4, 0, yPos)
            label.BackgroundTransparency = 1
            label.Text = "• " .. feature
            label.TextColor3 = Color3.fromRGB(180, 180, 210)
            label.TextSize = 13
            label.Font = Enum.Font.Gotham
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Parent = featuresList
            table.insert(featureLabels, label)
            yPos = yPos + 26
        end
    end
    print("✅ [35] updateInfoPanel создана")
    
    -- ============================================
    -- ВЫБОР ПЕРВОГО МОДУЛЯ
    -- ============================================
    print("🔴 [36] Выбираем первый модуль...")
    task.wait(0.5)
    local firstBtn = buttons[1]
    if firstBtn then
        -- ✅ АВТОМАТИЧЕСКИ ВЫБИРАЕМ ПЕРВЫЙ МОДУЛЬ
        firstBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 70)
        local firstLine = firstBtn:FindFirstChild("line")
        if firstLine then firstLine.BackgroundTransparency = 0 end
        updateInfoPanel(buttonData[firstBtn])
        selectedModuleId = buttonData[firstBtn].id
        selectedModule = 1
        print("✅ [37] Первый модуль выбран: " .. selectedModuleId)
    else
        print("⚠️ [37] Нет модулей для выбора")
    end
    
    -- ============================================
    -- 🔥 КНОПКА "ЗАПУСТИТЬ"
    -- ============================================
    print("🔴 [38] СОЗДАЕМ КНОПКУ ЗАПУСТИТЬ!")
    
    local launchGui = Instance.new("ScreenGui")
    launchGui.Name = "LaunchButtonGui"
    launchGui.Parent = player.PlayerGui
    launchGui.ResetOnSpawn = false
    launchGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    launchGui.DisplayOrder = 999
    print("✅ [39] launchGui создан")
    
    local launchBtn = Instance.new("TextButton")
    launchBtn.Size = UDim2.new(0, 300, 0, 46)
    launchBtn.Position = UDim2.new(0.5, -150, 0.92, 0)
    launchBtn.BackgroundColor3 = Color3.fromRGB(128, 87, 255)
    launchBtn.BorderSizePixel = 0
    launchBtn.Text = "▶  ЗАПУСТИТЬ"
    launchBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    launchBtn.TextSize = 15
    launchBtn.Font = Enum.Font.GothamBold
    launchBtn.Parent = launchGui
    launchBtn.ZIndex = 999
    print("✅ [40] launchBtn создан")
    
    local btnCorner3 = Instance.new("UICorner")
    btnCorner3.CornerRadius = UDim.new(0, 10)
    btnCorner3.Parent = launchBtn
    print("✅ [41] Угол кнопки создан")
    
    local launchState = Instance.new("TextLabel")
    launchState.Size = UDim2.new(0, 250, 0, 18)
    launchState.Position = UDim2.new(0.5, -125, 0, -25)
    launchState.BackgroundTransparency = 1
    launchState.Text = ""
    launchState.TextColor3 = Color3.fromRGB(180, 180, 200)
    launchState.TextSize = 11
    launchState.Font = Enum.Font.Gotham
    launchState.TextXAlignment = Enum.TextXAlignment.Center
    launchState.Visible = false
    launchState.Parent = launchBtn
    print("✅ [42] launchState создан")
    
    launchBtn.MouseEnter:Connect(function()
        launchBtn.BackgroundColor3 = Color3.fromRGB(160, 120, 255)
        launchBtn.Size = UDim2.new(0, 306, 0, 48)
        launchBtn.Position = UDim2.new(0.5, -153, 0.92, 0)
    end)
    launchBtn.MouseLeave:Connect(function()
        launchBtn.BackgroundColor3 = Color3.fromRGB(128, 87, 255)
        launchBtn.Size = UDim2.new(0, 300, 0, 46)
        launchBtn.Position = UDim2.new(0.5, -150, 0.92, 0)
    end)
    launchBtn.MouseButton1Down:Connect(function()
        launchBtn.Size = UDim2.new(0, 294, 0, 44)
        launchBtn.Position = UDim2.new(0.5, -147, 0.92, 0)
        task.wait(0.1)
        launchBtn.Size = UDim2.new(0, 300, 0, 46)
        launchBtn.Position = UDim2.new(0.5, -150, 0.92, 0)
    end)
    print("✅ [43] Анимация создана")
    
    -- ============================================
    -- ОБРАБОТЧИК КНОПКИ → ЗАПУСКАЕТ ВЕСЬ ПРОЦЕСС
    -- ============================================
    launchBtn.MouseButton1Click:Connect(function()
        print("🔴🔴🔴 [44] КНОПКА ЗАПУСТИТЬ НАЖАТА! 🔴🔴🔴")
        print("🚀 [45] Выбран модуль: " .. selectedModuleId)
        
        launchBtn.Visible = false
        launchState.Visible = true
        launchState.Text = "⏳ Проверка..."
        launchState.TextColor3 = Color3.fromRGB(255, 255, 100)
        
        task.spawn(function()
            task.wait(0.3)
            
            -- Скрываем лаунчер
            screenGui:Destroy()
            launchGui:Destroy()
            
            -- Запускаем процесс проверки ключа и загрузки
            loadWithSavedKey()
        end)
    end)
    
    print("✅ [46] Обработчик кнопки создан")
    print("🔴🔴🔴 [47] КНОПКА ГОТОВА! 🔴🔴🔴")
end

-- ============================================
-- 12. ЗАПУСК
-- ============================================
print("📅 [48] " .. os.date("%Y-%m-%d %H:%M:%S"))
print("👤 [49] User: " .. player.Name .. " (ID: " .. player.UserId .. ")")

print("🔴 [50] Запуск лаунчера...")
local success, err = pcall(showLauncher)

if success then
    print("✅ [51] Лаунчер запущен успешно!")
else
    print("❌❌❌ [52] ОШИБКА: " .. tostring(err))
end

print("✅ [53] Private Script System v12.3 запущен!")
print("🔴🔴🔴 [54] Выберите скрипт и нажмите 'ЗАПУСТИТЬ' 🔴🔴🔴")