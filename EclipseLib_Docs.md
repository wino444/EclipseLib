# 🌒 EclipseLib v5.2.1 — คู่มือการใช้งาน

---

## 📦 วิธีโหลด Library

```lua
local EclipseLib = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/wino444/EclipseLib/main/UI%20Library.lua"
))()
```

---

## 🎬 IntroConfig — ตั้งค่า Intro Screen

อยู่ในไฟล์ Library โดยตรง (เปลี่ยนได้เฉพาะเจ้าของ)

| ค่า | ตัวเลือก | ความหมาย |
|---|---|---|
| `Mode` | `"particle"` / `"fade"` / `"zoom"` / `"glitch"` | รูปแบบ Intro |
| `Duration` | ตัวเลข (วินาที) | ความยาวของ Intro |
| `Icon` | emoji / string | ไอคอนที่แสดงตอน Intro |

---

## 🪟 CreateWindow — สร้างหน้าต่างหลัก

```lua
local Window = EclipseLib:CreateWindow({
    Name              = "ชื่อ UI",
    LoadingTitle      = "🌒 EclipseLib",
    LoadingSubtitle   = "กำลังโหลด...",

    -- 🔑 KeySystem (ถ้าไม่ใช้ ตั้งเป็น false)
    KeySystem         = true,
    Key               = {"KEY-ABC-123", "KEY-XYZ-456"},
    KeyTitle          = "🔑 ใส่ Key",
    KeyDescription    = "หา Key ได้จากลิงก์ด้านล่าง",
    KeyLink           = "https://linkvertise.com/xxxxx",

    -- 💾 Config Save
    ConfigurationSaving = {
        FolderName = "ชื่อโฟลเดอร์",
    },
})
```

### 📌 อธิบายแต่ละ Option

| Option | ชนิด | ความหมาย |
|---|---|---|
| `Name` | string | ชื่อที่แสดงบน TopBar |
| `LoadingTitle` | string | ชื่อที่แสดงตอน Intro |
| `LoadingSubtitle` | string | คำบรรยายตอน Intro |
| `KeySystem` | boolean | เปิด/ปิดระบบ Key |
| `Key` | table | รายการ Key ที่ถูกต้อง |
| `KeyTitle` | string | ชื่อหน้าต่าง Key |
| `KeyDescription` | string | คำอธิบายในหน้า Key |
| `KeyLink` | string | ลิงก์ที่จะ copy ให้ผู้ใช้ไปหา Key |
| `ConfigurationSaving.FolderName` | string | ชื่อโฟลเดอร์ที่ใช้ save config |

---

## ➕ CreateTab — สร้างแท็บ

```lua
-- แบบที่ 1: ใส่ชื่อ + ไอคอนแยก
local Tab = Window:CreateTab("ชื่อแท็บ", "⚡")

-- แบบที่ 2: ใส่เป็น table
local Tab = Window:CreateTab({
    Name = "ชื่อแท็บ",
    Icon = "⚡",
})
```

---

## 📂 AddSection — เส้นแบ่งหัวข้อ

```lua
Tab:AddSection({
    Name = "หัวข้อ",
})
```

ใช้แบ่งกลุ่มของ Element ในแท็บให้ดูเป็นระเบียบ 🗂️

---

## 🏷️ AddLabel — ข้อความธรรมดา

```lua
local Label = Tab:AddLabel({
    Text = "ข้อความที่ต้องการแสดง",
})

-- เปลี่ยนข้อความทีหลัง
Label:SetText("ข้อความใหม่")
```

---

## 🔘 AddButton — ปุ่มกด

```lua
Tab:AddButton({
    Name          = "ชื่อปุ่ม",
    Description   = "คำอธิบาย (ไม่บังคับ)",
    
    -- แสดงค่า Realtime ข้างปุ่ม (ไม่บังคับ)
    RealtimeValue = function()
        return tostring(game.Players.LocalPlayer.Character.Humanoid.WalkSpeed)
    end,
    
    Callback = function()
        -- โค้ดที่รันเมื่อกดปุ่ม
        print("กดแล้ว!")
    end,
})
```

### 📌 อธิบาย Option

| Option | ชนิด | ความหมาย |
|---|---|---|
| `Name` | string | ชื่อปุ่ม |
| `Description` | string | คำอธิบายเล็กๆ ใต้ชื่อ |
| `RealtimeValue` | function | ฟังก์ชันที่คืนค่าแบบ realtime แสดงข้างปุ่ม |
| `Callback` | function | โค้ดที่รันเมื่อกด |

---

## 🔄 AddToggle — สวิตช์เปิด/ปิด

```lua
local Toggle = Tab:AddToggle({
    Name        = "ชื่อ Toggle",
    Description = "คำอธิบาย",
    Default     = false,       -- ค่าเริ่มต้น (true = เปิด)
    ConfigKey   = "MyToggle",  -- ใช้กับ Config Save/Load

    Callback = function(state)
        -- state = true (เปิด) หรือ false (ปิด)
        if state then
            print("เปิดแล้ว!")
        else
            print("ปิดแล้ว!")
        end
    end,
})

-- เปลี่ยน State จากภายนอก
Toggle:SetState(true)   -- บังคับเปิด
Toggle:SetState(false)  -- บังคับปิด

-- ดูค่าปัจจุบัน
local currentState = Toggle:GetState()
```

### 📌 อธิบาย Option

| Option | ชนิด | ความหมาย |
|---|---|---|
| `Name` | string | ชื่อ Toggle |
| `Description` | string | คำอธิบาย |
| `Default` | boolean | ค่าเริ่มต้น |
| `ConfigKey` | string | key สำหรับ save/load config |
| `Callback` | function(bool) | รับค่า true/false |

---

## 🎚️ AddSlider — แถบเลื่อนค่า

```lua
local Slider = Tab:AddSlider({
    Name      = "ชื่อ Slider",
    Min       = 0,      -- ค่าต่ำสุด
    Max       = 100,    -- ค่าสูงสุด
    Default   = 16,     -- ค่าเริ่มต้น
    ConfigKey = "MySlider",

    Callback = function(value)
        -- value = ตัวเลขที่ผู้ใช้เลื่อน
        print("ค่าปัจจุบัน:", value)
    end,
})

-- ดูค่าปัจจุบัน
local val = Slider:GetValue()

-- ตั้งค่าจากภายนอก
Slider:SetValue(50)
```

### 📌 อธิบาย Option

| Option | ชนิด | ความหมาย |
|---|---|---|
| `Name` | string | ชื่อ Slider |
| `Min` | number | ค่าต่ำสุด |
| `Max` | number | ค่าสูงสุด |
| `Default` | number | ค่าเริ่มต้น |
| `ConfigKey` | string | key สำหรับ save/load config |
| `Callback` | function(number) | รับค่าเมื่อเลื่อน |

---

## 🔽 AddDropdown — เมนูเลือกตัวเลือก

```lua
local Dropdown = Tab:AddDropdown({
    Name    = "ชื่อ Dropdown",
    Options = {"ตัวเลือก1", "ตัวเลือก2", "ตัวเลือก3"},
    Default = "ตัวเลือก1",

    -- แสดงค่า Realtime ข้างๆ (ไม่บังคับ)
    RealtimeValue = function()
        return "ค่าที่อยากแสดง"
    end,

    Callback = function(selected)
        print("เลือก:", selected)
    end,
})

-- ดูค่าที่เลือกอยู่
local val = Dropdown:GetValue()

-- เปลี่ยน Options ใหม่
Dropdown:SetOptions({"A", "B", "C"})
```

### 📌 อธิบาย Option

| Option | ชนิด | ความหมาย |
|---|---|---|
| `Name` | string | ชื่อ Dropdown |
| `Options` | table | รายการตัวเลือก |
| `Default` | string | ตัวเลือกเริ่มต้น |
| `RealtimeValue` | function | แสดงค่า realtime ข้างๆ |
| `Callback` | function(string) | รับค่าที่เลือก |

---

## 📝 AddInput — ช่องพิมพ์ข้อความ

```lua
local Input = Tab:AddInput({
    Name        = "ชื่อ Input",
    Placeholder = "พิมพ์ที่นี่...",

    Callback = function(text)
        -- รับค่าเมื่อกด Enter
        print("พิมพ์ว่า:", text)
    end,
})

-- ดูค่าปัจจุบัน
local val = Input:GetValue()

-- ตั้งค่าจากภายนอก
Input:SetValue("ข้อความ")
```

---

## 📊 AddProgressBar — แถบแสดงความคืบหน้า

```lua
Tab:AddProgressBar({
    Name  = "ชื่อ Progress Bar",
    Max   = 100,

    Value = function()
        -- ฟังก์ชันที่คืนค่าปัจจุบัน (realtime)
        return game.Players.LocalPlayer.Character.Humanoid.Health
    end,
})
```

> 🎨 สีแถบเปลี่ยนอัตโนมัติ:
> - 🔴 แดง = 0–30%
> - 🟡 เหลือง = 30–60%
> - 🟢 เขียว = 60–100%

---

## 🔔 Notify — แจ้งเตือน

```lua
-- เรียกผ่าน EclipseLib โดยตรง
EclipseLib:Notify({
    Title    = "ชื่อการแจ้งเตือน",
    Content  = "ข้อความ",
    Duration = 4,       -- กี่วินาที
    Type     = "info",  -- info / success / error / warn
})

-- หรือเรียกผ่าน Window ก็ได้
Window:Notify({
    Title    = "✅ สำเร็จ!",
    Content  = "โหลดเสร็จแล้ว",
    Duration = 3,
    Type     = "success",
})
```

### 📌 ประเภทการแจ้งเตือน

| Type | สี | ใช้เมื่อ |
|---|---|---|
| `"info"` | 🟣 ม่วง | แจ้งทั่วไป |
| `"success"` | 🟢 เขียว | สำเร็จ |
| `"error"` | 🔴 แดง | ผิดพลาด |
| `"warn"` | 🟡 เหลือง | เตือน |

---

## 💾 ConfigSystem — บันทึกและโหลดค่า

### วิธีผูก Toggle / Slider กับ Config

```lua
-- ใส่ ConfigKey ใน Toggle หรือ Slider
local Toggle = Tab:AddToggle({
    Name      = "Speed Hack",
    ConfigKey = "SpeedHack",   -- ← ชื่อ key ที่ใช้ save
    Callback  = function(v) end,
})

local Slider = Tab:AddSlider({
    Name      = "Speed Value",
    Min       = 16,
    Max       = 300,
    ConfigKey = "SpeedValue",  -- ← ชื่อ key ที่ใช้ save
    Callback  = function(v) end,
})
```

### วิธี Save / Load Config ใน UI

ไปที่แท็บ **⚙️ ตั้งค่า UI** → หัวข้อ **💾 บันทึก / โหลด Config**

```
📝 พิมพ์ชื่อไฟล์ใหม่ → กด "💾 Save ใหม่"
📂 เลือกไฟล์จาก Dropdown → กด "📂 Load"
✏️ เลือกไฟล์จาก Dropdown → กด "✏️ ทับ"
```

> 📁 ไฟล์จะถูก save ที่:
> `workspace/../[FolderName]/[ชื่อไฟล์].eclipse`

---

## ⚙️ Tab ตั้งค่า UI (Built-in)

มีอยู่แล้วโดยอัตโนมัติ ไม่ต้องสร้างเอง

| ฟีเจอร์ | รายละเอียด |
|---|---|
| 🎨 Preset Themes | Eclipse / Ocean / Forest / Inferno / Sakura / Midnight |
| 🖌️ Custom Accent Color | ปรับ RGB ได้เอง |
| 📏 ขนาด UI | เล็ก / กลาง / ใหญ่ |
| 🔔 ตำแหน่ง Notification | มุมขวาบน / มุมซ้ายบน |
| 🌗 ความโปร่งใส UI | ปรับ slider ได้ |
| 🔄 Reset การตั้งค่า | Reset แยกทีละอย่าง |
| 💾 Save / Load Config | บันทึกและโหลดค่าได้ |

---

## 🏠 Tab ยินดีต้อนรับ (Built-in)

แสดงข้อมูลอัตโนมัติ ไม่ต้องเขียนเพิ่ม

| ข้อมูล | รายละเอียด |
|---|---|
| 🖼️ Avatar | รูปโปรไฟล์ + ชื่อ + UserID |
| 🗺️ ชื่อแมพ | ดึงจาก MarketplaceService |
| 📍 Place ID | ID ของเกม |
| ⏳ อายุบัญชี | แปลงเป็น ปี / เดือน / วัน |
| 🖥️ Server ID | JobId ของเซิร์ฟเวอร์ |
| ⏱️ เวลาที่เล่น | นับแบบ realtime |

---

## 📱 Floating Button

เมื่อกดปุ่ม **✕ Close** บน TopBar:
- UI จะซ่อน
- จะมีปุ่มลอย **🌒** ขึ้นมา
- กดปุ่มลอยเพื่อเปิด UI กลับมา
- ปุ่มลอยนี้ **ลากได้อิสระ** บนหน้าจอ

---

## 🔑 KeySystem

เมื่อตั้ง `KeySystem = true` จะมีหน้าต่างให้กรอก Key ก่อน

```lua
local Window = EclipseLib:CreateWindow({
    KeySystem       = true,
    Key             = {"ECLIPSE-2025", "FREE-KEY-001"},
    KeyTitle        = "🔑 ใส่ Key ก่อนนะ",
    KeyDescription  = "หา Key ได้จากลิงก์ด้านล่าง",
    KeyLink         = "https://linkvertise.com/xxxxx",
})
```

> ⚠️ Key เก็บอยู่ฝั่ง client ทุกคนที่มีสคริปต์จะเห็น Key ได้
> ถ้าอยากปลอดภัยกว่านี้ ต้องใช้ระบบ Key Server แยก

---

## 📋 ตัวอย่างการใช้งานแบบสมบูรณ์

```lua
local EclipseLib = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/wino444/EclipseLib/45ca6e8001608487b618ee2c9cdac7867b562dd8/Library%20EclipseLib.lua"
))()

local Window = EclipseLib:CreateWindow({
    Name                = "🌒 My Script",
    LoadingTitle        = "🌒 My Script",
    LoadingSubtitle     = "v1.0.0",
    KeySystem           = false,
    ConfigurationSaving = { FolderName = "MyScript" },
})

local Tab = Window:CreateTab("⚡ Main", "⚡")

Tab:AddSection({ Name = "🏃 Movement" })

local SpeedToggle = Tab:AddToggle({
    Name      = "Speed Hack",
    Default   = false,
    ConfigKey = "Speed",
    Callback  = function(v)
        local hum = game.Players.LocalPlayer.Character.Humanoid
        hum.WalkSpeed = v and 100 or 16
    end,
})

local SpeedSlider = Tab:AddSlider({
    Name      = "Speed Value",
    Min       = 16,
    Max       = 300,
    Default   = 100,
    ConfigKey = "SpeedVal",
    Callback  = function(v)
        if SpeedToggle:GetState() then
            game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = v
        end
    end,
})

Tab:AddButton({
    Name     = "Notify Test",
    Callback = function()
        Window:Notify({
            Title   = "✅ Test",
            Content = "กดแล้ว!",
            Duration = 2,
            Type    = "success",
        })
    end,
})

Window:Notify({
    Title   = "🌒 โหลดสำเร็จ!",
    Content = "My Script พร้อมใช้งาน",
    Duration = 3,
    Type    = "success",
})
```

---

*🌒 EclipseLib v5.2.1 — สร้างโดย wino444*
