-- 🌒 EclipseLib — Loader
-- โหลดผ่าน: loadstring(game:HttpGet("https://raw.githubusercontent.com/YOUR_USERNAME/EclipseLib/main/src/Loader.lua"))()
--
-- ⚠️ แก้ไข BASE_URL ให้ตรงกับ GitHub ของแก ก่อนใช้งาน

local BASE_URL = "https://raw.githubusercontent.com/YOUR_USERNAME/EclipseLib/main/src/"

-- ═══════════════════════════════════════════
-- 🔧 Module Loader (โหลดแต่ละ module แยก)
-- ═══════════════════════════════════════════
local function LoadModule(path)
    local ok, result = pcall(function()
        return loadstring(game:HttpGet(BASE_URL .. path))()
    end)
    if not ok then
        warn("[EclipseLib Loader] ❌ โหลด module ล้มเหลว: " .. path .. "\n" .. tostring(result))
        return nil
    end
    return result
end

-- ═══════════════════════════════════════════
-- 📦 โหลด EclipseLib หลักพร้อม modules
-- ═══════════════════════════════════════════
local EclipseLib = LoadModule("EclipseLib.lua")

if not EclipseLib then
    error("[EclipseLib] ❌ โหลด EclipseLib.lua ล้มเหลว — ตรวจสอบ BASE_URL และ internet connection")
end

return EclipseLib
