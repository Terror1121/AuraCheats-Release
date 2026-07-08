-- ============================================
-- 🔒 AURA CHEATS - ЗАГРУЗЧИК v3.4
-- ИСПРАВЛЕННАЯ ЗАГРУЗКА СКРИПТА
-- ============================================

print("🔧 Загрузка AuraCheats v3.4")

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
-- 2. ОБЕРТКИ ДЛЯ ФАЙЛОВ
-- ============================================
local function writeFile(path, data)
    if syn and syn.writefile then
        return syn.writefile(path, data)
    end
    return false
end

local function readFile(path)
    if syn and syn.readfile then
        return syn.readfile(path)
    end
    return nil
end

local function isFile(path)
    if syn and syn.isfile then
        return syn.isfile(path)
    end
    return false
end

-- ============================================
-- 3. РАБОТА С ФАЙЛАМИ
-- ============================================
local function saveData(data)
    local success, json = pcall(function()
        return game:GetService("HttpService"):JSONEncode(data)
    end)
    if success and json then
        return writeFile(CONFIG.SAVE_FILE, json)
    end
    return false
end

local function loadData()
    if isFile(CONFIG.SAVE_FILE) then
        local success, data = pcall(function()
            local content = readFile(CONFIG.SAVE_FILE)
            if content then
                return game:GetService("HttpService"):JSONDecode(content)
            end
            return nil
        end)
        if success and data then
            return data
        end
    end
    return nil
end

-- ============================================
-- 4. HTTP ЗАПРОСЫ (POST)
-- ============================================
local function sendRequest(endpoint, data)
    local url = CONFIG.API_URL .. endpoint
    local json = game:GetService("HttpService"):JSONEncode(data)
    
    print("📤 Отправка запроса на: " .. url)
    print("📤 Данные: " .. json)
    
    -- SYN.REQUEST
    if syn and syn.request then
        print("🔄 Использую syn.request")
        local response = syn.request({
            Url = url,
            Method = "POST",
            Headers = {
                ["Content-Type"] = "application/json"
            },
            Body = json
        })
        
        if response then
            print("📥 Ответ статус: " .. (response.StatusCode or "unknown"))
            print("📥 Ответ тело: " .. (response.Body or "empty"))
            
            if response.StatusCode == 200 then
                return game:GetService("HttpService"):JSONDecode(response.Body), nil
            else
                return nil, "HTTP " .. (response.StatusCode or "unknown")
            end
        end
    end
    
    -- HTTP.REQUEST (XENO)
    if http and http.request then
        print("🔄 Использую http.request")
        local response = http.request({
            Url = url,
            Method = "POST",
            Headers = {
                ["Content-Type"] = "application/json"
            },
            Body = json
        })
        
        if response then
            print("📥 Ответ статус: " .. (response.StatusCode or "unknown"))
            print("📥 Ответ тело: " .. (response.Body or "empty"))
            
            if response.StatusCode == 200 then
                return game:GetService("HttpService"):JSONDecode(response.Body), nil
            else
                return nil, "HTTP " .. (response.StatusCode or "unknown")
            end
        end
    end
    
    -- HTTPSERVICE:REQUESTASYNC
    print("🔄 Использую HttpService:RequestAsync")
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
    
    if success and response then
        print("📥 Ответ статус: " .. (response.StatusCode or "unknown"))
        print("📥 Ответ тело: " .. (response.Body or "empty"))
        
        if response.StatusCode == 200 then
            return game:GetService("HttpService"):JSONDecode(response.Body), nil
        else
            return nil, "HTTP " .. (response.StatusCode or "unknown")
        end
    end
    
    return nil, "No HTTP method available"
end

-- ============================================
-- 5. GET ЗАПРОС (ДЛЯ СКРИПТА)
-- ============================================
local function httpGet(url)
    print("📤 GET запрос: " .. url)
    
    -- SYN.REQUEST
    if syn and syn.request then
        local response = syn.request({
            Url = url,
            Method = "GET"
        })
        if response and response.StatusCode == 200 then
            return response.Body
        end
    end
    
    -- HTTP.REQUEST (XENO)
    if http and http.request then
        local response = http.request({
            Url = url,
            Method = "GET"
        })
        if response and response.StatusCode == 200 then
            return response.Body
        end
    end
    
    -- GAME:HTTPGET
    local success, result = pcall(function()
        return game:HttpGet(url)
    end)
    if success then
        return result
    end
    
    return nil
end

-- ============================================
-- 6. АКТИВАЦИЯ КЛЮЧА
-- ============================================
local function activateKey(key)
    local player = game.Players.LocalPlayer
    local execName = getexecutorname and getexecutorname() or "Unknown"
    
    print("📡 Активация ключа...")
    print("   User ID: " .. player.UserId)
    print("   User: " .. player.Name)
    print("   Injector: " .. execName)
    print("   Version: " .. CONFIG.VERSION)
    
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
        return false, err
    end
    
    if response.status == "success" then
        -- Получаем сессию
        local sessionData = {
            userId = player.UserId,
            executor = execName,
            version = CONFIG.VERSION,
            gameId = game.GameId or 0,
            placeId = game.PlaceId or 0
        }
        
        local sessionResponse, sessionErr = sendRequest("/session", sessionData)
        if not sessionResponse or sessionResponse.status ~= "success" then
            return false, "Failed to create session"
        end
        
        return true, {
            key = key,
            userId = player.UserId,
            expires_at = response.expires_at,
            session_token = sessionResponse.session
        }
    else
        return false, response.message or "Unknown error"
    end
end

-- ============================================
-- 7. РАСШИФРОВКА (XOR НА БАЙТАХ)
-- ============================================
local function decrypt(encrypted_b64, key)
    -- 1. Декодируем Base64
    local encrypted = ""
    
    -- Пробуем HttpService:Base64Decode
    local success, result = pcall(function()
        return game:GetService("HttpService"):Base64Decode(encrypted_b64)
    end)
    if success and result then
        encrypted = result
    end
    
    -- Пробуем crypt
    if encrypted == "" and crypt and crypt.base64decode then
        local success, result = pcall(function()
            return crypt.base64decode(encrypted_b64)
        end)
        if success and result then
            encrypted = result
        end
    end
    
    -- Пробуем syn.crypt
    if encrypted == "" and syn and syn.crypt and syn.crypt.base64 and syn.crypt.base64.decode then
        local success, result = pcall(function()
            return syn.crypt.base64.decode(encrypted_b64)
        end)
        if success and result then
            encrypted = result
        end
    end
    
    -- Пробуем base64 (глобальный)
    if encrypted == "" and base64 and base64.decode then
        local success, result = pcall(function()
            return base64.decode(encrypted_b64)
        end)
        if success and result then
            encrypted = result
        end
    end
    
    if encrypted == "" then
        return nil, "Base64 decode failed"
    end
    
    -- 2. XOR расшифровка
    local key_bytes = key
    local key_len = #key_bytes
    local out = {}
    
    for i = 1, #encrypted do
        local byte = string.byte(encrypted, i)
        local keyByte = string.byte(key_bytes, (i - 1) % key_len + 1)
        out[i] = string.char(bit32.bxor(byte, keyByte))
    end
    
    return table.concat(out), nil
end

-- ============================================
-- 8. ЗАГРУЗКА СКРИПТА С СЕРВЕРА
-- ============================================
local function loadScriptFromServer(session_token)
    print("📥 Загрузка скрипта с сервера...")
    
    local player = game.Players.LocalPlayer
    local userId = player.UserId
    
    local url = string.format(
        "%s/script?session=%s&user_id=%s",
        CONFIG.API_URL,
        session_token,
        userId
    )
    
    local raw_response = httpGet(url)
    if not raw_response then
        print("❌ Ошибка загрузки скрипта")
        return false
    end
    
    print("🔴 RAW RESPONSE (первые 200 символов):")
    print(raw_response:sub(1, 200))
    
    -- ============================================
    -- ✅ ПАРСИМ JSON (ВАЖНО!)
    -- ============================================
    local response_data = game:GetService("HttpService"):JSONDecode(raw_response)
    
    if not response_data or response_data.status ~= "success" then
        print("❌ Ошибка ответа сервера: " .. (response_data and response_data.detail or "unknown"))
        return false
    end
    
    local encrypted_b64 = response_data.script
    if not encrypted_b64 then
        print("❌ Нет поля 'script' в ответе")
        return false
    end
    
    print("🔴 ENCRYPTED B64 (первые 100 символов):")
    print(encrypted_b64:sub(1, 100))
    
    -- Расшифровка
    local key = CONFIG.ENCRYPT_KEY .. tostring(userId)
    local decrypted, err = decrypt(encrypted_b64, key)
    if not decrypted then
        print("❌ Ошибка расшифровки: " .. err)
        return false
    end
    
    -- ============================================
    -- ОТЛАДКА
    -- ============================================
    print("🔴 DECRYPTED LENGTH:", #decrypted)
    print("🔴 DECRYPTED FIRST 80 CHARS:", decrypted:sub(1, 80))
    
    local hex_bytes = {}
    for i = 1, math.min(16, #decrypted) do
        hex_bytes[i] = string.format("%02X", string.byte(decrypted, i))
    end
    print("🔴 HEX BYTES:", table.concat(hex_bytes, " "))
    
    if decrypted:sub(1,1) == "{" then
        print("🔴 DETECTED: JSON (NEED TO PARSE)")
    elseif decrypted:find("local") or decrypted:find("function") or decrypted:find("--") then
        print("🔴 DETECTED: LUA CODE")
    else
        print("🔴 DETECTED: UNKNOWN FORMAT")
    end
    
    -- Сохраняем для отладки
    if writeFile then
        writeFile("aura_debug.lua", decrypted)
        print("📁 debug file saved: aura_debug.lua")
    end
    
    -- Компилируем
    local func, err = loadstring(decrypted)
    if not func then
        print("❌ Ошибка компиляции: " .. (err or "unknown"))
        return false
    end
    
    print("✅ Скрипт загружен!")
    pcall(func)
    return true
end

-- ============================================
-- 9. ПАРСИНГ ДАТЫ
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
-- 10. GUI ВВОДА КЛЮЧА
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
                status.Text = "✅ Ключ активирован!"
                status.TextColor3 = Color3.fromRGB(100, 255, 100)
                
                saveData({
                    key = key,
                    userId = result.userId,
                    expires_at = result.expires_at,
                    session_token = result.session_token
                })
                
                task.wait(1)
                gui:Destroy()
                loadScriptFromServer(result.session_token)
            else
                attempts = attempts + 1
                status.Text = "❌ " .. result
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
-- 11. ЗАПУСК
-- ============================================
print("📅 " .. os.date("%Y-%m-%d %H:%M:%S"))

local player = game.Players.LocalPlayer
if not player then
    print("❌ Нет игрока")
    return
end

print("👤 User ID: " .. player.UserId)
print("👤 User: " .. player.Name)

-- Проверяем сохраненный ключ
local saved = loadData()
if saved and saved.session_token and saved.userId == player.UserId then
    print("🔑 Найден сохраненный ключ")
    
    if saved.expires_at then
        local exp = parseDate(saved.expires_at)
        if exp and os.time() >= exp then
            print("⚠️ Срок истек, требуется повторная активация")
            showGUI()
            return
        end
    end
    
    print("📥 Загрузка скрипта...")
    loadScriptFromServer(saved.session_token)
else
    print("🔑 Требуется активация")
    showGUI()
end