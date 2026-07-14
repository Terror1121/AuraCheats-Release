-- ============================================
-- 🔒 AURA CHEATS - ЗАГРУЗЧИК v5.31
-- FIX: АСИНХРОННАЯ ЗАГРУЗКА ДЛЯ XENO
-- ============================================

print("🔧 Загрузка AuraCheats v5.31")

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
-- 7. УНИВЕРСАЛЬНЫЙ ЗАПРОС (АСИНХРОННЫЙ)
-- ============================================
local function universalRequest(method, url, data, timeout, callback)
    timeout = timeout or 10
    local body = nil
    local headers = { ["Content-Type"] = "application/json" }
    
    if data then
        local success, result = pcall(function()
            return game:GetService("HttpService"):JSONEncode(data)
        end)
        if success then body = result else
            if callback then callback(nil, "json_error") end
            return
        end
    end
    
    -- syn.request
    if syn and syn.request then
        local success, response = pcall(function()
            return syn.request({
                Url = url,
                Method = method,
                Headers = headers,
                Body = body,
                Timeout = timeout
            })
        end)
        if success and response then
            if response.StatusCode == 200 then
                if type(response.Body) == "string" then
                    local success2, decoded = pcall(function()
                        return game:GetService("HttpService"):JSONDecode(response.Body)
                    end)
                    if success2 then
                        if callback then callback(decoded, response.StatusCode) end
                        return
                    end
                end
            else
                if callback then callback(nil, response.StatusCode) end
                return
            end
        end
    end
    
    -- http.request
    if http and http.request then
        local success, response = pcall(function()
            return http.request({
                Url = url,
                Method = method,
                Headers = headers,
                Body = body,
                Timeout = timeout
            })
        end)
        if success and response then
            if response.StatusCode == 200 then
                if type(response.Body) == "string" then
                    local success2, decoded = pcall(function()
                        return game:GetService("HttpService"):JSONDecode(response.Body)
                    end)
                    if success2 then
                        if callback then callback(decoded, response.StatusCode) end
                        return
                    end
                end
            else
                if callback then callback(nil, response.StatusCode) end
                return
            end
        end
    end
    
    -- HttpService:RequestAsync
    local success, response = pcall(function()
        return game:GetService("HttpService"):RequestAsync({
            Url = url,
            Method = method,
            Headers = headers,
            Body = body
        })
    end)
    if success and response then
        if response.StatusCode == 200 then
            local success2, decoded = pcall(function()
                return game:GetService("HttpService"):JSONDecode(response.Body)
            end)
            if success2 then
                if callback then callback(decoded, response.StatusCode) end
                return
            end
        else
            if callback then callback(nil, response.StatusCode) end
            return
        end
    end
    
    if callback then callback(nil, nil) end
end

-- ============================================
-- 8. GET ЗАПРОС (АСИНХРОННЫЙ)
-- ============================================
local function httpGetAsync(url, timeout, callback)
    timeout = timeout or 10
    
    if url:find("raw.githubusercontent.com") then
        url = url:gsub("raw.githubusercontent.com", "raw.githack.com")
    end
    
    -- syn.request
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
                if callback then callback(response.Body, 200) end
                return
            end
        end
    end
    
    -- http.request
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
                if callback then callback(response.Body, 200) end
                return
            end
        end
    end
    
    -- HttpService:RequestAsync
    local success, response = pcall(function()
        return game:GetService("HttpService"):RequestAsync({
            Url = url,
            Method = "GET"
        })
    end)
    if success and response and response.StatusCode == 200 then
        if callback then callback(response.Body, 200) end
        return
    end
    
    if callback then callback(nil, nil) end
end

-- ============================================
-- 9. ПРОВЕРКА ВЕРСИИ (АСИНХРОННАЯ)
-- ============================================
local function checkVersionAsync(callback)
    httpGetAsync(CONFIG.VERSION_URL, 10, function(response, status)
        if not response then
            print("⚠️ Не удалось проверить версию. Пропускаем.")
            if callback then callback(true) end
            return
        end
        
        local latestVersion = response:gsub("%s+", "")
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
                if c < l then
                    print("⚠️ ВЕРСИЯ УСТАРЕЛА! Текущая: " .. CONFIG.VERSION .. ", Последняя: " .. latestVersion)
                end
                if callback then callback(true) end
                return
            end
        end
        
        if callback then callback(true) end
    end)
end

-- ============================================
-- 10. ПРОВЕРКА КЛЮЧА (АСИНХРОННАЯ)
-- ============================================
local function checkKeyOnServerAsync(key, userId, callback)
    print("📡 Проверка ключа на сервере...")
    print("   KEY: " .. key)
    print("   User ID: " .. userId)
    
    local url = CONFIG.API_URL .. "/check"
    local data = { key = key, userId = userId }
    
    universalRequest("POST", url, data, 15, function(response, status)
        if not response then
            print("⚠️ Сервер недоступен, используем локальные данные")
            if callback then callback(true, nil) end
            return
        end
        
        print("📥 Ответ статус: " .. (response.status or "unknown"))
        
        if response.status == "active" then
            print("✅ Ключ активен!")
            if callback then callback(true, response) end
            return
        end
        
        if response.status == "expired" then
            print("❌ Ключ истек!")
            if callback then callback(false, "❌ Срок действия ключа истек") end
            return
        end
        
        if response.status == "inactive" then
            print("❌ Ключ не активирован!")
            if callback then callback(false, "❌ Ключ не активирован") end
            return
        end
        
        if callback then callback(false, response.message or "❌ Неизвестная ошибка") end
    end)
end

-- ============================================
-- 11. АКТИВАЦИЯ КЛЮЧА (АСИНХРОННАЯ)
-- ============================================
local function activateKeyAsync(key, callback)
    print("📡 Активация ключа...")
    print("   KEY: " .. key)
    
    local player = game.Players.LocalPlayer
    local execName = getexecutorname and getexecutorname() or "Unknown"
    
    local url = CONFIG.API_URL .. "/activate"
    local data = {
        key = key,
        userId = player.UserId,
        userName = player.Name,
        executor = execName,
        version = CONFIG.VERSION,
        gameId = game.GameId or 0,
        placeId = game.PlaceId or 0
    }
    
    universalRequest("POST", url, data, 15, function(response, status)
        if not response then
            if callback then callback(false, "❌ Ошибка подключения к серверу") end
            return
        end
        
        if response.status == "success" then
            print("✅ Ключ активирован!")
            if response.session_token then
                print("✅ Сессия получена: " .. response.session_token)
            end
            if callback then callback(true, response) end
            return
        end
        
        if response.status == "error" and response.message == "Key already activated" then
            print("✅ Ключ уже активирован, создаем сессию...")
            local sessionData = {
                userId = player.UserId,
                executor = execName,
                version = CONFIG.VERSION,
                gameId = game.GameId or 0,
                placeId = game.PlaceId or 0
            }
            local sessionUrl = CONFIG.API_URL .. "/session"
            universalRequest("POST", sessionUrl, sessionData, 15, function(sessionResponse, sessionStatus)
                if sessionResponse and sessionResponse.status == "success" then
                    print("✅ Сессия создана: " .. sessionResponse.session)
                    if callback then callback(true, {
                        session_token = sessionResponse.session,
                        expires_at = response.expires_at,
                        userId = player.UserId
                    }) end
                    return
                end
                if callback then callback(false, "❌ Ошибка создания сессии") end
            end)
            return
        end
        
        if response.status == "error" and response.message == "Key expired" then
            if callback then callback(false, "❌ Срок действия ключа истек") end
            return
        end
        
        if callback then callback(false, response.message or "❌ Неизвестная ошибка") end
    end)
end

-- ============================================
-- 12. ЗАГРУЗКА СКРИПТА (АСИНХРОННАЯ)
-- ============================================
local function loadScriptFromServerAsync(session_token, callback)
    print("📥 Загрузка скрипта с сервера...")
    
    local player = game.Players.LocalPlayer
    local userId = player.UserId
    local currentSession = session_token
    
    local function doLoadScript(token, cb)
        local url = string.format(
            "%s/script?session=%s&user_id=%s",
            CONFIG.API_URL,
            token,
            userId
        )
        
        print("⏳ Загрузка скрипта...")
        
        httpGetAsync(url, 30, function(raw_response, status)
            if not raw_response then
                print("❌ Ошибка загрузки скрипта")
                if cb then cb(nil, "timeout") end
                return
            end
            
            local response_data = nil
            local parseSuccess, parseResult = pcall(function()
                return game:GetService("HttpService"):JSONDecode(raw_response)
            end)
            
            if not parseSuccess or not parseResult then
                print("❌ Ошибка парсинга JSON")
                if cb then cb(nil, "parse_error") end
                return
            end
            
            response_data = parseResult
            
            if response_data.status == "error" then
                if response_data.message == "Invalid session" or 
                   response_data.message == "Session expired" then
                    if cb then cb(nil, "invalid_session") end
                    return
                end
                if cb then cb(nil, "server_error") end
                return
            end
            
            if response_data.status ~= "success" then
                if cb then cb(nil, "unknown_status") end
                return
            end
            
            if cb then cb(response_data, "success") end
        end)
    end
    
    doLoadScript(currentSession, function(response_data, status)
        if status == "invalid_session" then
            print("🔄 Сессия невалидна, создаем новую...")
            local execName = getexecutorname and getexecutorname() or "Unknown"
            local sessionData = {
                userId = userId,
                executor = execName,
                version = CONFIG.VERSION,
                gameId = game.GameId or 0,
                placeId = game.PlaceId or 0
            }
            local sessionUrl = CONFIG.API_URL .. "/session"
            universalRequest("POST", sessionUrl, sessionData, 15, function(sessionResponse, sessionStatus)
                if not sessionResponse or sessionResponse.status ~= "success" then
                    print("❌ Ошибка создания сессии")
                    if callback then callback(false) end
                    return
                end
                
                local new_session_token = sessionResponse.session
                print("✅ Новая сессия создана: " .. new_session_token)
                
                local saved = loadData()
                if saved then
                    saved.session_token = new_session_token
                    saveData(saved)
                end
                
                currentSession = new_session_token
                doLoadScript(currentSession, function(new_response, new_status)
                    if new_status ~= "success" then
                        print("❌ Ошибка загрузки скрипта: " .. new_status)
                        if callback then callback(false) end
                        return
                    end
                    
                    if callback then callback(true, new_response, currentSession) end
                end)
            end)
            return
        end
        
        if status ~= "success" then
            print("❌ Ошибка загрузки скрипта: " .. status)
            if callback then callback(false) end
            return
        end
        
        if callback then callback(true, response_data, currentSession) end
    end)
end

-- ============================================
-- 13. GUI ВВОДА КЛЮЧА (БЕЗ ИЗМЕНЕНИЙ)
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
            activateKeyAsync(key, function(ok, result)
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
                        loadScriptFromServerAsync(result.session_token, function(success)
                            if not success then
                                print("❌ Ошибка загрузки скрипта после активации")
                                status.Text = "❌ Ошибка загрузки скрипта"
                                status.TextColor3 = Color3.fromRGB(255, 80, 80)
                                btn.Active = true
                                btn.BackgroundColor3 = Color3.fromRGB(50, 50, 200)
                                btn.Text = "АКТИВИРОВАТЬ"
                            end
                        end)
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
        end)
    end
    
    btn.MouseButton1Click:Connect(doActivate)
    input.FocusLost:Connect(function(enter)
        if enter then doActivate() end
    end)
end

-- ============================================
-- 14. ЗАПУСК (АСИНХРОННЫЙ)
-- ============================================
print("📅 " .. os.date("%Y-%m-%d %H:%M:%S"))

local player = game.Players.LocalPlayer
if not player then
    print("❌ Нет игрока")
    return
end

print("👤 User ID: " .. player.UserId)
print("👤 User: " .. player.Name)

-- ДИАГНОСТИКА
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
            print("🔴   key: " .. tostring(data.key))
            print("🔴   userId: " .. tostring(data.userId))
            print("🔴   session_token: " .. tostring(data.session_token))
        end
    end
end

local saved = loadData()

if saved and saved.key and saved.userId == player.UserId then
    print("🔑 Найден сохраненный ключ: " .. saved.key)
    
    checkKeyOnServerAsync(saved.key, player.UserId, function(ok, result)
        if ok then
            print("✅ Ключ валиден, загрузка скрипта...")
            
            if not saved.session_token then
                print("⚠️ Нет session_token, создаем...")
                local execName = getexecutorname and getexecutorname() or "Unknown"
                local sessionData = {
                    userId = player.UserId,
                    executor = execName,
                    version = CONFIG.VERSION,
                    gameId = game.GameId or 0,
                    placeId = game.PlaceId or 0
                }
                local sessionUrl = CONFIG.API_URL .. "/session"
                universalRequest("POST", sessionUrl, sessionData, 15, function(sessionResponse, sessionStatus)
                    if sessionResponse and sessionResponse.status == "success" then
                        saved.session_token = sessionResponse.session
                        saveData({
                            key = saved.key,
                            userId = saved.userId,
                            session_token = sessionResponse.session,
                            activationDate = saved.activationDate,
                            expirationDate = saved.expirationDate
                        })
                        print("✅ session_token создан: " .. saved.session_token)
                    end
                    
                    if saved.session_token then
                        loadScriptFromServerAsync(saved.session_token, function(success)
                            if not success then
                                print("❌ Ошибка загрузки скрипта")
                                showGUI("❌ Ошибка загрузки скрипта")
                            end
                        end)
                    else
                        print("❌ Нет session_token!")
                        showGUI("❌ Ошибка получения сессии")
                    end
                end)
            else
                loadScriptFromServerAsync(saved.session_token, function(success)
                    if not success then
                        print("❌ Ошибка загрузки скрипта")
                        showGUI("❌ Ошибка загрузки скрипта")
                    end
                end)
            end
        else
            print("❌ Ключ невалиден: " .. tostring(result))
            if isFileUniversal(CONFIG.SAVE_FILE) then
                pcall(function()
                    if syn and syn.delfile then syn.delfile(CONFIG.SAVE_FILE) end
                    if delfile then delfile(CONFIG.SAVE_FILE) end
                end)
            end
            _G.AuraCheatsKeyData = nil
            showGUI(tostring(result))
        end
    end)
else
    print("🔑 Требуется активация")
    showGUI()
end