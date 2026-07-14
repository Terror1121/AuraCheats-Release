-- ============================================
-- 🔒 AURA CHEATS - ЗАГРУЗЧИК v5.42
-- FIX: АСИНХРОННАЯ ЗАГРУЗКА (НЕТ ЗАВИСАНИЙ!)
-- РАБОТАЕТ НА ВСЕХ ИНЖЕКТОРАХ
-- ============================================

print("🔧 Загрузка AuraCheats v5.42")

-- ============================================
-- 1. КОНФИГУРАЦИЯ
-- ============================================
local CONFIG = {
    API_URL = "https://aura-cheats-bot.onrender.com/api/v6",
    SAVE_FILE = "AuraCheatsKeyData",
    ENCRYPT_KEY = "AuraCheats2024",
    VERSION = "2.2.25",
}

-- ============================================
-- 2. УНИВЕРСАЛЬНАЯ ЗАПИСЬ ФАЙЛА
-- ============================================
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
-- 3. РАБОТА С ДАННЫМИ
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
-- 4. АСИНХРОННЫЙ ЗАПРОС (НЕ БЛОКИРУЕТ!)
-- ============================================
local function asyncRequest(url, method, data, callback, timeout)
    timeout = timeout or 15
    local body = data and game:GetService("HttpService"):JSONEncode(data) or nil
    
    task.spawn(function()
        local result = nil
        local statusCode = nil
        
        -- 1️⃣ syn.request (Synapse, Xeno, Krnl, Solara, Velocity)
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
                statusCode = response.StatusCode
                if response.StatusCode == 200 then
                    if type(response.Body) == "string" then
                        result = game:GetService("HttpService"):JSONDecode(response.Body)
                    end
                end
            end
        end
        
        -- 2️⃣ http.request (SirHurt, ScriptWare, Fluxus)
        if not result and http and http.request then
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
                statusCode = response.StatusCode
                if response.StatusCode == 200 then
                    if type(response.Body) == "string" then
                        result = game:GetService("HttpService"):JSONDecode(response.Body)
                    end
                end
            end
        end
        
        -- 3️⃣ HttpService:RequestAsync (JJSploit, Hydrogen, Delta)
        if not result then
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
                statusCode = response.StatusCode
                if response.StatusCode == 200 then
                    if type(response.Body) == "string" then
                        result = game:GetService("HttpService"):JSONDecode(response.Body)
                    end
                end
            end
        end
        
        if callback then
            callback(result, statusCode)
        end
    end)
end

-- ============================================
-- 5. ЗАГРУЗКА ОСНОВНОГО СКРИПТА (С GITHUB)
-- ============================================
local function loadMainScript(keyData)
    print("📥 Загрузка основного скрипта...")
    
    local url = "https://raw.githubusercontent.com/Terror1121/AuraCheats-Release/main/main_clean.lua"
    
    local success, script = pcall(function()
        return game:HttpGet(url)
    end)
    
    if not success or not script or #script < 100 then
        print("❌ Ошибка загрузки основного скрипта")
        return
    end
    
    local func, err = loadstring(script)
    if not func then
        print("❌ Ошибка компиляции: " .. tostring(err))
        return
    end
    
    print("✅ Скрипт загружен, запуск...")
    pcall(func, keyData)
end

-- ============================================
-- 6. ЗАГРУЗКА СКРИПТА С СЕРВЕРА (АСИНХРОННО)
-- ============================================
local function loadScriptFromServerAsync(session_token, userId)
    local url = string.format(
        "%s/script?session=%s&user_id=%s",
        CONFIG.API_URL,
        session_token,
        userId
    )
    
    print("📥 Загрузка скрипта с сервера...")
    
    asyncRequest(url, "GET", nil, function(response, statusCode)
        if statusCode == 401 then
            print("⚠️ Сессия невалидна, создаем новую...")
            
            local sessionData = {
                userId = userId,
                executor = getexecutorname and getexecutorname() or "Unknown",
                version = CONFIG.VERSION
            }
            local sessionUrl = CONFIG.API_URL .. "/session"
            
            asyncRequest(sessionUrl, "POST", sessionData, function(sessionResponse)
                if sessionResponse and sessionResponse.status == "success" then
                    local newSession = sessionResponse.session
                    print("✅ Новая сессия создана: " .. newSession)
                    
                    local saved = loadData()
                    if saved then
                        saved.session_token = newSession
                        saveData(saved)
                    end
                    
                    loadScriptFromServerAsync(newSession, userId)
                else
                    print("❌ Ошибка создания сессии")
                end
            end)
            return
        end
        
        if not response or response.status ~= "success" then
            print("❌ Ошибка загрузки скрипта")
            return
        end
        
        local encrypted_b64 = response.script
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
        
        print("📦 Расшифровываем XOR...")
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
            print("❌ Ошибка компиляции: " .. (err or "unknown"))
            return
        end
        
        print("✅ Скрипт загружен!")
        pcall(func, keyData)
    end)
end

-- ============================================
-- 7. АСИНХРОННАЯ ПРОВЕРКА КЛЮЧА
-- ============================================
local function checkKeyAsync(key, userId)
    print("📡 Проверка ключа...")
    
    local url = CONFIG.API_URL .. "/check"
    local data = { key = key, userId = userId }
    
    asyncRequest(url, "POST", data, function(response, statusCode)
        if not response then
            print("⚠️ Сервер недоступен, используем локальные данные")
            local saved = loadData()
            if saved and saved.session_token then
                loadScriptFromServerAsync(saved.session_token, userId)
            else
                showGUI("❌ Ошибка подключения к серверу")
            end
            return
        end
        
        print("📥 Статус: " .. (response.status or "unknown"))
        
        if response.status == "active" then
            print("✅ Ключ активен!")
            local saved = loadData()
            if saved and saved.session_token then
                loadScriptFromServerAsync(saved.session_token, userId)
            else
                loadMainScript({ isValid = true, key = key, userId = userId })
            end
        elseif response.status == "expired" then
            print("❌ Ключ истек!")
            showGUI("❌ Срок действия ключа истек")
        elseif response.status == "inactive" then
            print("❌ Ключ не активирован!")
            showGUI("❌ Ключ не активирован")
        else
            print("❌ Ошибка: " .. (response.message or "unknown"))
            showGUI("❌ Ошибка проверки ключа")
        end
    end)
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
            local url = CONFIG.API_URL .. "/activate"
            local data = {
                key = key,
                userId = player.UserId,
                userName = player.Name,
                executor = getexecutorname and getexecutorname() or "Unknown",
                version = CONFIG.VERSION,
                gameId = game.GameId or 0,
                placeId = game.PlaceId or 0
            }
            
            asyncRequest(url, "POST", data, function(response, statusCode)
                if not response then
                    status.Text = "❌ Ошибка подключения к серверу"
                    status.TextColor3 = Color3.fromRGB(255, 80, 80)
                    btn.Active = true
                    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 200)
                    btn.Text = "АКТИВИРОВАТЬ"
                    return
                end
                
                if response.status == "success" then
                    status.Text = "✅ Ключ активирован!"
                    status.TextColor3 = Color3.fromRGB(100, 255, 100)
                    
                    if response.session_token then
                        saveData({
                            key = key,
                            userId = player.UserId,
                            expires_at = response.expires_at,
                            session_token = response.session_token,
                            activationDate = os.time(),
                            expirationDate = parseDate(response.expires_at) or (os.time() + 86400 * 7)
                        })
                        task.wait(0.5)
                        gui:Destroy()
                        loadScriptFromServerAsync(response.session_token, player.UserId)
                    end
                elseif response.status == "error" and response.message == "Key already activated" then
                    -- Ключ уже активирован — создаём сессию
                    local sessionUrl = CONFIG.API_URL .. "/session"
                    local sessionData = {
                        userId = player.UserId,
                        executor = getexecutorname and getexecutorname() or "Unknown",
                        version = CONFIG.VERSION
                    }
                    asyncRequest(sessionUrl, "POST", sessionData, function(sessionResponse)
                        if sessionResponse and sessionResponse.status == "success" then
                            status.Text = "✅ Ключ активирован!"
                            status.TextColor3 = Color3.fromRGB(100, 255, 100)
                            saveData({
                                key = key,
                                userId = player.UserId,
                                session_token = sessionResponse.session,
                                activationDate = os.time(),
                                expirationDate = os.time() + 86400 * 7
                            })
                            task.wait(0.5)
                            gui:Destroy()
                            loadScriptFromServerAsync(sessionResponse.session, player.UserId)
                        end
                    end)
                else
                    attempts = attempts + 1
                    status.Text = "❌ " .. (response.message or "Ошибка активации")
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
    checkKeyAsync(saved.key, player.UserId)
else
    print("🔑 Требуется активация")
    showGUI()
end

print("✅ Загрузка запущена! Ожидайте...")