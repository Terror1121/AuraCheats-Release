local CONFIG = {
    LOADER_URL = "https://raw.githubusercontent.com/Terror1121/AuraCheats-Release/main/loader2.lua",
    VERSION = "2.2.7"
}
local function checkEnvironment()
    if not game or not game:GetService("RunService") then return false end
    if not game:GetService("Players").LocalPlayer then return false end
    return true
end
local function loadScript()
    local success, scriptContent = pcall(function()
        return game:HttpGet(CONFIG.LOADER_URL)
    end)
    if not success then print("❌ Ошибка загрузки") return end
    local func = loadstring(scriptContent)
    if func then pcall(func) end
end
if checkEnvironment() then
    print("🔧 Загрузка AuraCheats v" .. CONFIG.VERSION)
    loadScript()
end