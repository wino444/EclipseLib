# 🌒 EclipseLib

> **Roblox Exploit UI Library** — Dark but Radiant  
> Version: `5.4.0` • Mobile Friendly ✅ • Lua 5.1+

---

## ⚡ Quick Load

```lua
local EclipseLib = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/YOUR_USERNAME/EclipseLib/main/src/Loader.lua"
))()
```

> ⚠️ แก้ `YOUR_USERNAME` ให้ตรงกับ GitHub username ของแก

---

## 🔧 Features

| Feature | รายละเอียด |
|---|---|
| 🎬 Intro Animations | `fade` / `zoom` / `glitch` / `particle` |
| 🎨 Theme System | 6 Preset + Custom RGB |
| 💾 Config Save/Load | บันทึกค่าลงไฟล์ได้ |
| 🔑 Key System | ระบบ Key + จำ Key อัตโนมัติ |
| 🔔 Notification | Queue-based ไม่ stack ทับกัน |
| 📱 Mobile Friendly | รองรับ Touch เต็มรูปแบบ |
| 🧹 Clean Destroy | Disconnect connections ทั้งหมด |

---

## 📖 Basic Usage

```lua
local EclipseLib = loadstring(game:HttpGet("...URL..."))()

local Window = EclipseLib:CreateWindow({
    Name            = "My Script",
    LoadingTitle    = "🌒 My Script",
    LoadingSubtitle = "กำลังโหลด...",
    KeySystem       = false,
    ConfigurationSaving = { FolderName = "MyScript" },
})

local Tab = Window:CreateTab({ Name = "Main", Icon = "🏠" })

Tab:AddToggle({
    Name     = "Speed Hack",
    Default  = false,
    Callback = function(state)
        -- โค้ดของแกตรงนี้
    end,
})

Tab:AddSlider({
    Name     = "Speed",
    Min      = 16,
    Max      = 500,
    Default  = 50,
    Callback = function(val)
        -- โค้ดของแกตรงนี้
    end,
})
```

---

## 🧩 Components

| Component | วิธีใช้ |
|---|---|
| `AddButton` | `Tab:AddButton({Name, Description, Callback})` |
| `AddToggle` | `Tab:AddToggle({Name, Default, Callback, ConfigKey})` |
| `AddSlider` | `Tab:AddSlider({Name, Min, Max, Default, Callback, ConfigKey})` |
| `AddDropdown` | `Tab:AddDropdown({Name, Options, Default, Callback})` |
| `AddInput` | `Tab:AddInput({Name, Placeholder, Callback})` |
| `AddParagraph` | `Tab:AddParagraph({Title, Content})` |
| `AddSection` | `Tab:AddSection({Name})` |
| `AddLabel` | `Tab:AddLabel({Text})` |
| `AddProgressBar` | `Tab:AddProgressBar({Name, Max, Value})` |

---

## 🔑 Key System

```lua
local Window = EclipseLib:CreateWindow({
    KeySystem       = true,
    Key             = {"key123", "key456"},
    KeyTitle        = "🔑 ใส่ Key",
    KeyDescription  = "ติดต่อรับ Key ที่ Discord",
    KeyLink         = "https://discord.gg/xxxxxx",
})
```

---

## 🎨 Preset Themes

| Theme | สี |
|---|---|
| 🌒 Eclipse | Purple (Default) |
| 🌊 Ocean | Blue |
| 🌲 Forest | Green |
| 🔥 Inferno | Orange-Red |
| 🌸 Sakura | Pink |
| 🖤 Midnight | Gray-White |

---

## 🔔 Notification

```lua
Window:Notify({
    Title    = "✅ สำเร็จ",
    Content  = "ทำงานเรียบร้อย",
    Duration = 3,
    Type     = "success", -- "info" | "success" | "error" | "warn"
})
```

---

## 🗂️ Config Save/Load

```lua
-- ใส่ ConfigKey ใน component ที่ต้องการบันทึก
Tab:AddToggle({
    ConfigKey = "SpeedEnabled",
    ...
})

-- จากนั้นไปที่ Settings Tab → Save/Load Config ได้เลย
```

---

## 📁 โครงสร้างไฟล์

```
EclipseLib/
├── src/
│   ├── EclipseLib.lua        ← Core library
│   ├── Loader.lua            ← loadstring entry
│   └── modules/
│       ├── Utility.lua
│       ├── ThemeSystem.lua
│       ├── ConfigSystem.lua
│       ├── Notification.lua
│       ├── Intro.lua
│       └── KeySystem.lua
├── examples/
│   └── FullExample.lua
├── docs/
└── README.md
```

---

## 📜 Changelog

### v5.4.0 (Refactored)
- ✅ แยกโค้ดเป็น modules แต่ละไฟล์
- ✅ แก้ Heartbeat leak — ใช้ task loop แทน
- ✅ แก้ Config encode — รองรับ special characters
- ✅ แก้ Draggable connection stack
- ✅ Notification Queue — ไม่ stack ทับกัน
- ✅ AutomaticSize สำหรับ Paragraph
- ✅ Cache MarketplaceService call
- ✅ Destroy cleanup connections

### v5.3.0
- Initial release

---

> 🏷️ **สร้างโดย wino444**
