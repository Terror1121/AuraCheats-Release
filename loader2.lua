-- ============================================
-- 🔒 AURA CHEATS - ЗАГРУЗЧИК v5.41
-- УНИВЕРСАЛЬНЫЙ (РАБОТАЕТ НА ВСЕХ ИНЖЕКТОРАХ)
-- ============================================

print("🔧 Загрузка AuraCheats v5.41 (Universal)")

-- ============================================
-- 1. КОНФИГУРАЦИЯ
-- ============================================
local CONFIG = {
    API_URLS = {
        "https://auracheats.ru/api/v6",
        "https://aura-cheats-bot.onrender.com/api/v6",
    },
    SAVE_FILE = "AuraCheatsKeyData",
    ENCRYPT_KEY = "AuraCheats2024",
    VERSION = "2.2.25",
}

-- ============================================
-- 2. ДИАГНОСТИКА ИНЖЕКТОРА
-- ============================================
local injectorName = "Unknown"
local hasSyn = type(syn) == "table"
local hasHttp = type(http) == "table"
local hasCrypto = type(crypt) == "table"
local hasBase64 = type(base64) == "table"

if getexecutorname then
    injectorName = getexecutorname() or "Unknown"
end

print("📋 ДИАГНОСТИКА:")
print("   Инжектор: " .. injectorName)
print("   syn: " .. tostring(hasSyn))
print("   http: " .. tostring(hasHttp))
print("   crypt: " .. tostring(hasCrypto))
print("   base64: " .. tostring(hasBase64))

-- ============================================
-- 3. HTTP GET (УНИВЕРСАЛЬНЫЙ)
-- ============================================
local function httpGet(url)
    print("📡 GET: " .. url)
    
    -- СПОСОБ 1: syn.request (Velocity, Synapse, Xeno, ScriptWare)
    if hasSyn and syn.request then
        local success, response = pcall(function()
            return syn.request({
                Url = url,
                Method = "GET",
                Timeout = 25,
                Headers = {
                    ["User-Agent"] = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36",
                    ["Accept"] = "application/json"
                }
            })
        end)
        if success and response then
            if response.StatusCode == 200 and type(response.Body) == "string" then
                print("✅ GET через syn.request")
                return response.Body
            end
            if response.StatusCode then
                print("⚠️ syn.request статус: " .. tostring(response.StatusCode))
            end
        end
    end
    
    -- СПОСОБ 2: http.request (Krnl, Fluxus, Hydrogen)
    if hasHttp and http.request then
        local success, response = pcall(function()
            return http.request({
                Url = url,
                Method = "GET",
                Timeout = 25,
                Headers = {
                    ["User-Agent"] = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36",
                    ["Accept"] = "application/json"
                }
            })
        end)
        if success and response then
            if response.StatusCode == 200 and type(response.Body) == "string" then
                print("✅ GET через http.request")
                return response.Body
            end
            if response.StatusCode then
                print("⚠️ http.request статус: " .. tostring(response.StatusCode))
            end
        end
    end
    
    -- СПОСОБ 3: game:HttpGet (работает везде!)
    local success, result = pcall(function()
        return game:HttpGet(url)
    end)
    if success and result then
        print("✅ GET через game:HttpGet")
        return result
    end
    
    -- СПОСОБ 4: game.HttpGet (старый метод)
    if game.HttpGet then
        local success, result = pcall(function()
            return game.HttpGet(url)
        end)
        if success and result then
            print("✅ GET через game.HttpGet")
            return result
        end
    end
    
    -- СПОСОБ 5: HttpService:RequestAsync (если ничего не помогло)
    local success, response = pcall(function()
        return game:GetService("HttpService"):RequestAsync({
            Url = url,
            Method = "GET",
            Headers = {
                ["User-Agent"] = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36",
                ["Accept"] = "application/json"
            }
        })
    end)
    if success and response and response.StatusCode == 200 then
        if type(response.Body) == "string" then
            print("✅ GET через HttpService")
            return response.Body
        end
    end
    
    print("❌ Все методы GET не удались!")
    return nil
end

-- ============================================
-- 3.1 API GET С ЗЕРКАЛАМИ
-- ============================================
local function apiGet(path)
    for i, baseUrl in ipairs(CONFIG.API_URLS) do
        local url = baseUrl .. path
        print("🌐 API зеркало #" .. i .. ": " .. baseUrl)
        local result = httpGet(url)
        if result then
            return result
        end
        print("⚠️ Зеркало #" .. i .. " недоступно, пробуем следующее...")
    end
    return nil
end

-- ============================================
-- 4. УНИВЕРСАЛЬНАЯ ЗАПИСЬ ФАЙЛА
-- ============================================
local function writeFileUniversal(path, data)
    if hasSyn and syn.writefile then
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
    if hasSyn and syn.readfile then
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
    if hasSyn and syn.isfile then
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
-- 6. АКТИВАЦИЯ КЛЮЧА (ЧЕРЕЗ GET)
-- ============================================
local function activateKey(key)
    print("📡 Активация ключа...")
    print("   KEY: " .. key)
    
    local player = game.Players.LocalPlayer
    local execName = injectorName
    
    local path = "/activate?key=" .. key ..
                "&userId=" .. tostring(player.UserId) ..
                "&userName=" .. tostring(player.Name) ..
                "&executor=" .. tostring(execName) ..
                "&version=" .. tostring(CONFIG.VERSION) ..
                "&gameId=" .. tostring(game.GameId or 0) ..
                "&placeId=" .. tostring(game.PlaceId or 0)
    
    local response_str = apiGet(path)
    
    if not response_str then
        return false, "❌ Ошибка подключения к серверу"
    end
    
    local response = nil
    local success, result = pcall(function()
        return game:GetService("HttpService"):JSONDecode(response_str)
    end)
    
    if not success or not result then
        return false, "❌ Ошибка парсинга ответа"
    end
    
    response = result
    
    if response.status == "success" then
        print("✅ Ключ активирован!")
        if response.session_token then
            print("✅ Сессия получена: " .. response.session_token)
        end
        return true, response
    elseif response.status == "error" and response.message == "Key already activated" then
        print("✅ Ключ уже активирован, создаем сессию...")
        local sessionPath = "/session?user_id=" .. tostring(player.UserId) ..
                           "&executor=" .. tostring(execName) ..
                           "&version=" .. tostring(CONFIG.VERSION)
        local sessionResponse_str = apiGet(sessionPath)
        if sessionResponse_str then
            local sessionResult = game:GetService("HttpService"):JSONDecode(sessionResponse_str)
            if sessionResult and sessionResult.status == "success" and sessionResult.session then
                print("✅ Сессия создана: " .. sessionResult.session)
                return true, {
                    session_token = sessionResult.session,
                    expires_at = response.expires_at,
                    userId = player.UserId
                }
            end
        end
        return false, "❌ Ошибка создания сессии"
    else
        return false, response.message or "❌ Неизвестная ошибка"
    end
end

-- ============================================
-- 7. ЗАГРУЗКА СКРИПТА (УНИВЕРСАЛЬНАЯ)
-- ============================================
local function loadScriptFromServer(session_token, moduleId)
    print("📥 Загрузка скрипта с сервера...")
    
    local player = game.Players.LocalPlayer
    local userId = player.UserId
    local currentSession = session_token
    
    if not moduleId or moduleId == "" then
        moduleId = "main"
    end
    
    local function doLoadScript(token)
        local path = "/script?session=" .. token .. "&user_id=" .. userId .. "&script_name=" .. moduleId
        
        local raw_response = apiGet(path)
        
        if not raw_response then
            return nil, "empty_response"
        end
        
        if raw_response:find('"detail":"Invalid session"') or raw_response:find('"status":"error"') then
            return nil, "invalid_session"
        end
        
        local response_data = nil
        local success, result = pcall(function()
            return game:GetService("HttpService"):JSONDecode(raw_response)
        end)
        
        if not success or not result then
            return nil, "parse_error"
        end
        
        response_data = result
        
        if response_data.status == "error" then
            if response_data.message == "Invalid session" or response_data.message == "Session expired" then
                return nil, "invalid_session"
            end
            return nil, "server_error"
        end
        
        if response_data.status ~= "success" then
            return nil, "unknown_status"
        end
        
        return response_data, "success"
    end
    
    local response_data, status = doLoadScript(currentSession)
    
    -- Retry on any error (replication lag, WAF, network issues)
    if status ~= "success" and status ~= "invalid_session" then
        print("🔄 Повтор через 1 сек (ошибка: " .. status .. ")...")
        task.wait(1)
        response_data, status = doLoadScript(currentSession)
    end
    
    if status ~= "success" and status ~= "invalid_session" then
        print("🔄 Вторая попытка через 2 сек...")
        task.wait(2)
        response_data, status = doLoadScript(currentSession)
    end
    
    if status == "invalid_session" then
        print("🔄 Сессия невалидна, создаем новую...")
        local execName = injectorName
        local sessionPath = "/session?user_id=" .. userId ..
                           "&executor=" .. execName ..
                           "&version=" .. CONFIG.VERSION
        
        local sessionResponse_str = apiGet(sessionPath)
        if not sessionResponse_str then
            print("❌ Ошибка создания сессии")
            return false
        end
        
        local sessionResponse = game:GetService("HttpService"):JSONDecode(sessionResponse_str)
        if not sessionResponse or sessionResponse.status ~= "success" then
            print("❌ Ошибка создания сессии")
            return false
        end
        
        local new_session_token = sessionResponse.session
        print("✅ Новая сессия создана: " .. new_session_token)
        
        local saved = loadData()
        if saved then
            saved.session_token = new_session_token
            saveData(saved)
        end
        
        currentSession = new_session_token
        response_data, status = doLoadScript(currentSession)
        if status ~= "success" then
            print("❌ Ошибка загрузки скрипта: " .. status)
            return false
        end
    end
    
    if status ~= "success" then
        print("❌ Ошибка загрузки скрипта: " .. status)
        return false
    end
    
    local encrypted_b64 = response_data.script
    if not encrypted_b64 then
        print("❌ Нет поля 'script'")
        return false
    end
    
    encrypted_b64 = encrypted_b64:gsub("%s+", "")
    
    print("📦 Декодируем Base64...")
    
    local encrypted_bytes = nil
    
    -- crypt.base64decode (Krnl, Fluxus)
    if hasCrypto and crypt.base64decode then
        local success, result = pcall(function() return crypt.base64decode(encrypted_b64) end)
        if success then encrypted_bytes = result end
    end
    
    -- syn.crypt.base64.decode (Velocity, Synapse, Xeno)
    if not encrypted_bytes and hasSyn and syn.crypt and syn.crypt.base64 and syn.crypt.base64.decode then
        local success, result = pcall(function() return syn.crypt.base64.decode(encrypted_b64) end)
        if success then encrypted_bytes = result end
    end
    
    -- base64.decode (некоторые инжекторы)
    if not encrypted_bytes and hasBase64 and base64.decode then
        local success, result = pcall(function() return base64.decode(encrypted_b64) end)
        if success then encrypted_bytes = result end
    end
    
    if not encrypted_bytes then
        print("❌ Ошибка декодирования Base64")
        return false
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
            session_token = currentSession
        }
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
    
    task.spawn(function()
        print("⏳ Запуск через 1 секунду...")
        task.wait(1)
        local execSuccess, execErr = pcall(func, keyData)
        if execSuccess then
            print("✅ Скрипт выполнен успешно!")
        else
            print("❌ Ошибка выполнения: " .. tostring(execErr))
        end
    end)
    
    return true
end

-- ============================================
-- 8. GUI ВВОДА КЛЮЧА
-- ============================================
local function showGUI(errorMessage)
    local player = game.Players.LocalPlayer
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
                    loadScriptFromServer(result.session_token, "main")
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
-- 9. ЗАПУСК
-- ============================================
print("📅 " .. os.date("%Y-%m-%d %H:%M:%S"))

local player = game.Players.LocalPlayer
if not player then
    print("❌ Нет игрока")
    return
end

print("👤 User ID: " .. player.UserId)
print("👤 User: " .. player.Name)

local saved = loadData()

if saved and saved.key and saved.userId == player.UserId then
    print("🔑 Найден сохраненный ключ: " .. saved.key)
    
    if saved.session_token then
        print("🎫 Сессия найдена: " .. saved.session_token)
        loadScriptFromServer(saved.session_token, "main")
    else
        print("⚠️ Нет session_token, создаем...")
        local sessionPath = "/session?user_id=" .. player.UserId ..
                           "&executor=" .. injectorName ..
                           "&version=" .. CONFIG.VERSION
        local sessionResponse_str = apiGet(sessionPath)
        if sessionResponse_str then
            local sessionResponse = game:GetService("HttpService"):JSONDecode(sessionResponse_str)
            if sessionResponse and sessionResponse.status == "success" and sessionResponse.session then
                saved.session_token = sessionResponse.session
                saveData(saved)
                print("✅ session_token создан: " .. saved.session_token)
                loadScriptFromServer(saved.session_token, "main")
            else
                print("❌ Ошибка создания сессии")
                showGUI("❌ Ошибка создания сессии")
            end
        else
            print("❌ Ошибка создания сессии")
            showGUI("❌ Ошибка создания сессии")
        end
    end
else
    print("🔑 Требуется активация")
    showGUI()
end