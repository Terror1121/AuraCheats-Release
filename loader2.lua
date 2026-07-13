-- ============================================
-- 🔒 AURA CHEATS - ЗАГРУЗЧИК v5.23
-- FIX: Обработка 401, пересоздание сессии
-- ============================================

print("🔧 Загрузка AuraCheats v5.23")

-- ============================================
-- 1. КОНФИГУРАЦИЯ
-- ============================================
local CONFIG = {
    API_URL = "https://aura-cheats-bot.onrender.com/api/v6",
    SAVE_FILE = "AuraCheatsKeyData",
    ENCRYPT_KEY = "AuraCheats2024",
    VERSION = "2.2.25",
    MAIN_URL = "https://raw.githack.com/Terror1121/AuraCheats-Release/main/main.lua",
    VERSION_URL = "https://raw.githack.com/Terror1121/AuraCheats-Release/main/version.txt"
}

-- ============================================
-- 2. УНИВЕРСАЛЬНАЯ ЗАПИСЬ ФАЙЛА
-- ============================================
local function writeFileUniversal(path, data)
    local writeFuncs = {
        function() if syn and syn.writefile then return syn.writefile(path, data) end end,
        function() if writefile then return writefile(path, data) end end,
        function() if secure_call then return secure_call(function() return writefile(path, data) end) end end
    }
    
    for _, func in ipairs(writeFuncs) do
        local success, result = pcall(func)
        if success and result then return true end
    end
    return false
end

-- ============================================
-- 3. УНИВЕРСАЛЬНОЕ ЧТЕНИЕ ФАЙЛА
-- ============================================
local function readFileUniversal(path)
    local readFuncs = {
        function() if syn and syn.readfile then return syn.readfile(path) end end,
        function() if readfile then return readfile(path) end end,
        function() if secure_call then return secure_call(function() return readfile(path) end) end end
    }
    
    for _, func in ipairs(readFuncs) do
        local success, result = pcall(func)
        if success and result then return result end
    end
    return nil
end

-- ============================================
-- 4. УНИВЕРСАЛЬНАЯ ПРОВЕРКА ФАЙЛА
-- ============================================
local function isFileUniversal(path)
    local checkFuncs = {
        function() if syn and syn.isfile then return syn.isfile(path) end end,
        function() if isfile then return isfile(path) end end,
        function() if secure_call then return secure_call(function() return isfile(path) end) end end
    }
    
    for _, func in ipairs(checkFuncs) do
        local success, result = pcall(func)
        if success and result then return result end
    end
    return false
end

-- ============================================
-- 5. РАБОТА С ДАННЫМИ
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

-- ============================================
-- 6. ПАРСИНГ ДАТЫ
-- ============================================
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
-- 7. HTTP ЗАПРОСЫ (С ТАЙМАУТОМ И ПАРСИНГОМ JSON)
-- ============================================
local function sendRequest(endpoint, data, timeout)
    timeout = timeout or 10
    local url = CONFIG.API_URL .. endpoint
    local json = game:GetService("HttpService"):JSONEncode(data)
    
    print("📡 Отправка запроса: " .. endpoint)
    print("   URL: " .. url)
    
    local requestFuncs = {
        function()
            if syn and syn.request then
                return syn.request({
                    Url = url,
                    Method = "POST",
                    Headers = { ["Content-Type"] = "application/json" },
                    Body = json,
                    Timeout = timeout
                })
            end
        end,
        function()
            if http and http.request then
                return http.request({
                    Url = url,
                    Method = "POST",
                    Headers = { ["Content-Type"] = "application/json" },
                    Body = json,
                    Timeout = timeout
                })
            end
        end,
        function()
            return game:GetService("HttpService"):RequestAsync({
                Url = url,
                Method = "POST",
                Headers = { ["Content-Type"] = "application/json" },
                Body = json
            })
        end
    }
    
    for _, func in ipairs(requestFuncs) do
        local success, response = pcall(func)
        if success and response then
            print("📥 Ответ получен, статус: " .. tostring(response.StatusCode))
            
            if response.StatusCode == 200 then
                local decoded = nil
                local parseSuccess, parseResult = pcall(function()
                    return game:GetService("HttpService"):JSONDecode(response.Body)
                end)
                if parseSuccess then
                    decoded = parseResult
                    print("✅ JSON распарсен успешно")
                    return decoded, nil
                else
                    print("❌ Ошибка парсинга JSON: " .. tostring(parseResult))
                    print("📄 Сырой ответ: " .. tostring(response.Body):sub(1, 200))
                    return nil, "JSON parse error"
                end
            else
                print("⚠️ Статус не 200: " .. tostring(response.StatusCode))
                print("📄 Ответ: " .. tostring(response.Body):sub(1, 200))
            end
        end
    end
    
    return nil, "HTTP error"
end

-- ============================================
-- 8. GET ЗАПРОС С РЕАЛЬНЫМ ТАЙМАУТОМ
-- ============================================
local function httpGet(url, timeout)
    timeout = timeout or 10
    
    if url:find("raw.githubusercontent.com") then
        url = url:gsub("raw.githubusercontent.com", "raw.githack.com")
    end
    
    if syn and syn.request then
        local success, response = pcall(function()
            return syn.request({
                Url = url,
                Method = "GET",
                Timeout = timeout
            })
        end)
        if success and response and response.StatusCode == 200 then
            if type(response.Body) == "string" then
                return response.Body
            end
        end
    end
    
    if http and http.request then
        local success, response = pcall(function()
            return http.request({
                Url = url,
                Method = "GET",
                Timeout = timeout
            })
        end)
        if success and response and response.StatusCode == 200 then
            if type(response.Body) == "string" then
                return response.Body
            end
        end
    end
    
    local result = nil
    local finished = false
    
    local co = coroutine.create(function()
        local success, response = pcall(function()
            return game:GetService("HttpService"):RequestAsync({
                Url = url,
                Method = "GET"
            })
        end)
        if success and response and response.StatusCode == 200 then
            result = response.Body
        end
        finished = true
    end)
    
    coroutine.resume(co)
    
    local startTime = tick()
    while not finished and tick() - startTime < timeout do
        task.wait(0.1)
    end
    
    if not finished then
        print("⚠️ Таймаут GET запроса (" .. timeout .. "с): " .. url)
        return nil
    end
    
    return result
end

-- ============================================
-- 9. ПРОВЕРКА ВЕРСИИ
-- ============================================
local versionWarningShown = false

local function getCachedVersion()
    if isFileUniversal(CONFIG.SAVE_FILE .. "_version") then
        local success, data = pcall(function()
            return readFileUniversal(CONFIG.SAVE_FILE .. "_version")
        end)
        if success and data then
            return data:gsub("%s+", "")
        end
    end
    return nil
end

local function saveVersionCache(version)
    pcall(function()
        writeFileUniversal(CONFIG.SAVE_FILE .. "_version", version)
    end)
end

local function checkVersion()
    local latestVersion = getCachedVersion()
    
    if not latestVersion then
        local success, response = pcall(function()
            return game:HttpGet(CONFIG.VERSION_URL)
        end)
        if success and response then
            latestVersion = response:gsub("%s+", "")
            saveVersionCache(latestVersion)
        end
    end
    
    if not latestVersion then
        print("⚠️ Не удалось проверить версию. Пропускаем проверку.")
        return true
    end
    
    local function splitVersion(v)
        local parts = {}
        for part in v:gmatch("[^.]+") do
            table.insert(parts, tonumber(part) or 0)
        end
        return parts
    end
    
    local current = splitVersion(CONFIG.VERSION)
    local latest = splitVersion(latestVersion)
    
    for i = 1, math.max(#current, #latest) do
        local c = current[i] or 0
        local l = latest[i] or 0
        if c ~= l then
            if c < l and not versionWarningShown then
                versionWarningShown = true
                print("")
                print("⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️")
                print("⚠️  ВНИМАНИЕ! ВЕРСИЯ ЧИТА УСТАРЕЛА!")
                print("⚠️  Текущая версия: " .. CONFIG.VERSION)
                print("⚠️  Последняя версия: " .. latestVersion)
                print("⚠️  Обновите чит для стабильной работы!")
                print("⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️")
                print("")
            end
            return true
        end
    end
    
    return true
end

-- ============================================
-- 10. ПРОВЕРКА КЛЮЧА НА СЕРВЕРЕ (ЧЕРЕЗ /check)
-- ============================================
local function checkKeyOnServer(key, userId)
    print("📡 Проверка ключа на сервере (через /check)...")
    print("   KEY: " .. key)
    print("   User ID: " .. userId)
    
    local data = {
        key = key,
        userId = userId
    }
    
    local response, err = sendRequest("/check", data, 15)
    
    -- Проверяем, что response - это таблица
    if not response then
        print("❌ Ошибка проверки ключа: " .. tostring(err))
        return false, "❌ Ошибка подключения к серверу"
    end
    
    -- Получаем статус (поддерживаем разные форматы ответа)
    local status = response.status or response.valid
    local message = response.message or response.msg or "none"
    
    print("📥 Ответ статус: " .. tostring(status))
    print("📥 Ответ сообщение: " .. tostring(message))
    
    -- Если ключ активен (status = "active" ИЛИ valid = true)
    if status == "active" or status == true then
        print("✅ Ключ активен на сервере!")
        return true, response
    end
    
    -- Если ключ истек
    if status == "expired" then
        print("❌ Ключ истек на сервере!")
        return false, "❌ Срок действия ключа истек. Введите новый ключ."
    end
    
    -- Если ключ не активирован
    if status == "inactive" then
        print("❌ Ключ не активирован на сервере!")
        return false, "❌ Ключ не активирован. Введите новый ключ."
    end
    
    -- Если status = "error"
    if status == "error" then
        print("❌ Ошибка: " .. message)
        return false, "❌ " .. message
    end
    
    -- Неизвестный статус
    print("❌ Неизвестный статус: " .. tostring(status))
    return false, "❌ Неизвестная ошибка. Код: " .. tostring(status)
end

-- ============================================
-- 11. АКТИВАЦИЯ КЛЮЧА (ЧЕРЕЗ /activate)
-- ============================================
local function activateKey(key)
    print("📡 Активация ключа на сервере (через /activate)...")
    print("   KEY: " .. key)
    
    local player = game.Players.LocalPlayer
    local execName = getexecutorname and getexecutorname() or "Unknown"
    
    local data = {
        key = key,
        userId = player.UserId,
        userName = player.Name,
        executor = execName,
        version = CONFIG.VERSION,
        gameId = game.GameId or 0,
        placeId = game.PlaceId or 0
    }
    
    local response, err = sendRequest("/activate", data, 15)
    
    if not response then
        print("❌ Ошибка активации: " .. tostring(err))
        return false, "❌ Ошибка подключения к серверу"
    end
    
    local status = response.status
    local message = response.message or "none"
    
    print("📥 Ответ статус: " .. tostring(status))
    print("📥 Ответ сообщение: " .. tostring(message))
    
    -- УСПЕХ: ключ активирован
    if status == "success" then
        print("✅ Ключ активирован!")
        if response.session_token then
            print("✅ Сессия получена: " .. response.session_token)
        end
        return true, response
    end
    
    -- Ключ уже активирован → создаем сессию
    if status == "error" and message == "Key already activated" then
        print("✅ Ключ уже активирован, создаем сессию...")
        
        local sessionData = {
            userId = player.UserId,
            executor = execName,
            version = CONFIG.VERSION,
            gameId = game.GameId or 0,
            placeId = game.PlaceId or 0
        }
        
        local sessionResponse, sessionErr = sendRequest("/session", sessionData, 15)
        if not sessionResponse or sessionResponse.status ~= "success" then
            print("❌ Ошибка создания сессии: " .. tostring(sessionErr))
            return false, "❌ Ошибка создания сессии"
        end
        
        print("✅ Сессия создана: " .. tostring(sessionResponse.session))
        
        return true, {
            session_token = sessionResponse.session,
            expires_at = response.expires_at,
            userId = player.UserId
        }
    end
    
    -- Ключ истек
    if status == "error" and message == "Key expired" then
        print("❌ Ключ истек!")
        return false, "❌ Срок действия ключа истек. Введите новый ключ."
    end
    
    -- Любая другая ошибка
    print("❌ Ключ неактивен: " .. message)
    return false, "❌ " .. message
end

-- ============================================
-- 12. ЗАГРУЗКА СКРИПТА С СЕРВЕРА (С ОБРАБОТКОЙ 401)
-- ============================================
local function loadScriptFromServer(session_token)
    print("📥 Загрузка скрипта с сервера...")
    
    local player = game.Players.LocalPlayer
    local userId = player.UserId
    local currentSession = session_token
    
    -- ============================================
    -- ВНУТРЕННЯЯ ФУНКЦИЯ ЗАГРУЗКИ
    -- ============================================
    local function doLoadScript(token)
        local url = string.format(
            "%s/script?session=%s&user_id=%s",
            CONFIG.API_URL,
            token,
            userId
        )
        
        print("⏳ Ожидание ответа от сервера (до 30 секунд)...")
        print("   URL: " .. url)
        
        local raw_response = httpGet(url, 30)
        if not raw_response then
            print("❌ Ошибка загрузки скрипта (таймаут или ошибка)")
            return nil, "timeout"
        end
        
        print("✅ Ответ получен, размер: " .. #raw_response .. " байт")
        
        -- Парсим JSON
        local response_data = nil
        local parseSuccess, parseResult = pcall(function()
            return game:GetService("HttpService"):JSONDecode(raw_response)
        end)
        
        if not parseSuccess or not parseResult then
            print("❌ Ошибка парсинга JSON: " .. tostring(parseResult))
            return nil, "parse_error"
        end
        
        response_data = parseResult
        
        -- Проверяем статус
        if response_data.status == "error" then
            print("⚠️ Ошибка сервера: " .. (response_data.message or "unknown"))
            
            -- Если сессия невалидна или истекла
            if response_data.message == "Invalid session" or 
               response_data.message == "Session expired" or
               response_data.message == "Session not found" then
                return nil, "invalid_session"
            end
            
            return nil, "server_error"
        end
        
        if response_data.status ~= "success" then
            print("❌ Неизвестный статус: " .. tostring(response_data.status))
            return nil, "unknown_status"
        end
        
        return response_data, "success"
    end
    
    -- ============================================
    -- ПЕРВАЯ ПОПЫТКА
    -- ============================================
    local response_data, status = doLoadScript(currentSession)
    
    -- ✅ Если сессия невалидна → создаем новую
    if status == "invalid_session" then
        print("🔄 Сессия невалидна на сервере, создаем новую через /session...")
        
        local execName = getexecutorname and getexecutorname() or "Unknown"
        local sessionData = {
            userId = userId,
            executor = execName,
            version = CONFIG.VERSION,
            gameId = game.GameId or 0,
            placeId = game.PlaceId or 0
        }
        
        local sessionResponse, sessionErr = sendRequest("/session", sessionData, 15)
        if not sessionResponse or sessionResponse.status ~= "success" then
            print("❌ Ошибка создания сессии: " .. tostring(sessionErr))
            return false
        end
        
        local new_session_token = sessionResponse.session
        print("✅ Новая сессия создана: " .. new_session_token)
        
        -- Обновляем сохраненные данные
        local saved = loadData()
        if saved then
            saved.session_token = new_session_token
            saveData(saved)
            print("✅ session_token обновлен в файле")
        end
        
        currentSession = new_session_token
        
        -- Пробуем загрузить скрипт с новой сессией
        response_data, status = doLoadScript(currentSession)
        
        if status ~= "success" then
            print("❌ Ошибка загрузки скрипта с новой сессией: " .. status)
            return false
        end
    end
    
    -- ❌ Если другая ошибка
    if status ~= "success" then
        print("❌ Ошибка загрузки скрипта: " .. status)
        return false
    end
    
    -- ============================================
    -- ДЕКОДИРУЕМ И РАСШИФРОВЫВАЕМ
    -- ============================================
    local encrypted_b64 = response_data.script
    if not encrypted_b64 then
        print("❌ Нет поля 'script'")
        return false
    end
    
    print("📦 Декодируем Base64...")
    
    local encrypted_bytes = nil
    
    local decodeFuncs = {
        function() if crypt and crypt.base64decode then return crypt.base64decode(encrypted_b64) end end,
        function() if syn and syn.crypt and syn.crypt.base64 and syn.crypt.base64.decode then return syn.crypt.base64.decode(encrypted_b64) end end,
        function() if base64 and base64.decode then return base64.decode(encrypted_b64) end end
    }
    
    for _, func in ipairs(decodeFuncs) do
        local success, result = pcall(func)
        if success and result then
            encrypted_bytes = result
            break
        end
    end
    
    if not encrypted_bytes then
        print("❌ Ошибка декодирования Base64")
        return false
    end
    
    print("📦 Расшифровываем XOR (" .. #encrypted_bytes .. " байт)...")
    
    local key = CONFIG.ENCRYPT_KEY .. tostring(userId)
    local decrypted = ""
    for i = 1, #encrypted_bytes do
        local byte = string.byte(encrypted_bytes, i)
        local keyByte = string.byte(key, (i - 1) % #key + 1)
        decrypted = decrypted .. string.char(bit32.bxor(byte, keyByte))
    end
    
    print("📦 Расшифровано байт: " .. #decrypted)
    
    local saved = loadData()
    local keyData = nil
    
    if saved then
        keyData = {
            isValid = true,
            key = saved.key,
            userId = saved.userId,
            activationDate = saved.activationDate,
            expirationDate = saved.expirationDate,
            session_token = currentSession
        }
        print("📅 Дата активации: " .. os.date("%d.%m.%Y %H:%M", saved.activationDate))
        print("📅 Дата истечения: " .. os.date("%d.%m.%Y %H:%M", saved.expirationDate))
    else
        local currentTime = os.time()
        keyData = {
            isValid = true,
            key = "Unknown",
            userId = userId,
            activationDate = currentTime,
            expirationDate = currentTime + (86400 * 7),
            session_token = currentSession
        }
    end
    
    local func, err = loadstring(decrypted)
    if not func then
        print("❌ Ошибка компиляции: " .. (err or "unknown"))
        return false
    end
    
    print("✅ Скрипт загружен!")
    
    print("⏳ Запуск через 2.5 секунды...")
    task.wait(2.5)
    
    local execSuccess, execErr = pcall(func, keyData)
    if execSuccess then
        print("✅ Скрипт выполнен успешно!")
    else
        print("❌ Ошибка выполнения: " .. tostring(execErr))
        return false
    end
    
    return true
end

-- ============================================
-- 13. GUI ВВОДА КЛЮЧА
-- ============================================
local function showGUI(errorMessage)
    local player = game.Players.LocalPlayer
    if not player then
        print("❌ Нет игрока")
        return
    end
    
    if not player.PlayerGui then
        print("❌ PlayerGui не найден!")
        return
    end
    
    local oldGui = player.PlayerGui:FindFirstChild("AuraKeySystem")
    if oldGui then
        oldGui:Destroy()
    end
    
    local gui = nil
    local success, result = pcall(function()
        local newGui = Instance.new("ScreenGui")
        newGui.Name = "AuraKeySystem"
        newGui.Parent = player.PlayerGui
        newGui.ResetOnSpawn = false
        newGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        newGui.DisplayOrder = 999
        return newGui
    end)
    
    if not success or not result then
        print("❌ Не удалось создать GUI: " .. tostring(result))
        return
    end
    
    gui = result
    
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
                    loadScriptFromServer(result.session_token)
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
        if enter then
            doActivate()
        end
    end)
end

-- ============================================
-- 14. ЗАПУСК (С ПРОВЕРКОЙ НА СЕРВЕРЕ)
-- ============================================
print("📅 " .. os.date("%Y-%m-%d %H:%M:%S"))

local player = game.Players.LocalPlayer
if not player then
    print("❌ Нет игрока")
    return
end

print("👤 User ID: " .. player.UserId)
print("👤 User: " .. player.Name)

if not checkVersion() then
    print("❌ Ошибка проверки версии")
end

print("🔴 ДИАГНОСТИКА ФАЙЛОВ:")
print("🔴 isFileUniversal: " .. tostring(isFileUniversal(CONFIG.SAVE_FILE)))
if isFileUniversal(CONFIG.SAVE_FILE) then
    local content = readFileUniversal(CONFIG.SAVE_FILE)
    print("🔴 Содержимое файла: " .. tostring(content))
    if content then
        local success, data = pcall(function()
            return game:GetService("HttpService"):JSONDecode(content)
        end)
        if success then
            print("🔴 Распарсенные данные:")
            print("🔴   key: " .. tostring(data.key))
            print("🔴   userId: " .. tostring(data.userId))
            print("🔴   session_token: " .. tostring(data.session_token))
            print("🔴   expirationDate: " .. tostring(data.expirationDate))
        else
            print("🔴 Ошибка парсинга JSON")
        end
    end
else
    print("🔴 Файл НЕ СУЩЕСТВУЕТ")
end
print("🔴 _G.AuraCheatsKeyData: " .. tostring(_G.AuraCheatsKeyData))

local saved = loadData()

if saved and saved.key and saved.userId == player.UserId then
    print("🔑 Найден сохраненный ключ: " .. saved.key)
    
    -- ============================================
    -- ✅ ПРОВЕРКА КЛЮЧА НА СЕРВЕРЕ (ЧЕРЕЗ /check)
    -- ============================================
    local ok, result = checkKeyOnServer(saved.key, player.UserId)
    
    if ok then
        print("✅ Ключ валиден на сервере, загрузка скрипта...")
        
        -- Получаем актуальную информацию с сервера
        local newExpiration = result.expires_at
        local expTime = nil
        if newExpiration then
            expTime = parseDate(newExpiration)
        end
        
        -- Обновляем сохраненные данные
        saveData({
            key = saved.key,
            userId = saved.userId,
            expires_at = newExpiration,
            session_token = saved.session_token,
            activationDate = saved.activationDate,
            expirationDate = expTime or saved.expirationDate
        })
        
        -- Если нет session_token, пробуем создать через /session
        if not saved.session_token then
            print("⚠️ Нет session_token, создаем через /session...")
            local execName = getexecutorname and getexecutorname() or "Unknown"
            local sessionData = {
                userId = player.UserId,
                executor = execName,
                version = CONFIG.VERSION,
                gameId = game.GameId or 0,
                placeId = game.PlaceId or 0
            }
            local sessionResponse, sessionErr = sendRequest("/session", sessionData, 15)
            if sessionResponse and sessionResponse.status == "success" then
                saved.session_token = sessionResponse.session
                saveData({
                    key = saved.key,
                    userId = saved.userId,
                    expires_at = newExpiration,
                    session_token = sessionResponse.session,
                    activationDate = saved.activationDate,
                    expirationDate = expTime or saved.expirationDate
                })
                print("✅ session_token создан: " .. saved.session_token)
            else
                print("❌ Не удалось создать session_token: " .. tostring(sessionErr))
            end
        end
        
        if saved.session_token then
            loadScriptFromServer(saved.session_token)
        else
            print("❌ Нет session_token!")
            showGUI("❌ Ошибка получения сессии")
        end
    else
        print("❌ Ключ невалиден на сервере, требуется активация")
        print("   Причина: " .. tostring(result))
        
        -- Удаляем старый сохраненный ключ
        if isFileUniversal(CONFIG.SAVE_FILE) then
            pcall(function()
                if syn and syn.delfile then syn.delfile(CONFIG.SAVE_FILE) end
                if delfile then delfile(CONFIG.SAVE_FILE) end
            end)
        end
        _G.AuraCheatsKeyData = nil
        showGUI(tostring(result) or "❌ Ключ неактивен. Введите новый ключ.")
    end
else
    print("🔑 Требуется активация")
    showGUI()
end