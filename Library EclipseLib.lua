-- 🌒 EclipseLib
-- Version: 2.0.0

local EclipseLib = {}
EclipseLib.__index = EclipseLib

-- ═══════════════════════════════════════
-- 🎨 Default Theme
-- ═══════════════════════════════════════
local Theme = {
    Background    = Color3.fromRGB(15, 15, 20),
    Secondary     = Color3.fromRGB(22, 22, 30),
    Accent        = Color3.fromRGB(100, 60, 200),
    AccentHover   = Color3.fromRGB(120, 80, 220),
    Text          = Color3.fromRGB(220, 220, 235),
    SubText       = Color3.fromRGB(140, 140, 160),
    Border        = Color3.fromRGB(50, 40, 80),
    TabActive     = Color3.fromRGB(100, 60, 200),
    TabInactive   = Color3.fromRGB(30, 28, 40),
    Toggle_ON     = Color3.fromRGB(100, 60, 200),
    Toggle_OFF    = Color3.fromRGB(50, 45, 65),
    Slider_Fill   = Color3.fromRGB(100, 60, 200),
    Slider_BG     = Color3.fromRGB(35, 32, 50),
    Notif_BG      = Color3.fromRGB(20, 18, 30),
    Notif_Border  = Color3.fromRGB(100, 60, 200),
    Input_BG      = Color3.fromRGB(28, 25, 40),
    Dropdown_BG   = Color3.fromRGB(25, 22, 38),
}

-- ═══════════════════════════════════════
-- 🛠️ Services
-- ═══════════════════════════════════════
local Players           = game:GetService("Players")
local UserInputService  = game:GetService("UserInputService")
local TweenService      = game:GetService("TweenService")
local RunService        = game:GetService("RunService")
local CoreGui           = game:GetService("CoreGui")
local LocalPlayer       = Players.LocalPlayer

-- ═══════════════════════════════════════
-- 🧰 Utility Functions
-- ═══════════════════════════════════════
local function Tween(obj, props, t)
    TweenService:Create(obj, TweenInfo.new(t or 0.2, Enum.EasingStyle.Quad), props):Play()
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

local function CreatePadding(parent, t, b, l, r)
    local p = Instance.new("UIPadding")
    p.PaddingTop    = UDim.new(0, t or 8)
    p.PaddingBottom = UDim.new(0, b or 8)
    p.PaddingLeft   = UDim.new(0, l or 8)
    p.PaddingRight  = UDim.new(0, r or 8)
    p.Parent = parent
end

local function SetClipboard(text)
    pcall(function()
        if setclipboard then setclipboard(text)
        elseif toclipboard then toclipboard(text)
        elseif Clipboard then Clipboard.set(text) end
    end)
end

-- ═══════════════════════════════════════
-- 🔔 Notification System
-- ═══════════════════════════════════════
local NotifHolder

local function EnsureNotifHolder()
    if NotifHolder and NotifHolder.Parent then return end
    local sg = Instance.new("ScreenGui")
    sg.Name            = "__EclipseNotif"
    sg.ResetOnSpawn    = false
    sg.IgnoreGuiInset  = true
    sg.DisplayOrder    = 9999
    pcall(function() sg.Parent = CoreGui end)
    if not sg.Parent then sg.Parent = LocalPlayer:WaitForChild("PlayerGui") end

    NotifHolder = Instance.new("Frame")
    NotifHolder.BackgroundTransparency = 1
    NotifHolder.Position = UDim2.new(1, -220, 0, 60)
    NotifHolder.Size     = UDim2.new(0, 210, 1, -120)
    NotifHolder.Parent   = sg

    local layout = Instance.new("UIListLayout")
    layout.SortOrder          = Enum.SortOrder.LayoutOrder
    layout.Padding            = UDim.new(0, 8)
    layout.VerticalAlignment  = Enum.VerticalAlignment.Top
    layout.Parent             = NotifHolder
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
    titleLbl.Position        = UDim2.new(0, 12, 0, 8)
    titleLbl.Size            = UDim2.new(1, -16, 0, 20)
    titleLbl.Text            = title
    titleLbl.TextColor3      = Theme.Text
    titleLbl.Font            = Enum.Font.GothamBold
    titleLbl.TextSize        = 13
    titleLbl.TextXAlignment  = Enum.TextXAlignment.Left
    titleLbl.Parent          = card

    local contentLbl = Instance.new("TextLabel")
    contentLbl.BackgroundTransparency = 1
    contentLbl.Position        = UDim2.new(0, 12, 0, 30)
    contentLbl.Size            = UDim2.new(1, -16, 0, 32)
    contentLbl.Text            = content
    contentLbl.TextColor3      = Theme.SubText
    contentLbl.Font            = Enum.Font.Gotham
    contentLbl.TextSize        = 11
    contentLbl.TextXAlignment  = Enum.TextXAlignment.Left
    contentLbl.TextWrapped     = true
    contentLbl.Parent          = card

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
    local keyList   = opts.Key or {}
    local keyTitle  = opts.KeyTitle or "🔑 ใส่ Key"
    local keyDesc   = opts.KeyDescription or "กรอก Key เพื่อใช้งาน"
    local keyLink   = opts.KeyLink or ""  -- ลิ้งที่จะคัดลอกให้

    local sg = Instance.new("ScreenGui")
    sg.Name           = "__EclipseKey"
    sg.ResetOnSpawn   = false
    sg.IgnoreGuiInset = true
    sg.DisplayOrder   = 10000
    pcall(function() sg.Parent = CoreGui end)
    if not sg.Parent then sg.Parent = LocalPlayer:WaitForChild("PlayerGui") end

    -- Blur BG
    local bg = Instance.new("Frame")
    bg.BackgroundColor3   = Color3.fromRGB(0, 0, 0)
    bg.BackgroundTransparency = 0.4
    bg.Size   = UDim2.new(1, 0, 1, 0)
    bg.Parent = sg

    -- Card
    local card = Instance.new("Frame")
    card.BackgroundColor3 = Theme.Background
    card.Size     = UDim2.new(0, 320, 0, 260)
    card.Position = UDim2.new(0.5, -160, 0.5, -130)
    card.Parent   = sg
    CreateCorner(card, 14)
    CreateStroke(card, Theme.Accent, 1.5)

    -- Top glow bar
    local glowBar = Instance.new("Frame")
    glowBar.BackgroundColor3 = Theme.Accent
    glowBar.Size = UDim2.new(1, 0, 0, 3)
    glowBar.BorderSizePixel = 0
    glowBar.Parent = card

    -- Icon
    local iconLbl = Instance.new("TextLabel")
    iconLbl.BackgroundTransparency = 1
    iconLbl.Position  = UDim2.new(0, 0, 0, 16)
    iconLbl.Size      = UDim2.new(1, 0, 0, 36)
    iconLbl.Text      = "🔑"
    iconLbl.TextSize  = 28
    iconLbl.Font      = Enum.Font.GothamBold
    iconLbl.Parent    = card

    local titleLbl = Instance.new("TextLabel")
    titleLbl.BackgroundTransparency = 1
    titleLbl.Position        = UDim2.new(0, 0, 0, 54)
    titleLbl.Size            = UDim2.new(1, 0, 0, 24)
    titleLbl.Text            = keyTitle
    titleLbl.TextColor3      = Theme.Text
    titleLbl.Font            = Enum.Font.GothamBold
    titleLbl.TextSize        = 16
    titleLbl.Parent          = card

    local descLbl = Instance.new("TextLabel")
    descLbl.BackgroundTransparency = 1
    descLbl.Position        = UDim2.new(0, 16, 0, 80)
    descLbl.Size            = UDim2.new(1, -32, 0, 30)
    descLbl.Text            = keyDesc
    descLbl.TextColor3      = Theme.SubText
    descLbl.Font            = Enum.Font.Gotham
    descLbl.TextSize        = 12
    descLbl.TextWrapped     = true
    descLbl.Parent          = card

    -- Input box
    local inputBG = Instance.new("Frame")
    inputBG.BackgroundColor3 = Theme.Input_BG
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
    inputBox.Font               = Enum.Font.Gotham
    inputBox.TextSize           = 13
    inputBox.ClearTextOnFocus   = false
    inputBox.Text               = ""
    inputBox.Parent             = inputBG

    -- Status label
    local statusLbl = Instance.new("TextLabel")
    statusLbl.BackgroundTransparency = 1
    statusLbl.Position  = UDim2.new(0, 16, 0, 158)
    statusLbl.Size      = UDim2.new(1, -32, 0, 16)
    statusLbl.Text      = ""
    statusLbl.TextColor3 = Color3.fromRGB(200, 60, 60)
    statusLbl.Font      = Enum.Font.Gotham
    statusLbl.TextSize  = 11
    statusLbl.Parent    = card

    -- ปุ่ม Get Key (คัดลอกลิ้ง)
    local getLinkBtn = Instance.new("TextButton")
    getLinkBtn.BackgroundColor3 = Theme.Secondary
    getLinkBtn.Size     = UDim2.new(0, 120, 0, 34)
    getLinkBtn.Position = UDim2.new(0, 16, 0, 182)
    getLinkBtn.Text     = "🔗 Get Key"
    getLinkBtn.TextColor3 = Theme.Accent
    getLinkBtn.Font     = Enum.Font.GothamBold
    getLinkBtn.TextSize = 12
    getLinkBtn.Parent   = card
    CreateCorner(getLinkBtn, 8)
    CreateStroke(getLinkBtn, Theme.Accent, 1)

    getLinkBtn.MouseButton1Click:Connect(function()
        SetClipboard(keyLink)
        local old = getLinkBtn.Text
        getLinkBtn.Text = "✅ คัดลอกแล้ว!"
        Tween(getLinkBtn, {BackgroundColor3 = Color3.fromRGB(30, 80, 40)}, 0.2)
        task.wait(2)
        getLinkBtn.Text = old
        Tween(getLinkBtn, {BackgroundColor3 = Theme.Secondary}, 0.2)
    end)

    -- ปุ่ม Submit
    local submitBtn = Instance.new("TextButton")
    submitBtn.BackgroundColor3 = Theme.Accent
    submitBtn.Size     = UDim2.new(0, 130, 0, 34)
    submitBtn.Position = UDim2.new(1, -146, 0, 182)
    submitBtn.Text     = "✅ ยืนยัน Key"
    submitBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    submitBtn.Font     = Enum.Font.GothamBold
    submitBtn.TextSize = 12
    submitBtn.Parent   = card
    CreateCorner(submitBtn, 8)

    submitBtn.MouseButton1Click:Connect(function()
        local entered = inputBox.Text
        local valid   = false
        for _, k in ipairs(keyList) do
            if k == entered then valid = true break end
        end
        if valid then
            Tween(card, {BackgroundTransparency = 1}, 0.3)
            Tween(bg,   {BackgroundTransparency = 1}, 0.3)
            task.wait(0.35)
            sg:Destroy()
            onSuccess()
        else
            statusLbl.Text = "❌ Key ไม่ถูกต้อง ลองใหม่!"
            Tween(inputBG, {BackgroundColor3 = Color3.fromRGB(60, 20, 20)}, 0.15)
            task.wait(0.5)
            Tween(inputBG, {BackgroundColor3 = Theme.Input_BG}, 0.15)
        end
    end)
end

-- ═══════════════════════════════════════
-- 🪟 Create Window
-- ═══════════════════════════════════════
function EclipseLib:CreateWindow(opts)
    opts = opts or {}
    local windowName = opts.Name or "EclipseLib"
    local loadTitle  = opts.LoadingTitle    or "🌒 EclipseLib"
    local loadSub    = opts.LoadingSubtitle or "กำลังโหลด..."
    local useKey     = opts.KeySystem       or false
    local keyOpts    = {
        Key            = opts.Key            or {},
        KeyTitle       = opts.KeyTitle       or "🔑 ใส่ Key",
        KeyDescription = opts.KeyDescription or "กรอก Key เพื่อใช้งาน",
        KeyLink        = opts.KeyLink        or "",
    }

    -- ═══ ScreenGui ═══
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name           = "__EclipseLib"
    ScreenGui.ResetOnSpawn   = false
    ScreenGui.IgnoreGuiInset = true
    ScreenGui.DisplayOrder   = 999
    pcall(function() ScreenGui.Parent = CoreGui end)
    if not ScreenGui.Parent then
        ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    end

    -- ═══ Loading Screen ═══
    local LoadScreen = Instance.new("Frame")
    LoadScreen.BackgroundColor3 = Theme.Background
    LoadScreen.Size   = UDim2.new(1, 0, 1, 0)
    LoadScreen.ZIndex = 100
    LoadScreen.Parent = ScreenGui

    local loadT = Instance.new("TextLabel")
    loadT.BackgroundTransparency = 1
    loadT.Size       = UDim2.new(1, 0, 0, 40)
    loadT.Position   = UDim2.new(0, 0, 0.4, 0)
    loadT.Text       = loadTitle
    loadT.TextColor3 = Theme.Accent
    loadT.Font       = Enum.Font.GothamBold
    loadT.TextSize   = 24
    loadT.Parent     = LoadScreen

    local loadS = Instance.new("TextLabel")
    loadS.BackgroundTransparency = 1
    loadS.Size       = UDim2.new(1, 0, 0, 30)
    loadS.Position   = UDim2.new(0, 0, 0.5, 0)
    loadS.Text       = loadSub
    loadS.TextColor3 = Theme.SubText
    loadS.Font       = Enum.Font.Gotham
    loadS.TextSize   = 14
    loadS.Parent     = LoadScreen

    local lBarBG = Instance.new("Frame")
    lBarBG.BackgroundColor3 = Theme.Slider_BG
    lBarBG.Size     = UDim2.new(0, 200, 0, 4)
    lBarBG.Position = UDim2.new(0.5, -100, 0.58, 0)
    lBarBG.Parent   = LoadScreen
    CreateCorner(lBarBG, 4)

    local lBar = Instance.new("Frame")
    lBar.BackgroundColor3 = Theme.Accent
    lBar.Size   = UDim2.new(0, 0, 1, 0)
    lBar.Parent = lBarBG
    CreateCorner(lBar, 4)
    TweenService:Create(lBar, TweenInfo.new(1.5, Enum.EasingStyle.Quad), {
        Size = UDim2.new(1, 0, 1, 0)
    }):Play()

    task.delay(1.8, function()
        Tween(LoadScreen, {BackgroundTransparency = 1}, 0.4)
        for _, v in ipairs(LoadScreen:GetDescendants()) do
            pcall(function()
                if v:IsA("TextLabel") then Tween(v, {TextTransparency = 1}, 0.4) end
                if v:IsA("Frame")     then Tween(v, {BackgroundTransparency = 1}, 0.4) end
            end)
        end
        task.wait(0.5)
        LoadScreen:Destroy()
    end)

    -- ═══ Main Frame ═══
    local Main = Instance.new("Frame")
    Main.BackgroundColor3 = Theme.Background
    Main.Size     = UDim2.new(0, 500, 0, 350)
    Main.Position = UDim2.new(0.5, -250, 0.5, -175)
    Main.ClipsDescendants = true
    Main.Parent   = ScreenGui
    CreateCorner(Main, 12)
    CreateStroke(Main, Theme.Border, 1.5)

    -- ═══ Top Bar ═══
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

    -- ปุ่ม X
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

    -- ปุ่ม Toggle (minimize)
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

    -- ═══ Body ═══
    local Body = Instance.new("Frame")
    Body.BackgroundTransparency = 1
    Body.Position = UDim2.new(0, 0, 0, 38)
    Body.Size     = UDim2.new(1, 0, 1, -38)
    Body.Parent   = Main

    -- ═══ Tab Bar ═══
    local TabBar = Instance.new("ScrollingFrame")
    TabBar.BackgroundColor3    = Theme.Secondary
    TabBar.Size                = UDim2.new(0, 115, 1, 0)
    TabBar.ScrollBarThickness  = 2
    TabBar.CanvasSize          = UDim2.new(0, 0, 0, 0)
    TabBar.ScrollingDirection  = Enum.ScrollingDirection.Y
    TabBar.Parent              = Body
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

    -- ═══ Content Area ═══
    local ContentArea = Instance.new("Frame")
    ContentArea.BackgroundTransparency = 1
    ContentArea.Position = UDim2.new(0, 119, 0, 0)
    ContentArea.Size     = UDim2.new(1, -119, 1, 0)
    ContentArea.Parent   = Body

    -- ═══ Toggle Logic ═══
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

    -- ─────────────────────────────────────
    -- Helper: สร้าง ScrollFrame + Layout
    -- ─────────────────────────────────────
    local function MakeScrollFrame(name)
        local sf = Instance.new("ScrollingFrame")
        sf.Name                = name
        sf.BackgroundTransparency = 1
        sf.Size                = UDim2.new(1, 0, 1, 0)
        sf.CanvasSize          = UDim2.new(0, 0, 0, 0)
        sf.ScrollBarThickness  = 3
        sf.Visible             = false
        sf.Parent              = ContentArea

        local layout = Instance.new("UIListLayout")
        layout.Padding     = UDim.new(0, 6)
        layout.SortOrder   = Enum.SortOrder.LayoutOrder
        layout.Parent      = sf

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

    -- Helper: สร้างปุ่ม Tab
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
    -- 🏠 Tab: ยินดีต้อนรับ (Built-in)
    -- ═══════════════════════════════════════
    do
        local wBtn   = MakeTabButton("🏠 ยินดีต้อนรับ", true)
        local wFrame = MakeScrollFrame("Frame_Welcome")
        wFrame.Visible = true

        tabButtons["_Welcome"] = wBtn
        tabFrames["_Welcome"]  = wFrame
        activeTab = "_Welcome"

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

        MakeInfoCard("👤", "Display Name  ·  Username", function()
            return (LocalPlayer.DisplayName or "?") .. "  ·  @" .. (LocalPlayer.Name or "?")
        end)
        MakeInfoCard("🆔", "User ID", function()
            return tostring(LocalPlayer.UserId)
        end)
        MakeInfoCard("🗺️", "ชื่อแมพ", function()
            return tostring(game.Name)
        end)
        MakeInfoCard("📍", "Place ID", function()
            return tostring(game.PlaceId)
        end)

        wBtn.MouseButton1Click:Connect(function()
            SetActiveTab("_Welcome")
        end)
    end

    -- ═══════════════════════════════════════
    -- ⚙️ Tab: ตั้งค่า UI (Built-in)
    -- ═══════════════════════════════════════
    do
        local sBtn   = MakeTabButton("⚙️ ตั้งค่า UI", false)
        local sFrame = MakeScrollFrame("Frame_Settings")

        tabButtons["_Settings"] = sBtn
        tabFrames["_Settings"]  = sFrame

        sBtn.MouseButton1Click:Connect(function()
            SetActiveTab("_Settings")
        end)

        -- Section title helper
        local function SectionTitle(text)
            local lbl = Instance.new("TextLabel")
            lbl.BackgroundTransparency = 1
            lbl.Size        = UDim2.new(1, 0, 0, 22)
            lbl.Text        = text
            lbl.TextColor3  = Theme.Accent
            lbl.Font        = Enum.Font.GothamBold
            lbl.TextSize    = 12
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.Parent      = sFrame
        end

        -- ── 🎨 Accent Color Presets ──
        SectionTitle("🎨 สี Accent")

        local colorPresets = {
            {"🟣 Purple",  Color3.fromRGB(100, 60, 200)},
            {"🔵 Blue",    Color3.fromRGB(50, 120, 220)},
            {"🟢 Green",   Color3.fromRGB(50, 180, 100)},
            {"🔴 Red",     Color3.fromRGB(200, 60, 60)},
            {"🟠 Orange",  Color3.fromRGB(220, 120, 40)},
            {"🩷 Pink",    Color3.fromRGB(220, 80, 160)},
        }

        local colorRow = Instance.new("Frame")
        colorRow.BackgroundColor3 = Theme.Secondary
        colorRow.Size   = UDim2.new(1, 0, 0, 48)
        colorRow.Parent = sFrame
        CreateCorner(colorRow, 8)
        CreateStroke(colorRow, Theme.Border)

        local colorLayout = Instance.new("UIListLayout")
        colorLayout.FillDirection  = Enum.FillDirection.Horizontal
        colorLayout.Padding        = UDim.new(0, 6)
        colorLayout.VerticalAlignment = Enum.VerticalAlignment.Center
        colorLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        colorLayout.Parent         = colorRow

        for _, preset in ipairs(colorPresets) do
            local name  = preset[1]
            local color = preset[2]
            local dot = Instance.new("TextButton")
            dot.BackgroundColor3 = color
            dot.Size    = UDim2.new(0, 28, 0, 28)
            dot.Text    = ""
            dot.Parent  = colorRow
            CreateCorner(dot, 14)
            dot.MouseButton1Click:Connect(function()
                Theme.Accent      = color
                Theme.TabActive   = color
                Theme.Toggle_ON   = color
                Theme.Slider_Fill = color
                Theme.Notif_Border = color
                -- update active tab button
                for n, btn in pairs(tabButtons) do
                    if n == activeTab then
                        Tween(btn, {BackgroundColor3 = color}, 0.2)
                    end
                end
                EclipseLib:Notify({
                    Title   = "🎨 เปลี่ยนสีแล้ว",
                    Content = "เปลี่ยนเป็น " .. name,
                    Duration = 2,
                    Type    = "success"
                })
            end)
        end

        -- ── 📏 ขนาด UI ──
        SectionTitle("📏 ขนาด UI")

        local sizePresets = {
            {"เล็ก",   UDim2.new(0, 420, 0, 300)},
            {"กลาง",   UDim2.new(0, 500, 0, 350)},
            {"ใหญ่",   UDim2.new(0, 600, 0, 420)},
        }

        local sizeRow = Instance.new("Frame")
        sizeRow.BackgroundColor3 = Theme.Secondary
        sizeRow.Size   = UDim2.new(1, 0, 0, 48)
        sizeRow.Parent = sFrame
        CreateCorner(sizeRow, 8)
        CreateStroke(sizeRow, Theme.Border)

        local sizeLayout = Instance.new("UIListLayout")
        sizeLayout.FillDirection = Enum.FillDirection.Horizontal
        sizeLayout.Padding       = UDim.new(0, 6)
        sizeLayout.VerticalAlignment   = Enum.VerticalAlignment.Center
        sizeLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        sizeLayout.Parent = sizeRow

        for _, sz in ipairs(sizePresets) do
            local label = sz[1]
            local size  = sz[2]
            local btn2 = Instance.new("TextButton")
            btn2.BackgroundColor3 = Theme.TabInactive
            btn2.Size     = UDim2.new(0, 80, 0, 30)
            btn2.Text     = label
            btn2.TextColor3 = Theme.Text
            btn2.Font     = Enum.Font.GothamBold
            btn2.TextSize = 12
            btn2.Parent   = sizeRow
            CreateCorner(btn2, 8)
            btn2.MouseButton1Click:Connect(function()
                if isOpen then
                    local newSize = UDim2.new(size.X.Scale, size.X.Offset, size.Y.Scale, size.Y.Offset)
                    Tween(Main, {Size = newSize}, 0.3)
                    Main.Position = UDim2.new(
                        0.5, -size.X.Offset/2,
                        0.5, -size.Y.Offset/2
                    )
                end
            end)
        end

        -- ── 🔔 ตำแหน่ง Notification ──
        SectionTitle("🔔 ตำแหน่ง Notification")

        local notifPositions = {
            {"มุมขวาบน",  UDim2.new(1, -220, 0, 60)},
            {"มุมซ้ายบน", UDim2.new(0, 10,   0, 60)},
        }

        local notifRow = Instance.new("Frame")
        notifRow.BackgroundColor3 = Theme.Secondary
        notifRow.Size   = UDim2.new(1, 0, 0, 48)
        notifRow.Parent = sFrame
        CreateCorner(notifRow, 8)
        CreateStroke(notifRow, Theme.Border)

        local notifLayout = Instance.new("UIListLayout")
        notifLayout.FillDirection = Enum.FillDirection.Horizontal
        notifLayout.Padding       = UDim.new(0, 6)
        notifLayout.VerticalAlignment   = Enum.VerticalAlignment.Center
        notifLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        notifLayout.Parent = notifRow

        for _, np in ipairs(notifPositions) do
            local label = np[1]
            local pos   = np[2]
            local nbtn = Instance.new("TextButton")
            nbtn.BackgroundColor3 = Theme.TabInactive
            nbtn.Size     = UDim2.new(0, 110, 0, 30)
            nbtn.Text     = label
            nbtn.TextColor3 = Theme.Text
            nbtn.Font     = Enum.Font.GothamBold
            nbtn.TextSize = 11
            nbtn.Parent   = notifRow
            CreateCorner(nbtn, 8)
            nbtn.MouseButton1Click:Connect(function()
                EnsureNotifHolder()
                NotifHolder.Position = pos
                EclipseLib:Notify({
                    Title   = "🔔 เปลี่ยนตำแหน่งแล้ว",
                    Content = label,
                    Duration = 2,
                    Type    = "info"
                })
            end)
        end

        -- ── 🌗 Transparency ──
        SectionTitle("🌗 ความโปร่งใส UI")

        local transCard = Instance.new("Frame")
        transCard.BackgroundColor3 = Theme.Secondary
        transCard.Size   = UDim2.new(1, 0, 0, 60)
        transCard.Parent = sFrame
        CreateCorner(transCard, 8)
        CreateStroke(transCard, Theme.Border)

        local transValLbl = Instance.new("TextLabel")
        transValLbl.BackgroundTransparency = 1
        transValLbl.Position       = UDim2.new(0.7, 0, 0, 6)
        transValLbl.Size           = UDim2.new(0.28, 0, 0, 18)
        transValLbl.Text           = "0%"
        transValLbl.TextColor3     = Theme.Accent
        transValLbl.Font           = Enum.Font.GothamBold
        transValLbl.TextSize       = 13
        transValLbl.TextXAlignment = Enum.TextXAlignment.Right
        transValLbl.Parent         = transCard

        local transNameL = Instance.new("TextLabel")
        transNameL.BackgroundTransparency = 1
        transNameL.Position       = UDim2.new(0, 10, 0, 6)
        transNameL.Size           = UDim2.new(0.68, 0, 0, 18)
        transNameL.Text           = "ความโปร่งใสพื้นหลัง"
        transNameL.TextColor3     = Theme.Text
        transNameL.Font           = Enum.Font.GothamBold
        transNameL.TextSize       = 12
        transNameL.TextXAlignment = Enum.TextXAlignment.Left
        transNameL.Parent         = transCard

        local tTrackBG = Instance.new("Frame")
        tTrackBG.BackgroundColor3 = Theme.Slider_BG
        tTrackBG.Size     = UDim2.new(1, -20, 0, 8)
        tTrackBG.Position = UDim2.new(0, 10, 0, 36)
        tTrackBG.Parent   = transCard
        CreateCorner(tTrackBG, 4)

        local tFill = Instance.new("Frame")
        tFill.BackgroundColor3 = Theme.Slider_Fill
        tFill.Size   = UDim2.new(0, 0, 1, 0)
        tFill.Parent = tTrackBG
        CreateCorner(tFill, 4)

        local draggingTrans = false
        tTrackBG.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
                draggingTrans = true
            end
        end)
        UserInputService.InputChanged:Connect(function(input)
            if draggingTrans and (
                input.UserInputType == Enum.UserInputType.MouseMovement
                or input.UserInputType == Enum.UserInputType.Touch
            ) then
                local abs = tTrackBG.AbsolutePosition
                local sz  = tTrackBG.AbsoluteSize
                local rel = math.clamp((input.Position.X - abs.X) / sz.X, 0, 1)
                tFill.Size = UDim2.new(rel, 0, 1, 0)
                local pct  = math.floor(rel * 80) -- max 80% โปร่งใส
                transValLbl.Text = pct .. "%"
                Tween(Main, {BackgroundTransparency = rel * 0.8}, 0.05)
            end
        end)
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
                draggingTrans = false
            end
        end)
    end

    -- ═══════════════════════════════════════
    -- ➕ CreateTab (User tabs)
    -- ═══════════════════════════════════════
    function WindowObj:CreateTab(nameOrOpts, _icon)
        local tabName, tabIcon
        if type(nameOrOpts) == "string" then
            tabName = nameOrOpts
            tabIcon = _icon or ""
        else
            tabName = nameOrOpts.Name or "Tab"
            tabIcon = nameOrOpts.Icon or ""
        end

        local label  = (tabIcon ~= "") and (tabIcon .. " " .. tabName) or tabName
        local tabBtn = MakeTabButton(label, false)
        local tabFrame = MakeScrollFrame("Frame_" .. tabName)

        tabButtons[tabName] = tabBtn
        tabFrames[tabName]  = tabFrame

        tabBtn.MouseButton1Click:Connect(function()
            SetActiveTab(tabName)
        end)

        -- ── Tab API ──
        local TabAPI = {}

        local function BaseCard(h)
            local card = Instance.new("Frame")
            card.BackgroundColor3 = Theme.Secondary
            card.Size   = UDim2.new(1, 0, 0, h)
            card.Parent = tabFrame
            CreateCorner(card, 8)
            CreateStroke(card, Theme.Border)
            return card
        end

        -- 🏷️ Label
        function TabAPI:AddLabel(opts2)
            opts2 = opts2 or {}
            local lbl = Instance.new("TextLabel")
            lbl.BackgroundTransparency = 1
            lbl.Size        = UDim2.new(1, 0, 0, 24)
            lbl.Text        = opts2.Text or ""
            lbl.TextColor3  = Theme.SubText
            lbl.Font        = Enum.Font.Gotham
            lbl.TextSize    = 12
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.TextWrapped = true
            lbl.Parent      = tabFrame
            local API = {}
            function API:SetText(t) lbl.Text = t end
            return API
        end

        -- 🔘 Button
        function TabAPI:AddButton(opts2)
            opts2 = opts2 or {}
            local card = BaseCard(50)
            local nameLbl = Instance.new("TextLabel")
            nameLbl.BackgroundTransparency = 1
            nameLbl.Position       = UDim2.new(0, 10, 0, 6)
            nameLbl.Size           = UDim2.new(0.6, 0, 0, 18)
            nameLbl.Text           = opts2.Name or "Button"
            nameLbl.TextColor3     = Theme.Text
            nameLbl.Font           = Enum.Font.GothamBold
            nameLbl.TextSize       = 13
            nameLbl.TextXAlignment = Enum.TextXAlignment.Left
            nameLbl.Parent         = card

            local descLbl = Instance.new("TextLabel")
            descLbl.BackgroundTransparency = 1
            descLbl.Position       = UDim2.new(0, 10, 0, 26)
            descLbl.Size           = UDim2.new(0.6, 0, 0, 16)
            descLbl.Text           = opts2.Description or ""
            descLbl.TextColor3     = Theme.SubText
            descLbl.Font           = Enum.Font.Gotham
            descLbl.TextSize       = 10
            descLbl.TextXAlignment = Enum.TextXAlignment.Left
            descLbl.Parent         = card

            if opts2.RealtimeValue then
                local rtLbl = Instance.new("TextLabel")
                rtLbl.BackgroundTransparency = 1
                rtLbl.Position       = UDim2.new(0.6, 0, 0, 6)
                rtLbl.Size           = UDim2.new(0.22, 0, 0, 18)
                rtLbl.Text           = tostring(opts2.RealtimeValue())
                rtLbl.TextColor3     = Theme.Accent
                rtLbl.Font           = Enum.Font.GothamBold
                rtLbl.TextSize       = 11
                rtLbl.TextXAlignment = Enum.TextXAlignment.Right
                rtLbl.Parent         = card
                RunService.Heartbeat:Connect(function()
                    local v = tostring(opts2.RealtimeValue())
                    if rtLbl.Text ~= v then rtLbl.Text = v end
                end)
            end

            local btn = Instance.new("TextButton")
            btn.BackgroundColor3 = Theme.Accent
            btn.Size     = UDim2.new(0, 52, 0, 26)
            btn.Position = UDim2.new(1, -62, 0.5, -13)
            btn.Text     = "▶ RUN"
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            btn.Font     = Enum.Font.GothamBold
            btn.TextSize = 10
            btn.Parent   = card
            CreateCorner(btn, 6)
            btn.MouseButton1Click:Connect(function()
                Tween(btn, {BackgroundColor3 = Theme.AccentHover}, 0.1)
                task.wait(0.1)
                Tween(btn, {BackgroundColor3 = Theme.Accent}, 0.1)
                if opts2.Callback then opts2.Callback() end
            end)
        end

        -- 🔄 Toggle
        function TabAPI:AddToggle(opts2)
            opts2 = opts2 or {}
            local state = opts2.Default or false
            local card  = BaseCard(50)

            local nameLbl = Instance.new("TextLabel")
            nameLbl.BackgroundTransparency = 1
            nameLbl.Position       = UDim2.new(0, 10, 0, 6)
            nameLbl.Size           = UDim2.new(0.7, 0, 0, 18)
            nameLbl.Text           = opts2.Name or "Toggle"
            nameLbl.TextColor3     = Theme.Text
            nameLbl.Font           = Enum.Font.GothamBold
            nameLbl.TextSize       = 13
            nameLbl.TextXAlignment = Enum.TextXAlignment.Left
            nameLbl.Parent         = card

            local descLbl = Instance.new("TextLabel")
            descLbl.BackgroundTransparency = 1
            descLbl.Position       = UDim2.new(0, 10, 0, 26)
            descLbl.Size           = UDim2.new(0.7, 0, 0, 16)
            descLbl.Text           = opts2.Description or ""
            descLbl.TextColor3     = Theme.SubText
            descLbl.Font           = Enum.Font.Gotham
            descLbl.TextSize       = 10
            descLbl.TextXAlignment = Enum.TextXAlignment.Left
            descLbl.Parent         = card

            local switchBG = Instance.new("Frame")
            switchBG.BackgroundColor3 = state and Theme.Toggle_ON or Theme.Toggle_OFF
            switchBG.Size     = UDim2.new(0, 44, 0, 24)
            switchBG.Position = UDim2.new(1, -54, 0.5, -12)
            switchBG.Parent   = card
            CreateCorner(switchBG, 12)

            local knob = Instance.new("Frame")
            knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            knob.Size     = UDim2.new(0, 18, 0, 18)
            knob.Position = state
                and UDim2.new(1, -21, 0.5, -9)
                or  UDim2.new(0,   3, 0.5, -9)
            knob.Parent = switchBG
            CreateCorner(knob, 9)

            local clickArea = Instance.new("TextButton")
            clickArea.BackgroundTransparency = 1
            clickArea.Size   = UDim2.new(1, 0, 1, 0)
            clickArea.Text   = ""
            clickArea.Parent = card
            clickArea.MouseButton1Click:Connect(function()
                state = not state
                Tween(switchBG, {BackgroundColor3 = state and Theme.Toggle_ON or Theme.Toggle_OFF}, 0.2)
                Tween(knob, {Position = state
                    and UDim2.new(1, -21, 0.5, -9)
                    or  UDim2.new(0,   3, 0.5, -9)
                }, 0.2)
                if opts2.Callback then opts2.Callback(state) end
            end)

            local ToggleAPI = {}
            function ToggleAPI:SetState(s)
                state = s
                Tween(switchBG, {BackgroundColor3 = state and Theme.Toggle_ON or Theme.Toggle_OFF}, 0.2)
                Tween(knob, {Position = state
                    and UDim2.new(1, -21, 0.5, -9)
                    or  UDim2.new(0,   3, 0.5, -9)
                }, 0.2)
                if opts2.Callback then opts2.Callback(state) end
            end
            function ToggleAPI:GetState() return state end
            return ToggleAPI
        end

        -- 🎚️ Slider
        function TabAPI:AddSlider(opts2)
            opts2 = opts2 or {}
            local minVal  = opts2.Min     or 0
            local maxVal  = opts2.Max     or 100
            local value   = math.clamp(opts2.Default or minVal, minVal, maxVal)
            local card    = BaseCard(60)

            local nameLbl = Instance.new("TextLabel")
            nameLbl.BackgroundTransparency = 1
            nameLbl.Position       = UDim2.new(0, 10, 0, 6)
            nameLbl.Size           = UDim2.new(0.7, 0, 0, 18)
            nameLbl.Text           = opts2.Name or "Slider"
            nameLbl.TextColor3     = Theme.Text
            nameLbl.Font           = Enum.Font.GothamBold
            nameLbl.TextSize       = 13
            nameLbl.TextXAlignment = Enum.TextXAlignment.Left
            nameLbl.Parent         = card

            local valLbl = Instance.new("TextLabel")
            valLbl.BackgroundTransparency = 1
            valLbl.Position       = UDim2.new(0.7, 0, 0, 6)
            valLbl.Size           = UDim2.new(0.28, 0, 0, 18)
            valLbl.Text           = tostring(value)
            valLbl.TextColor3     = Theme.Accent
            valLbl.Font           = Enum.Font.GothamBold
            valLbl.TextSize       = 13
            valLbl.TextXAlignment = Enum.TextXAlignment.Right
            valLbl.Parent         = card

            local trackBG = Instance.new("Frame")
            trackBG.BackgroundColor3 = Theme.Slider_BG
            trackBG.Size     = UDim2.new(1, -20, 0, 8)
            trackBG.Position = UDim2.new(0, 10, 0, 36)
            trackBG.Parent   = card
            CreateCorner(trackBG, 4)

            local fill = Instance.new("Frame")
            fill.BackgroundColor3 = Theme.Slider_Fill
            fill.Size   = UDim2.new((value - minVal)/(maxVal - minVal), 0, 1, 0)
            fill.Parent = trackBG
            CreateCorner(fill, 4)

            local draggingSlider = false
            local function UpdateSlider(pos)
                local abs = trackBG.AbsolutePosition
                local sz  = trackBG.AbsoluteSize
                local rel = math.clamp((pos.X - abs.X) / sz.X, 0, 1)
                value      = math.floor(minVal + (maxVal - minVal) * rel)
                valLbl.Text = tostring(value)
                fill.Size   = UDim2.new(rel, 0, 1, 0)
                if opts2.Callback then opts2.Callback(value) end
            end
            trackBG.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1
                or input.UserInputType == Enum.UserInputType.Touch then
                    draggingSlider = true
                    UpdateSlider(input.Position)
                end
            end)
            UserInputService.InputChanged:Connect(function(input)
                if draggingSlider and (
                    input.UserInputType == Enum.UserInputType.MouseMovement
                    or input.UserInputType == Enum.UserInputType.Touch
                ) then
                    UpdateSlider(input.Position)
                end
            end)
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1
                or input.UserInputType == Enum.UserInputType.Touch then
                    draggingSlider = false
                end
            end)

            local SliderAPI = {}
            function SliderAPI:GetValue() return value end
            function SliderAPI:SetValue(v)
                value = math.clamp(v, minVal, maxVal)
                local rel = (value - minVal)/(maxVal - minVal)
                fill.Size   = UDim2.new(rel, 0, 1, 0)
                valLbl.Text = tostring(value)
                if opts2.Callback then opts2.Callback(value) end
            end
            return SliderAPI
        end

        -- 🔽 Dropdown
        function TabAPI:AddDropdown(opts2)
            opts2 = opts2 or {}
            local items    = opts2.Options or {}
            local selected = opts2.Default or (items[1] or "")
            local isExpand = false

            local wrapper = Instance.new("Frame")
            wrapper.BackgroundTransparency = 1
            wrapper.Size            = UDim2.new(1, 0, 0, 46)
            wrapper.ClipsDescendants = false
            wrapper.Parent          = tabFrame

            local card = Instance.new("Frame")
            card.BackgroundColor3  = Theme.Secondary
            card.Size              = UDim2.new(1, 0, 0, 46)
            card.ClipsDescendants  = false
            card.Parent            = wrapper
            CreateCorner(card, 8)
            CreateStroke(card, Theme.Border)

            local nameLbl = Instance.new("TextLabel")
            nameLbl.BackgroundTransparency = 1
            nameLbl.Position       = UDim2.new(0, 10, 0, 6)
            nameLbl.Size           = UDim2.new(0.55, 0, 0, 14)
            nameLbl.Text           = opts2.Name or "Dropdown"
            nameLbl.TextColor3     = Theme.SubText
            nameLbl.Font           = Enum.Font.Gotham
            nameLbl.TextSize       = 11
            nameLbl.TextXAlignment = Enum.TextXAlignment.Left
            nameLbl.Parent         = card

            local selLbl = Instance.new("TextLabel")
            selLbl.BackgroundTransparency = 1
            selLbl.Position       = UDim2.new(0, 10, 0, 22)
            selLbl.Size           = UDim2.new(0.65, 0, 0, 18)
            selLbl.Text           = selected
            selLbl.TextColor3     = Theme.Text
            selLbl.Font           = Enum.Font.GothamBold
            selLbl.TextSize       = 13
            selLbl.TextXAlignment = Enum.TextXAlignment.Left
            selLbl.Parent         = card

            if opts2.RealtimeValue then
                local rtLbl = Instance.new("TextLabel")
                rtLbl.BackgroundTransparency = 1
                rtLbl.Position       = UDim2.new(0.6, 0, 0, 22)
                rtLbl.Size           = UDim2.new(0.2, 0, 0, 18)
                rtLbl.Text           = tostring(opts2.RealtimeValue())
                rtLbl.TextColor3     = Theme.Accent
                rtLbl.Font           = Enum.Font.GothamBold
                rtLbl.TextSize       = 11
                rtLbl.TextXAlignment = Enum.TextXAlignment.Right
                rtLbl.Parent         = card
                RunService.Heartbeat:Connect(function()
                    local v = tostring(opts2.RealtimeValue())
                    if rtLbl.Text ~= v then rtLbl.Text = v end
                end)
            end

            local arrowBtn = Instance.new("TextButton")
            arrowBtn.BackgroundColor3 = Theme.Accent
            arrowBtn.Size     = UDim2.new(0, 30, 0, 30)
            arrowBtn.Position = UDim2.new(1, -40, 0.5, -15)
            arrowBtn.Text     = "▼"
            arrowBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            arrowBtn.Font     = Enum.Font.GothamBold
            arrowBtn.TextSize = 12
            arrowBtn.Parent   = card
            CreateCorner(arrowBtn, 6)

            local dropList = Instance.new("Frame")
            dropList.BackgroundColor3 = Theme.Dropdown_BG
            dropList.Size     = UDim2.new(1, 0, 0, #items * 30 + 8)
            dropList.Position = UDim2.new(0, 0, 1, 4)
            dropList.Visible  = false
            dropList.ZIndex   = 10
            dropList.Parent   = card
            CreateCorner(dropList, 8)
            CreateStroke(dropList, Theme.Border)

            local dLayout = Instance.new("UIListLayout")
            dLayout.Padding    = UDim.new(0, 2)
            dLayout.SortOrder  = Enum.SortOrder.LayoutOrder
            dLayout.Parent     = dropList
            local dPad = Instance.new("UIPadding")
            dPad.PaddingTop   = UDim.new(0, 4)
            dPad.PaddingLeft  = UDim.new(0, 4)
            dPad.PaddingRight = UDim.new(0, 4)
            dPad.Parent       = dropList

            local function PopulateDropdown()
                for _, c in ipairs(dropList:GetChildren()) do
                    if c:IsA("TextButton") then c:Destroy() end
                end
                for _, item in ipairs(items) do
                    local iBtn = Instance.new("TextButton")
                    iBtn.BackgroundColor3 = Theme.Secondary
                    iBtn.Size     = UDim2.new(1, 0, 0, 26)
                    iBtn.Text     = "  " .. item
                    iBtn.TextColor3 = Theme.Text
                    iBtn.Font     = Enum.Font.Gotham
                    iBtn.TextSize = 12
                    iBtn.TextXAlignment = Enum.TextXAlignment.Left
                    iBtn.ZIndex   = 11
                    iBtn.Parent   = dropList
                    CreateCorner(iBtn, 6)
                    iBtn.MouseButton1Click:Connect(function()
                        selected       = item
                        selLbl.Text    = item
                        isExpand       = false
                        dropList.Visible = false
                        arrowBtn.Text  = "▼"
                        if opts2.Callback then opts2.Callback(item) end
                    end)
                end
                dropList.Size = UDim2.new(1, 0, 0, #items * 30 + 8)
            end
            PopulateDropdown()

            arrowBtn.MouseButton1Click:Connect(function()
                isExpand         = not isExpand
                dropList.Visible = isExpand
                arrowBtn.Text    = isExpand and "▲" or "▼"
            end)

            local DropAPI = {}
            function DropAPI:GetValue() return selected end
            function DropAPI:SetOptions(newOpts)
                items = newOpts
                PopulateDropdown()
            end
            return DropAPI
        end

        -- 📝 Input
        function TabAPI:AddInput(opts2)
            opts2 = opts2 or {}
            local card = BaseCard(60)

            local nameLbl = Instance.new("TextLabel")
            nameLbl.BackgroundTransparency = 1
            nameLbl.Position       = UDim2.new(0, 10, 0, 6)
            nameLbl.Size           = UDim2.new(1, -20, 0, 16)
            nameLbl.Text           = opts2.Name or "Input"
            nameLbl.TextColor3     = Theme.SubText
            nameLbl.Font           = Enum.Font.Gotham
            nameLbl.TextSize       = 11
            nameLbl.TextXAlignment = Enum.TextXAlignment.Left
            nameLbl.Parent         = card

            local inputBG = Instance.new("Frame")
            inputBG.BackgroundColor3 = Theme.Input_BG
            inputBG.Size     = UDim2.new(1, -20, 0, 28)
            inputBG.Position = UDim2.new(0, 10, 0, 26)
            inputBG.Parent   = card
            CreateCorner(inputBG, 6)
            CreateStroke(inputBG, Theme.Border)

            local box = Instance.new("TextBox")
            box.BackgroundTransparency = 1
            box.Size             = UDim2.new(1, -10, 1, 0)
            box.Position         = UDim2.new(0, 6, 0, 0)
            box.PlaceholderText  = opts2.Placeholder or "พิมพ์ที่นี่..."
            box.PlaceholderColor3 = Theme.SubText
            box.TextColor3       = Theme.Text
            box.Font             = Enum.Font.Gotham
            box.TextSize         = 12
            box.TextXAlignment   = Enum.TextXAlignment.Left
            box.ClearTextOnFocus = false
            box.Text             = ""
            box.Parent           = inputBG
            box.FocusLost:Connect(function(enter)
                if enter and opts2.Callback then opts2.Callback(box.Text) end
            end)

            local InputAPI = {}
            function InputAPI:GetValue() return box.Text end
            function InputAPI:SetValue(v) box.Text = v end
            return InputAPI
        end

        return TabAPI
    end

    function WindowObj:Notify(o) EclipseLib:Notify(o) end

    -- ═══ KeySystem ═══
    local function StartMain()
        -- เริ่มต้น UI ปกติ
        EclipseLib:Notify({
            Title   = "🌒 " .. windowName,
            Content = "โหลดสำเร็จแล้ว!",
            Duration = 3,
            Type    = "success"
        })
    end

    if useKey then
        Main.Visible = false
        ShowKeySystem(keyOpts, function()
            Main.Visible = true
            StartMain()
        end)
    else
        task.delay(2, StartMain)
    end

    return WindowObj
end

return EclipseLib
