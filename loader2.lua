-- ============================================
-- 🔒 AURA CHEATS - ЗАГРУЗЧИК v5.10 (FIX: session_token nil)
-- ============================================

print("🔧 Загрузка AuraCheats v5.11")

-- ============================================
-- 1. КОНФИГУРАЦИЯ
-- ============================================
local CONFIG = {
    API_URL = "https://aura-cheats-bot.onrender.com/api/v6",
    SAVE_FILE = "AuraCheatsKeyData",
    ENCRYPT_KEY = "AuraCheats2024",
    VERSION = "2.2.9"
}

-- ============================================
-- 2. УНИВЕРСАЛЬНАЯ ЗАПИСЬ ФАЙЛА
-- ============================================
local function writeFileUniversal(path, data)
    if syn and syn.writefile then
        local success, result = pcall(function()
            return syn.writefile(path, data)
        end)
        if success and result then
            return true
        end
    end
    
    if writefile then
        local success, result = pcall(function()
            return writefile(path, data)
        end)
        if success and result then
            return true
        end
    end
    
    if secure_call then
        local success, result = pcall(function()
            return secure_call(function()
                return writefile(path, data)
            end)
        end)
        if success and result then
            return true
        end
    end
    
    return false
end

-- ============================================
-- 3. УНИВЕРСАЛЬНОЕ ЧТЕНИЕ ФАЙЛА
-- ============================================
local function readFileUniversal(path)
    if syn and syn.readfile then
        local success, result = pcall(function()
            return syn.readfile(path)
        end)
        if success and result then
            return result
        end
    end
    
    if readfile then
        local success, result = pcall(function()
            return readfile(path)
        end)
        if success and result then
            return result
        end
    end
    
    if secure_call then
        local success, result = pcall(function()
            return secure_call(function()
                return readfile(path)
            end)
        end)
        if success and result then
            return result
        end
    end
    
    return nil
end

-- ============================================
-- 4. УНИВЕРСАЛЬНАЯ ПРОВЕРКА ФАЙЛА
-- ============================================
local function isFileUniversal(path)
    if syn and syn.isfile then
        local success, result = pcall(function()
            return syn.isfile(path)
        end)
        if success and result then
            return result
        end
    end
    
    if isfile then
        local success, result = pcall(function()
            return isfile(path)
        end)
        if success and result then
            return result
        end
    end
    
    if secure_call then
        local success, result = pcall(function()
            return secure_call(function()
                return isfile(path)
            end)
        end)
        if success and result then
            return result
        end
    end
    
    return false
end

-- ============================================
-- 5. РАБОТА С ДАННЫМИ (_G + ФАЙЛ)
-- ============================================
local function saveData(data)
    _G.AuraCheatsKeyData = data
    print("🔴 Данные сохранены в _G")
    
    local success, json = pcall(function()
        return game:GetService("HttpService"):JSONEncode(data)
    end)
    if success and json then
        local result = writeFileUniversal(CONFIG.SAVE_FILE, json)
        if result then
            print("🔴 Файл сохранен на диск")
        else
            print("🔴 Файл НЕ сохранен (инжектор не поддерживает запись)")
        end
    end
    
    return true
end

local function loadData()
    if _G.AuraCheatsKeyData then
        print("🔴 Данные загружены из _G")
        return _G.AuraCheatsKeyData
    end
    
    if isFileUniversal(CONFIG.SAVE_FILE) then
        local content = readFileUniversal(CONFIG.SAVE_FILE)
        if content then
            local success, data = pcall(function()
                return game:GetService("HttpService"):JSONDecode(content)
            end)
            if success and data then
                print("🔴 Данные загружены из файла")
                _G.AuraCheatsKeyData = data
                return data
            end
        end
    end
    
    print("🔴 Данные не найдены")
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
-- 7. HTTP ЗАПРОСЫ (УНИВЕРСАЛЬНЫЕ)
-- ============================================
local function sendRequest(endpoint, data)
    local url = CONFIG.API_URL .. endpoint
    local json = game:GetService("HttpService"):JSONEncode(data)
    
    if syn and syn.request then
        local response = syn.request({
            Url = url,
            Method = "POST",
            Headers = {
                ["Content-Type"] = "application/json"
            },
            Body = json
        })
        if response and response.StatusCode == 200 then
            return game:GetService("HttpService"):JSONDecode(response.Body), nil
        end
    end
    
    if http and http.request then
        local response = http.request({
            Url = url,
            Method = "POST",
            Headers = {
                ["Content-Type"] = "application/json"
            },
            Body = json
        })
        if response and response.StatusCode == 200 then
            return game:GetService("HttpService"):JSONDecode(response.Body), nil
        end
    end
    
    local success, response = pcall(function()
        return game:GetService("HttpService"):RequestAsync({
            Url = url,
            Method = "POST",
            Headers = {
                ["Content-Type"] = "application/json"
            },
            Body = json
        })
    end)
    
    if success and response and response.StatusCode == 200 then
        return game:GetService("HttpService"):JSONDecode(response.Body), nil
    end
    
    return nil, "HTTP error"
end

-- ============================================
-- 8. GET ЗАПРОС (УНИВЕРСАЛЬНЫЙ)
-- ============================================
local function httpGet(url)
    if syn and syn.request then
        local response = syn.request({ Url = url, Method = "GET" })
        if response and response.StatusCode == 200 then
            return response.Body
        end
    end
    
    if http and http.request then
        local response = http.request({ Url = url, Method = "GET" })
        if response and response.StatusCode == 200 then
            return response.Body
        end
    end
    
    local success, result = pcall(function()
        return game:HttpGet(url)
    end)
    if success then
        return result
    end
    
    return nil
end

-- ============================================
-- 9. ПРОВЕРКА КЛЮЧА НА СЕРВЕРЕ
-- ============================================
local function checkKeyOnServer(key)
    print("📡 Проверка ключа на сервере...")
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
    
    local response, err = sendRequest("/activate", data)
    if not response then
        print("❌ Ошибка проверки ключа: " .. err)
        return false, nil
    end
    
    print("📥 Ответ статус: " .. response.status)
    print("📥 Ответ сообщение: " .. (response.message or "none"))
    print("📥 Ответ содержит session: " .. tostring(response.session))
    
    -- ============================================
    -- ✅ ЛОГИКА ПРОВЕРКИ:
    -- "Key already activated" → УСПЕХ
    -- Любая другая ошибка → НЕ УСПЕХ
    -- ============================================
    
    -- 1. Если ключ активирован только что
    if response.status == "success" then
        print("✅ Ключ активирован!")
        return true, response
    end
    
    -- 2. Если ключ уже был активирован ранее → ЭТО УСПЕХ!
    if response.status == "error" and response.message == "Key already activated" then
        print("✅ Ключ уже активирован, создаем сессию...")
        
        local sessionData = {
            userId = player.UserId,
            executor = execName,
            version = CONFIG.VERSION,
            gameId = game.GameId or 0,
            placeId = game.PlaceId or 0
        }
        
        local sessionResponse, sessionErr = sendRequest("/session", sessionData)
        
        if not sessionResponse then
            print("❌ sessionResponse = nil")
            return false, nil
        end
        
        if sessionResponse.status ~= "success" then
            print("❌ Ошибка создания сессии: " .. (sessionResponse.message or "unknown"))
            return false, nil
        end
        
        print("🔍 sessionResponse.session: " .. tostring(sessionResponse.session))
        print("🔍 sessionResponse.userId: " .. tostring(sessionResponse.userId))
        
        if not sessionResponse.session then
            print("❌ Сервер не вернул session_token!")
            return false, nil
        end
        
        return true, {
            key = key,
            userId = player.UserId,
            expires_at = nil,
            session_token = sessionResponse.session
        }
    end
    
    -- 3. Все остальные ошибки → НЕ УСПЕХ
    print("❌ Ключ неактивен: " .. (response.message or "unknown"))
    return false, nil
end

-- ============================================
-- 10. АКТИВАЦИЯ КЛЮЧА (С ОТЛАДКОЙ)
-- ============================================
local function activateKey(key)
    print("🔑 Активация ключа: " .. key)
    
    local ok, result = checkKeyOnServer(key)
    
    if not ok then
        print("❌ Активация не удалась")
        return false, result
    end
    
    print("🔍 Результат активации:")
    print("   key: " .. tostring(result.key))
    print("   userId: " .. tostring(result.userId))
    print("   session_token: " .. tostring(result.session_token))
    print("   expires_at: " .. tostring(result.expires_at))
    
    if not result.session_token then
        print("❌ session_token отсутствует в ответе сервера!")
        return false, "❌ Не получен session_token от сервера"
    end
    
    return true, result
end

-- ============================================
-- 11. ЗАГРУЗКА СКРИПТА С СЕРВЕРА (FIX: nil session_token)
-- ============================================
local function loadScriptFromServer(session_token)
    print("📥 Загрузка скрипта с сервера...")
    
    local player = game.Players.LocalPlayer
    if not player then
        print("❌ Нет LocalPlayer")
        return false
    end
    
    local userId = player.UserId
    if not userId then
        print("❌ userId = nil")
        return false
    end
    
    if not session_token or session_token == "" then
        print("❌ session_token пустой или равен нулю")
        return false
    end
    
    local url = string.format(
        "%s/script?session=%s&user_id=%s",
        CONFIG.API_URL,
        session_token,
        userId
    )
    
    print("📡 URL: " .. url)
    
    local raw_response = httpGet(url)
    if not raw_response then
        print("❌ Ошибка загрузки скрипта")
        return false
    end
    
    local response_data = game:GetService("HttpService"):JSONDecode(raw_response)
    if not response_data or response_data.status ~= "success" then
        print("❌ Ошибка ответа сервера")
        return false
    end
    
    local encrypted_b64 = response_data.script
    if not encrypted_b64 then
        print("❌ Нет поля 'script'")
        return false
    end
    
    -- Декодируем Base64
    local encrypted_bytes = nil
    
    if crypt and crypt.base64decode then
        local success, result = pcall(function()
            return crypt.base64decode(encrypted_b64)
        end)
        if success then
            encrypted_bytes = result
        end
    end
    
    if not encrypted_bytes and syn and syn.crypt and syn.crypt.base64 and syn.crypt.base64.decode then
        local success, result = pcall(function()
            return syn.crypt.base64.decode(encrypted_b64)
        end)
        if success then
            encrypted_bytes = result
        end
    end
    
    if not encrypted_bytes and base64 and base64.decode then
        local success, result = pcall(function()
            return base64.decode(encrypted_b64)
        end)
        if success then
            encrypted_bytes = result
        end
    end
    
    if not encrypted_bytes then
        print("❌ Ошибка декодирования Base64")
        return false
    end
    
    -- XOR расшифровка
    local key = CONFIG.ENCRYPT_KEY .. tostring(userId)
    local decrypted = ""
    for i = 1, #encrypted_bytes do
        local byte = string.byte(encrypted_bytes, i)
        local keyByte = string.byte(key, (i - 1) % #key + 1)
        decrypted = decrypted .. string.char(bit32.bxor(byte, keyByte))
    end
    
    -- keyData
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
            session_token = session_token
        }
        print("⚠️ keyData создан из session_token")
    end
    
    local func, err = loadstring(decrypted)
    if not func then
        print("❌ Ошибка компиляции: " .. (err or "unknown"))
        return false
    end
    
    print("✅ Скрипт загружен!")
    pcall(func, keyData)
    return true
end

-- ============================================
-- 12. GUI ВВОДА КЛЮЧА (С ОТЛАДКОЙ)
-- ============================================
local function showGUI()
    local player = game.Players.LocalPlayer
    if not player then return end
    
    local gui = Instance.new("ScreenGui")
    gui.Name = "AuraKeySystem"
    gui.Parent = player.PlayerGui
    gui.ResetOnSpawn = false
    
    local bg = Instance.new("Frame")
    bg.Size = UDim2.new(1, 0, 1, 0)
    bg.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    bg.BackgroundTransparency = 0.5
    bg.Parent = gui
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 400, 0, 300)
    frame.Position = UDim2.new(0.5, -200, 0.5, -150)
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
    status.Size = UDim2.new(1, -40, 0, 25)
    status.Position = UDim2.new(0, 20, 0, 155)
    status.BackgroundTransparency = 1
    status.Text = "Готов к активации"
    status.TextColor3 = Color3.fromRGB(180, 180, 200)
    status.TextSize = 12
    status.Font = Enum.Font.Gotham
    status.Parent = frame
    
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 200, 0, 45)
    btn.Position = UDim2.new(0.5, -100, 0, 195)
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
    support.Position = UDim2.new(0, 20, 0, 260)
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
                print("✅ Активация успешна!")
                print("🔍 result.session_token: " .. tostring(result.session_token))
                
                status.Text = "✅ Ключ активирован!"
                status.TextColor3 = Color3.fromRGB(100, 255, 100)
                
                if not result.session_token then
                    print("❌ session_token не получен от сервера!")
                    status.Text = "❌ Ошибка: не получен session_token"
                    status.TextColor3 = Color3.fromRGB(255, 80, 80)
                    btn.Active = true
                    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 200)
                    btn.Text = "АКТИВИРОВАТЬ"
                    return
                end
                
                local exp = parseDate(result.expires_at)
                saveData({
                    key = key,
                    userId = result.userId,
                    expires_at = result.expires_at,
                    session_token = result.session_token,
                    activationDate = os.time(),
                    expirationDate = exp or (os.time() + 86400 * 7)
                })
                
                task.wait(1)
                gui:Destroy()
                loadScriptFromServer(result.session_token)
            else
                attempts = attempts + 1
                status.Text = "❌ " .. tostring(result)
                status.TextColor3 = Color3.fromRGB(255, 80, 80)
                btn.Active = true
                btn.BackgroundColor3 = Color3.fromRGB(50, 50, 200)
                btn.Text = "АКТИВИРОВАТЬ"
            end
        end)
    end
    
    btn.MouseButton1Click:Connect(doActivate)
    input.FocusLost:Connect(function(enter)
        if enter then doActivate() end
    end)
end

-- ============================================
-- 13. ЗАПУСК
-- ============================================
print("📅 " .. os.date("%Y-%m-%d %H:%M:%S"))

local player = game.Players.LocalPlayer
if not player then
    print("❌ Нет игрока")
    return
end

print("👤 User ID: " .. player.UserId)
print("👤 User: " .. player.Name)

-- ============================================
-- ДИАГНОСТИКА
-- ============================================
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
        else
            print("🔴 Ошибка парсинга JSON")
        end
    end
else
    print("🔴 Файл НЕ СУЩЕСТВУЕТ")
end
print("🔴 _G.AuraCheatsKeyData: " .. tostring(_G.AuraCheatsKeyData))

-- ============================================
-- ГЛАВНАЯ ЛОГИКА
-- ============================================
local saved = loadData()

if saved and saved.key and saved.userId == player.UserId then
    print("🔑 Найден сохраненный ключ: " .. saved.key)
    
    local ok, result = checkKeyOnServer(saved.key)
    
    if ok then
        print("✅ Ключ валиден, загрузка скрипта...")
        print("🔍 result.session_token: " .. tostring(result.session_token))
        
        if not result.session_token then
            print("❌ session_token отсутствует!")
            showGUI()
            return
        end
        
        saveData({
            key = saved.key,
            userId = saved.userId,
            expires_at = result.expires_at or saved.expires_at,
            session_token = result.session_token,
            activationDate = saved.activationDate,
            expirationDate = saved.expirationDate
        })
        loadScriptFromServer(result.session_token)
    else
        print("❌ Ключ невалиден, требуется активация")
        showGUI()
    end
else
    print("🔑 Требуется активация")
    showGUI()
end