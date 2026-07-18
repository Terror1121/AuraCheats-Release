-- ============================================
-- 🔒 AURA CHEATS - PRIVATE SCRIPT SYSTEM v7.7
-- С ЛОГАМИ (КАЖДЫЙ ШАГ)
-- ============================================

print("🔧 [1] Загрузка AuraCheats Private Script System v7.7")

local player = game.Players.LocalPlayer
if not player then
    print("❌ [2] Нет игрока")
    return
end
print("✅ [3] Игрок: " .. player.Name)

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

-- ============================================
-- 4. РАБОТА С ДАННЫМИ КЛЮЧА
-- ============================================
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
-- 5. HTTP ЗАПРОСЫ (УНИВЕРСАЛЬНЫЕ)
-- ============================================
local function httpRequest(url, method, data, timeout)
    timeout = timeout or 15
    local body = data and game:GetService("HttpService"):JSONEncode(data) or nil
    
    if syn and syn.request then
        local success, response = pcall(function()
            return syn.request({
                Url = url,
                Method = method,
                Headers = {
                    ["Content-Type"] = "application/json",
                    ["User-Agent"] = "Mozilla/5.0"
                },
                Body = body,
                Timeout = timeout
            })
        end)
        if success and response then
            if response.StatusCode == 200 then
                if type(response.Body) == "string" then
                    return game:GetService("HttpService"):JSONDecode(response.Body), 200
                end
            else
                return nil, response.StatusCode
            end
        end
    end
    
    if http and http.request then
        local success, response = pcall(function()
            return http.request({
                Url = url,
                Method = method,
                Headers = {
                    ["Content-Type"] = "application/json",
                    ["User-Agent"] = "Mozilla/5.0"
                },
                Body = body,
                Timeout = timeout
            })
        end)
        if success and response then
            if response.StatusCode == 200 then
                if type(response.Body) == "string" then
                    return game:GetService("HttpService"):JSONDecode(response.Body), 200
                end
            else
                return nil, response.StatusCode
            end
        end
    end
    
    local success, response = pcall(function()
        return game:GetService("HttpService"):RequestAsync({
            Url = url,
            Method = method,
            Headers = {
                ["Content-Type"] = "application/json"
            },
            Body = body
        })
    end)
    if success and response then
        if response.StatusCode == 200 then
            if type(response.Body) == "string" then
                return game:GetService("HttpService"):JSONDecode(response.Body), 200
            end
        else
            return nil, response.StatusCode
        end
    end
    
    return nil, nil
end

-- ============================================
-- 6. ПРОВЕРКА КЛЮЧА НА СЕРВЕРЕ
-- ============================================
local function checkKeyOnServer(key, userId)
    print("📡 [9] Проверка ключа...")
    
    local response, status = httpRequest(CONFIG.API_URL .. "/check", "POST", { key = key, userId = userId }, 10)
    
    if not response then
        print("⚠️ [10] Сервер недоступен, используем локальные данные")
        return true, nil
    end
    
    print("📥 [11] Статус: " .. (response.status or "unknown"))
    
    if response.status == "active" then
        print("✅ [12] Ключ активен!")
        return true, response
    elseif response.status == "expired" then
        print("❌ [13] Ключ истек!")
        return false, "Срок действия ключа истек"
    elseif response.status == "inactive" then
        print("❌ [14] Ключ не активирован!")
        return false, "Ключ не активирован"
    else
        return false, response.message or "Неизвестная ошибка"
    end
end

-- ============================================
-- 7. АКТИВАЦИЯ КЛЮЧА
-- ============================================
local function activateKey(key, callback)
    print("📡 [15] Активация ключа...")
    
    local data = {
        key = key,
        userId = player.UserId,
        userName = player.Name,
        executor = getexecutorname and getexecutorname() or "Unknown",
        version = CONFIG.VERSION,
        gameId = game.GameId or 0,
        placeId = game.PlaceId or 0
    }
    
    local response, status = httpRequest(CONFIG.API_URL .. "/activate", "POST", data, 15)
    
    if not response then
        callback(false, "❌ [16] Ошибка подключения к серверу")
        return
    end
    
    if response.status == "success" then
        print("✅ [17] Ключ активирован!")
        if response.session_token then
            saveData({
                key = key,
                userId = player.UserId,
                expires_at = response.expires_at,
                session_token = response.session_token,
                activationDate = os.time(),
                expirationDate = parseDate(response.expires_at) or (os.time() + 86400 * 7)
            })
        end
        callback(true, response)
    elseif response.status == "error" and response.message == "Key already activated" then
        print("✅ [18] Ключ уже активирован, создаем сессию...")
        local sessionResponse, sessionStatus = httpRequest(CONFIG.API_URL .. "/session", "POST", {
            userId = player.UserId,
            executor = getexecutorname and getexecutorname() or "Unknown",
            version = CONFIG.VERSION
        }, 15)
        
        if sessionResponse and sessionResponse.status == "success" then
            saveData({
                key = key,
                userId = player.UserId,
                session_token = sessionResponse.session,
                activationDate = os.time(),
                expirationDate = os.time() + 86400 * 7
            })
            callback(true, { session_token = sessionResponse.session })
        else
            callback(false, "❌ [19] Ошибка создания сессии")
        end
    else
        callback(false, response.message or "❌ [20] Неизвестная ошибка")
    end
end

-- ============================================
-- 8. ЗАГРУЗКА СКРИПТА С СЕРВЕРА
-- ============================================
local function loadScriptFromServer(session_token, userId, moduleId)
    local url = string.format(
        "%s/script?session=%s&user_id=%s&script_name=%s",
        CONFIG.API_URL,
        session_token,
        userId,
        moduleId
    )
    
    print("📥 [21] Загрузка модуля: " .. moduleId)
    print("   📡 " .. url)
    
    task.spawn(function()
        local raw_response = nil
        local statusCode = nil
        
        if syn and syn.request then
            local success, response = pcall(function()
                return syn.request({
                    Url = url,
                    Method = "GET",
                    Timeout = 30,
                    Headers = {
                        ["User-Agent"] = "Mozilla/5.0"
                    }
                })
            end)
            if success and response then
                statusCode = response.StatusCode
                if response.StatusCode == 200 then
                    raw_response = response.Body
                end
            end
        end
        
        if not raw_response and http and http.request then
            local success, response = pcall(function()
                return http.request({
                    Url = url,
                    Method = "GET",
                    Timeout = 30,
                    Headers = {
                        ["User-Agent"] = "Mozilla/5.0"
                    }
                })
            end)
            if success and response then
                statusCode = response.StatusCode
                if response.StatusCode == 200 then
                    raw_response = response.Body
                end
            end
        end
        
        if not raw_response then
            local success, response = pcall(function()
                return game:GetService("HttpService"):RequestAsync({
                    Url = url,
                    Method = "GET",
                    Headers = {
                        ["User-Agent"] = "Mozilla/5.0"
                    }
                })
            end)
            if success and response then
                statusCode = response.StatusCode
                if response.StatusCode == 200 then
                    raw_response = response.Body
                end
            end
        end
        
        if statusCode == 401 then
            print("⚠️ [22] Сессия невалидна, создаем новую...")
            local sessionResponse, sessionStatus = httpRequest(CONFIG.API_URL .. "/session", "POST", {
                userId = userId,
                executor = getexecutorname and getexecutorname() or "Unknown",
                version = CONFIG.VERSION
            }, 15)
            if sessionResponse and sessionResponse.status == "success" then
                local saved = loadData()
                saveData({
                    key = saved and saved.key or "Unknown",
                    userId = userId,
                    session_token = sessionResponse.session,
                    activationDate = os.time(),
                    expirationDate = os.time() + 86400 * 7
                })
                loadScriptFromServer(sessionResponse.session, userId, moduleId)
            end
            return
        end
        
        if statusCode == 403 then
            print("❌ [23] Требуется ключ для этого модуля!")
            return
        end
        
        if not raw_response then
            print("❌ [24] Ошибка загрузки модуля")
            return
        end
        
        local response_data = nil
        local success, result = pcall(function()
            return game:GetService("HttpService"):JSONDecode(raw_response)
        end)
        if success and result then
            response_data = result
        else
            print("❌ [25] Ошибка парсинга JSON")
            return
        end
        
        if response_data.status ~= "success" then
            print("❌ [26] Сервер вернул ошибку: " .. (response_data.message or "unknown"))
            return
        end
        
        local encrypted_b64 = response_data.script
        if not encrypted_b64 then
            print("❌ [27] Нет поля 'script'")
            return
        end
        
        print("📦 [28] Декодируем Base64...")
        
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
            print("❌ [29] Ошибка декодирования Base64")
            return
        end
        
        print("📦 [30] Расшифровываем XOR... (" .. #encrypted_bytes .. " байт)")
        local key = CONFIG.ENCRYPT_KEY .. tostring(userId)
        local key_len = #key
        local total = #encrypted_bytes
        local chunk_size = 1024
        
        local key_bytes = {}
        for i = 1, key_len do
            key_bytes[i] = string.byte(key, i)
        end
        
        local result_parts = {}
        local part_index = 1
        
        for offset = 1, total, chunk_size do
            local chunk_end = math.min(offset + chunk_size - 1, total)
            local chunk_len = chunk_end - offset + 1
            
            local chunk = string.sub(encrypted_bytes, offset, chunk_end)
            local chunk_bytes = { string.byte(chunk, 1, chunk_len) }
            
            local decrypted_chunk = {}
            for i = 1, chunk_len do
                local global_idx = offset + i - 1
                local key_idx = ((global_idx - 1) % key_len) + 1
                decrypted_chunk[i] = string.char(bit32.bxor(chunk_bytes[i], key_bytes[key_idx]))
            end
            
            result_parts[part_index] = table.concat(decrypted_chunk)
            part_index = part_index + 1
        end
        
        local decrypted = table.concat(result_parts)
        print("✅ [31] Расшифровка завершена! (" .. #decrypted .. " байт)")
        
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
            print("❌ [32] Ошибка компиляции: " .. tostring(err))
            return
        end
        
        print("✅ [33] Модуль загружен!")
        pcall(func, keyData)
        
        if _G.AuraLoadingHide then
            task.wait(0.5)
            _G.AuraLoadingHide()
        end
    end)
end

-- ============================================
-- 9. GUI — ПРОСТОЙ ЛАУНЧЕР
-- ============================================
print("🔧 [34] Создание GUI...")

local function showScriptSelector()
    print("🔴 [35] showScriptSelector() вызвана")
    
    local oldGui = player.PlayerGui:FindFirstChild("AuraLauncher")
    if oldGui then 
        oldGui:Destroy()
        print("🔴 [36] Старый GUI удален")
    end
    
    print("🔴 [37] Создаем ScreenGui...")
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "AuraLauncher"
    screenGui.Parent = player.PlayerGui
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.DisplayOrder = 999
    print("✅ [38] ScreenGui создан")
    
    print("🔴 [39] Создаем фон...")
    local bg = Instance.new("Frame")
    bg.Size = UDim2.new(1, 0, 1, 0)
    bg.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    bg.BackgroundTransparency = 0.75
    bg.Parent = screenGui
    print("✅ [40] Фон создан")
    
    print("🔴 [41] Создаем контейнер...")
    local container = Instance.new("Frame")
    container.Size = UDim2.new(0, 400, 0, 300)
    container.Position = UDim2.new(0.5, -200, 0.5, -150)
    container.BackgroundColor3 = Color3.fromRGB(15, 15, 28)
    container.BorderSizePixel = 0
    container.Parent = screenGui
    container.ClipsDescendants = true
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = container
    print("✅ [42] Контейнер создан")
    
    print("🔴 [43] Создаем заголовок...")
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 40)
    title.Position = UDim2.new(0, 0, 0, 10)
    title.BackgroundTransparency = 1
    title.Text = "⚡ AURA CHEATS"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextSize = 24
    title.Font = Enum.Font.GothamBold
    title.Parent = container
    print("✅ [44] Заголовок создан")
    
    print("🔴 [45] Создаем кнопки модулей...")
    local buttons = {}
    local selectedModule = 1
    local yOffset = 60
    
    for i, moduleData in ipairs(MODULES) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, -20, 0, 40)
        btn.Position = UDim2.new(0, 10, 0, yOffset)
        btn.BackgroundColor3 = Color3.fromRGB(30, 30, 55)
        btn.BorderSizePixel = 0
        btn.Text = moduleData.icon .. " " .. moduleData.name
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.TextSize = 14
        btn.Font = Enum.Font.Gotham
        btn.Parent = container
        
        local btnCorner2 = Instance.new("UICorner")
        btnCorner2.CornerRadius = UDim.new(0, 6)
        btnCorner2.Parent = btn
        
        btn.Data = {
            id = moduleData.id,
            name = moduleData.name,
        }
        
        btn.MouseButton1Click:Connect(function()
            print("🔴 [46] Выбран модуль: " .. moduleData.name)
            for _, b in ipairs(buttons) do
                b.BackgroundColor3 = Color3.fromRGB(30, 30, 55)
            end
            btn.BackgroundColor3 = Color3.fromRGB(60, 60, 100)
            selectedModule = i
        end)
        
        buttons[i] = btn
        yOffset = yOffset + 48
    end
    
    -- Выбираем первый
    if buttons[1] then
        buttons[1].BackgroundColor3 = Color3.fromRGB(60, 60, 100)
    end
    print("✅ [47] Кнопки модулей созданы (" .. #buttons .. " шт.)")
    
    print("🔴 [48] Создаем кнопку ЗАПУСТИТЬ...")
    local launchBtn = Instance.new("TextButton")
    launchBtn.Size = UDim2.new(0, 200, 0, 40)
    launchBtn.Position = UDim2.new(0.5, -100, 1, -50)
    launchBtn.BackgroundColor3 = Color3.fromRGB(100, 80, 255)
    launchBtn.BorderSizePixel = 0
    launchBtn.Text = "▶ ЗАПУСТИТЬ"
    launchBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    launchBtn.TextSize = 16
    launchBtn.Font = Enum.Font.GothamBold
    launchBtn.Parent = container
    
    local btnCorner3 = Instance.new("UICorner")
    btnCorner3.CornerRadius = UDim.new(0, 8)
    btnCorner3.Parent = launchBtn
    
    local launchState = Instance.new("TextLabel")
    launchState.Size = UDim2.new(0, 250, 0, 18)
    launchState.Position = UDim2.new(0.5, -125, 0, -20)
    launchState.BackgroundTransparency = 1
    launchState.Text = ""
    launchState.TextColor3 = Color3.fromRGB(180, 180, 200)
    launchState.TextSize = 11
    launchState.Font = Enum.Font.Gotham
    launchState.TextXAlignment = Enum.TextXAlignment.Center
    launchState.Visible = false
    launchState.Parent = launchBtn
    
    print("✅ [49] Кнопка ЗАПУСТИТЬ создана")
    
    -- ============================================
    -- ЛОГИКА ЗАПУСКА
    -- ============================================
    print("🔴 [50] Создаем обработчик кнопки...")
    
    launchBtn.MouseButton1Click:Connect(function()
        print("🔴🔴🔴 [51] КНОПКА ЗАПУСТИТЬ НАЖАТА! 🔴🔴🔴")
        
        local btn = buttons[selectedModule]
        if not btn then
            print("❌ [52] Кнопка не найдена")
            return
        end
        
        local data = btn.Data
        if not data then
            print("❌ [53] Данные модуля не найдены")
            return
        end
        
        print("🚀 [54] Запуск модуля: " .. data.name .. " (ID: " .. data.id .. ")")
        
        launchBtn.Visible = false
        launchState.Visible = true
        launchState.Text = "⏳ Запуск..."
        launchState.TextColor3 = Color3.fromRGB(255, 255, 100)
        
        task.spawn(function()
            task.wait(0.5)
            screenGui:Destroy()
            
            local saved = loadData()
            print("📦 [55] Загружены данные: " .. (saved and "ЕСТЬ" or "НЕТ"))
            if saved then
                print("   🔑 Ключ: " .. (saved.key or "НЕТ"))
                print("   🎫 Сессия: " .. (saved.session_token or "НЕТ"))
            end
            
            if not saved or not saved.session_token then
                print("🔄 [56] Создаём новую сессию...")
                local sessionUrl = CONFIG.API_URL .. "/session"
                local sessionData = {
                    userId = player.UserId,
                    executor = getexecutorname and getexecutorname() or "Unknown",
                    version = CONFIG.VERSION
                }
                local sessionResponse, sessionStatus = httpRequest(sessionUrl, "POST", sessionData, 15)
                
                if sessionResponse and sessionResponse.status == "success" then
                    saved = {
                        userId = player.UserId,
                        session_token = sessionResponse.session,
                        activationDate = os.time(),
                        expirationDate = os.time() + 86400 * 7
                    }
                    saveData(saved)
                    print("✅ [57] Сессия создана: " .. saved.session_token)
                else
                    print("❌ [58] Ошибка создания сессии")
                    return
                end
            end
            
            if saved and saved.session_token then
                print("📥 [59] Загрузка модуля: " .. data.id)
                loadScriptFromServer(saved.session_token, player.UserId, data.id)
            else
                print("❌ [60] Нет сессии для загрузки")
            end
        end)
    end)
    
    print("✅ [61] Обработчик кнопки создан")
    print("🔴🔴🔴 [62] КНОПКА ГОТОВА! 🔴🔴🔴")
end

-- ============================================
-- 10. ЗАПУСК
-- ============================================
print("📅 [63] " .. os.date("%Y-%m-%d %H:%M:%S"))
print("👤 [64] User: " .. player.Name .. " (ID: " .. player.UserId .. ")")

print("🔴 [65] Вызов showScriptSelector()...")
local success, err = pcall(showScriptSelector)

if success then
    print("✅ [66] showScriptSelector() выполнен успешно!")
else
    print("❌❌❌ [67] ОШИБКА: " .. tostring(err))
end

print("✅ [68] Private Script System v7.7 запущен!")
print("🔴🔴🔴 [69] Нажми на кнопку '▶ ЗАПУСТИТЬ' внизу экрана! 🔴🔴🔴")