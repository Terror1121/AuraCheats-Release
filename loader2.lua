-- ============================================
-- AURA CHEATS - Loader v2.2.25 (Universal)
-- ============================================

-- 1. Detecting the Injector
local injectorName = "Unknown"
local hasSyn = type(syn) == "table"
local hasHttp = type(http) == "table"
local hasCrypto = type(crypt) == "table"
local hasBase64 = type(base64) == "table"

if getexecutorname then
	injectorName = getexecutorname() or "Unknown"
end

-- 2. Config
local CONFIG = {
	API_URLS = {
		"https://auracheats.ru/api/v6",
		"https://aura-cheats-bot.onrender.com/api/v6",
	},
	SAVE_FILE = "AuraCheatsKeyData",
	ENCRYPT_KEY = "AuraCheats2024",
	VERSION = "2.2.25",
}

local player = nil

-- 3. HTTP GET (5 methods)
local function httpGet(url)
	-- Method 1: syn.request
	if hasSyn and syn.request then
		local ok, res = pcall(function()
			return syn.request({
				Url = url, Method = "GET", Timeout = 25,
				Headers = {["User-Agent"] = "Mozilla/5.0", ["Accept"] = "application/json"}
			})
		end)
		if ok and res and res.StatusCode == 200 and type(res.Body) == "string" then
			return res.Body
		end
	end

	-- Method 2: http.request
	if hasHttp and http.request then
		local ok, res = pcall(function()
			return http.request({
				Url = url, Method = "GET", Timeout = 25,
				Headers = {["User-Agent"] = "Mozilla/5.0", ["Accept"] = "application/json"}
			})
		end)
		if ok and res and res.StatusCode == 200 and type(res.Body) == "string" then
			return res.Body
		end
	end

	-- Method 3: game:HttpGet
	local ok, res = pcall(function() return game:HttpGet(url) end)
	if ok and res then return res end

	-- Method 4: game.HttpGet
	if game.HttpGet then
		local ok, res = pcall(function() return game.HttpGet(url) end)
		if ok and res then return res end
	end

	-- Method 5: HttpService:RequestAsync
	local ok, res = pcall(function()
		return game:GetService("HttpService"):RequestAsync({
			Url = url, Method = "GET",
			Headers = {["User-Agent"] = "Mozilla/5.0", ["Accept"] = "application/json"}
		})
	end)
	if ok and res and res.StatusCode == 200 and type(res.Body) == "string" then
		return res.Body
	end

	return nil
end

-- 4. API GET (mirror fallback)
local function apiGet(path)
	for i, baseUrl in ipairs(CONFIG.API_URLS) do
		local result = httpGet(baseUrl .. path)
		if result then return result end
	end
	return nil
end

-- 5. File read/write
local function writeFileUniversal(path, data)
	if hasSyn and syn.writefile then
		local ok = pcall(function() syn.writefile(path, data) end)
		if ok then return true end
	end
	if writefile then
		local ok = pcall(function() writefile(path, data) end)
		if ok then return true end
	end
	return false
end

local function readFileUniversal(path)
	if hasSyn and syn.readfile then
		local ok, res = pcall(function() return syn.readfile(path) end)
		if ok and res then return res end
	end
	if readfile then
		local ok, res = pcall(function() return readfile(path) end)
		if ok and res then return res end
	end
	return nil
end

local function isFileUniversal(path)
	if hasSyn and syn.isfile then
		local ok, res = pcall(function() return syn.isfile(path) end)
		if ok then return res end
	end
	if isfile then
		local ok, res = pcall(function() return isfile(path) end)
		if ok then return res end
	end
	return false
end

-- 6. Data save/load
local function saveData(data)
	_G.AuraCheatsKeyData = data
	local ok, json = pcall(function()
		return game:GetService("HttpService"):JSONEncode(data)
	end)
	if ok and json then
		writeFileUniversal(CONFIG.SAVE_FILE, json)
	end
end

local function loadData()
	if _G.AuraCheatsKeyData then
		return _G.AuraCheatsKeyData
	end
	if isFileUniversal(CONFIG.SAVE_FILE) then
		local content = readFileUniversal(CONFIG.SAVE_FILE)
		if content then
			local ok, data = pcall(function()
				return game:GetService("HttpService"):JSONDecode(content)
			end)
			if ok and data then
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
			year = tonumber(year), month = tonumber(month), day = tonumber(day),
			hour = tonumber(hour), min = tonumber(minute), sec = tonumber(second)
		})
	end
	return nil
end

-- 7. Key activation
local function activateKey(key)
	local player = game.Players.LocalPlayer
	local path = "/activate?key=" .. key ..
		"&userId=" .. tostring(player.UserId) ..
		"&userName=" .. tostring(player.Name) ..
		"&executor=" .. tostring(injectorName) ..
		"&version=" .. tostring(CONFIG.VERSION) ..
		"&gameId=" .. tostring(game.GameId or 0) ..
		"&placeId=" .. tostring(game.PlaceId or 0)

	local responseStr = apiGet(path)
	if not responseStr then
		return false, "Server connection error"
	end

	local ok, response = pcall(function()
		return game:GetService("HttpService"):JSONDecode(responseStr)
	end)
	if not ok or not response then
		return false, "Response parse error"
	end

	if response.status == "success" then
		return true, response
	elseif response.status == "error" and response.message == "Key blocked" then
		return false, "Ваш ключ заблокирован по причине:\n" .. tostring(response.reason or "Без указания причины")
	elseif response.status == "error" and (response.message == "Key already activated" or response.message == "Key is active") then
		local sessionPath = "/session?user_id=" .. tostring(player.UserId) ..
			"&executor=" .. tostring(injectorName) ..
			"&version=" .. tostring(CONFIG.VERSION)
		local sessionStr = apiGet(sessionPath)
		if sessionStr then
			local ok2, sessionRes = pcall(function()
				return game:GetService("HttpService"):JSONDecode(sessionStr)
			end)
			if ok2 and sessionRes and sessionRes.status == "success" and sessionRes.session then
				return true, {
					session_token = sessionRes.session,
					expires_at = response.expires_at,
					userId = player.UserId
				}
			end
			if ok2 and sessionRes and sessionRes.message == "Key blocked" then
				return false, "Ваш ключ заблокирован по причине:\n" .. tostring(sessionRes.reason or "Без указания причины")
			end
		end
		return false, "Session creation failed"
	end

	return false, response.message or "Unknown error"
end

-- 8. Script loading
local function showBlocked(reason)
	showGUI("Ключ заблокирован. Введите другой ключ.")
	local blockedGui = Instance.new("ScreenGui")
	blockedGui.Name = "AuraBlocked"
	blockedGui.ResetOnSpawn = false
	blockedGui.DisplayOrder = 10000
	blockedGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
	local overlay = Instance.new("Frame")
	overlay.Size = UDim2.fromScale(1, 1)
	overlay.BackgroundColor3 = Color3.fromRGB(5, 7, 15)
	overlay.BackgroundTransparency = 1
	overlay.Parent = blockedGui
	local box = Instance.new("Frame")
	box.AnchorPoint = Vector2.new(0.5, 0.5)
	box.Position = UDim2.fromScale(0.5, 0.5)
	box.Size = UDim2.fromOffset(430, 190)
	box.BackgroundColor3 = Color3.fromRGB(20, 20, 35)
	box.BorderSizePixel = 0
	box.Parent = overlay
	Instance.new("UICorner", box).CornerRadius = UDim.new(0, 12)
	local outline = Instance.new("UIStroke", box)
	outline.Color = Color3.fromRGB(255, 83, 100)
	outline.Thickness = 1.5
	local title = Instance.new("TextLabel", box)
	title.Position = UDim2.new(0, 24, 0, 22)
	title.Size = UDim2.new(1, -48, 0, 30)
	title.BackgroundTransparency = 1
	title.Text = "Ключ заблокирован"
	title.TextColor3 = Color3.fromRGB(255, 110, 120)
	title.TextSize = 21
	title.Font = Enum.Font.GothamBold
	title.TextXAlignment = Enum.TextXAlignment.Left
	local message = Instance.new("TextLabel", box)
	message.Position = UDim2.new(0, 24, 0, 68)
	message.Size = UDim2.new(1, -48, 0, 75)
	message.BackgroundTransparency = 1
	message.Text = "Ваш ключ заблокирован по причине:\n" .. tostring(reason) .. "\n\nПоддержка: discord.gg/XPwdHN4jHf"
	message.TextColor3 = Color3.fromRGB(235, 238, 250)
	message.TextSize = 14
	message.Font = Enum.Font.Gotham
	message.TextWrapped = true
	message.TextXAlignment = Enum.TextXAlignment.Left
	message.TextYAlignment = Enum.TextYAlignment.Top
	local copy = Instance.new("TextButton", box)
	copy.Position = UDim2.new(0, 24, 1, -48)
	copy.Size = UDim2.fromOffset(210, 32)
	copy.BackgroundColor3 = Color3.fromRGB(70, 55, 150)
	copy.BorderSizePixel = 0
	copy.Text = "Скопировать Discord"
	copy.TextColor3 = Color3.fromRGB(255, 255, 255)
	copy.TextSize = 13
	copy.Font = Enum.Font.GothamBold
	Instance.new("UICorner", copy).CornerRadius = UDim.new(0, 7)
	copy.MouseButton1Click:Connect(function()
		if setclipboard then setclipboard("https://discord.gg/XPwdHN4jHf") end
		copy.Text = "Ссылка скопирована"
	end)
	local close = Instance.new("TextButton", box)
	close.AnchorPoint = Vector2.new(1, 0)
	close.Position = UDim2.new(1, -12, 0, 10)
	close.Size = UDim2.fromOffset(28, 28)
	close.BackgroundTransparency = 1
	close.Text = "✕"
	close.TextColor3 = Color3.fromRGB(255, 110, 120)
	close.TextSize = 16
	close.Font = Enum.Font.GothamBold
	close.MouseButton1Click:Connect(function() blockedGui:Destroy() end)
end

local function loadScriptFromServer(session_token, moduleId)
	local player = game.Players.LocalPlayer
	local userId = player.UserId
	local currentSession = session_token
	moduleId = moduleId or "main"

	local function doLoadScript(token)
		local path = "/script?session=" .. token .. "&user_id=" .. userId .. "&script_name=" .. moduleId
		local raw = apiGet(path)
		if not raw then return nil, "empty_response" end

		local ok, res = pcall(function()
			return game:GetService("HttpService"):JSONDecode(raw)
		end)
		if not ok or not res then return nil, "parse_error" end

		if res.status == "error" then
			if res.message == "Key blocked" or tostring(res.detail or ""):find("Key blocked", 1, true) then
				return nil, "blocked:" .. tostring(res.reason or res.detail or "Без указания причины")
			end
			return nil, "server_error"
		end
		if res.detail and tostring(res.detail):find("Key blocked", 1, true) then
			return nil, "blocked:" .. tostring(res.detail)
		end
		if res.status ~= "success" then
			return nil, "unknown_status"
		end
		return res, "success"
	end

	-- Attempt 1
	local response, status = doLoadScript(currentSession)

	-- Retry once
	if status ~= "success" then
		task.wait(1)
		response, status = doLoadScript(currentSession)
	end

	-- Create new session and retry
	if status ~= "success" then
		local sessionPath = "/session?user_id=" .. userId ..
			"&executor=" .. injectorName ..
			"&version=" .. CONFIG.VERSION
		local sessionStr = apiGet(sessionPath)
		if sessionStr then
			local ok, sessionRes = pcall(function()
				return game:GetService("HttpService"):JSONDecode(sessionStr)
			end)
			if ok and sessionRes and sessionRes.status == "success" and sessionRes.session then
				currentSession = sessionRes.session
				local saved = loadData()
				if saved then
					saved.session_token = currentSession
					saveData(saved)
				end
				response, status = doLoadScript(currentSession)
			end
		end
	end

	if status ~= "success" then
		if tostring(status):sub(1, 8) == "blocked:" then
			showBlocked(tostring(status):sub(9))
		end
		return false
	end

	-- Decode Base64
	local encryptedB64 = response.script
	if not encryptedB64 then return false end

	local encryptedBytes = nil

	if hasCrypto and crypt.base64decode then
		local ok, res = pcall(function() return crypt.base64decode(encryptedB64) end)
		if ok then encryptedBytes = res end
	end

	if not encryptedBytes and hasSyn and syn.crypt and syn.crypt.base64 and syn.crypt.base64.decode then
		local ok, res = pcall(function() return syn.crypt.base64.decode(encryptedB64) end)
		if ok then encryptedBytes = res end
	end

	if not encryptedBytes and hasBase64 and base64.decode then
		local ok, res = pcall(function() return base64.decode(encryptedB64) end)
		if ok then encryptedBytes = res end
	end

	if not encryptedBytes then return false end

	-- XOR decrypt
	local key = CONFIG.ENCRYPT_KEY .. tostring(userId)
	local decrypted = ""
	for i = 1, #encryptedBytes do
		local byte = string.byte(encryptedBytes, i)
		local keyByte = string.byte(key, (i - 1) % #key + 1)
		decrypted = decrypted .. string.char(bit32.bxor(byte, keyByte))
	end

	-- Build keyData
	local saved = loadData()
	local keyData
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
		local now = os.time()
		keyData = {
			isValid = true,
			key = "Unknown",
			userId = userId,
			activationDate = now,
			expirationDate = now + 86400 * 7,
			session_token = currentSession
		}
	end

	-- Compile and run
	local func, err = loadstring(decrypted)
	if not func then return false end

	task.spawn(function()
		task.wait(1)
		local ok, execErr = pcall(func, keyData)
		if not ok then
			print("Script execution error: " .. tostring(execErr))
		end
	end)

	return true
end

-- 8.5. Launcher
local showGUI
local function showLauncher(session_token)
	print("🔵 [LAUNCHER] showLauncher called, token=" .. session_token:sub(1,8) .. "...")
	local saved = loadData()
	local userData = { key = saved and saved.key, userId = saved and saved.userId or player.UserId, userName = player.Name }
	print("🔵 [LAUNCHER] userData: userId=" .. tostring(userData.userId) .. ", name=" .. (userData.userName or "nil"))

	if userData.key then
		local checkPath = "/check?key=" .. userData.key .. "&userId=" .. tostring(userData.userId)
		local checkRaw = apiGet(checkPath)
		if checkRaw then
			local checkOk, checkData = pcall(function() return game:GetService("HttpService"):JSONDecode(checkRaw) end)
			if checkOk and checkData and checkData.status == "blocked" then
				showBlocked(checkData.reason or "Без указания причины")
				return
			end
			if checkOk and checkData and (checkData.status == "error" or checkData.status == "inactive" or checkData.status == "expired") then
				showGUI(checkData.message == "Key not found" and "Ключ не найден на сервере. Введите ключ снова." or (checkData.message or "Ключ недействителен."))
				return
			end
		end
	end

	_G.AuraLauncherConfig = {
		apiBaseUrls = CONFIG.API_URLS,
		userData = userData,
		-- Set to a Roblox asset id when the icon is uploaded, for example: rbxassetid://1234567890
		iconAssetId = "rbxassetid://105065225970263",
	}
	_G.AuraLauncherCallback = function(scriptId)
		print("🚀 Launcher: launching " .. scriptId)
		return loadScriptFromServer(session_token, scriptId)
	end

	local launcherPath = "/script?session=" .. session_token .. "&user_id=" .. userData.userId .. "&script_name=launcher"
	print("🔵 [LAUNCHER] fetching: " .. launcherPath)
	local raw = apiGet(launcherPath)
	print("🔵 [LAUNCHER] apiGet result: " .. (raw and ("got " .. #raw .. " bytes") or "nil"))
	print("🔵 [LAUNCHER] raw preview: " .. (raw and raw:sub(1,100) or "nil"))
	if not raw then
		print("⚠️ Launcher failed, trying main script directly")
		loadScriptFromServer(session_token, "main")
		return
	end

	local ok, data = pcall(function() return game:GetService("HttpService"):JSONDecode(raw) end)
	print("🔵 [LAUNCHER] JSON parse ok=" .. tostring(ok) .. ", status=" .. tostring(data and data.status or "nil"))
	
	-- Handle expired session
	if not (ok and data and data.status == "success" and data.script) then
		print("🔵 [LAUNCHER] Need new session, creating...")
		local newSessionPath = "/session?user_id=" .. userData.userId .. "&executor=" .. injectorName .. "&version=" .. CONFIG.VERSION
		local newSessionRaw = apiGet(newSessionPath)
		print("🔵 [LAUNCHER] /session result: " .. (newSessionRaw and ("got " .. #newSessionRaw .. " bytes") or "nil"))
		print("🔵 [LAUNCHER] /session preview: " .. (newSessionRaw and newSessionRaw:sub(1,200) or "nil"))
		if newSessionRaw then
			local ok2, sessData = pcall(function() return game:GetService("HttpService"):JSONDecode(newSessionRaw) end)
			if ok2 and sessData and sessData.status == "blocked" then
				showBlocked(sessData.reason or "Без указания причины")
				return
			end
			if ok2 and sessData and sessData.message == "Key blocked" then
				showBlocked(sessData.reason or "Без указания причины")
				return
			end
			if ok2 and sessData and sessData.status == "error" then
				local message = sessData.message or "Ошибка лицензии"
				print("🔵 [LAUNCHER] license error: " .. tostring(message))
				showGUI(message == "License not found" and "Ключ не найден на сервере. Введите ключ снова." or message)
				return
			end
			if ok2 and sessData and sessData.status == "success" and sessData.session then
				local newSession = sessData.session
				print("🔵 [LAUNCHER] New session: " .. newSession:sub(1,8) .. "...")
				local saved = loadData()
				if saved then saved.session_token = newSession; saveData(saved) end
				_G.AuraLauncherCallback = function(scriptId)
					loadScriptFromServer(newSession, scriptId)
				end
				local retryPath = "/script?session=" .. newSession .. "&user_id=" .. userData.userId .. "&script_name=launcher"
				local retryRaw = apiGet(retryPath)
				print("🔵 [LAUNCHER] Retry /script: " .. (retryRaw and ("got " .. #retryRaw .. " bytes") or "nil"))
				if retryRaw then
					local ok3, retryData = pcall(function() return game:GetService("HttpService"):JSONDecode(retryRaw) end)
					if ok3 and retryData and retryData.status == "success" and retryData.script then
						ok = true
						data = retryData
						print("🔵 [LAUNCHER] Retry data received, decrypting...")
					end
				end
			end
		end
	end
	
	if ok and data and data.status == "success" and data.script then
		print("🔵 [LAUNCHER] Decrypting script, " .. #data.script .. " chars")
		local encrypted_b64 = data.script
		local key = CONFIG.ENCRYPT_KEY .. tostring(userData.userId)
		local encrypted_bytes = nil
		if hasCrypto and crypt.base64decode then
			local s, r = pcall(function() return crypt.base64decode(encrypted_b64) end)
			if s then encrypted_bytes = r end
		end
		print("🔵 [LAUNCHER] base64: " .. tostring(encrypted_bytes and ("got " .. #encrypted_bytes .. " bytes") or "failed"))
		if encrypted_bytes then
			local decrypted = ""
			for i = 1, #encrypted_bytes do
				local byte = string.byte(encrypted_bytes, i)
				local keyByte = string.byte(key, (i - 1) % #key + 1)
				decrypted = decrypted .. string.char(bit32.bxor(byte, keyByte))
			end
			print("🔵 [LAUNCHER] Decrypted " .. #decrypted .. " chars")
			local func, err = loadstring(decrypted)
			print("🔵 [LAUNCHER] loadstring: " .. (func and "OK" or ("FAIL: " .. tostring(err))))
			if func then
				local execOk, execErr = pcall(func)
				print("🔵 [LAUNCHER] pcall: " .. (execOk and "OK" or ("ERR: " .. tostring(execErr))))
				return
			end
		end
		print("🔵 [LAUNCHER] Decryption failed")
	else
		print("🔵 [LAUNCHER] No valid script data")
	end
	showGUI()
end

-- 9. GUI
showGUI = function(errorMessage)
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
	title.Text = "AURA CHEATS"
	title.TextColor3 = Color3.fromRGB(255, 255, 255)
	title.TextSize = 24
	title.Font = Enum.Font.GothamBold
	title.Parent = frame

	local userLabel = Instance.new("TextLabel")
	userLabel.Size = UDim2.new(1, -40, 0, 25)
	userLabel.Position = UDim2.new(0, 20, 0, 65)
	userLabel.BackgroundTransparency = 1
	userLabel.Text = player.Name .. " (ID: " .. player.UserId .. ")"
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
	input.PlaceholderText = "Enter key..."
	input.Parent = frame

	local inputCorner = Instance.new("UICorner")
	inputCorner.CornerRadius = UDim.new(0, 8)
	inputCorner.Parent = input

	local status = Instance.new("TextLabel")
	status.Size = UDim2.new(1, -40, 0, 30)
	status.Position = UDim2.new(0, 20, 0, 155)
	status.BackgroundTransparency = 1
	status.Text = errorMessage or "Ready"
	status.TextColor3 = errorMessage and Color3.fromRGB(255, 80, 80) or Color3.fromRGB(180, 180, 200)
	status.TextSize = 12
	status.Font = Enum.Font.Gotham
	status.Parent = frame

	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0, 200, 0, 45)
	btn.Position = UDim2.new(0.5, -100, 0, 205)
	btn.BackgroundColor3 = Color3.fromRGB(50, 50, 200)
	btn.BorderSizePixel = 0
	btn.Text = "ACTIVATE"
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.TextSize = 16
	btn.Font = Enum.Font.GothamBold
	btn.Parent = frame

	local btnCorner = Instance.new("UICorner")
	btnCorner.CornerRadius = UDim.new(0, 8)
	btnCorner.Parent = btn

	local support = Instance.new("TextButton")
	support.Size = UDim2.new(1, -40, 0, 20)
	support.Position = UDim2.new(0, 20, 0, 270)
	support.BackgroundTransparency = 1
	support.Text = "Скопировать Discord поддержки"
	support.TextColor3 = Color3.fromRGB(150, 150, 180)
	support.TextSize = 11
	support.Font = Enum.Font.GothamMedium
	support.AutoButtonColor = false
	support.Parent = frame
	local supportCorner = Instance.new("UICorner")
	supportCorner.CornerRadius = UDim.new(0, 6)
	supportCorner.Parent = support
	support.MouseButton1Click:Connect(function()
		if setclipboard then setclipboard("https://discord.gg/XPwdHN4jHf") end
		support.Text = "Discord ссылка скопирована"
	end)

	local attempts = 0

	local function doActivate()
		local key = input.Text:gsub("%s+", "")
		if key == "" then
			status.Text = "Enter a key"
			status.TextColor3 = Color3.fromRGB(255, 80, 80)
			return
		end

		status.Text = "Checking..."
		status.TextColor3 = Color3.fromRGB(255, 255, 100)
		btn.Active = false
		btn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
		btn.Text = "CHECKING..."

		task.spawn(function()
			local ok, result = activateKey(key)

			if ok then
				status.Text = "Activated"
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
					showLauncher(result.session_token)
				else
					status.Text = "No session_token received"
					status.TextColor3 = Color3.fromRGB(255, 80, 80)
					btn.Active = true
					btn.BackgroundColor3 = Color3.fromRGB(50, 50, 200)
					btn.Text = "ACTIVATE"
				end
			else
				attempts = attempts + 1
				status.Text = tostring(result)
				status.TextColor3 = Color3.fromRGB(255, 80, 80)
				btn.Active = true
				btn.BackgroundColor3 = Color3.fromRGB(50, 50, 200)
				btn.Text = "ACTIVATE"

				if attempts >= 3 then
					status.Text = "Too many attempts"
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

-- 10. Startup
print("🔵 [STARTUP] Starting...")
player = game.Players.LocalPlayer
print("🔵 [STARTUP] player=" .. tostring(player and (player.Name or "noname") or "nil"))
if not player then return end

local saved = loadData()

if saved and saved.key and saved.userId == player.UserId then
	if saved.session_token then
		showLauncher(saved.session_token)
	else
		showGUI()
	end
else
	showGUI()
end
