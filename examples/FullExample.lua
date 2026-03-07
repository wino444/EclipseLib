-- 🌒 EclipseLib — ตัวอย่างการใช้งานเต็มรูปแบบ
-- โหลด EclipseLib ก่อน แล้วรันสคริปต์นี้

local EclipseLib = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/wino444/EclipseLib/main/src/Loader.lua"
))()

-- ═══════════════════════════
-- 🪟 สร้าง Window
-- ═══════════════════════════
local Window = EclipseLib:CreateWindow({
    Name             = "🌒 My Script",
    LoadingTitle     = "🌒 My Script",
    LoadingSubtitle  = "กำลังโหลด...",
    KeySystem        = false, -- เปลี่ยนเป็น true ถ้าต้องการ Key
    -- Key            = {"mykey123"},
    -- KeyTitle       = "🔑 ใส่ Key",
    -- KeyDescription = "ติดต่อรับ Key ได้ที่ Discord",
    -- KeyLink        = "https://discord.gg/example",
    ConfigurationSaving = {
        FolderName = "MyScript",
    },
})

-- ═══════════════════════════
-- 📑 Tab: Main
-- ═══════════════════════════
local MainTab = Window:CreateTab({Name = "Main", Icon = "🏠"})

MainTab:AddSection({Name = "⚡ Speed & Movement"})

local SpeedToggle = MainTab:AddToggle({
    Name        = "Speed Hack",
    Description = "เปิด/ปิด Speed Hack",
    Default     = false,
    ConfigKey   = "SpeedEnabled",
    Callback    = function(state)
        -- ใส่โค้ด speed hack ตรงนี้
        print("Speed:", state)
    end,
})

local SpeedSlider = MainTab:AddSlider({
    Name      = "Speed Value",
    Min       = 16,
    Max       = 500,
    Default   = 50,
    ConfigKey = "SpeedValue",
    Callback  = function(val)
        -- ใส่โค้ด set speed ตรงนี้
        print("Speed Value:", val)
    end,
})

MainTab:AddSection({Name = "🦘 Jump"})

MainTab:AddToggle({
    Name        = "Infinite Jump",
    Description = "กระโดดได้ไม่จำกัด",
    Default     = false,
    ConfigKey   = "InfJump",
    Callback    = function(state)
        print("InfJump:", state)
    end,
})

MainTab:AddButton({
    Name        = "Teleport to Spawn",
    Description = "เทเลพอร์ตไปจุดเริ่มต้น",
    Callback    = function()
        -- ใส่โค้ด teleport ตรงนี้
        print("Teleported!")
        Window:Notify({Title="✅ Teleport", Content="ไปจุด Spawn แล้ว!", Duration=2, Type="success"})
    end,
})

-- ═══════════════════════════
-- 📑 Tab: Visual
-- ═══════════════════════════
local VisualTab = Window:CreateTab({Name = "Visual", Icon = "👁️"})

VisualTab:AddSection({Name = "🎯 ESP"})

VisualTab:AddToggle({
    Name        = "Player ESP",
    Description = "แสดง ESP ผู้เล่นทุกคน",
    Default     = false,
    Callback    = function(state) print("ESP:", state) end,
})

VisualTab:AddDropdown({
    Name      = "ESP Color",
    Options   = {"สีแดง", "สีน้ำเงิน", "สีเขียว", "สีเหลือง"},
    Default   = "สีแดง",
    ConfigKey = "ESPColor",
    Callback  = function(val) print("ESP Color:", val) end,
})

VisualTab:AddParagraph({
    Title   = "ℹ️ หมายเหตุ",
    Content = "ESP อาจทำให้ FPS ลดลงถ้าผู้เล่นเยอะ แนะนำให้ปิดเมื่อไม่ใช้งาน",
})

-- ═══════════════════════════
-- 📑 Tab: Misc
-- ═══════════════════════════
local MiscTab = Window:CreateTab({Name = "Misc", Icon = "🔧"})

MiscTab:AddInput({
    Name        = "Custom Message",
    Placeholder = "พิมพ์ข้อความที่ต้องการ...",
    Callback    = function(text)
        print("Input:", text)
    end,
})

MiscTab:AddProgressBar({
    Name  = "โหลดข้อมูล",
    Max   = 100,
    Value = function()
        -- ใส่ logic คำนวณ progress ตรงนี้
        return math.floor(tick() % 100)
    end,
})

-- ═══════════════════════════
-- 🔔 Test Notification
-- ═══════════════════════════
Window:Notify({
    Title   = "✅ โหลดสำเร็จ!",
    Content = "My Script พร้อมใช้งานแล้ว 🌒",
    Duration = 4,
    Type    = "success",
})
