-- 🌒 EclipseLib — Theme System Module
-- ระบบ Theme, Presets และ Apply ทั่วทั้ง UI

local ThemeSystem = {}
ThemeSystem.__index = ThemeSystem

-- ═══════════════════════════════════
-- 🎨 Default Theme
-- ═══════════════════════════════════
ThemeSystem.Default = {
    Background   = Color3.fromRGB(15, 15, 20),
    Secondary    = Color3.fromRGB(22, 22, 30),
    Accent       = Color3.fromRGB(100, 60, 200),
    AccentHover  = Color3.fromRGB(120, 80, 220),
    Text         = Color3.fromRGB(220, 220, 235),
    SubText      = Color3.fromRGB(140, 140, 160),
    Border       = Color3.fromRGB(50, 40, 80),
    TabActive    = Color3.fromRGB(100, 60, 200),
    TabInactive  = Color3.fromRGB(30, 28, 40),
    Toggle_ON    = Color3.fromRGB(100, 60, 200),
    Toggle_OFF   = Color3.fromRGB(50, 45, 65),
    Slider_Fill  = Color3.fromRGB(100, 60, 200),
    Slider_BG    = Color3.fromRGB(35, 32, 50),
    Notif_BG     = Color3.fromRGB(20, 18, 30),
    Notif_Border = Color3.fromRGB(100, 60, 200),
    Input_BG     = Color3.fromRGB(28, 25, 40),
    Dropdown_BG  = Color3.fromRGB(25, 22, 38),
}

-- ═══════════════════════════════════
-- 🌈 Preset Themes
-- ═══════════════════════════════════
ThemeSystem.Presets = {
    {
        name     = "🌒 Eclipse",
        accent   = Color3.fromRGB(100, 60, 200),
        bg       = Color3.fromRGB(15, 15, 20),
        sec      = Color3.fromRGB(22, 22, 30),
        border   = Color3.fromRGB(50, 40, 80),
        inactive = Color3.fromRGB(30, 28, 40),
    },
    {
        name     = "🌊 Ocean",
        accent   = Color3.fromRGB(30, 120, 220),
        bg       = Color3.fromRGB(10, 18, 28),
        sec      = Color3.fromRGB(15, 28, 42),
        border   = Color3.fromRGB(20, 60, 100),
        inactive = Color3.fromRGB(18, 32, 50),
    },
    {
        name     = "🌲 Forest",
        accent   = Color3.fromRGB(40, 170, 90),
        bg       = Color3.fromRGB(10, 18, 12),
        sec      = Color3.fromRGB(15, 26, 18),
        border   = Color3.fromRGB(25, 70, 35),
        inactive = Color3.fromRGB(18, 32, 20),
    },
    {
        name     = "🔥 Inferno",
        accent   = Color3.fromRGB(220, 80, 30),
        bg       = Color3.fromRGB(20, 10, 8),
        sec      = Color3.fromRGB(30, 15, 10),
        border   = Color3.fromRGB(80, 30, 15),
        inactive = Color3.fromRGB(35, 18, 12),
    },
    {
        name     = "🌸 Sakura",
        accent   = Color3.fromRGB(220, 80, 140),
        bg       = Color3.fromRGB(20, 12, 18),
        sec      = Color3.fromRGB(30, 18, 26),
        border   = Color3.fromRGB(80, 30, 60),
        inactive = Color3.fromRGB(35, 18, 30),
    },
    {
        name     = "🖤 Midnight",
        accent   = Color3.fromRGB(160, 160, 180),
        bg       = Color3.fromRGB(8, 8, 10),
        sec      = Color3.fromRGB(14, 14, 18),
        border   = Color3.fromRGB(40, 40, 50),
        inactive = Color3.fromRGB(20, 20, 26),
    },
}

-- ═══════════════════════════════════
-- 🔧 Theme Registry (เก็บ refs ทุก element)
-- ═══════════════════════════════════
function ThemeSystem.NewRegistry()
    return {
        backgrounds = {},
        secondaries = {},
        accents     = {},
        borders     = {},
        texts       = {},
        subtexts    = {},
        tabInactive = {},
        tabActive   = {},
        sliderFills = {},
        toggleON    = {},
        toggleOFF   = {},
    }
end

-- ═══════════════════════════════════
-- 🎨 Apply Theme to Registry
-- ═══════════════════════════════════
function ThemeSystem.ApplyAll(TR, th, tabButtons, activeTab, Theme, Tween)
    -- อัปเดต Theme table ก่อน
    if th.bg      then Theme.Background  = th.bg      end
    if th.sec     then Theme.Secondary   = th.sec     end
    if th.accent  then
        Theme.Accent       = th.accent
        Theme.TabActive    = th.accent
        Theme.Toggle_ON    = th.accent
        Theme.Slider_Fill  = th.accent
        Theme.Notif_Border = th.accent
        Theme.AccentHover  = th.accent
    end
    if th.border   then Theme.Border     = th.border   end
    if th.inactive then Theme.TabInactive = th.inactive end
    if th.text     then Theme.Text       = th.text     end
    if th.subtext  then Theme.SubText    = th.subtext  end

    -- Apply ทุก element
    for _, f in ipairs(TR.backgrounds) do
        pcall(function() Tween(f, {BackgroundColor3 = Theme.Background}, 0.3) end)
    end
    for _, f in ipairs(TR.secondaries) do
        pcall(function() Tween(f, {BackgroundColor3 = Theme.Secondary}, 0.3) end)
    end
    for _, f in ipairs(TR.accents) do
        pcall(function()
            if f:IsA("TextLabel") or f:IsA("TextButton") then
                f.TextColor3 = Theme.Accent
            else
                Tween(f, {BackgroundColor3 = Theme.Accent}, 0.3)
            end
        end)
    end
    for _, s in ipairs(TR.borders) do
        pcall(function()
            if s._isPseudo then
                s._frame.BackgroundColor3 = Theme.Border
            else
                s.Color = Theme.Border
            end
        end)
    end
    for _, l in ipairs(TR.texts) do
        pcall(function() l.TextColor3 = Theme.Text end)
    end
    for _, l in ipairs(TR.subtexts) do
        pcall(function() l.TextColor3 = Theme.SubText end)
    end
    -- slider fills
    for _, f in ipairs(TR.sliderFills) do
        pcall(function() Tween(f, {BackgroundColor3 = Theme.Slider_Fill}, 0.3) end)
    end
    -- tab buttons
    if tabButtons and activeTab then
        for n, btn in pairs(tabButtons) do
            if n == activeTab then
                pcall(function() Tween(btn, {BackgroundColor3 = Theme.TabActive}, 0.2) end)
            else
                pcall(function() Tween(btn, {BackgroundColor3 = Theme.TabInactive}, 0.2) end)
            end
        end
    end
end

return ThemeSystem
