📘 EclipseLib v6.5.2 — เอกสารประกอบ

UI Library สำหรับ Roblox | สร้างโดย wino444
👤 Profile | 🔍 Search | ⚙️ Settings | 🌈 Rainbow

---

📑 สารบัญ

1  📦 การติดตั้ง
2  🚀 Quick Start
3  🌐 Global API
4  🪟 Window System
5  📑 Tab System
6  👤 Built-in Pages
7  🧩 Components ทั้งหมด
8  🎁 Accordion
9  🎨 Themes
10 🌈 Rainbow Mode
11 🔔 Notification
12 💬 Dialog System
13 🖱️ Context Menu
14 🔊 Sound System
15 💾 Config System
16 🔑 Key System
17 ⌨️ Hotkeys
18 🧹 Unload
19 🔧 Best Practices
20 🩺 Troubleshooting

---

1. การติดตั้ง

🔹 โหลดจาก GitHub

```lua
local EclipseLib = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/wino444/EclipseLib/main/Library%20ui.lua"
), true)()
```

---

2. Quick Start

```lua
-- 1. โหลด Library
local EclipseLib = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/wino444/EclipseLib/main/Library%20ui.lua"
), true)()

-- 2. สร้าง Window
local Win = EclipseLib:CreateWindow({
    Name = "My Script",
    LoadingTitle = "🚀 My Script",
    LoadingSubtitle = "กำลังโหลด...",
    ConfigurationSaving = { FolderName = "MyScript" },
    KeySystem = false,
})

-- 3. สร้าง Tab
local Tab = Win:CreateTab({ Name = "Main", Icon = "⚔️" })

-- 4. เพิ่ม Component
Tab:AddButton({
    Name = "กดฉัน",
    Description = "ปุ่มทดสอบ",
    Callback = function()
        EclipseLib:Notify({
            Title = "✅ สำเร็จ",
            Content = "คุณกดปุ่ม!",
            Duration = 3,
        })
    end,
})

-- 5. Hotkey
Win:AddGlobalHotkey({
    Name = "ToggleUI",
    Default = Enum.KeyCode.RightControl,
    Callback = function() Win:Toggle() end,
})

-- 6. Autosave
Win:SetAutosave(true, "my_session", 30)
```

---

3. Global API

🔧 EclipseLib Methods

Method                        Args            คำอธิบาย
EclipseLib:CreateWindow(opts) table           สร้างหน้าต่าง
EclipseLib:Notify(opts)       table           Notify
EclipseLib:Alert(opts)        table           Alert Dialog
EclipseLib:Prompt(opts)       table           Prompt Dialog
EclipseLib:Toast(opts)        table           Toast
EclipseLib:Confirm(msg)       string          Confirm Dialog
EclipseLib:Log(msg, level)    string, string  Log
EclipseLib:ShowContextMenu    table, Vector2  คลิกขวา
EclipseLib:PlaySound(name)    string          เล่นเสียง
EclipseLib:SetSounds(tbl)     table           ตั้งค่าเสียง
EclipseLib:SetSoundEnabled(b) boolean         เปิด/ปิดเสียง
EclipseLib:Unload()           —               ลบทุกอย่าง

---

4. Window System

EclipseLib:CreateWindow(opts)

Parameter                       Type    Default
Name                            string  "EclipseLib"
LoadingTitle                    string  "🌒 EclipseLib"
LoadingSubtitle                 string  "กำลังโหลด..."
ConfigurationSaving.FolderName  string  "EclipseLib"
KeySystem                       boolean false
Key                             table   {}
KeyTitle                        string  "🔑 ใส่ Key"
KeyDescription                  string  "กรอก Key..."
KeyLink                         string  ""

🎯 TopBar — 5 ปุ่ม

```
┌──────────────────────────────────────────────┐
│ 🌒 My Script         👤  ⚙️  ☰  —  ✕        │
└──────────────────────────────────────────────┘
                       ①   ②   ③   ④   ⑤
```

ปุ่ม    ชื่อ           หน้าที่

①  👤     Profile       เปิดหน้า Profile (toggle)
②  ⚙️     Settings      เปิดหน้า Settings (toggle)
③  ☰     Toggle TabBar ซ่อน/แสดง TabBar
④  —     Minimize      ย่อ UI
⑤  ✕     Close         ซ่อน UI

Window Methods

Method                              คำอธิบาย
Win:CreateTab(nameOrOpts, icon)     สร้าง Tab
Win:Show()                          เปิด UI
Win:Hide()                          ซ่อน UI
Win:Toggle()                        สลับเปิด/ปิด
Win:Destroy()                       ลบ UI
Win:Notify(opts)                    Shortcut
Win:Alert(opts)                     Shortcut
Win:Prompt(opts)                    Shortcut
Win:Toast(opts)                     Shortcut
Win:Confirm(msg)                    Shortcut
Win:Log(msg, level)                 Shortcut
Win:ShowContextMenu(items, pos)     Shortcut
Win:PlaySound(name)                 Shortcut
Win:SetNotifPosition(side)          "left" / "right"
Win:ToggleTabBar()                  ซ่อน/แสดง TabBar
Win:AddGlobalHotkey(opts)           เพิ่ม Hotkey
Win:SetAutosave(enabled, n, int)    Autosave
Win:SetResizable(bool)              resize handle

---

5. Tab System

🏗️ โครงสร้าง

```
Body
├── TabBarContainer
│   └── TabBar
│       ├── 🔍 Search Box
│       ├── ──────── (Divider)
│       ├── ⚔️ Main
│       ├── 🎨 Visual
│       └── 🎮 Player
└── ContentArea
```

🔍 Search Box

· พิมพ์ในกล่อง → filter tabs แบบ realtime
· ลบข้อความ → tabs กลับมา

Win:CreateTab(nameOrOpts, icon)

```lua
-- แบบ String
local Tab = Win:CreateTab("Main", "⚔️")

-- แบบ Table
local Tab = Win:CreateTab({
    Name = "Main",
    Icon = "⚔️",
})
```

---

6. Built-in Pages

👤 หน้า Profile

เปิดจากปุ่ม 👤 บน TopBar

แสดงข้อมูลผู้เล่น:

Card         Icon   รายละเอียด
Profile      👤    Avatar + DisplayName + Username + UserId
ชื่อแมพ       🗺️   MarketplaceService
อายุบัญชี      ⏳    ปี/เดือน/วัน
Place ID     📍    game.PlaceId
Server ID    🖥️   game.JobId
เวลาที่เล่น    ⏱️   Session timer

⚙️ หน้า Settings

เปิดจากปุ่ม ⚙️ บน TopBar

ประกอบด้วย:

1. 🎨 Preset Themes — 7 ธีม + Rainbow
2. 🌈 Rainbow Mode
3. 📏 ขนาด UI — เล็ก/กลาง/ใหญ่
4. 🔔 ตำแหน่ง Notification
5. 💾 บันทึก/โหลด Config
6. ⚠️ Danger Zone — Reset/Destroy

---

7. Components ทั้งหมด

7.1 🏷️ AddLabel

```lua
local L = Tab:AddLabel({ Text = "ข้อความ" })
L:SetText("ใหม่")
```

7.2 📂 AddSection

```lua
local sec = Tab:AddSection({ Name = "หัวข้อ" })
sec:SetText("ใหม่")
sec:Destroy()
```

7.3 🔘 AddButton

```lua
Tab:AddButton({
    Name = "ชื่อปุ่ม",
    Description = "คำอธิบาย",
    RealtimeValue = function() return os.time() end,
    Callback = function() print("กด!") end,
})
```

7.4 🎚️ AddToggle

```lua
local T = Tab:AddToggle({
    Name = "God Mode",
    Description = "เปิดโหมดอมตะ",
    Default = false,
    ConfigKey = "god_mode",
    Callback = function(state) print(state) end,
})

T:SetState(true)
T:GetState()
```

7.5 📊 AddSlider

```lua
local S = Tab:AddSlider({
    Name = "Speed",
    Min = 0, Max = 100, Default = 50,
    ConfigKey = "speed",
    Callback = function(v) print(v) end,
})

S:GetValue()
S:SetValue(75)
```

7.6 📋 AddDropdown

```lua
local D = Tab:AddDropdown({
    Name = "โหมด",
    Options = {"Easy", "Normal", "Hard"},
    Default = "Normal",
    ConfigKey = "mode",
    Callback = function(sel) print(sel) end,
})

D:GetValue()
D:SetOptions({"A", "B", "C"})
```

7.7 ⌨️ AddInput

```lua
local I = Tab:AddInput({
    Name = "ชื่อ",
    Placeholder = "พิมพ์...",
    ConfigKey = "player_name",
    Callback = function(text) print(text) end,
})

I:GetValue()
I:SetValue("hello")
```

7.8 🎨 AddColorPicker

```lua
local C = Tab:AddColorPicker({
    Name = "สี",
    Default = Color3.fromRGB(120, 70, 230),
    ConfigKey = "esp_color",
    Callback = function(c) print(c) end,
})

C:GetColor()
C:SetColor(Color3.fromRGB(255, 0, 0))
```

7.9 📈 AddProgressBar

```lua
local PB = Tab:AddProgressBar({
    Name = "HP",
    Max = 100,
    Value = function() return 80 end,
})

PB:SetValue(75)
PB:GetValue()
PB:Reset()
```

7.10 📄 AddParagraph

```lua
local P = Tab:AddParagraph({
    Title = "หัวข้อ",
    Content = "เนื้อหายาว...",
})

P:SetTitle("ใหม่")
P:SetContent("ใหม่")
```

7.11 ⌨️ AddKeybind

```lua
local KB = Tab:AddKeybind({
    Name = "Toggle UI",
    Default = Enum.KeyCode.RightShift,
    ConfigKey = "toggle_key",
    Callback = function() Win:Toggle() end,
})

KB:GetKey()
KB:SetKey(k)
KB:IsMobile()
KB:Trigger()
```

7.12 🃏 AddCard

```lua
local Card = Tab:AddCard({
    Title = "หัวข้อ",
    Content = "เนื้อหา",
    Height = 80,
})

Card:SetTitle("ใหม่")
Card:SetContent("ใหม่")
```

7.13 📝 AddMultiDropdown

```lua
local MD = Tab:AddMultiDropdown({
    Name = "ฟีเจอร์",
    Options = {"A", "B", "C", "D"},
    Default = {"A", "C"},
    ConfigKey = "features",
    Callback = function(arr) print(arr) end,
})

MD:GetSelected()
MD:SetSelected({"B", "D"})
```

7.14 🔢 AddNumberInput

```lua
local NI = Tab:AddNumberInput({
    Name = "จำนวน",
    Min = 0, Max = 1000, Step = 50, Default = 100,
    ConfigKey = "money_amount",
    Callback = function(v) print(v) end,
})

NI:GetValue()
NI:SetValue(500)
```

7.15 📝 AddTextArea

```lua
local TA = Tab:AddTextArea({
    Name = "บันทึก",
    Placeholder = "พิมพ์หลายบรรทัด...",
    Height = 100,
    ConfigKey = "notes",
    Callback = function(text) print(text) end,
})

TA:GetValue()
TA:SetValue("Hello\nWorld")
```

7.16 ➖ AddDivider

```lua
Tab:AddDivider({ Text = "แบ่งส่วน" })
Tab:AddDivider({})
Tab:AddDivider({ Text = "หนา", Thickness = 3 })
```

7.17 🖼️ AddImage

```lua
local IMG = Tab:AddImage({
    Name = "รูป",
    Image = "rbxassetid://1234567890",
    Height = 120,
    ScaleType = Enum.ScaleType.Fit,
})

IMG:SetImage("rbxassetid://...")
```

7.18 🔍 AddSearch (Component)

```lua
Tab:AddSearch({
    Name = "ค้นหา",
    Placeholder = "พิมพ์...",
    OnSearch = function(q) print("ค้นหา:", q) end,
    Callback = function(text) print("ยืนยัน:", text) end,
})
```

7.19 🌳 AddTreeView

```lua
local Tree = Tab:AddTreeView({
    Name = "โครงสร้าง",
    Data = {
        {Name = "📁 Folder A", Children = {
            {Name = "📄 File 1"},
            {Name = "📁 Sub", Children = {
                {Name = "📄 Nested"},
            }},
        }},
        {Name = "📄 Root"},
    },
    Callback = function(node) print(node.Name) end,
})

Tree:Refresh(newData)
```

7.20 🎁 AddAccordion

ดู Section 8

---

8. Accordion

```lua
local Acc = Tab:AddAccordion({
    Name = "⚙️ Advanced",
    Default = false,
})

Acc:AddToggle({ Name = "Debug", ConfigKey = "debug" })
Acc:AddSlider({ Name = "Speed", Min = 1, Max = 100 })
Acc:AddButton({ Name = "Reset", Callback = function() end })
```

⚠️ ห้าม nested Accordion

Component ที่ใส่ได้

· AddToggle, AddSlider, AddButton, AddDropdown, AddColorPicker
· AddLabel, AddSection, AddInput, AddParagraph
· AddProgressBar, AddCard, AddMultiDropdown, AddNumberInput
· AddTextArea, AddDivider, AddImage, AddSearch, AddTreeView

---

9. Themes

7 ธีมสำเร็จรูป

ชื่อ        ไอคอน
Eclipse     🌒
Ocean       🌊
Forest      🌲
Inferno     🔥
Sakura      🌸
Midnight    🖤
Rainbow     🌈

เปิดที่ ⚙️ Settings → Preset Themes

---

10. Rainbow Mode 🌈

วิธีเปิด

1. กดปุ่ม ⚙️ บน TopBar
2. 🌈 Rainbow Mode → toggle

สิ่งที่เปลี่ยน

· 🎨 Accent
· 🖼️ Background
· 🎁 Secondary
· 🔔 Border
· 📝 Input BG
· 📊 Slider BG
· 📋 Dropdown BG
· 🔘 Tab buttons
· ✨ UIStroke

ปิด → กลับมาธีมเดิมอัตโนมัติ

---

11. Notification

```lua
EclipseLib:Notify({
    Title = "📢 แจ้งเตือน",
    Content = "ข้อความ",
    Duration = 3,
    Type = "info",     -- info / error
    Silent = false,
})
```

Param     Type    Default
Title     string  "EclipseLib"
Content   string  ""
Duration  number  3
Type      string  "info"
Silent    boolean false

🔔 เปลี่ยนตำแหน่ง

```lua
Win:SetNotifPosition("left")
Win:SetNotifPosition("right")
```

---

12. Dialog System

🔔 Alert

```lua
local result = EclipseLib:Alert({
    Title = "แจ้งเตือน",
    Message = "ข้อความ",
    Type = "info",  -- info / warning / error / success
    Buttons = {"Cancel", "OK"},
})
-- 1 = Cancel, 2 = OK
```

💬 Prompt

```lua
local text = EclipseLib:Prompt({
    Title = "ใส่ชื่อ",
    Placeholder = "ชื่อ...",
    Default = "",
})
-- string หรือ nil
```

🎉 Toast

```lua
EclipseLib:Toast({
    Title = "🎉 สำเร็จ",
    Content = "เสร็จแล้ว",
    Duration = 3,
})
```

❓ Confirm

```lua
if EclipseLib:Confirm("แน่ใจหรือไม่?") then
    print("ตกลง")
end
```

---

13. Context Menu

```lua
EclipseLib:ShowContextMenu({
    {"📋 Copy",  function() print("Copy")  end},
    {"🎯 Select", function() print("Select") end},
    {"❌ Delete", function() print("Delete") end},
}, Vector2.new(200, 200))
```

---

14. Sound System

```lua
EclipseLib:SetSounds({ Click = "rbxasset://sounds/new.wav" })
EclipseLib:SetSoundEnabled(true)
EclipseLib:PlaySound("Click")
EclipseLib:PlaySound("Toggle")
```

Sounds ที่มี
· Notify
· Click
· Toggle
· Error

---

15. Config System

หลักการ

· ใส่ ConfigKey ใน Component → save อัตโนมัติ
· ไฟล์เก็บใน {FolderName}/ เท่านั้น
· เปลี่ยนค่า → mark dirty → autosave (ถ้าเปิด)

Component ที่ ConfigKey รองรับ

· ✅ Toggle
· ✅ Slider
· ✅ Dropdown
· ✅ Input
· ✅ NumberInput
· ✅ TextArea
· ✅ MultiDropdown
· ✅ ColorPicker
· ✅ Keybind

UI State ที่เก็บอัตโนมัติ

· ตำแหน่ง UI
· ขนาด UI
· Tab ที่เปิด
· TabBar แสดง/ซ่อน
· Theme
· Rainbow
· ตำแหน่ง Notification
· Hotkeys ทั้งหมด

📖 ผ่าน UI

1. กด ⚙️ → ไปที่ 💾 บันทึก/โหลด Config
2. ใส่ชื่อไฟล์ → 💾 Save ใหม่
3. เลือกไฟล์ → 📂 Load หรือ ✏️ ทับ

🎯 ตัวอย่าง

```lua
Tab:AddToggle({
    Name = "Speed Hack",
    ConfigKey = "speed_hack_v1",
    Callback = function(state) end,
})
```

---

16. Key System

```lua
local Win = EclipseLib:CreateWindow({
    Name = "My Script",
    KeySystem = true,
    Key = {"ABC123", "XYZ789"},
    KeyTitle = "🔑 ใส่ Key",
    KeyDescription = "กรอก Key เพื่อเข้าใช้",
    KeyLink = "https://example.com/getkey",
})
```

ฟีเจอร์
· ✅ Save Key
· ✅ Auto-check
· ✅ Invalid key → auto delete
· ✅ Copy link
· ✅ Shake animation

---

17. Hotkeys

```lua
local hk = Win:AddGlobalHotkey({
    Name = "Toggle UI",
    Default = Enum.KeyCode.RightControl,
    Callback = function() Win:Toggle() end,
})

hk:GetKey()
hk:SetKey(k)
```

🎯 ปุ่มที่แนะนำ
✅ ปลอดภัย: RightControl, RightShift, F1–F12, Insert, Home
❌ ระวัง: Delete, Escape, Tab, Backspace

---

18. Unload

```lua
local count = EclipseLib:Unload()
print("Unloaded", count, "windows")
```

ทำความสะอาดทั้งหมด
· ✅ Destroy ทุก window
· ✅ Disconnect ทุก connection
· ✅ ลบ Notification
· ✅ Clear Rainbow
· ✅ Destroy Sound

---

19. Best Practices

⏱️ 1. ใช้ RealtimeValue

```lua
Tab:AddButton({
    Name = "Clock",
    RealtimeValue = function() return os.clock() end,
})
```

🔔 2. Debounce Notify

```lua
local lastWarn = 0
if hp < 10 and os.clock() - lastWarn > 2 then
    lastWarn = os.clock()
    EclipseLib:Notify({Title = "⚠️ HP ต่ำ!"})
end
```

🛡️ 3. Silent Notify

```lua
EclipseLib:Notify({
    Title = "📢 Update",
    Content = "HP: " .. hp,
    Silent = true,
})
```

💾 4. ConfigKey ที่ดี

```lua
ConfigKey = "my_script_speed_v1"  -- ✅ unique + version
ConfigKey = "speed"                -- ❌ ซ้ำง่าย
```

---

20. Troubleshooting

❌ Tab กดไม่ติด
→ ตรวจสอบว่าสร้าง Tab สำเร็จ

❌ Rainbow ไม่เปลี่ยนสี
→ ลองปิด/เปิดใหม่

❌ Load แล้วค่าหาย
→ ตรวจสอบว่า Component มี ConfigKey

❌ Autosave ไม่ทำงาน
→ ตรวจสอบ Win:SetAutosave(true, "name", 30)

❌ Key ผิดแม้ใส่ถูก
→ ลบ eclipse_key.dat แล้วใส่ใหม่

---

📘 EclipseLib v6.5.2 — เอกสารประกอบ
🏷️ สร้างโดย wino444
📅 อัปเดต: 2026
🌟 Happy Scripting!

```
