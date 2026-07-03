<<<<<<< HEAD
-- ============================================
-- AURACHEATS ЗАГРУЗЧИК v2.2
-- ============================================

local CONFIG = {
    LOADER_URL = "https://raw.githubusercontent.com/Terror1121/AuraCheats-Release/main/loader2.lua",
    VERSION = "2.2.0"
}

local function checkEnvironment()
    if not game or not game:GetService("RunService") then
        return false, "❌ Этот скрипт работает только в Roblox"
    end
    if not game:GetService("Players").LocalPlayer then
        return false, "❌ Не удалось найти игрока"
    end
    return true, "OK"
end

=======
local CONFIG = {
    LOADER_URL = "https://raw.githubusercontent.com/Terror1121/AuraCheats-Release/main/loader2.lua",
    VERSION = "2.2.3"
}
local function checkEnvironment()
    if not game or not game:GetService("RunService") then return false end
    if not game:GetService("Players").LocalPlayer then return false end
    return true
end
>>>>>>> 223ae047f3e6692c3e9e2d708f357065e1bb980d
local function loadScript()
    local success, scriptContent = pcall(function()
        return game:HttpGet(CONFIG.LOADER_URL)
    end)
<<<<<<< HEAD
    
    if not success then
        print("❌ Ошибка загрузки скрипта")
        return
    end
    
    local func = loadstring(scriptContent)
    if func then
        pcall(func)
    else
        print("❌ Ошибка компиляции скрипта")
    end
end

local envOk, envMsg = checkEnvironment()
if not envOk then
    print(envMsg)
    return
end

print("🔧 Загрузка AuraCheats v" .. CONFIG.VERSION)
loadScript()
=======
    if not success then print("❌ Ошибка загрузки") return end
    local func = loadstring(scriptContent)
    if func then pcall(func) end
end
if checkEnvironment() then
    print("🔧 Загрузка AuraCheats v" .. CONFIG.VERSION)
    loadScript()
end
>>>>>>> 223ae047f3e6692c3e9e2d708f357065e1bb980d
