-- 🌒 EclipseLib
-- Version: 3.0.0
-- Theme: Dark but Radiant

local EclipseLib = {}
EclipseLib.__index = EclipseLib

-- ═══════════════════════════════════════
-- 🎬 Intro Config (เจ้าของโค้ดเปลี่ยนได้เท่านั้น)
-- Mode: "fade" | "zoom" | "glitch" | "particle"
-- ═══════════════════════════════════════
local IntroConfig = {
    Mode     = "particle",   -- default mode
    Duration = 4,        -- วินาทีรวม
    Icon     = "🌒",     -- ไอคอนตรงกลาง
}

-- ═══════════════════════════════════════
-- 🎨 Default Theme
-- ═══════════════════════════════════════
local Theme = {
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

-- ═══════════════════════════════════════
-- 🛠️ Services
-- ═══════════════════════════════════════
local Players          = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService     = game:GetService("TweenService")
local RunService       = game:GetService("RunService")
local CoreGui          = game:GetService("CoreGui")
local LocalPlayer      = Players.LocalPlayer

-- ═══════════════════════════════════════
-- 🧰 Utility
-- ═══════════════════════════════════════
local function Tween(obj, props, t, style, dir)
    local info = TweenInfo.new(
        t or 0.2,
        style or Enum.EasingStyle.Quad,
        dir   or Enum.EasingDirection.Out
    )
    local tw = TweenService:Create(obj, info, props)
    tw:Play()
    return tw
end

local function TweenWait(obj, props, t, style, dir)
    local tw = Tween(obj, props, t, style, dir)
    tw.Completed:Wait()
end

local function MakeDraggable(frame, handle)
    local dragging, dragStart, startPos = false, nil, nil
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging  = true
            dragStart = input.Position
            startPos  = frame.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (
            input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch
        ) then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
end

local function CreateCorner(parent, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius or 8)
    c.Parent = parent
end

local function CreateStroke(parent, color, thickness)
    local s = Instance.new("UIStroke")
    s.Color     = color or Theme.Border
    s.Thickness = thickness or 1
    s.Parent    = parent
end

local function SetClipboard(text)
    pcall(function()
        if setclipboard then setclipboard(text)
        elseif toclipboard then toclipboard(text)
        elseif Clipboard then Clipboard.set(text) end
    end)
end

local function MakeScreenGui(name, order)
    local sg = Instance.new("ScreenGui")
    sg.Name            = name
    sg.ResetOnSpawn    = false
    sg.IgnoreGuiInset  = true
    sg.DisplayOrder    = order or 999
    pcall(function() sg.Parent = CoreGui end)
    if not sg.Parent then
        sg.Parent = LocalPlayer:WaitForChild("PlayerGui")
    end
    return sg
end

-- ═══════════════════════════════════════
-- 🎬 Intro Animations
-- ═══════════════════════════════════════
local function RunIntroMode_Fade(sg, title, subtitle, onDone)
    -- พื้นหลังดำ
    local bg = Instance.new("Frame")
    bg.BackgroundColor3 = Color3.fromRGB(8, 8, 12)
    bg.Size   = UDim2.new(1, 0, 1, 0)
    bg.BackgroundTransparency = 1
    bg.Parent = sg

    -- Glow center
    local glowCenter = Instance.new("Frame")
    glowCenter.BackgroundColor3 = Theme.Accent
    glowCenter.BackgroundTransparency = 1
    glowCenter.Size     = UDim2.new(0, 180, 0, 180)
    glowCenter.Position = UDim2.new(0.5, -90, 0.5, -90)
    glowCenter.Parent   = bg
    CreateCorner(glowCenter, 90)

    -- ไอคอน 🌒
    local iconLbl = Instance.new("TextLabel")
    iconLbl.BackgroundTransparency = 1
    iconLbl.Size     = UDim2.new(0, 80, 0, 80)
    iconLbl.Position = UDim2.new(0.5, -40, 0.5, -70)
    iconLbl.Text     = IntroConfig.Icon
    iconLbl.TextSize = 56
    iconLbl.Font     = Enum.Font.GothamBold
    iconLbl.TextTransparency = 1
    iconLbl.Parent   = bg

    -- LoadingTitle
    local titleLbl = Instance.new("TextLabel")
    titleLbl.BackgroundTransparency = 1
    titleLbl.Size     = UDim2.new(1, 0, 0, 36)
    titleLbl.Position = UDim2.new(0, 0, 0.5, 20)
    titleLbl.Text     = title
    titleLbl.TextColor3 = Theme.Text
    titleLbl.TextTransparency = 1
    titleLbl.Font     = Enum.Font.GothamBold
    titleLbl.TextSize = 22
    titleLbl.Parent   = bg

    -- LoadingSubtitle
    local subLbl = Instance.new("TextLabel")
    subLbl.BackgroundTransparency = 1
    subLbl.Size     = UDim2.new(1, 0, 0, 24)
    subLbl.Position = UDim2.new(0, 0, 0.5, 58)
    subLbl.Text     = subtitle
    subLbl.TextColor3 = Theme.SubText
    subLbl.TextTransparency = 1
    subLbl.Font     = Enum.Font.Gotham
    subLbl.TextSize = 14
    subLbl.Parent   = bg

    -- Loading bar BG
    local barBG = Instance.new("Frame")
    barBG.BackgroundColor3 = Theme.Slider_BG
    barBG.BackgroundTransparency = 1
    barBG.Size     = UDim2.new(0, 220, 0, 3)
    barBG.Position = UDim2.new(0.5, -110, 0.5, 90)
    barBG.Parent   = bg
    CreateCorner(barBG, 3)

    local barFill = Instance.new("Frame")
    barFill.BackgroundColor3 = Theme.Accent
    barFill.Size   = UDim2.new(0, 0, 1, 0)
    barFill.Parent = barBG
    CreateCorner(barFill, 3)

    -- ── Animation sequence ──
    task.spawn(function()
        -- fade in bg
        TweenWait(bg, {BackgroundTransparency = 0}, 0.4)

        -- glow pulse
        Tween(glowCenter, {BackgroundTransparency = 0.88, Size = UDim2.new(0, 200, 0, 200), Position = UDim2.new(0.5, -100, 0.5, -100)}, 0.6, Enum.EasingStyle.Sine)

        -- icon fade in + slide up
        iconLbl.Position = UDim2.new(0.5, -40, 0.5, -50)
        TweenWait(iconLbl, {TextTransparency = 0, Position = UDim2.new(0.5, -40, 0.5, -70)}, 0.5, Enum.EasingStyle.Quint)

        task.wait(0.1)

        -- title fade in
        TweenWait(titleLbl, {TextTransparency = 0}, 0.45, Enum.EasingStyle.Quad)

        task.wait(0.1)

        -- subtitle fade in
        TweenWait(subLbl, {TextTransparency = 0}, 0.4, Enum.EasingStyle.Quad)

        task.wait(0.1)

        -- bar appear
        TweenWait(barBG, {BackgroundTransparency = 0}, 0.3)

        -- bar fill
        TweenWait(barFill, {Size = UDim2.new(1, 0, 1, 0)}, 1.2, Enum.EasingStyle.Quint)

        task.wait(0.25)

        -- fade out everything
        Tween(iconLbl,  {TextTransparency = 1, Position = UDim2.new(0.5, -40, 0.5, -90)}, 0.45)
        Tween(titleLbl, {TextTransparency = 1}, 0.45)
        Tween(subLbl,   {TextTransparency = 1}, 0.45)
        Tween(barBG,    {BackgroundTransparency = 1}, 0.45)
        Tween(barFill,  {BackgroundTransparency = 1}, 0.45)
        Tween(glowCenter, {BackgroundTransparency = 1}, 0.45)
        TweenWait(bg, {BackgroundTransparency = 1}, 0.5)

        sg:Destroy()
        onDone()
    end)
end

local function RunIntroMode_Zoom(sg, title, subtitle, onDone)
    local bg = Instance.new("Frame")
    bg.BackgroundColor3 = Color3.fromRGB(8, 8, 12)
    bg.Size   = UDim2.new(1, 0, 1, 0)
    bg.BackgroundTransparency = 1
    bg.Parent = sg

    local iconLbl = Instance.new("TextLabel")
    iconLbl.BackgroundTransparency = 1
    iconLbl.Size     = UDim2.new(0, 20, 0, 20)
    iconLbl.Position = UDim2.new(0.5, -10, 0.5, -60)
    iconLbl.Text     = IntroConfig.Icon
    iconLbl.TextSize = 12
    iconLbl.TextTransparency = 0.8
    iconLbl.Font     = Enum.Font.GothamBold
    iconLbl.Parent   = bg

    local titleLbl = Instance.new("TextLabel")
    titleLbl.BackgroundTransparency = 1
    titleLbl.Size     = UDim2.new(1, 0, 0, 36)
    titleLbl.Position = UDim2.new(0, 0, 0.5, 20)
    titleLbl.Text     = title
    titleLbl.TextColor3 = Theme.Text
    titleLbl.TextTransparency = 1
    titleLbl.Font     = Enum.Font.GothamBold
    titleLbl.TextSize = 22
    titleLbl.Parent   = bg

    local subLbl = Instance.new("TextLabel")
    subLbl.BackgroundTransparency = 1
    subLbl.Size     = UDim2.new(1, 0, 0, 24)
    subLbl.Position = UDim2.new(0, 0, 0.5, 58)
    subLbl.Text     = subtitle
    subLbl.TextColor3 = Theme.SubText
    subLbl.TextTransparency = 1
    subLbl.Font     = Enum.Font.Gotham
    subLbl.TextSize = 14
    subLbl.Parent   = bg

    local barBG = Instance.new("Frame")
    barBG.BackgroundColor3 = Theme.Slider_BG
    barBG.BackgroundTransparency = 1
    barBG.Size     = UDim2.new(0, 220, 0, 3)
    barBG.Position = UDim2.new(0.5, -110, 0.5, 90)
    barBG.Parent   = bg
    CreateCorner(barBG, 3)

    local barFill = Instance.new("Frame")
    barFill.BackgroundColor3 = Theme.Accent
    barFill.Size   = UDim2.new(0, 0, 1, 0)
    barFill.Parent = barBG
    CreateCorner(barFill, 3)

    task.spawn(function()
        TweenWait(bg, {BackgroundTransparency = 0}, 0.3)

        -- zoom in icon
        TweenWait(iconLbl, {
            TextSize = 72,
            TextTransparency = 0,
            Size     = UDim2.new(0, 80, 0, 80),
            Position = UDim2.new(0.5, -40, 0.5, -70),
        }, 0.55, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

        -- bounce settle
        TweenWait(iconLbl, {
            TextSize = 56,
            Size     = UDim2.new(0, 70, 0, 70),
        }, 0.2, Enum.EasingStyle.Bounce)

        task.wait(0.05)
        TweenWait(titleLbl, {TextTransparency = 0}, 0.4)
        task.wait(0.1)
        TweenWait(subLbl, {TextTransparency = 0}, 0.35)
        task.wait(0.1)
        TweenWait(barBG, {BackgroundTransparency = 0}, 0.25)
        TweenWait(barFill, {Size = UDim2.new(1, 0, 1, 0)}, 1.2, Enum.EasingStyle.Quint)

        task.wait(0.2)
        Tween(iconLbl,  {TextTransparency = 1, TextSize = 100}, 0.5)
        Tween(titleLbl, {TextTransparency = 1}, 0.4)
        Tween(subLbl,   {TextTransparency = 1}, 0.4)
        Tween(barBG,    {BackgroundTransparency = 1}, 0.4)
        Tween(barFill,  {BackgroundTransparency = 1}, 0.4)
        TweenWait(bg, {BackgroundTransparency = 1}, 0.5)

        sg:Destroy()
        onDone()
    end)
end

local function RunIntroMode_Glitch(sg, title, subtitle, onDone)
    local bg = Instance.new("Frame")
    bg.BackgroundColor3 = Color3.fromRGB(8, 8, 12)
    bg.Size   = UDim2.new(1, 0, 1, 0)
    bg.BackgroundTransparency = 1
    bg.Parent = sg

    -- Scanlines effect
    for i = 1, 8 do
        local line = Instance.new("Frame")
        line.BackgroundColor3 = Color3.fromRGB(100, 60, 200)
        line.BackgroundTransparency = 0.92
        line.Size     = UDim2.new(1, 0, 0, 1)
        line.Position = UDim2.new(0, 0, i / 9, 0)
        line.BorderSizePixel = 0
        line.Parent   = bg
    end

    local iconLbl = Instance.new("TextLabel")
    iconLbl.BackgroundTransparency = 1
    iconLbl.Size     = UDim2.new(0, 80, 0, 80)
    iconLbl.Position = UDim2.new(0.5, -40, 0.5, -70)
    iconLbl.Text     = IntroConfig.Icon
    iconLbl.TextSize = 56
    iconLbl.TextTransparency = 1
    iconLbl.Font     = Enum.Font.GothamBold
    iconLbl.Parent   = bg

    local titleLbl = Instance.new("TextLabel")
    titleLbl.BackgroundTransparency = 1
    titleLbl.Size     = UDim2.new(1, 0, 0, 36)
    titleLbl.Position = UDim2.new(0, 0, 0.5, 20)
    titleLbl.Text     = "█▓░ LOADING ░▓█"
    titleLbl.TextColor3 = Theme.Accent
    titleLbl.TextTransparency = 1
    titleLbl.Font     = Enum.Font.Code
    titleLbl.TextSize = 18
    titleLbl.Parent   = bg

    local subLbl = Instance.new("TextLabel")
    subLbl.BackgroundTransparency = 1
    subLbl.Size     = UDim2.new(1, 0, 0, 24)
    subLbl.Position = UDim2.new(0, 0, 0.5, 58)
    subLbl.Text     = subtitle
    subLbl.TextColor3 = Theme.SubText
    subLbl.TextTransparency = 1
    subLbl.Font     = Enum.Font.Code
    subLbl.TextSize = 13
    subLbl.Parent   = bg

    local barBG = Instance.new("Frame")
    barBG.BackgroundColor3 = Theme.Slider_BG
    barBG.BackgroundTransparency = 1
    barBG.Size     = UDim2.new(0, 220, 0, 3)
    barBG.Position = UDim2.new(0.5, -110, 0.5, 90)
    barBG.Parent   = bg
    CreateCorner(barBG, 2)

    local barFill = Instance.new("Frame")
    barFill.BackgroundColor3 = Theme.Accent
    barFill.Size   = UDim2.new(0, 0, 1, 0)
    barFill.Parent = barBG

    -- Glitch helper: สุ่มตัวอักษร
    local glitchChars = {"█","▓","▒","░","▄","▌","▐","▀","■","□","▪","▫"}
    local function GlitchText(lbl, finalText, duration)
        local steps = math.floor(duration / 0.06)
        for i = 1, steps do
            local out = ""
            for j = 1, #finalText do
                if i / steps > (j / #finalText * 0.8) then
                    out = out .. string.sub(finalText, j, j)
                else
                    out = out .. glitchChars[math.random(1, #glitchChars)]
                end
            end
            lbl.Text = out
            task.wait(0.06)
        end
        lbl.Text = finalText
    end

    task.spawn(function()
        TweenWait(bg, {BackgroundTransparency = 0}, 0.25)

        -- icon glitch appear
        titleLbl.TextTransparency = 0
        iconLbl.TextTransparency  = 0
        iconLbl.TextColor3 = Theme.Accent

        -- glitch icon flicker
        for i = 1, 6 do
            iconLbl.TextTransparency = (i % 2 == 0) and 0 or 0.7
            iconLbl.Position = UDim2.new(0.5, math.random(-4,4), 0.5, -70 + math.random(-3,3))
            task.wait(0.07)
        end
        iconLbl.TextTransparency = 0
        iconLbl.TextColor3 = Theme.Text
        iconLbl.Position = UDim2.new(0.5, -40, 0.5, -70)

        task.wait(0.1)

        -- glitch title text
        GlitchText(titleLbl, title, 0.9)
        titleLbl.TextColor3 = Theme.Text
        titleLbl.Font = Enum.Font.GothamBold
        titleLbl.TextSize = 22

        task.wait(0.1)

        -- subtitle
        TweenWait(subLbl, {TextTransparency = 0}, 0.3)
        subLbl.Font = Enum.Font.Gotham

        task.wait(0.1)

        -- bar
        TweenWait(barBG, {BackgroundTransparency = 0}, 0.2)
        TweenWait(barFill, {Size = UDim2.new(1, 0, 1, 0)}, 1.1, Enum.EasingStyle.Linear)

        task.wait(0.2)

        -- glitch out
        for i = 1, 5 do
            bg.BackgroundColor3 = i % 2 == 0
                and Color3.fromRGB(8, 8, 12)
                or  Color3.fromRGB(20, 10, 40)
            task.wait(0.05)
        end

        Tween(iconLbl,  {TextTransparency = 1}, 0.35)
        Tween(titleLbl, {TextTransparency = 1}, 0.35)
        Tween(subLbl,   {TextTransparency = 1}, 0.35)
        Tween(barBG,    {BackgroundTransparency = 1}, 0.35)
        Tween(barFill,  {BackgroundTransparency = 1}, 0.35)
        TweenWait(bg, {BackgroundTransparency = 1}, 0.45)

        sg:Destroy()
        onDone()
    end)
end

local function RunIntroMode_Particle(sg, title, subtitle, onDone)
    local bg = Instance.new("Frame")
    bg.BackgroundColor3 = Color3.fromRGB(8, 8, 12)
    bg.Size   = UDim2.new(1, 0, 1, 0)
    bg.BackgroundTransparency = 1
    bg.Parent = sg

    -- สร้าง particles
    local particles = {}
    local centerX   = 0.5
    local centerY   = 0.5
    math.randomseed(tick())

    for i = 1, 28 do
        local p = Instance.new("Frame")
        local sz = math.random(2, 6)
        p.BackgroundColor3 = (math.random() > 0.5) and Theme.Accent or Color3.fromRGB(180, 140, 255)
        p.BackgroundTransparency = 0
        p.Size     = UDim2.new(0, sz, 0, sz)
        local angle  = math.rad(math.random(0, 360))
        local dist   = math.random(80, 200)
        local px = 0.5 + (math.cos(angle) * dist / 600)
        local py = 0.5 + (math.sin(angle) * dist / 600)
        p.Position = UDim2.new(px, -sz/2, py, -sz/2)
        p.Parent   = bg
        CreateCorner(p, sz)
        table.insert(particles, {frame=p, angle=angle, dist=dist})
    end

    local iconLbl = Instance.new("TextLabel")
    iconLbl.BackgroundTransparency = 1
    iconLbl.Size     = UDim2.new(0, 80, 0, 80)
    iconLbl.Position = UDim2.new(0.5, -40, 0.5, -70)
    iconLbl.Text     = IntroConfig.Icon
    iconLbl.TextSize = 12
    iconLbl.TextTransparency = 1
    iconLbl.Font     = Enum.Font.GothamBold
    iconLbl.Parent   = bg

    local titleLbl = Instance.new("TextLabel")
    titleLbl.BackgroundTransparency = 1
    titleLbl.Size     = UDim2.new(1, 0, 0, 36)
    titleLbl.Position = UDim2.new(0, 0, 0.5, 20)
    titleLbl.Text     = title
    titleLbl.TextColor3 = Theme.Text
    titleLbl.TextTransparency = 1
    titleLbl.Font     = Enum.Font.GothamBold
    titleLbl.TextSize = 22
    titleLbl.Parent   = bg

    local subLbl = Instance.new("TextLabel")
    subLbl.BackgroundTransparency = 1
    subLbl.Size     = UDim2.new(1, 0, 0, 24)
    subLbl.Position = UDim2.new(0, 0, 0.5, 58)
    subLbl.Text     = subtitle
    subLbl.TextColor3 = Theme.SubText
    subLbl.TextTransparency = 1
    subLbl.Font     = Enum.Font.Gotham
    subLbl.TextSize = 14
    subLbl.Parent   = bg

    local barBG = Instance.new("Frame")
    barBG.BackgroundColor3 = Theme.Slider_BG
    barBG.BackgroundTransparency = 1
    barBG.Size     = UDim2.new(0, 220, 0, 3)
    barBG.Position = UDim2.new(0.5, -110, 0.5, 90)
    barBG.Parent   = bg
    CreateCorner(barBG, 3)

    local barFill = Instance.new("Frame")
    barFill.BackgroundColor3 = Theme.Accent
    barFill.Size   = UDim2.new(0, 0, 1, 0)
    barFill.Parent = barBG
    CreateCorner(barFill, 3)

    task.spawn(function()
        TweenWait(bg, {BackgroundTransparency = 0}, 0.3)

        -- particles converge to center
        for _, pd in ipairs(particles) do
            Tween(pd.frame, {
                Position = UDim2.new(0.5, -3, 0.5, -3),
                BackgroundTransparency = 0.3,
                Size = UDim2.new(0, 4, 0, 4),
            }, 0.7, Enum.EasingStyle.Quint)
        end
        task.wait(0.65)

        -- particles disappear + icon zoom in
        for _, pd in ipairs(particles) do
            Tween(pd.frame, {BackgroundTransparency = 1, Size = UDim2.new(0, 0, 0, 0)}, 0.2)
        end

        TweenWait(iconLbl, {
            TextTransparency = 0,
            TextSize = 56,
        }, 0.45, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

        task.wait(0.1)
        TweenWait(titleLbl, {TextTransparency = 0}, 0.4)
        task.wait(0.1)
        TweenWait(subLbl, {TextTransparency = 0}, 0.35)
        task.wait(0.1)
        TweenWait(barBG, {BackgroundTransparency = 0}, 0.25)
        TweenWait(barFill, {Size = UDim2.new(1, 0, 1, 0)}, 1.1, Enum.EasingStyle.Quint)

        task.wait(0.2)
        Tween(iconLbl,  {TextTransparency = 1}, 0.4)
        Tween(titleLbl, {TextTransparency = 1}, 0.4)
        Tween(subLbl,   {TextTransparency = 1}, 0.4)
        Tween(barBG,    {BackgroundTransparency = 1}, 0.4)
        Tween(barFill,  {BackgroundTransparency = 1}, 0.4)
        TweenWait(bg, {BackgroundTransparency = 1}, 0.5)

        sg:Destroy()
        onDone()
    end)
end

-- ── Intro Dispatcher ──
local function PlayIntro(title, subtitle, onDone)
    local sg = MakeScreenGui("__EclipseIntro", 10000)
    local mode = IntroConfig.Mode

    if mode == "zoom" then
        RunIntroMode_Zoom(sg, title, subtitle, onDone)
    elseif mode == "glitch" then
        RunIntroMode_Glitch(sg, title, subtitle, onDone)
    elseif mode == "particle" then
        RunIntroMode_Particle(sg, title, subtitle, onDone)
    else
        RunIntroMode_Fade(sg, title, subtitle, onDone)
    end
end

-- ═══════════════════════════════════════
-- 🔔 Notification System
-- ═══════════════════════════════════════
local NotifHolder

local function EnsureNotifHolder()
    if NotifHolder and NotifHolder.Parent then return end
    local sg = MakeScreenGui("__EclipseNotif", 9999)

    NotifHolder = Instance.new("Frame")
    NotifHolder.BackgroundTransparency = 1
    NotifHolder.Position = UDim2.new(1, -220, 0, 60)
    NotifHolder.Size     = UDim2.new(0, 210, 1, -120)
    NotifHolder.Parent   = sg

    local layout = Instance.new("UIListLayout")
    layout.SortOrder         = Enum.SortOrder.LayoutOrder
    layout.Padding           = UDim.new(0, 8)
    layout.VerticalAlignment = Enum.VerticalAlignment.Top
    layout.Parent            = NotifHolder
end

function EclipseLib:Notify(opts)
    opts = opts or {}
    local title    = opts.Title    or "🌒 EclipseLib"
    local content  = opts.Content  or ""
    local duration = opts.Duration or 4
    local ntype    = opts.Type     or "info"

    EnsureNotifHolder()

    local typeColor = {
        info    = Color3.fromRGB(100, 60, 200),
        success = Color3.fromRGB(60, 180, 100),
        error   = Color3.fromRGB(200, 60, 60),
        warn    = Color3.fromRGB(200, 160, 40),
    }
    local accent = typeColor[ntype] or typeColor.info

    local card = Instance.new("Frame")
    card.BackgroundColor3 = Theme.Notif_BG
    card.Size             = UDim2.new(1, 0, 0, 70)
    card.ClipsDescendants = true
    card.Parent           = NotifHolder
    CreateCorner(card, 10)
    CreateStroke(card, accent, 1.5)

    local bar = Instance.new("Frame")
    bar.BackgroundColor3 = accent
    bar.Size             = UDim2.new(0, 4, 1, 0)
    bar.BorderSizePixel  = 0
    bar.Parent           = card
    CreateCorner(bar, 4)

    local titleLbl = Instance.new("TextLabel")
    titleLbl.BackgroundTransparency = 1
    titleLbl.Position       = UDim2.new(0, 12, 0, 8)
    titleLbl.Size           = UDim2.new(1, -16, 0, 20)
    titleLbl.Text           = title
    titleLbl.TextColor3     = Theme.Text
    titleLbl.Font           = Enum.Font.GothamBold
    titleLbl.TextSize       = 13
    titleLbl.TextXAlignment = Enum.TextXAlignment.Left
    titleLbl.Parent         = card

    local contentLbl = Instance.new("TextLabel")
    contentLbl.BackgroundTransparency = 1
    contentLbl.Position       = UDim2.new(0, 12, 0, 30)
    contentLbl.Size           = UDim2.new(1, -16, 0, 32)
    contentLbl.Text           = content
    contentLbl.TextColor3     = Theme.SubText
    contentLbl.Font           = Enum.Font.Gotham
    contentLbl.TextSize       = 11
    contentLbl.TextXAlignment = Enum.TextXAlignment.Left
    contentLbl.TextWrapped    = true
    contentLbl.Parent         = card

    local prog = Instance.new("Frame")
    prog.BackgroundColor3 = accent
    prog.Size             = UDim2.new(1, 0, 0, 2)
    prog.Position         = UDim2.new(0, 0, 1, -2)
    prog.BorderSizePixel  = 0
    prog.Parent           = card

    card.Position = UDim2.new(1, 10, 0, 0)
    Tween(card, {Position = UDim2.new(0, 0, 0, 0)}, 0.3)
    TweenService:Create(prog, TweenInfo.new(duration, Enum.EasingStyle.Linear), {
        Size = UDim2.new(0, 0, 0, 2)
    }):Play()

    task.delay(duration, function()
        Tween(card, {Position = UDim2.new(1, 10, 0, 0)}, 0.3)
        task.wait(0.35)
        card:Destroy()
    end)
end

-- ═══════════════════════════════════════
-- 🔑 KeySystem Screen
-- ═══════════════════════════════════════
local function ShowKeySystem(opts, onSuccess)
    local keyList  = opts.Key            or {}
    local keyTitle = opts.KeyTitle       or "🔑 ใส่ Key"
    local keyDesc  = opts.KeyDescription or "กรอก Key เพื่อใช้งาน"
    local keyLink  = opts.KeyLink        or ""

    local sg = MakeScreenGui("__EclipseKey", 10001)

    -- bg overlay
    local bgOverlay = Instance.new("Frame")
    bgOverlay.BackgroundColor3       = Color3.fromRGB(0, 0, 0)
    bgOverlay.BackgroundTransparency = 1
    bgOverlay.Size   = UDim2.new(1, 0, 1, 0)
    bgOverlay.Parent = sg

    -- card (เริ่มจากตรงกลาง scale เล็ก)
    local card = Instance.new("Frame")
    card.BackgroundColor3 = Theme.Background
    card.Size     = UDim2.new(0, 320, 0, 270)
    card.Position = UDim2.new(0.5, -160, 0.5, -135)
    card.BackgroundTransparency = 1
    card.Parent   = sg
    CreateCorner(card, 14)
    CreateStroke(card, Theme.Accent, 1.5)

    local glowBar = Instance.new("Frame")
    glowBar.BackgroundColor3 = Theme.Accent
    glowBar.Size = UDim2.new(1, 0, 0, 3)
    glowBar.BorderSizePixel = 0
    glowBar.Parent = card

    local iconLbl = Instance.new("TextLabel")
    iconLbl.BackgroundTransparency = 1
    iconLbl.Position  = UDim2.new(0, 0, 0, 16)
    iconLbl.Size      = UDim2.new(1, 0, 0, 36)
    iconLbl.Text      = "🔑"
    iconLbl.TextSize  = 28
    iconLbl.Font      = Enum.Font.GothamBold
    iconLbl.TextTransparency = 1
    iconLbl.Parent    = card

    local titleLbl = Instance.new("TextLabel")
    titleLbl.BackgroundTransparency = 1
    titleLbl.Position        = UDim2.new(0, 0, 0, 54)
    titleLbl.Size            = UDim2.new(1, 0, 0, 24)
    titleLbl.Text            = keyTitle
    titleLbl.TextColor3      = Theme.Text
    titleLbl.TextTransparency = 1
    titleLbl.Font            = Enum.Font.GothamBold
    titleLbl.TextSize        = 16
    titleLbl.Parent          = card

    local descLbl = Instance.new("TextLabel")
    descLbl.BackgroundTransparency = 1
    descLbl.Position        = UDim2.new(0, 16, 0, 80)
    descLbl.Size            = UDim2.new(1, -32, 0, 30)
    descLbl.Text            = keyDesc
    descLbl.TextColor3      = Theme.SubText
    descLbl.TextTransparency = 1
    descLbl.Font            = Enum.Font.Gotham
    descLbl.TextSize        = 12
    descLbl.TextWrapped     = true
    descLbl.Parent          = card

    local inputBG = Instance.new("Frame")
    inputBG.BackgroundColor3 = Theme.Input_BG
    inputBG.BackgroundTransparency = 1
    inputBG.Size     = UDim2.new(1, -32, 0, 36)
    inputBG.Position = UDim2.new(0, 16, 0, 118)
    inputBG.Parent   = card
    CreateCorner(inputBG, 8)
    CreateStroke(inputBG, Theme.Border)

    local inputBox = Instance.new("TextBox")
    inputBox.BackgroundTransparency = 1
    inputBox.Size               = UDim2.new(1, -12, 1, 0)
    inputBox.Position           = UDim2.new(0, 8, 0, 0)
    inputBox.PlaceholderText    = "🔐 กรอก Key ที่นี่..."
    inputBox.PlaceholderColor3  = Theme.SubText
    inputBox.TextColor3         = Theme.Text
    inputBox.TextTransparency   = 1
    inputBox.Font               = Enum.Font.Gotham
    inputBox.TextSize           = 13
    inputBox.ClearTextOnFocus   = false
    inputBox.Text               = ""
    inputBox.Parent             = inputBG

    local statusLbl = Instance.new("TextLabel")
    statusLbl.BackgroundTransparency = 1
    statusLbl.Position   = UDim2.new(0, 16, 0, 160)
    statusLbl.Size       = UDim2.new(1, -32, 0, 16)
    statusLbl.Text       = ""
    statusLbl.TextColor3 = Color3.fromRGB(200, 60, 60)
    statusLbl.Font       = Enum.Font.Gotham
    statusLbl.TextSize   = 11
    statusLbl.Parent     = card

    local getLinkBtn = Instance.new("TextButton")
    getLinkBtn.BackgroundColor3 = Theme.Secondary
    getLinkBtn.BackgroundTransparency = 1
    getLinkBtn.Size     = UDim2.new(0, 120, 0, 34)
    getLinkBtn.Position = UDim2.new(0, 16, 0, 184)
    getLinkBtn.Text     = "🔗 Get Key"
    getLinkBtn.TextColor3 = Theme.Accent
    getLinkBtn.TextTransparency = 1
    getLinkBtn.Font     = Enum.Font.GothamBold
    getLinkBtn.TextSize = 12
    getLinkBtn.Parent   = card
    CreateCorner(getLinkBtn, 8)
    CreateStroke(getLinkBtn, Theme.Accent, 1)

    local submitBtn = Instance.new("TextButton")
    submitBtn.BackgroundColor3 = Theme.Accent
    submitBtn.BackgroundTransparency = 1
    submitBtn.Size     = UDim2.new(0, 130, 0, 34)
    submitBtn.Position = UDim2.new(1, -146, 0, 184)
    submitBtn.Text     = "✅ ยืนยัน Key"
    submitBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    submitBtn.TextTransparency = 1
    submitBtn.Font     = Enum.Font.GothamBold
    submitBtn.TextSize = 12
    submitBtn.Parent   = card
    CreateCorner(submitBtn, 8)

    -- ── Animate Key screen in ──
    local function AnimateKeyIn()
        Tween(bgOverlay, {BackgroundTransparency = 0.5}, 0.3)
        Tween(card, {BackgroundTransparency = 0}, 0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        task.wait(0.15)
        local fadeList = {iconLbl, titleLbl, descLbl, getLinkBtn, submitBtn}
        for _, obj in ipairs(fadeList) do
            Tween(obj, {TextTransparency = 0}, 0.3)
            pcall(function() Tween(obj, {BackgroundTransparency = 0}, 0.3) end)
            task.wait(0.05)
        end
        Tween(inputBG,  {BackgroundTransparency = 0}, 0.3)
        Tween(inputBox, {TextTransparency = 0}, 0.3)
    end

    task.spawn(AnimateKeyIn)

    getLinkBtn.MouseButton1Click:Connect(function()
        SetClipboard(keyLink)
        local old = getLinkBtn.Text
        getLinkBtn.Text = "✅ คัดลอกแล้ว!"
        Tween(getLinkBtn, {BackgroundColor3 = Color3.fromRGB(30, 80, 40)}, 0.2)
        task.wait(2)
        getLinkBtn.Text = old
        Tween(getLinkBtn, {BackgroundColor3 = Theme.Secondary}, 0.2)
    end)

    submitBtn.MouseButton1Click:Connect(function()
        local entered = inputBox.Text
        local valid   = false
        for _, k in ipairs(keyList) do
            if k == entered then valid = true break end
        end
        if valid then
            -- 🌩️ Key ถูก → หายพริบตา flash แล้วไป UI หลัก
            for i = 1, 3 do
                Tween(bgOverlay, {BackgroundTransparency = i % 2 == 0 and 0.5 or 0.1}, 0.06)
                task.wait(0.06)
            end
            Tween(card,      {BackgroundTransparency = 1, Size = UDim2.new(0, 320, 0, 0)}, 0.25)
            Tween(bgOverlay, {BackgroundTransparency = 1}, 0.3)
            task.wait(0.35)
            sg:Destroy()
            onSuccess()
        else
            statusLbl.Text = "❌ Key ไม่ถูกต้อง ลองใหม่!"
            Tween(inputBG, {BackgroundColor3 = Color3.fromRGB(60, 20, 20)}, 0.12)
            -- shake
            local origPos = inputBG.Position
            for i = 1, 4 do
                Tween(inputBG, {Position = UDim2.new(
                    origPos.X.Scale,
                    origPos.X.Offset + (i % 2 == 0 and 6 or -6),
                    origPos.Y.Scale,
                    origPos.Y.Offset
                )}, 0.05)
                task.wait(0.05)
            end
            Tween(inputBG, {Position = origPos, BackgroundColor3 = Theme.Input_BG}, 0.1)
        end
    end)
end

-- ═══════════════════════════════════════
-- 🪟 Create Window
-- ═══════════════════════════════════════
function EclipseLib:CreateWindow(opts)
    opts = opts or {}
    local windowName = opts.Name            or "EclipseLib"
    local loadTitle  = opts.LoadingTitle    or "🌒 EclipseLib"
    local loadSub    = opts.LoadingSubtitle or "กำลังโหลด..."
    local useKey     = opts.KeySystem       or false
    local keyOpts    = {
        Key            = opts.Key            or {},
        KeyTitle       = opts.KeyTitle       or "🔑 ใส่ Key",
        KeyDescription = opts.KeyDescription or "กรอก Key เพื่อใช้งาน",
        KeyLink        = opts.KeyLink        or "",
    }

    -- ScreenGui (Main)
    local ScreenGui = MakeScreenGui("__EclipseLib", 999)

    -- Main Frame (ซ่อนก่อน)
    local Main = Instance.new("Frame")
    Main.BackgroundColor3 = Theme.Background
    Main.Size     = UDim2.new(0, 500, 0, 350)
    Main.Position = UDim2.new(0.5, -250, 0.5, -175)
    Main.ClipsDescendants = true
    Main.Visible  = false
    Main.Parent   = ScreenGui
    CreateCorner(Main, 12)
    CreateStroke(Main, Theme.Border, 1.5)

    -- Top Bar
    local TopBar = Instance.new("Frame")
    TopBar.BackgroundColor3 = Theme.Secondary
    TopBar.Size   = UDim2.new(1, 0, 0, 38)
    TopBar.Parent = Main
    CreateCorner(TopBar, 12)

    local tbFix = Instance.new("Frame")
    tbFix.BackgroundColor3 = Theme.Secondary
    tbFix.Size     = UDim2.new(1, 0, 0, 10)
    tbFix.Position = UDim2.new(0, 0, 1, -10)
    tbFix.BorderSizePixel = 0
    tbFix.Parent   = TopBar

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Position       = UDim2.new(0, 12, 0, 0)
    TitleLabel.Size           = UDim2.new(1, -80, 1, 0)
    TitleLabel.Text           = "🌒  " .. windowName
    TitleLabel.TextColor3     = Theme.Text
    TitleLabel.Font           = Enum.Font.GothamBold
    TitleLabel.TextSize       = 14
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent         = TopBar

    local CloseBtn = Instance.new("TextButton")
    CloseBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
    CloseBtn.Size     = UDim2.new(0, 22, 0, 22)
    CloseBtn.Position = UDim2.new(1, -30, 0.5, -11)
    CloseBtn.Text     = "✕"
    CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseBtn.Font     = Enum.Font.GothamBold
    CloseBtn.TextSize = 12
    CloseBtn.Parent   = TopBar
    CreateCorner(CloseBtn, 6)

    local ToggleBtn = Instance.new("TextButton")
    ToggleBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    ToggleBtn.Size     = UDim2.new(0, 22, 0, 22)
    ToggleBtn.Position = UDim2.new(1, -56, 0.5, -11)
    ToggleBtn.Text     = "—"
    ToggleBtn.TextColor3 = Theme.Text
    ToggleBtn.Font     = Enum.Font.GothamBold
    ToggleBtn.TextSize = 12
    ToggleBtn.Parent   = TopBar
    CreateCorner(ToggleBtn, 6)

    MakeDraggable(Main, TopBar)

    -- Body
    local Body = Instance.new("Frame")
    Body.BackgroundTransparency = 1
    Body.Position = UDim2.new(0, 0, 0, 38)
    Body.Size     = UDim2.new(1, 0, 1, -38)
    Body.Parent   = Main

    -- Tab Bar
    local TabBar = Instance.new("ScrollingFrame")
    TabBar.BackgroundColor3   = Theme.Secondary
    TabBar.Size               = UDim2.new(0, 115, 1, 0)
    TabBar.ScrollBarThickness = 2
    TabBar.CanvasSize         = UDim2.new(0, 0, 0, 0)
    TabBar.ScrollingDirection = Enum.ScrollingDirection.Y
    TabBar.Parent             = Body
    CreateStroke(TabBar, Theme.Border, 1)

    local TabLayout = Instance.new("UIListLayout")
    TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabLayout.Padding   = UDim.new(0, 4)
    TabLayout.Parent    = TabBar

    local TabPad = Instance.new("UIPadding")
    TabPad.PaddingTop   = UDim.new(0, 6)
    TabPad.PaddingLeft  = UDim.new(0, 5)
    TabPad.PaddingRight = UDim.new(0, 5)
    TabPad.Parent       = TabBar

    TabLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        TabBar.CanvasSize = UDim2.new(0, 0, 0, TabLayout.AbsoluteContentSize.Y + 12)
    end)

    -- Content Area
    local ContentArea = Instance.new("Frame")
    ContentArea.BackgroundTransparency = 1
    ContentArea.Position = UDim2.new(0, 119, 0, 0)
    ContentArea.Size     = UDim2.new(1, -119, 1, 0)
    ContentArea.Parent   = Body

    -- Toggle/Close
    local isOpen = true
    ToggleBtn.MouseButton1Click:Connect(function()
        isOpen = not isOpen
        Tween(Main, {Size = isOpen
            and UDim2.new(0, 500, 0, 350)
            or  UDim2.new(0, 500, 0, 38)
        }, 0.3)
        ToggleBtn.Text = isOpen and "—" or "▲"
    end)

    CloseBtn.MouseButton1Click:Connect(function()
        Tween(Main, {Size = UDim2.new(0, 500, 0, 0)}, 0.25)
        task.wait(0.3)
        ScreenGui:Destroy()
    end)

    -- ── ฟังก์ชัน Open Main UI ──
    local function OpenMainUI()
        Main.Visible = true
        Main.Size    = UDim2.new(0, 500, 0, 0)
        Main.BackgroundTransparency = 0
        Tween(Main, {Size = UDim2.new(0, 500, 0, 350)}, 0.45, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        task.wait(0.5)
        EclipseLib:Notify({
            Title   = "🌒 " .. windowName,
            Content = "โหลดสำเร็จแล้ว! ✨",
            Duration = 3,
            Type    = "success"
        })
    end

    -- ═══════════════════════════════════════
    -- Window Object
    -- ═══════════════════════════════════════
    local WindowObj  = {}
    local tabButtons = {}
    local tabFrames  = {}
    local activeTab  = nil

    local function SetActiveTab(name)
        for n, btn in pairs(tabButtons) do
            if n == name then
                Tween(btn, {BackgroundColor3 = Theme.TabActive}, 0.2)
                btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            else
                Tween(btn, {BackgroundColor3 = Theme.TabInactive}, 0.2)
                btn.TextColor3 = Theme.SubText
            end
        end
        for n, frame in pairs(tabFrames) do
            frame.Visible = (n == name)
        end
        activeTab = name
    end

    local function MakeScrollFrame(name)
        local sf = Instance.new("ScrollingFrame")
        sf.Name               = name
        sf.BackgroundTransparency = 1
        sf.Size               = UDim2.new(1, 0, 1, 0)
        sf.CanvasSize         = UDim2.new(0, 0, 0, 0)
        sf.ScrollBarThickness = 3
        sf.Visible            = false
        sf.Parent             = ContentArea

        local layout = Instance.new("UIListLayout")
        layout.Padding   = UDim.new(0, 6)
        layout.SortOrder = Enum.SortOrder.LayoutOrder
        layout.Parent    = sf

        local pad = Instance.new("UIPadding")
        pad.PaddingTop   = UDim.new(0, 8)
        pad.PaddingLeft  = UDim.new(0, 8)
        pad.PaddingRight = UDim.new(0, 8)
        pad.Parent       = sf

        layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            sf.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 20)
        end)
        return sf
    end

    local function MakeTabButton(label, isActive)
        local btn = Instance.new("TextButton")
        btn.BackgroundColor3 = isActive and Theme.TabActive or Theme.TabInactive
        btn.Size             = UDim2.new(1, 0, 0, 34)
        btn.Text             = label
        btn.TextColor3       = isActive and Color3.fromRGB(255,255,255) or Theme.SubText
        btn.Font             = Enum.Font.GothamBold
        btn.TextSize         = 11
        btn.TextWrapped      = true
        btn.Parent           = TabBar
        CreateCorner(btn, 8)
        return btn
    end

    -- ═══════════════════════════════════════
    -- 🏠 Welcome Tab (Built-in)
    -- ═══════════════════════════════════════
    do
        local wBtn   = MakeTabButton("🏠 ยินดีต้อนรับ", true)
        local wFrame = MakeScrollFrame("Frame_Welcome")
        wFrame.Visible = true

        tabButtons["_Welcome"] = wBtn
        tabFrames["_Welcome"]  = wFrame
        activeTab = "_Welcome"

        -- Avatar Card
        local avatarCard = Instance.new("Frame")
        avatarCard.BackgroundColor3 = Theme.Secondary
        avatarCard.Size   = UDim2.new(1, 0, 0, 84)
        avatarCard.Parent = wFrame
        CreateCorner(avatarCard, 12)
        CreateStroke(avatarCard, Theme.Border)

        local avatarFrame = Instance.new("Frame")
        avatarFrame.BackgroundColor3 = Theme.Accent
        avatarFrame.Size     = UDim2.new(0, 62, 0, 62)
        avatarFrame.Position = UDim2.new(0, 11, 0.5, -31)
        avatarFrame.Parent   = avatarCard
        CreateCorner(avatarFrame, 31)
        CreateStroke(avatarFrame, Theme.Accent, 2)

        local avatarImg = Instance.new("ImageLabel")
        avatarImg.BackgroundTransparency = 1
        avatarImg.Size     = UDim2.new(1, -4, 1, -4)
        avatarImg.Position = UDim2.new(0, 2, 0, 2)
        avatarImg.Image    = "https://www.roblox.com/headshot-thumbnail/image?userId="
            .. tostring(LocalPlayer.UserId)
            .. "&width=150&height=150&format=png"
        avatarImg.Parent = avatarFrame
        CreateCorner(avatarImg, 29)

        local dispName = Instance.new("TextLabel")
        dispName.BackgroundTransparency = 1
        dispName.Position       = UDim2.new(0, 86, 0, 14)
        dispName.Size           = UDim2.new(1, -96, 0, 22)
        dispName.Text           = LocalPlayer.DisplayName or "?"
        dispName.TextColor3     = Theme.Text
        dispName.Font           = Enum.Font.GothamBold
        dispName.TextSize       = 16
        dispName.TextXAlignment = Enum.TextXAlignment.Left
        dispName.Parent         = avatarCard

        local userNameLbl = Instance.new("TextLabel")
        userNameLbl.BackgroundTransparency = 1
        userNameLbl.Position       = UDim2.new(0, 86, 0, 38)
        userNameLbl.Size           = UDim2.new(1, -96, 0, 16)
        userNameLbl.Text           = "@" .. (LocalPlayer.Name or "?")
        userNameLbl.TextColor3     = Theme.SubText
        userNameLbl.Font           = Enum.Font.Gotham
        userNameLbl.TextSize       = 12
        userNameLbl.TextXAlignment = Enum.TextXAlignment.Left
        userNameLbl.Parent         = avatarCard

        local idBadge = Instance.new("Frame")
        idBadge.BackgroundColor3 = Theme.Accent
        idBadge.Size     = UDim2.new(0, 100, 0, 18)
        idBadge.Position = UDim2.new(0, 86, 0, 58)
        idBadge.Parent   = avatarCard
        CreateCorner(idBadge, 6)

        local idLbl = Instance.new("TextLabel")
        idLbl.BackgroundTransparency = 1
        idLbl.Size       = UDim2.new(1, 0, 1, 0)
        idLbl.Text       = "🆔 " .. tostring(LocalPlayer.UserId)
        idLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
        idLbl.Font       = Enum.Font.GothamBold
        idLbl.TextSize   = 10
        idLbl.Parent     = idBadge

        local function MakeInfoCard(icon, labelText, valueFunc)
            local card = Instance.new("Frame")
            card.BackgroundColor3 = Theme.Secondary
            card.Size   = UDim2.new(1, 0, 0, 54)
            card.Parent = wFrame
            CreateCorner(card, 10)
            CreateStroke(card, Theme.Border)

            local iconL = Instance.new("TextLabel")
            iconL.BackgroundTransparency = 1
            iconL.Position  = UDim2.new(0, 8, 0, 0)
            iconL.Size      = UDim2.new(0, 30, 1, 0)
            iconL.Text      = icon
            iconL.TextSize  = 20
            iconL.Font      = Enum.Font.GothamBold
            iconL.Parent    = card

            local keyL = Instance.new("TextLabel")
            keyL.BackgroundTransparency = 1
            keyL.Position       = UDim2.new(0, 44, 0, 7)
            keyL.Size           = UDim2.new(1, -50, 0, 16)
            keyL.Text           = labelText
            keyL.TextColor3     = Theme.SubText
            keyL.TextSize       = 10
            keyL.Font           = Enum.Font.Gotham
            keyL.TextXAlignment = Enum.TextXAlignment.Left
            keyL.Parent         = card

            local valL = Instance.new("TextLabel")
            valL.BackgroundTransparency = 1
            valL.Position       = UDim2.new(0, 44, 0, 24)
            valL.Size           = UDim2.new(1, -50, 0, 22)
            valL.Text           = tostring(valueFunc())
            valL.TextColor3     = Theme.Text
            valL.TextSize       = 13
            valL.Font           = Enum.Font.GothamBold
            valL.TextXAlignment = Enum.TextXAlignment.Left
            valL.Parent         = card

            RunService.Heartbeat:Connect(function()
                local v = tostring(valueFunc())
                if valL.Text ~= v then valL.Text = v end
            end)
        end

        MakeInfoCard("🗺️", "ชื่อแมพ", function() return tostring(game.Name) end)
        MakeInfoCard("📍", "Place ID", function() return tostring(game.PlaceId) end)

        wBtn.MouseButton1Click:Connect(function() SetActiveTab("_Welcome") end)
    end

    -- ═══════════════════════════════════════
    -- ⚙️ Settings Tab (Built-in)
    -- ═══════════════════════════════════════
    do
        local sBtn   = MakeTabButton("⚙️ ตั้งค่า UI", false)
        local sFrame = MakeScrollFrame("Frame_Settings")
        tabButtons["_Settings"] = sBtn
        tabFrames["_Settings"]  = sFrame
        sBtn.MouseButton1Click:Connect(function() SetActiveTab("_Settings") end)

        local function SectionTitle(text)
            local lbl = Instance.new("TextLabel")
            lbl.BackgroundTransparency = 1
            lbl.Size           = UDim2.new(1, 0, 0, 22)
            lbl.Text           = text
            lbl.TextColor3     = Theme.Accent
            lbl.Font           = Enum.Font.GothamBold
            lbl.TextSize       = 12
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.Parent         = sFrame
        end

        SectionTitle("🎨 สี Accent")
        local colorPresets = {
            {"🟣 Purple", Color3.fromRGB(100,60,200)},{"🔵 Blue",Color3.fromRGB(50,120,220)},
            {"🟢 Green",Color3.fromRGB(50,180,100)},{"🔴 Red",Color3.fromRGB(200,60,60)},
            {"🟠 Orange",Color3.fromRGB(220,120,40)},{"🩷 Pink",Color3.fromRGB(220,80,160)},
        }
        local colorRow = Instance.new("Frame")
        colorRow.BackgroundColor3 = Theme.Secondary
        colorRow.Size   = UDim2.new(1, 0, 0, 48)
        colorRow.Parent = sFrame
        CreateCorner(colorRow, 8); CreateStroke(colorRow, Theme.Border)
        local cl = Instance.new("UIListLayout")
        cl.FillDirection=Enum.FillDirection.Horizontal; cl.Padding=UDim.new(0,6)
        cl.VerticalAlignment=Enum.VerticalAlignment.Center; cl.HorizontalAlignment=Enum.HorizontalAlignment.Center
        cl.Parent=colorRow
        for _,p in ipairs(colorPresets) do
            local dot = Instance.new("TextButton")
            dot.BackgroundColor3=p[2]; dot.Size=UDim2.new(0,28,0,28); dot.Text=""
            dot.Parent=colorRow; CreateCorner(dot,14)
            dot.MouseButton1Click:Connect(function()
                Theme.Accent=p[2]; Theme.TabActive=p[2]; Theme.Toggle_ON=p[2]
                Theme.Slider_Fill=p[2]; Theme.Notif_Border=p[2]
                for n,btn in pairs(tabButtons) do
                    if n==activeTab then Tween(btn,{BackgroundColor3=p[2]},0.2) end
                end
                EclipseLib:Notify({Title="🎨 เปลี่ยนสีแล้ว",Content="เปลี่ยนเป็น "..p[1],Duration=2,Type="success"})
            end)
        end

        SectionTitle("📏 ขนาด UI")
        local sizePresets={{"เล็ก",UDim2.new(0,420,0,300)},{"กลาง",UDim2.new(0,500,0,350)},{"ใหญ่",UDim2.new(0,600,0,420)}}
        local sizeRow = Instance.new("Frame")
        sizeRow.BackgroundColor3=Theme.Secondary; sizeRow.Size=UDim2.new(1,0,0,48); sizeRow.Parent=sFrame
        CreateCorner(sizeRow,8); CreateStroke(sizeRow,Theme.Border)
        local sl=Instance.new("UIListLayout"); sl.FillDirection=Enum.FillDirection.Horizontal; sl.Padding=UDim.new(0,6)
        sl.VerticalAlignment=Enum.VerticalAlignment.Center; sl.HorizontalAlignment=Enum.HorizontalAlignment.Center; sl.Parent=sizeRow
        for _,sz in ipairs(sizePresets) do
            local b=Instance.new("TextButton"); b.BackgroundColor3=Theme.TabInactive; b.Size=UDim2.new(0,80,0,30)
            b.Text=sz[1]; b.TextColor3=Theme.Text; b.Font=Enum.Font.GothamBold; b.TextSize=12; b.Parent=sizeRow
            CreateCorner(b,8)
            b.MouseButton1Click:Connect(function()
                if isOpen then Tween(Main,{Size=sz[2]},0.3)
                    Main.Position=UDim2.new(0.5,-sz[2].X.Offset/2,0.5,-sz[2].Y.Offset/2) end
            end)
        end

        SectionTitle("🔔 ตำแหน่ง Notification")
        local notifPos={{"มุมขวาบน",UDim2.new(1,-220,0,60)},{"มุมซ้ายบน",UDim2.new(0,10,0,60)}}
        local nRow=Instance.new("Frame"); nRow.BackgroundColor3=Theme.Secondary; nRow.Size=UDim2.new(1,0,0,48); nRow.Parent=sFrame
        CreateCorner(nRow,8); CreateStroke(nRow,Theme.Border)
        local nl=Instance.new("UIListLayout"); nl.FillDirection=Enum.FillDirection.Horizontal; nl.Padding=UDim.new(0,6)
        nl.VerticalAlignment=Enum.VerticalAlignment.Center; nl.HorizontalAlignment=Enum.HorizontalAlignment.Center; nl.Parent=nRow
        for _,np in ipairs(notifPos) do
            local b=Instance.new("TextButton"); b.BackgroundColor3=Theme.TabInactive; b.Size=UDim2.new(0,110,0,30)
            b.Text=np[1]; b.TextColor3=Theme.Text; b.Font=Enum.Font.GothamBold; b.TextSize=11; b.Parent=nRow
            CreateCorner(b,8)
            b.MouseButton1Click:Connect(function()
                EnsureNotifHolder(); NotifHolder.Position=np[2]
                EclipseLib:Notify({Title="🔔 เปลี่ยนตำแหน่งแล้ว",Content=np[1],Duration=2,Type="info"})
            end)
        end

        SectionTitle("🌗 ความโปร่งใส UI")
        local tCard=Instance.new("Frame"); tCard.BackgroundColor3=Theme.Secondary; tCard.Size=UDim2.new(1,0,0,60); tCard.Parent=sFrame
        CreateCorner(tCard,8); CreateStroke(tCard,Theme.Border)
        local tNameL=Instance.new("TextLabel"); tNameL.BackgroundTransparency=1; tNameL.Position=UDim2.new(0,10,0,6)
        tNameL.Size=UDim2.new(0.68,0,0,18); tNameL.Text="ความโปร่งใสพื้นหลัง"; tNameL.TextColor3=Theme.Text
        tNameL.Font=Enum.Font.GothamBold; tNameL.TextSize=12; tNameL.TextXAlignment=Enum.TextXAlignment.Left; tNameL.Parent=tCard
        local tValL=Instance.new("TextLabel"); tValL.BackgroundTransparency=1; tValL.Position=UDim2.new(0.7,0,0,6)
        tValL.Size=UDim2.new(0.28,0,0,18); tValL.Text="0%"; tValL.TextColor3=Theme.Accent
        tValL.Font=Enum.Font.GothamBold; tValL.TextSize=13; tValL.TextXAlignment=Enum.TextXAlignment.Right; tValL.Parent=tCard
        local tTrack=Instance.new("Frame"); tTrack.BackgroundColor3=Theme.Slider_BG; tTrack.Size=UDim2.new(1,-20,0,8)
        tTrack.Position=UDim2.new(0,10,0,36); tTrack.Parent=tCard; CreateCorner(tTrack,4)
        local tFill=Instance.new("Frame"); tFill.BackgroundColor3=Theme.Slider_Fill; tFill.Size=UDim2.new(0,0,1,0); tFill.Parent=tTrack; CreateCorner(tFill,4)
        local dragT=false
        tTrack.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then dragT=true end end)
        UserInputService.InputChanged:Connect(function(i)
            if dragT and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then
                local r=math.clamp((i.Position.X-tTrack.AbsolutePosition.X)/tTrack.AbsoluteSize.X,0,1)
                tFill.Size=UDim2.new(r,0,1,0); tValL.Text=math.floor(r*80).."%"
                Tween(Main,{BackgroundTransparency=r*0.8},0.05)
            end
        end)
        UserInputService.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then dragT=false end end)
    end

    -- ═══════════════════════════════════════
    -- ➕ CreateTab
    -- ═══════════════════════════════════════
    function WindowObj:CreateTab(nameOrOpts, _icon)
        local tabName, tabIcon
        if type(nameOrOpts) == "string" then
            tabName = nameOrOpts; tabIcon = _icon or ""
        else
            tabName = nameOrOpts.Name or "Tab"; tabIcon = nameOrOpts.Icon or ""
        end
        local label    = (tabIcon ~= "") and (tabIcon .. " " .. tabName) or tabName
        local tabBtn   = MakeTabButton(label, false)
        local tabFrame = MakeScrollFrame("Frame_" .. tabName)
        tabButtons[tabName] = tabBtn; tabFrames[tabName] = tabFrame
        tabBtn.MouseButton1Click:Connect(function() SetActiveTab(tabName) end)

        local TabAPI = {}
        local function BaseCard(h)
            local c=Instance.new("Frame"); c.BackgroundColor3=Theme.Secondary; c.Size=UDim2.new(1,0,0,h); c.Parent=tabFrame
            CreateCorner(c,8); CreateStroke(c,Theme.Border); return c
        end

        function TabAPI:AddLabel(o)
            o=o or {}
            local lbl=Instance.new("TextLabel"); lbl.BackgroundTransparency=1; lbl.Size=UDim2.new(1,0,0,24)
            lbl.Text=o.Text or ""; lbl.TextColor3=Theme.SubText; lbl.Font=Enum.Font.Gotham; lbl.TextSize=12
            lbl.TextXAlignment=Enum.TextXAlignment.Left; lbl.TextWrapped=true; lbl.Parent=tabFrame
            local A={}; function A:SetText(t) lbl.Text=t end; return A
        end

        function TabAPI:AddButton(o)
            o=o or {}; local card=BaseCard(50)
            local nL=Instance.new("TextLabel"); nL.BackgroundTransparency=1; nL.Position=UDim2.new(0,10,0,6)
            nL.Size=UDim2.new(0.6,0,0,18); nL.Text=o.Name or "Button"; nL.TextColor3=Theme.Text
            nL.Font=Enum.Font.GothamBold; nL.TextSize=13; nL.TextXAlignment=Enum.TextXAlignment.Left; nL.Parent=card
            local dL=Instance.new("TextLabel"); dL.BackgroundTransparency=1; dL.Position=UDim2.new(0,10,0,26)
            dL.Size=UDim2.new(0.6,0,0,16); dL.Text=o.Description or ""; dL.TextColor3=Theme.SubText
            dL.Font=Enum.Font.Gotham; dL.TextSize=10; dL.TextXAlignment=Enum.TextXAlignment.Left; dL.Parent=card
            if o.RealtimeValue then
                local rL=Instance.new("TextLabel"); rL.BackgroundTransparency=1; rL.Position=UDim2.new(0.58,0,0,6)
                rL.Size=UDim2.new(0.24,0,0,18); rL.Text=tostring(o.RealtimeValue()); rL.TextColor3=Theme.Accent
                rL.Font=Enum.Font.GothamBold; rL.TextSize=11; rL.TextXAlignment=Enum.TextXAlignment.Right; rL.Parent=card
                RunService.Heartbeat:Connect(function() local v=tostring(o.RealtimeValue()); if rL.Text~=v then rL.Text=v end end)
            end
            local btn=Instance.new("TextButton"); btn.BackgroundColor3=Theme.Accent; btn.Size=UDim2.new(0,52,0,26)
            btn.Position=UDim2.new(1,-62,0.5,-13); btn.Text="▶ RUN"; btn.TextColor3=Color3.fromRGB(255,255,255)
            btn.Font=Enum.Font.GothamBold; btn.TextSize=10; btn.Parent=card; CreateCorner(btn,6)
            btn.MouseButton1Click:Connect(function()
                Tween(btn,{BackgroundColor3=Theme.AccentHover},0.1); task.wait(0.1)
                Tween(btn,{BackgroundColor3=Theme.Accent},0.1)
                if o.Callback then o.Callback() end
            end)
        end

        function TabAPI:AddToggle(o)
            o=o or {}; local state=o.Default or false; local card=BaseCard(50)
            local nL=Instance.new("TextLabel"); nL.BackgroundTransparency=1; nL.Position=UDim2.new(0,10,0,6)
            nL.Size=UDim2.new(0.7,0,0,18); nL.Text=o.Name or "Toggle"; nL.TextColor3=Theme.Text
            nL.Font=Enum.Font.GothamBold; nL.TextSize=13; nL.TextXAlignment=Enum.TextXAlignment.Left; nL.Parent=card
            local dL=Instance.new("TextLabel"); dL.BackgroundTransparency=1; dL.Position=UDim2.new(0,10,0,26)
            dL.Size=UDim2.new(0.7,0,0,16); dL.Text=o.Description or ""; dL.TextColor3=Theme.SubText
            dL.Font=Enum.Font.Gotham; dL.TextSize=10; dL.TextXAlignment=Enum.TextXAlignment.Left; dL.Parent=card
            local sw=Instance.new("Frame"); sw.BackgroundColor3=state and Theme.Toggle_ON or Theme.Toggle_OFF
            sw.Size=UDim2.new(0,44,0,24); sw.Position=UDim2.new(1,-54,0.5,-12); sw.Parent=card; CreateCorner(sw,12)
            local kn=Instance.new("Frame"); kn.BackgroundColor3=Color3.fromRGB(255,255,255); kn.Size=UDim2.new(0,18,0,18)
            kn.Position=state and UDim2.new(1,-21,0.5,-9) or UDim2.new(0,3,0.5,-9); kn.Parent=sw; CreateCorner(kn,9)
            local ca=Instance.new("TextButton"); ca.BackgroundTransparency=1; ca.Size=UDim2.new(1,0,1,0); ca.Text=""; ca.Parent=card
            ca.MouseButton1Click:Connect(function()
                state=not state
                Tween(sw,{BackgroundColor3=state and Theme.Toggle_ON or Theme.Toggle_OFF},0.2)
                Tween(kn,{Position=state and UDim2.new(1,-21,0.5,-9) or UDim2.new(0,3,0.5,-9)},0.2)
                if o.Callback then o.Callback(state) end
            end)
            local A={}
            function A:SetState(s) state=s; Tween(sw,{BackgroundColor3=state and Theme.Toggle_ON or Theme.Toggle_OFF},0.2)
                Tween(kn,{Position=state and UDim2.new(1,-21,0.5,-9) or UDim2.new(0,3,0.5,-9)},0.2)
                if o.Callback then o.Callback(state) end end
            function A:GetState() return state end; return A
        end

        function TabAPI:AddSlider(o)
            o=o or {}; local mn=o.Min or 0; local mx=o.Max or 100
            local val=math.clamp(o.Default or mn,mn,mx); local card=BaseCard(60)
            local nL=Instance.new("TextLabel"); nL.BackgroundTransparency=1; nL.Position=UDim2.new(0,10,0,6)
            nL.Size=UDim2.new(0.7,0,0,18); nL.Text=o.Name or "Slider"; nL.TextColor3=Theme.Text
            nL.Font=Enum.Font.GothamBold; nL.TextSize=13; nL.TextXAlignment=Enum.TextXAlignment.Left; nL.Parent=card
            local vL=Instance.new("TextLabel"); vL.BackgroundTransparency=1; vL.Position=UDim2.new(0.7,0,0,6)
            vL.Size=UDim2.new(0.28,0,0,18); vL.Text=tostring(val); vL.TextColor3=Theme.Accent
            vL.Font=Enum.Font.GothamBold; vL.TextSize=13; vL.TextXAlignment=Enum.TextXAlignment.Right; vL.Parent=card
            local tr=Instance.new("Frame"); tr.BackgroundColor3=Theme.Slider_BG; tr.Size=UDim2.new(1,-20,0,8)
            tr.Position=UDim2.new(0,10,0,36); tr.Parent=card; CreateCorner(tr,4)
            local fi=Instance.new("Frame"); fi.BackgroundColor3=Theme.Slider_Fill
            fi.Size=UDim2.new((val-mn)/(mx-mn),0,1,0); fi.Parent=tr; CreateCorner(fi,4)
            local drag=false
            local function upd(pos)
                local r=math.clamp((pos.X-tr.AbsolutePosition.X)/tr.AbsoluteSize.X,0,1)
                val=math.floor(mn+(mx-mn)*r); vL.Text=tostring(val); fi.Size=UDim2.new(r,0,1,0)
                if o.Callback then o.Callback(val) end
            end
            tr.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then drag=true; upd(i.Position) end end)
            UserInputService.InputChanged:Connect(function(i) if drag and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then upd(i.Position) end end)
            UserInputService.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then drag=false end end)
            local A={}; function A:GetValue() return val end
            function A:SetValue(v) val=math.clamp(v,mn,mx); local r=(val-mn)/(mx-mn); fi.Size=UDim2.new(r,0,1,0); vL.Text=tostring(val); if o.Callback then o.Callback(val) end end
            return A
        end

        function TabAPI:AddDropdown(o)
            o=o or {}; local items=o.Options or {}; local sel=o.Default or (items[1] or ""); local exp=false
            local wr=Instance.new("Frame"); wr.BackgroundTransparency=1; wr.Size=UDim2.new(1,0,0,46); wr.ClipsDescendants=false; wr.Parent=tabFrame
            local card=Instance.new("Frame"); card.BackgroundColor3=Theme.Secondary; card.Size=UDim2.new(1,0,0,46); card.ClipsDescendants=false; card.Parent=wr
            CreateCorner(card,8); CreateStroke(card,Theme.Border)
            local nL=Instance.new("TextLabel"); nL.BackgroundTransparency=1; nL.Position=UDim2.new(0,10,0,6); nL.Size=UDim2.new(0.55,0,0,14)
            nL.Text=o.Name or "Dropdown"; nL.TextColor3=Theme.SubText; nL.Font=Enum.Font.Gotham; nL.TextSize=11; nL.TextXAlignment=Enum.TextXAlignment.Left; nL.Parent=card
            local sL=Instance.new("TextLabel"); sL.BackgroundTransparency=1; sL.Position=UDim2.new(0,10,0,22); sL.Size=UDim2.new(0.65,0,0,18)
            sL.Text=sel; sL.TextColor3=Theme.Text; sL.Font=Enum.Font.GothamBold; sL.TextSize=13; sL.TextXAlignment=Enum.TextXAlignment.Left; sL.Parent=card
            if o.RealtimeValue then
                local rL=Instance.new("TextLabel"); rL.BackgroundTransparency=1; rL.Position=UDim2.new(0.6,0,0,22); rL.Size=UDim2.new(0.2,0,0,18)
                rL.Text=tostring(o.RealtimeValue()); rL.TextColor3=Theme.Accent; rL.Font=Enum.Font.GothamBold; rL.TextSize=11; rL.TextXAlignment=Enum.TextXAlignment.Right; rL.Parent=card
                RunService.Heartbeat:Connect(function() local v=tostring(o.RealtimeValue()); if rL.Text~=v then rL.Text=v end end)
            end
            local ab=Instance.new("TextButton"); ab.BackgroundColor3=Theme.Accent; ab.Size=UDim2.new(0,30,0,30)
            ab.Position=UDim2.new(1,-40,0.5,-15); ab.Text="▼"; ab.TextColor3=Color3.fromRGB(255,255,255)
            ab.Font=Enum.Font.GothamBold; ab.TextSize=12; ab.Parent=card; CreateCorner(ab,6)
            local dl=Instance.new("Frame"); dl.BackgroundColor3=Theme.Dropdown_BG; dl.Size=UDim2.new(1,0,0,#items*30+8)
            dl.Position=UDim2.new(0,0,1,4); dl.Visible=false; dl.ZIndex=10; dl.Parent=card
            CreateCorner(dl,8); CreateStroke(dl,Theme.Border)
            local dly=Instance.new("UIListLayout"); dly.Padding=UDim.new(0,2); dly.SortOrder=Enum.SortOrder.LayoutOrder; dly.Parent=dl
            local dp=Instance.new("UIPadding"); dp.PaddingTop=UDim.new(0,4); dp.PaddingLeft=UDim.new(0,4); dp.PaddingRight=UDim.new(0,4); dp.Parent=dl
            local function Pop()
                for _,c in ipairs(dl:GetChildren()) do if c:IsA("TextButton") then c:Destroy() end end
                for _,item in ipairs(items) do
                    local ib=Instance.new("TextButton"); ib.BackgroundColor3=Theme.Secondary; ib.Size=UDim2.new(1,0,0,26)
                    ib.Text="  "..item; ib.TextColor3=Theme.Text; ib.Font=Enum.Font.Gotham; ib.TextSize=12
                    ib.TextXAlignment=Enum.TextXAlignment.Left; ib.ZIndex=11; ib.Parent=dl; CreateCorner(ib,6)
                    ib.MouseButton1Click:Connect(function() sel=item; sL.Text=item; exp=false; dl.Visible=false; ab.Text="▼"; if o.Callback then o.Callback(item) end end)
                end
                dl.Size=UDim2.new(1,0,0,#items*30+8)
            end
            Pop()
            ab.MouseButton1Click:Connect(function() exp=not exp; dl.Visible=exp; ab.Text=exp and "▲" or "▼" end)
            local A={}; function A:GetValue() return sel end
            function A:SetOptions(n) items=n; Pop() end; return A
        end

        function TabAPI:AddInput(o)
            o=o or {}; local card=BaseCard(60)
            local nL=Instance.new("TextLabel"); nL.BackgroundTransparency=1; nL.Position=UDim2.new(0,10,0,6)
            nL.Size=UDim2.new(1,-20,0,16); nL.Text=o.Name or "Input"; nL.TextColor3=Theme.SubText
            nL.Font=Enum.Font.Gotham; nL.TextSize=11; nL.TextXAlignment=Enum.TextXAlignment.Left; nL.Parent=card
            local iBG=Instance.new("Frame"); iBG.BackgroundColor3=Theme.Input_BG; iBG.Size=UDim2.new(1,-20,0,28)
            iBG.Position=UDim2.new(0,10,0,26); iBG.Parent=card; CreateCorner(iBG,6); CreateStroke(iBG,Theme.Border)
            local box=Instance.new("TextBox"); box.BackgroundTransparency=1; box.Size=UDim2.new(1,-10,1,0)
            box.Position=UDim2.new(0,6,0,0); box.PlaceholderText=o.Placeholder or "พิมพ์ที่นี่..."
            box.PlaceholderColor3=Theme.SubText; box.TextColor3=Theme.Text; box.Font=Enum.Font.Gotham
            box.TextSize=12; box.TextXAlignment=Enum.TextXAlignment.Left; box.ClearTextOnFocus=false; box.Text=""; box.Parent=iBG
            box.FocusLost:Connect(function(enter) if enter and o.Callback then o.Callback(box.Text) end end)
            local A={}; function A:GetValue() return box.Text end; function A:SetValue(v) box.Text=v end; return A
        end

        return TabAPI
    end

    function WindowObj:Notify(o) EclipseLib:Notify(o) end

    -- ═══════════════════════════════════════
    -- 🎬 เริ่ม Flow
    -- ═══════════════════════════════════════
    if useKey then
        -- กรณี KeySystem = true
        -- Intro → Key Screen → UI หลัก
        PlayIntro(loadTitle, loadSub, function()
            ShowKeySystem(keyOpts, function()
                OpenMainUI()
            end)
        end)
    else
        -- กรณี KeySystem = false
        -- Intro → UI หลัก
        PlayIntro(loadTitle, loadSub, function()
            OpenMainUI()
        end)
    end

    return WindowObj
end

return EclipseLib
