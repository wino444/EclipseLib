# 🌒 EclipseLib v5.3.1
> UI Library สำหรับ Roblox Exploiting | by wino444

---

## 📦 โหลด Library

```lua
local EclipseLib = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/wino444/EclipseLib/main/Library%20ui.lua"
))()
```

---

## 🪟 CreateWindow

```lua
local Win = EclipseLib:CreateWindow({
    Name             = "ชื่อ UI",
    LoadingTitle     = "🌒 Loading",
    LoadingSubtitle  = "กำลังโหลด...",

    -- Key System (ถ้าไม่ใช้ ลบออกได้)
    KeySystem        = true,
    Key              = {"YOUR-KEY-HERE"},
    KeyTitle         = "🔑 ใส่ Key",
    KeyDescription   = "ติดต่อเพื่อขอ Key",
    KeyLink          = "https://discord.gg/xxx",

    -- Config
    ConfigurationSaving = {
        FolderName = "MyScript"
    },
})
```

---

## 📁 CreateTab

```lua
local Tab = Win:CreateTab({
    Name = "Main",
    Icon = "⚔️"
})
```

---

## 🧩 Components

### 🔘 Button
```lua
Tab:AddButton({
    Name        = "ชื่อปุ่ม",
    Description = "คำอธิบาย",
    Callback    = function()
        -- โค้ดที่รันตอนกด
    end
})
```

---

### 🔄 Toggle
```lua
local T = Tab:AddToggle({
    Name        = "ชื่อ Toggle",
    Description = "คำอธิบาย",
    Default     = false,
    ConfigKey   = "MyToggle",
    Callback    = function(state)
        print(state) -- true / false
    end
})

T:SetState(true)
T:GetState() -- return bool
```

---

### 🎚️ Slider
```lua
local S = Tab:AddSlider({
    Name      = "ชื่อ Slider",
    Min       = 0,
    Max       = 100,
    Default   = 50,
    ConfigKey = "MySlider",
    Callback  = function(value)
        print(value)
    end
})

S:GetValue()
S:SetValue(75)
```

---

### 🔽 Dropdown
```lua
local D = Tab:AddDropdown({
    Name      = "ชื่อ Dropdown",
    Options   = {"Option1", "Option2", "Option3"},
    Default   = "Option1",
    ConfigKey = "MyDropdown",
    Callback  = function(selected)
        print(selected)
    end
})

D:GetValue()
D:SetOptions({"A", "B", "C"})
```

---

### ⌨️ Input
```lua
local I = Tab:AddInput({
    Name        = "ชื่อ Input",
    Placeholder = "พิมพ์ที่นี่...",
    Callback    = function(text)
        print(text) -- fires ตอนกด Enter
    end
})

I:GetValue()
I:SetValue("hello")
```

---

### 🎨 ColorPicker
```lua
local C = Tab:AddColorPicker({
    Name     = "ชื่อ ColorPicker",
    Default  = Color3.fromRGB(100, 60, 200),
    Callback = function(color)
        print(color)
    end
})

C:GetColor() -- return Color3
```

---

### 📊 ProgressBar
```lua
Tab:AddProgressBar({
    Name  = "HP",
    Max   = 100,
    Value = function()
        return 80 -- ส่ง function realtime
    end
})
```

---

### 🏷️ Label
```lua
local L = Tab:AddLabel({ Text = "ข้อความ" })
L:SetText("ข้อความใหม่")
```

---

### 📂 Section
```lua
Tab:AddSection({ Name = "หัวข้อ" })
```

---

### 📄 Paragraph
```lua
local P = Tab:AddParagraph({
    Title   = "หัวข้อ",
    Content = "เนื้อหา..."
})

P:SetTitle("หัวข้อใหม่")
P:SetContent("เนื้อหาใหม่")
```

---

### 🔑 Keybind
```lua
Tab:AddKeybind({
    Name        = "Toggle UI",
    Default     = Enum.KeyCode.RightShift,
    Description = "กดเพื่อเปิด/ปิด",
    Callback    = function()
        Win:Toggle()
    end
})
```
> 📱 มือถือ — แสดงเป็นปุ่มกดแทน Keybind อัตโนมัติ

---

## 🔔 Notification

```lua
EclipseLib:Notify({
    Title    = "✅ สำเร็จ",
    Content  = "ข้อความ",
    Duration = 4,
    Type     = "success" -- success | error | warn | info
})
```

---

## 🪟 Window Methods

```lua
Win:Show()     -- เปิด UI
Win:Hide()     -- ซ่อน UI
Win:Toggle()   -- สลับเปิด/ปิด
Win:Destroy()  -- ลบ UI ทั้งหมด
Win:Notify({}) -- ส่ง Notification
```

---

## 🎨 Intro Modes

> แก้ได้ที่ `IntroConfig.Mode` ในไฟล์ Library

| Mode | ลักษณะ |
|---|---|
| `fade` | จางเข้า-ออก |
| `zoom` | ซูมเข้า |
| `glitch` | สไตล์ glitch |
| `particle` | อนุภาคบินเข้า (default) |

---

## 🎨 Preset Themes

| Theme | สี |
|---|---|
| 🌒 Eclipse | ม่วงเข้ม (default) |
| 🌊 Ocean | ฟ้าเข้ม |
| 🌲 Forest | เขียว |
| 🔥 Inferno | ส้ม-แดง |
| 🌸 Sakura | ชมพู |
| 🖤 Midnight | เทาเข้ม |

---

## 💾 Config System

- ใส่ `ConfigKey` ใน Toggle / Slider / Dropdown
- ไปที่ Tab **⚙️ ตั้งค่า UI** → **💾 บันทึก / โหลด Config**
- ระบบ Save/Load ค่าทั้งหมดให้อัตโนมัติ
- ไฟล์เก็บใน `workspace/../{FolderName}/*.eclipse`

---

## 📝 ตัวอย่างโค้ดเต็ม

```lua
local EclipseLib = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/wino444/EclipseLib/main/Library%20ui.lua"
))()

local Win = EclipseLib:CreateWindow({
    Name            = "My Script",
    LoadingTitle    = "🌒 My Script",
    LoadingSubtitle = "กำลังโหลด...",
    ConfigurationSaving = { FolderName = "MyScript" },
})

local Tab = Win:CreateTab({ Name = "Main", Icon = "⚔️" })

Tab:AddSection({ Name = "Player" })

Tab:AddToggle({
    Name     = "Speed Hack",
    Default  = false,
    ConfigKey = "Speed",
    Callback = function(state)
        local hum = game.Players.LocalPlayer.Character
                    and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid")
        if hum then hum.WalkSpeed = state and 100 or 16 end
    end
})

Tab:AddSlider({
    Name     = "Jump Power",
    Min      = 50, Max = 500, Default = 50,
    ConfigKey = "Jump",
    Callback = function(val)
        local hum = game.Players.LocalPlayer.Character
                    and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid")
        if hum then hum.JumpPower = val end
    end
})

EclipseLib:Notify({
    Title = "🌒 My Script", Content = "โหลดสำเร็จ!", Duration = 3, Type = "success"
})
```

---

> 🏷️ UI สร้างโดย **wino444** | EclipseLib v5.3.1
