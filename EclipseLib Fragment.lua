-- 🧩 EclipseLib Fragment
-- Version: 1.0.0
-- ส่วนเสริมของ EclipseLib สำหรับดึงข้อมูลจากเกม

local Fragment = {}
Fragment.__index = Fragment

local BaseURL = "https://raw.githubusercontent.com/wino444/EclipseLib/main/Modules/"

local ModuleList = {
    "Players",
    "Teams",
    "Combat",
    "World",
}

-- โหลดทีละ Module
function Fragment:Load(name)
    if self[name] then
        warn("🧩 Fragment: '"..name.."' โหลดแล้ว ข้ามไป")
        return self[name]
    end
    local ok, result = pcall(function()
        return loadstring(game:HttpGet(BaseURL..name..".lua"))()
    end)
    if ok and result then
        self[name] = result
        print("✅ Fragment: โหลด '"..name.."' สำเร็จ!")
        return result
    else
        warn("❌ Fragment: โหลด '"..name.."' ไม่สำเร็จ!")
        return nil
    end
end

-- โหลดทุก Module พร้อมกัน
function Fragment:LoadAll()
    print("🧩 Fragment: กำลังโหลดทุก Module...")
    for _, name in ipairs(ModuleList) do
        self:Load(name)
    end
    print("✅ Fragment: โหลดทุก Module เสร็จแล้ว!")
end

-- เช็คว่า Module โหลดแล้วไหม
function Fragment:IsLoaded(name)
    return self[name] ~= nil
end

-- ดู Module ที่โหลดแล้วทั้งหมด
function Fragment:GetLoaded()
    local loaded = {}
    for _, name in ipairs(ModuleList) do
        if self[name] then
            table.insert(loaded, name)
        end
    end
    return loaded
end

return Fragment
