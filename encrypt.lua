-- ============================================
-- 🔥 ШИФРОВАНИЕ main.lua ДЛЯ AURACHEATS
-- Ключ: AuraCheats2024
-- Совместим с loader2.lua
-- ============================================

local ENCRYPT_KEY = "AuraCheats2024"

-- Функция шифрования (XOR)
local function encrypt(data, key)
    local encrypted = ""
    for i = 1, #data do
        local char = data:sub(i, i)
        local charCode = string.byte(char)
        local keyCode = string.byte(key:sub((i-1) % #key + 1, (i-1) % #key + 1))
        local code = (charCode + keyCode) % 256
        encrypted = encrypted .. string.char(code)
    end
    return encrypted
end

-- Читаем исходный main.lua
local file = io.open("main.lua", "r")
if not file then
    print("❌ Ошибка: файл main.lua не найден!")
    return
end

local content = file:read("*all")
file:close()

print("📥 Исходный main.lua загружен (" .. #content .. " байт)")

-- Шифруем
local encrypted = encrypt(content, ENCRYPT_KEY)

-- Сохраняем зашифрованный файл
local outFile = io.open("main.lua", "w")
if not outFile then
    print("❌ Ошибка: не могу создать файл!")
    return
end

outFile:write(encrypted)
outFile:close()

print("🔒 main.lua зашифрован! (" .. #encrypted .. " байт)")
print("🔑 Ключ: " .. ENCRYPT_KEY)
print("✅ Готово! Залей main.lua на GitHub.")