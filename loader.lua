-- ============================================
-- 🔒 AURA CHEATS - ТОЧКА ВХОДА v2.2.25
-- FIX: Множественные зеркала + отладка
-- ============================================

local CONFIG = {
    -- ✅ МНОЖЕСТВЕННЫЕ ЗЕРКАЛА (если одно не работает - пробует другое)
    LOADER_URLS = {
        "https://raw.githack.com/Terror1121/AuraCheats-Release/main/loader2.lua",
        "https://cdn.jsdelivr.net/gh/Terror1121/AuraCheats-Release@main/loader2.lua",
        "https://raw.githubusercontent.com/Terror1121/AuraCheats-Release/main/loader2.lua",
    },
    VERSION = "2.2.25"
}

local function checkEnvironment()
    if not game or not game:GetService("RunService") then return false end
    if not game:GetService("Players").LocalPlayer then return false end
    return true
end

local function loadScriptFromUrl(url)
    print("🔧 Попытка загрузки: " .. url)
    
    local success, scriptContent = pcall(function()
        return game:HttpGet(url)
    end)
    
    if not success or not scriptContent then
        print("❌ Ошибка загрузки с: " .. url)
        return false
    end
    
    print("✅ Загружено " .. #scriptContent .. " байт с: " .. url)
    
    local func, err = loadstring(scriptContent)
    if not func then
        print("❌ Ошибка компиляции: " .. tostring(err))
        return false
    end
    
    print("✅ Скрипт скомпилирован, запуск...")
    pcall(func)
    return true
end

local function loadScript()
    print("🔧 Загрузка AuraCheats v" .. CONFIG.VERSION)
    
    -- Пробуем все зеркала по очереди
    for _, url in ipairs(CONFIG.LOADER_URLS) do
        if loadScriptFromUrl(url) then
            print("✅ Успешно загружено с: " .. url)
            return true
        end
        print("⚠️ Следующее зеркало...")
    end
    
    -- Если все зеркала не сработали
    print("❌ НЕ УДАЛОСЬ ЗАГРУЗИТЬ СКРИПТ НИ С ОДНОГО ЗЕРКАЛА!")
    print("❌ Проверьте подключение к интернету или VPN.")
    return false
end

-- ============================================
-- ЗАПУСК
-- ============================================
if checkEnvironment() then
    -- Даем время на загрузку
    task.wait(0.5)
    loadScript()
else
    print("❌ Неподходящее окружение для загрузки")
end