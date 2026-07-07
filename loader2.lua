-- ============================================
-- 🔒 AURA CHEATS - ЗАГРУЗЧИК v3.0
-- МИНИМАЛЬНЫЙ, ТОЛЬКО АКТИВАЦИЯ ПО USER ID
-- ============================================

print("🔧 Загрузка AuraCheats v3.0")

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
-- 2. РАБОТА С ФАЙЛАМИ
-- ============================================
local function saveData(data)
    local success, json = pcall(function()
        return game:GetService("HttpService"):JSONEncode(data)
    end)
    if success and json then
        writefile(CONFIG.SAVE_FILE, json)
        return true
    end
    return false
end

local function loadData()
    if isfile(CONFIG.SAVE_FILE) then
        local success, data = pcall(function()
            return game:GetService("HttpService"):JSONDecode(readfile(CONFIG.SAVE_FILE))
        end)
        if success and data then
            return data
        end
    end
    return nil
end

-- ============================================
-- 3. ОТПРАВКА ЗАПРОСА НА СЕРВЕР
-- ============================================
local function sendRequest(endpoint, data)
    local url = CONFIG.API_URL .. endpoint
    local json = game:GetService("HttpService"):JSONEncode(data)
    
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
    
    if not success then
        return nil, "Connection error"
    end
    
    if response.StatusCode ~= 200 then
        return nil, "HTTP " .. response.StatusCode
    end
    
    return game:GetService("HttpService"):JSONDecode(response.Body), nil
end

-- ============================================
-- 4. АКТИВАЦИЯ КЛЮЧА
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
-- 5. ЗАГРУЗКА СКРИПТА С СЕРВЕРА
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
    
    local success, response = pcall(function()
        return game:HttpGet(url)
    end)
    
    if not success then
        print("❌ Ошибка загрузки скрипта")
        return false
    end
    
    -- Расшифровка
    local key = CONFIG.ENCRYPT_KEY .. tostring(userId)
    local decrypted = ""
    for i = 1, #response do
        local code = (string.byte(response, i) - string.byte(key, (i-1) % #key + 1)) % 256
        decrypted = decrypted .. string.char(code)
    end
    
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
-- 7. GUI ВВОДА КЛЮЧА
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
-- 8. ЗАПУСК
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