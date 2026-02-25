-- 🌒 EclipseLib by Eclipse
-- Version: 1.0.0
-- Theme: Dark but Radiant

local EclipseLib = {}
EclipseLib.__index = EclipseLib

-- ═══════════════════════════════════════
-- 🎨 Theme Colors
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
local Players        = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService   = game:GetService("TweenService")
local RunService     = game:GetService("RunService")
local CoreGui        = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer

-- ═══════════════════════════════════════
-- 🧱 Utility
-- ═══════════════════════════════════════
local function Tween(obj, props, t)
    TweenService:Create(obj, TweenInfo.new(t or 0.2, Enum.EasingStyle.Quad), props):Play()
end

local function MakeDraggable(frame, handle)
    local dragging, dragStart, startPos = false, nil, nil
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
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
    s.Color = color or Theme.Border
    s.Thickness = thickness or 1
    s.Parent = parent
end

local function CreatePadding(parent, pad)
    local p = Instance.new("UIPadding")
    p.PaddingLeft   = UDim.new(0, pad or 8)
    p.PaddingRight  = UDim.new(0, pad or 8)
    p.PaddingTop    = UDim.new(0, pad or 8)
    p.PaddingBottom = UDim.new(0, pad or 8)
    p.Parent = parent
end

-- ═══════════════════════════════════════
-- 🔔 Notification System (Custom – No Roblox)
-- ═══════════════════════════════════════
local NotifHolder

local function EnsureNotifHolder()
    if NotifHolder and NotifHolder.Parent then return end
    local sg = Instance.new("ScreenGui")
    sg.Name = "__EclipseNotif"
    sg.ResetOnSpawn = false
    sg.IgnoreGuiInset = true
    sg.DisplayOrder = 9999
    pcall(function() sg.Parent = CoreGui end)
    if not sg.Parent then sg.Parent = LocalPlayer:WaitForChild("PlayerGui") end

    NotifHolder = Instance.new("Frame")
    NotifHolder.Name = "NotifHolder"
    NotifHolder.BackgroundTransparency = 1
    -- ✅ มุมขวาบน ห่างจาก edge ปลอดภัย ไม่ทับปุ่มมือถือ
    NotifHolder.Position = UDim2.new(1, -220, 0, 60)
    MonifHolder = MonifHolder
    NotifHolder.Size = UDim2.new(0, 210, 1, -120)
    NotifHolder.Parent = sg

    local layout = Instance.new("UIListLayout")
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 8)
    layout.VerticalAlignment = Enum.VerticalAlignment.Top
    layout.Parent = NotifHolder
end

function EclipseLib:Notify(opts)
    opts = opts or {}
    local title    = opts.Title   or "🌒 EclipseLib"
    local content  = opts.Content or ""
    local duration = opts.Duration or 4
    local ntype    = opts.Type or "info" -- "info" | "success" | "error" | "warn"

    EnsureNotifHolder()

    local typeColor = {
        info    = Color3.fromRGB(100, 60, 200),
        success = Color3.fromRGB(60, 180, 100),
        error   = Color3.fromRGB(200, 60, 60),
        warn    = Color3.fromRGB(200, 160, 40),
    }
    local accent = typeColor[ntype] or typeColor.info

    local card = Instance.new("Frame")
    card.Name = "Notif"
    card.BackgroundColor3 = Theme.Notif_BG
    card.Size = UDim2.new(1, 0, 0, 70)
    card.BackgroundTransparency = 0
    card.ClipsDescendants = true
    card.Parent = NotifHolder
    CreateCorner(card, 10)
    CreateStroke(card, accent, 1.5)

    -- side bar
    local bar = Instance.new("Frame")
    bar.BackgroundColor3 = accent
    bar.Size = UDim2.new(0, 4, 1, 0)
    bar.Position = UDim2.new(0, 0, 0, 0)
    bar.BorderSizePixel = 0
    bar.Parent = card
    CreateCorner(bar, 4)

    local titleLbl = Instance.new("TextLabel")
    titleLbl.BackgroundTransparency = 1
    titleLbl.Position = UDim2.new(0, 12, 0, 8)
    titleLbl.Size = UDim2.new(1, -16, 0, 20)
    titleLbl.Text = title
    titleLbl.TextColor3 = Theme.Text
    titleLbl.Font = Enum.Font.GothamBold
    titleLbl.TextSize = 13
    titleLbl.TextXAlignment = Enum.TextXAlignment.Left
    titleLbl.Parent = card

    local contentLbl = Instance.new("TextLabel")
    contentLbl.BackgroundTransparency = 1
    contentLbl.Position = UDim2.new(0, 12, 0, 30)
    contentLbl.Size = UDim2.new(1, -16, 0, 32)
    contentLbl.Text = content
    contentLbl.TextColor3 = Theme.SubText
    contentLbl.Font = Enum.Font.Gotham
    contentLbl.TextSize = 11
    contentLbl.TextXAlignment = Enum.TextXAlignment.Left
    contentLbl.TextWrapped = true
    contentLbl.Parent = card

    -- progress bar
    local prog = Instance.new("Frame")
    prog.BackgroundColor3 = accent
    prog.Size = UDim2.new(1, 0, 0, 2)
    prog.Position = UDim2.new(0, 0, 1, -2)
    prog.BorderSizePixel = 0
    prog.Parent = card

    -- animate in
    card.Position = UDim2.new(1, 10, 0, 0)
    Tween(card, {Position = UDim2.new(0, 0, 0, 0)}, 0.3)

    -- progress tween
    TweenService:Create(prog, TweenInfo.new(duration, Enum.EasingStyle.Linear), {Size = UDim2.new(0, 0, 0, 2)}):Play()

    task.delay(duration, function()
        Tween(card, {Position = UDim2.new(1, 10, 0, 0)}, 0.3)
        task.wait(0.35)
        card:Destroy()
    end)
end

-- ═══════════════════════════════════════
-- 🪟 Create Window
-- ═══════════════════════════════════════
function EclipseLib:CreateWindow(opts)
    opts = opts or {}
    local windowName     = opts.Name or "EclipseLib"
    local loadTitle      = opts.LoadingTitle or "🌒 EclipseLib"
    local loadSub        = opts.LoadingSubtitle or "กำลังโหลด..."
    local cfgEnabled     = opts.ConfigurationSaving and opts.ConfigurationSaving.Enabled or false
    local cfgFolder      = opts.ConfigurationSaving and opts.ConfigurationSaving.FolderName or "EclipseLib"
    local cfgFile        = opts.ConfigurationSaving and opts.ConfigurationSaving.FileName or "config"

    -- ═══ ScreenGui ═══
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "__EclipseLib_" .. windowName
    ScreenGui.ResetOnSpawn = false
    ScreenGui.IgnoreGuiInset = true
    ScreenGui.DisplayOrder = 999
    pcall(function() ScreenGui.Parent = CoreGui end)
    if not ScreenGui.Parent then ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

    -- ═══ Loading Screen ═══
    local LoadScreen = Instance.new("Frame")
    LoadScreen.Name = "LoadScreen"
    LoadScreen.BackgroundColor3 = Theme.Background
    LoadScreen.Size = UDim2.new(1, 0, 1, 0)
    LoadScreen.ZIndex = 100
    LoadScreen.Parent = ScreenGui

    local loadT = Instance.new("TextLabel")
    loadT.BackgroundTransparency = 1
    loadT.Size = UDim2.new(1, 0, 0, 40)
    loadT.Position = UDim2.new(0, 0, 0.4, 0)
    loadT.Text = loadTitle
    loadT.TextColor3 = Theme.Accent
    loadT.Font = Enum.Font.GothamBold
    loadT.TextSize = 24
    loadT.Parent = LoadScreen

    local loadS = Instance.new("TextLabel")
    loadS.BackgroundTransparency = 1
    loadS.Size = UDim2.new(1, 0, 0, 30)
    loadS.Position = UDim2.new(0, 0, 0.5, 0)
    loadS.Text = loadSub
    loadS.TextColor3 = Theme.SubText
    loadS.Font = Enum.Font.Gotham
    loadS.TextSize = 14
    loadS.Parent = LoadScreen

    -- loading bar
    local lBarBG = Instance.new("Frame")
    lBarBG.BackgroundColor3 = Theme.Slider_BG
    lBarBG.Size = UDim2.new(0, 200, 0, 4)
    lBarBG.Position = UDim2.new(0.5, -100, 0.58, 0)
    lBarBG.Parent = LoadScreen
    CreateCorner(lBarBG, 4)

    local lBar = Instance.new("Frame")
    lBar.BackgroundColor3 = Theme.Accent
    lBar.Size = UDim2.new(0, 0, 1, 0)
    lBar.Parent = lBarBG
    CreateCorner(lBar, 4)

    TweenService:Create(lBar, TweenInfo.new(1.5, Enum.EasingStyle.Quad), {Size = UDim2.new(1, 0, 1, 0)}):Play()

    task.delay(1.8, function()
        Tween(LoadScreen, {BackgroundTransparency = 1}, 0.4)
        for _, v in ipairs(LoadScreen:GetDescendants()) do
            if v:IsA("TextLabel") or v:IsA("Frame") then
                pcall(function() Tween(v, {BackgroundTransparency = 1, TextTransparency = 1}, 0.4) end)
            end
        end
        task.wait(0.5)
        LoadScreen:Destroy()
    end)

    -- ═══ Main Frame ═══
    local Main = Instance.new("Frame")
    Main.Name = "EclipseMain"
    Main.BackgroundColor3 = Theme.Background
    Main.Size = UDim2.new(0, 480, 0, 340)
    Main.Position = UDim2.new(0.5, -240, 0.5, -170)
    Main.ClipsDescendants = true
    Main.Parent = ScreenGui
    CreateCorner(Main, 12)
    CreateStroke(Main, Theme.Border, 1.5)

    -- ═══ Top Bar ═══
    local TopBar = Instance.new("Frame")
    TopBar.Name = "TopBar"
    TopBar.BackgroundColor3 = Theme.Secondary
    TopBar.Size = UDim2.new(1, 0, 0, 38)
    TopBar.Parent = Main
    CreateCorner(TopBar, 12)

    -- fix bottom corners of topbar
    local tbFix = Instance.new("Frame")
    tbFix.BackgroundColor3 = Theme.Secondary
    tbFix.Size = UDim2.new(1, 0, 0, 10)
    tbFix.Position = UDim2.new(0, 0, 1, -10)
    tbFix.BorderSizePixel = 0
    tbFix.Parent = TopBar

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Position = UDim2.new(0, 12, 0, 0)
    TitleLabel.Size = UDim2.new(1, -80, 1, 0)
    TitleLabel.Text = "🌒  " .. windowName
    TitleLabel.TextColor3 = Theme.Text
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextSize = 14
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = TopBar

    -- ปุ่ม X (ปิด)
    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Name = "CloseBtn"
    CloseBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
    CloseBtn.Size = UDim2.new(0, 22, 0, 22)
    CloseBtn.Position = UDim2.new(1, -30, 0.5, -11)
    CloseBtn.Text = "✕"
    CloseBtn.TextColor3 = Color3.fromRGB(255,255,255)
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.TextSize = 12
    CloseBtn.Parent = TopBar
    CreateCorner(CloseBtn, 6)

    -- ปุ่ม Toggle (เปิด/ปิด UI)
    local ToggleBtn = Instance.new("TextButton")
    ToggleBtn.Name = "ToggleBtn"
    ToggleBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    ToggleBtn.Size = UDim2.new(0, 22, 0, 22)
    ToggleBtn.Position = UDim2.new(1, -56, 0.5, -11)
    ToggleBtn.Text = "—"
    ToggleBtn.TextColor3 = Theme.Text
    ToggleBtn.Font = Enum.Font.GothamBold
    ToggleBtn.TextSize = 12
    ToggleBtn.Parent = TopBar
    CreateCorner(ToggleBtn, 6)

    -- Draggable
    MakeDraggable(Main, TopBar)

    -- ═══ Body ═══
    local Body = Instance.new("Frame")
    Body.Name = "Body"
    Body.BackgroundTransparency = 1
    Body.Position = UDim2.new(0, 0, 0, 38)
    Body.Size = UDim2.new(1, 0, 1, -38)
    Body.Parent = Main

    -- ═══ Tab Bar (Left) ═══
    local TabBar = Instance.new("ScrollingFrame")
    TabBar.Name = "TabBar"
    TabBar.BackgroundColor3 = Theme.Secondary
    TabBar.Size = UDim2.new(0, 110, 1, 0)
    TabBar.ScrollBarThickness = 2
    TabBar.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabBar.ScrollingDirection = Enum.ScrollingDirection.Y
    TabBar.Parent = Body
    CreateStroke(TabBar, Theme.Border, 1)

    local TabLayout = Instance.new("UIListLayout")
    TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabLayout.Padding = UDim.new(0, 4)
    TabLayout.Parent = TabBar

    local TabPadding = Instance.new("UIPadding")
    TabPadding.PaddingTop = UDim.new(0, 6)
    TabPadding.PaddingLeft = UDim.new(0, 6)
    TabPadding.PaddingRight = UDim.new(0, 6)
    TabPadding.Parent = TabBar

    -- ═══ Content Area ═══
    local ContentArea = Instance.new("Frame")
    ContentArea.Name = "ContentArea"
    ContentArea.BackgroundTransparency = 1
    ContentArea.Position = UDim2.new(0, 114, 0, 0)
    ContentArea.Size = UDim2.new(1, -114, 1, 0)
    ContentArea.Parent = Body

    -- ═══ Toggle Logic ═══
    local isOpen = true
    ToggleBtn.MouseButton1Click:Connect(function()
        isOpen = not isOpen
        if isOpen then
            Tween(Main, {Size = UDim2.new(0, 480, 0, 340)}, 0.3)
            ToggleBtn.Text = "—"
        else
            Tween(Main, {Size = UDim2.new(0, 480, 0, 38)}, 0.3)
            ToggleBtn.Text = "▲"
        end
    end)

    CloseBtn.MouseButton1Click:Connect(function()
        Tween(Main, {BackgroundTransparency = 1, Size = UDim2.new(0, 480, 0, 0)}, 0.3)
        task.wait(0.35)
        ScreenGui:Destroy()
    end)

    -- ═══════════════════════════════════════
    -- 🪐 Window Object
    -- ═══════════════════════════════════════
    local WindowObj = {}
    local tabButtons = {}
    local tabFrames  = {}
    local activeTab  = nil

    local function SetActiveTab(name)
        for n, btn in pairs(tabButtons) do
            if n == name then
                Tween(btn, {BackgroundColor3 = Theme.TabActive}, 0.2)
                btn.TextColor3 = Color3.fromRGB(255,255,255)
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

    -- ═══════════════════════════════════════
    -- 🗂️ Welcome Tab (Built-in)
    -- ═══════════════════════════════════════
    do
        local welcomeBtn = Instance.new("TextButton")
        welcomeBtn.Name = "Tab_Welcome"
        welcomeBtn.BackgroundColor3 = Theme.TabActive
        welcomeBtn.Size = UDim2.new(1, 0, 0, 34)
        welcomeBtn.Text = "🏠 ยินดีต้อนรับ"
        welcomeBtn.TextColor3 = Color3.fromRGB(255,255,255)
        welcomeBtn.Font = Enum.Font.GothamBold
        welcomeBtn.TextSize = 11
        welcomeBtn.Parent = TabBar
        CreateCorner(welcomeBtn, 8)

        local welcomeFrame = Instance.new("ScrollingFrame")
        welcomeFrame.Name = "Frame_Welcome"
        welcomeFrame.BackgroundTransparency = 1
        welcomeFrame.Size = UDim2.new(1, 0, 1, 0)
        welcomeFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
        welcomeFrame.ScrollBarThickness = 3
        welcomeFrame.Visible = true
        welcomeFrame.Parent = ContentArea

        local wLayout = Instance.new("UIListLayout")
        wLayout.Padding = UDim.new(0, 8)
        wLayout.SortOrder = Enum.SortOrder.LayoutOrder
        wLayout.Parent = welcomeFrame
        local wPad = Instance.new("UIPadding")
        wPad.PaddingTop = UDim.new(0, 10)
        wPad.PaddingLeft = UDim.new(0, 10)
        wPad.PaddingRight = UDim.new(0, 10)
        wPad.Parent = welcomeFrame

        local function AutoCanvas()
            welcomeFrame.CanvasSize = UDim2.new(0, 0, 0, wLayout.AbsoluteContentSize.Y + 20)
        end
        wLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(AutoCanvas)

        local function MakeInfoCard(icon, labelText, valueFunc)
            local card = Instance.new("Frame")
            card.BackgroundColor3 = Theme.Secondary
            card.Size = UDim2.new(1, 0, 0, 52)
            card.Parent = welcomeFrame
            CreateCorner(card, 10)
            CreateStroke(card, Theme.Border)

            local iconLbl = Instance.new("TextLabel")
            iconLbl.BackgroundTransparency = 1
            iconLbl.Position = UDim2.new(0, 10, 0, 0)
            iconLbl.Size = UDim2.new(0, 30, 1, 0)
            iconLbl.Text = icon
            iconLbl.TextSize = 20
            iconLbl.Font = Enum.Font.GothamBold
            iconLbl.Parent = card

            local keyLbl = Instance.new("TextLabel")
            keyLbl.BackgroundTransparency = 1
            keyLbl.Position = UDim2.new(0, 44, 0, 6)
            keyLbl.Size = UDim2.new(1, -50, 0, 18)
            keyLbl.Text = labelText
            keyLbl.TextColor3 = Theme.SubText
            keyLbl.TextSize = 10
            keyLbl.Font = Enum.Font.Gotham
            keyLbl.TextXAlignment = Enum.TextXAlignment.Left
            keyLbl.Parent = card

            local valLbl = Instance.new("TextLabel")
            valLbl.BackgroundTransparency = 1
            valLbl.Position = UDim2.new(0, 44, 0, 24)
            valLbl.Size = UDim2.new(1, -50, 0, 20)
            valLbl.Text = tostring(valueFunc())
            valLbl.TextColor3 = Theme.Text
            valLbl.TextSize = 13
            valLbl.Font = Enum.Font.GothamBold
            valLbl.TextXAlignment = Enum.TextXAlignment.Left
            valLbl.Parent = card

            -- realtime update
            RunService.Heartbeat:Connect(function()
                local v = tostring(valueFunc())
                if valLbl.Text ~= v then valLbl.Text = v end
            end)
        end

        -- Display Name + Name
        MakeInfoCard("👤", "Display Name / Username", function()
            return (LocalPlayer.DisplayName or "?") .. "  ·  @" .. (LocalPlayer.Name or "?")
        end)
        -- UserID
        MakeInfoCard("🆔", "User ID", function()
            return tostring(LocalPlayer.UserId)
        end)
        -- Map name
        MakeInfoCard("🗺️", "ชื่อแมพ", function()
            return tostring(game:GetService("MarketplaceService"):GetProductInfo and game.Workspace.Name or game.Name)
        end)
        -- Place ID
        MakeInfoCard("📍", "Place ID", function()
            return tostring(game.PlaceId)
        end)

        tabButtons["_Welcome"] = welcomeBtn
        tabFrames["_Welcome"]  = welcomeFrame

        welcomeBtn.MouseButton1Click:Connect(function()
            SetActiveTab("_Welcome")
        end)

        activeTab = "_Welcome"
    end

    -- ═══════════════════════════════════════
    -- ➕ CreateTab
    -- ═══════════════════════════════════════
    function WindowObj:CreateTab(opts2)
        opts2 = opts2 or {}
        local tabName = opts2.Name or "Tab"
        local tabIcon = opts2.Icon or ""

        local tabBtn = Instance.new("TextButton")
        tabBtn.Name = "Tab_" .. tabName
        tabBtn.BackgroundColor3 = Theme.TabInactive
        tabBtn.Size = UDim2.new(1, 0, 0, 34)
        tabBtn.Text = tabIcon .. " " .. tabName
        tabBtn.TextColor3 = Theme.SubText
        tabBtn.Font = Enum.Font.GothamBold
        tabBtn.TextSize = 11
        tabBtn.Parent = TabBar
        CreateCorner(tabBtn, 8)

        local tabFrame = Instance.new("ScrollingFrame")
        tabFrame.Name = "Frame_" .. tabName
        tabFrame.BackgroundTransparency = 1
        tabFrame.Size = UDim2.new(1, 0, 1, 0)
        tabFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
        tabFrame.ScrollBarThickness = 3
        tabFrame.Visible = false
        tabFrame.Parent = ContentArea

        local layout = Instance.new("UIListLayout")
        layout.Padding = UDim.new(0, 6)
        layout.SortOrder = Enum.SortOrder.LayoutOrder
        layout.Parent = tabFrame
        local pad = Instance.new("UIPadding")
        pad.PaddingTop    = UDim.new(0, 8)
        pad.PaddingLeft   = UDim.new(0, 8)
        pad.PaddingRight  = UDim.new(0, 8)
        pad.Parent = tabFrame

        layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            tabFrame.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 20)
        end)

        tabButtons[tabName] = tabBtn
        tabFrames[tabName]  = tabFrame

        tabBtn.MouseButton1Click:Connect(function()
            SetActiveTab(tabName)
        end)

        -- ═══════════════════════════════════════
        -- Tab API
        -- ═══════════════════════════════════════
        local TabAPI = {}

        -- ──────────────────────────────────────
        -- 🏷️ Label
        -- ──────────────────────────────────────
        function TabAPI:AddLabel(opts3)
            opts3 = opts3 or {}
            local text = opts3.Text or ""

            local lbl = Instance.new("TextLabel")
            lbl.BackgroundTransparency = 1
            lbl.Size = UDim2.new(1, 0, 0, 24)
            lbl.Text = text
            lbl.TextColor3 = Theme.SubText
            lbl.Font = Enum.Font.Gotham
            lbl.TextSize = 12
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.TextWrapped = true
            lbl.Parent = tabFrame

            local LabelAPI = {}
            function LabelAPI:SetText(t) lbl.Text = t end
            return LabelAPI
        end

        -- ──────────────────────────────────────
        -- 🔘 Button
        -- ──────────────────────────────────────
        function TabAPI:AddButton(opts3)
            opts3 = opts3 or {}
            local text     = opts3.Name or "Button"
            local desc     = opts3.Description or ""
            local callback = opts3.Callback or function() end
            local rtFunc   = opts3.RealtimeValue -- function() return "value" end (optional)

            local card = Instance.new("Frame")
            card.BackgroundColor3 = Theme.Secondary
            card.Size = UDim2.new(1, 0, 0, 50)
            card.Parent = tabFrame
            CreateCorner(card, 8)
            CreateStroke(card, Theme.Border)

            local nameLbl = Instance.new("TextLabel")
            nameLbl.BackgroundTransparency = 1
            nameLbl.Position = UDim2.new(0, 10, 0, 6)
            nameLbl.Size = UDim2.new(0.6, 0, 0, 18)
            nameLbl.Text = text
            nameLbl.TextColor3 = Theme.Text
            nameLbl.Font = Enum.Font.GothamBold
            nameLbl.TextSize = 13
            nameLbl.TextXAlignment = Enum.TextXAlignment.Left
            nameLbl.Parent = card

            local descLbl = Instance.new("TextLabel")
            descLbl.BackgroundTransparency = 1
            descLbl.Position = UDim2.new(0, 10, 0, 26)
            descLbl.Size = UDim2.new(0.65, 0, 0, 16)
            descLbl.Text = desc
            descLbl.TextColor3 = Theme.SubText
            descLbl.Font = Enum.Font.Gotham
            descLbl.TextSize = 10
            descLbl.TextXAlignment = Enum.TextXAlignment.Left
            descLbl.Parent = card

            local rtLbl
            if rtFunc then
                rtLbl = Instance.new("TextLabel")
                rtLbl.BackgroundTransparency = 1
                rtLbl.Position = UDim2.new(0.6, 0, 0, 6)
                rtLbl.Size = UDim2.new(0.25, 0, 0, 18)
                rtLbl.Text = tostring(rtFunc())
                rtLbl.TextColor3 = Theme.Accent
                rtLbl.Font = Enum.Font.GothamBold
                rtLbl.TextSize = 11
                rtLbl.TextXAlignment = Enum.TextXAlignment.Right
                rtLbl.Parent = card

                RunService.Heartbeat:Connect(function()
                    local v = tostring(rtFunc())
                    if rtLbl.Text ~= v then rtLbl.Text = v end
                end)
            end

            local btn = Instance.new("TextButton")
            btn.BackgroundColor3 = Theme.Accent
            btn.Size = UDim2.new(0, 52, 0, 26)
            btn.Position = UDim2.new(1, -62, 0.5, -13)
            btn.Text = "▶ RUN"
            btn.TextColor3 = Color3.fromRGB(255,255,255)
            btn.Font = Enum.Font.GothamBold
            btn.TextSize = 10
            btn.Parent = card
            CreateCorner(btn, 6)

            btn.MouseButton1Click:Connect(function()
                Tween(btn, {BackgroundColor3 = Theme.AccentHover}, 0.1)
                task.wait(0.1)
                Tween(btn, {BackgroundColor3 = Theme.Accent}, 0.1)
                callback()
            end)
        end

        -- ──────────────────────────────────────
        -- 🔄 Toggle
        -- ──────────────────────────────────────
        function TabAPI:AddToggle(opts3)
            opts3 = opts3 or {}
            local text     = opts3.Name or "Toggle"
            local desc     = opts3.Description or ""
            local default  = opts3.Default or false
            local callback = opts3.Callback or function() end

            local state = default

            local card = Instance.new("Frame")
            card.BackgroundColor3 = Theme.Secondary
            card.Size = UDim2.new(1, 0, 0, 50)
            card.Parent = tabFrame
            CreateCorner(card, 8)
            CreateStroke(card, Theme.Border)

            local nameLbl = Instance.new("TextLabel")
            nameLbl.BackgroundTransparency = 1
            nameLbl.Position = UDim2.new(0, 10, 0, 6)
            nameLbl.Size = UDim2.new(0.7, 0, 0, 18)
            nameLbl.Text = text
            nameLbl.TextColor3 = Theme.Text
            nameLbl.Font = Enum.Font.GothamBold
            nameLbl.TextSize = 13
            nameLbl.TextXAlignment = Enum.TextXAlignment.Left
            nameLbl.Parent = card

            local descLbl = Instance.new("TextLabel")
            descLbl.BackgroundTransparency = 1
            descLbl.Position = UDim2.new(0, 10, 0, 26)
            descLbl.Size = UDim2.new(0.7, 0, 0, 16)
            descLbl.Text = desc
            descLbl.TextColor3 = Theme.SubText
            descLbl.Font = Enum.Font.Gotham
            descLbl.TextSize = 10
            descLbl.TextXAlignment = Enum.TextXAlignment.Left
            descLbl.Parent = card

            -- toggle switch
            local switchBG = Instance.new("Frame")
            switchBG.BackgroundColor3 = state and Theme.Toggle_ON or Theme.Toggle_OFF
            switchBG.Size = UDim2.new(0, 44, 0, 24)
            switchBG.Position = UDim2.new(1, -54, 0.5, -12)
            switchBG.Parent = card
            CreateCorner(switchBG, 12)

            local knob = Instance.new("Frame")
            knob.BackgroundColor3 = Color3.fromRGB(255,255,255)
            knob.Size = UDim2.new(0, 18, 0, 18)
            knob.Position = state and UDim2.new(1,-21,0.5,-9) or UDim2.new(0,3,0.5,-9)
            knob.Parent = switchBG
            CreateCorner(knob, 9)

            local clickArea = Instance.new("TextButton")
            clickArea.BackgroundTransparency = 1
            clickArea.Size = UDim2.new(1, 0, 1, 0)
            clickArea.Text = ""
            clickArea.Parent = card

            clickArea.MouseButton1Click:Connect(function()
                state = not state
                Tween(switchBG, {BackgroundColor3 = state and Theme.Toggle_ON or Theme.Toggle_OFF}, 0.2)
                Tween(knob, {Position = state and UDim2.new(1,-21,0.5,-9) or UDim2.new(0,3,0.5,-9)}, 0.2)
                callback(state)
            end)

            local ToggleAPI = {}
            function ToggleAPI:SetState(s)
                state = s
                Tween(switchBG, {BackgroundColor3 = state and Theme.Toggle_ON or Theme.Toggle_OFF}, 0.2)
                Tween(knob, {Position = state and UDim2.new(1,-21,0.5,-9) or UDim2.new(0,3,0.5,-9)}, 0.2)
                callback(state)
            end
            function ToggleAPI:GetState() return state end
            return ToggleAPI
        end

        -- ──────────────────────────────────────
        -- 🎚️ Slider (Mobile-ready)
        -- ──────────────────────────────────────
        function TabAPI:AddSlider(opts3)
            opts3 = opts3 or {}
            local text     = opts3.Name or "Slider"
            local minVal   = opts3.Min or 0
            local maxVal   = opts3.Max or 100
            local default  = opts3.Default or minVal
            local callback = opts3.Callback or function() end

            local value = math.clamp(default, minVal, maxVal)

            local card = Instance.new("Frame")
            card.BackgroundColor3 = Theme.Secondary
            card.Size = UDim2.new(1, 0, 0, 60)
            card.Parent = tabFrame
            CreateCorner(card, 8)
            CreateStroke(card, Theme.Border)

            local nameLbl = Instance.new("TextLabel")
            nameLbl.BackgroundTransparency = 1
            nameLbl.Position = UDim2.new(0, 10, 0, 6)
            nameLbl.Size = UDim2.new(0.7, 0, 0, 18)
            nameLbl.Text = text
            nameLbl.TextColor3 = Theme.Text
            nameLbl.Font = Enum.Font.GothamBold
            nameLbl.TextSize = 13
            nameLbl.TextXAlignment = Enum.TextXAlignment.Left
            nameLbl.Parent = card

            local valLbl = Instance.new("TextLabel")
            valLbl.BackgroundTransparency = 1
            valLbl.Position = UDim2.new(0.7, 0, 0, 6)
            valLbl.Size = UDim2.new(0.28, 0, 0, 18)
            valLbl.Text = tostring(value)
            valLbl.TextColor3 = Theme.Accent
            valLbl.Font = Enum.Font.GothamBold
            valLbl.TextSize = 13
            valLbl.TextXAlignment = Enum.TextXAlignment.Right
            valLbl.Parent = card

            local trackBG = Instance.new("Frame")
            trackBG.BackgroundColor3 = Theme.Slider_BG
            trackBG.Size = UDim2.new(1, -20, 0, 8)
            trackBG.Position = UDim2.new(0, 10, 0, 36)
            trackBG.Parent = card
            CreateCorner(trackBG, 4)

            local fill = Instance.new("Frame")
            fill.BackgroundColor3 = Theme.Slider_Fill
            local pct = (value - minVal) / (maxVal - minVal)
            fill.Size = UDim2.new(pct, 0, 1, 0)
            fill.Parent = trackBG
            CreateCorner(fill, 4)

            local draggingSlider = false

            local function UpdateSlider(inputPos)
                local abs = trackBG.AbsolutePosition
                local sz  = trackBG.AbsoluteSize
                local rel = math.clamp((inputPos.X - abs.X) / sz.X, 0, 1)
                value = math.floor(minVal + (maxVal - minVal) * rel)
                valLbl.Text = tostring(value)
                fill.Size = UDim2.new(rel, 0, 1, 0)
                callback(value)
            end

            trackBG.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    draggingSlider = true
                    UpdateSlider(input.Position)
                end
            end)

            UserInputService.InputChanged:Connect(function(input)
                if draggingSlider and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    UpdateSlider(input.Position)
                end
            end)

            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    draggingSlider = false
                end
            end)

            local SliderAPI = {}
            function SliderAPI:GetValue() return value end
            function SliderAPI:SetValue(v)
                value = math.clamp(v, minVal, maxVal)
                local pct2 = (value - minVal) / (maxVal - minVal)
                fill.Size = UDim2.new(pct2, 0, 1, 0)
                valLbl.Text = tostring(value)
                callback(value)
            end
            return SliderAPI
        end

        -- ──────────────────────────────────────
        -- 🔽 Dropdown (Realtime)
        -- ──────────────────────────────────────
        function TabAPI:AddDropdown(opts3)
            opts3 = opts3 or {}
            local text     = opts3.Name or "Dropdown"
            local items    = opts3.Options or {}
            local default  = opts3.Default or (items[1] or "")
            local callback = opts3.Callback or function() end
            local rtFunc   = opts3.RealtimeValue

            local selected = default
            local isExpanded = false

            local wrapper = Instance.new("Frame")
            wrapper.BackgroundTransparency = 1
            wrapper.Size = UDim2.new(1, 0, 0, 46)
            wrapper.ClipsDescendants = false
            wrapper.Parent = tabFrame

            local card = Instance.new("Frame")
            card.BackgroundColor3 = Theme.Secondary
            card.Size = UDim2.new(1, 0, 0, 46)
            card.ClipsDescendants = false
            card.Parent = wrapper
            CreateCorner(card, 8)
            CreateStroke(card, Theme.Border)

            local nameLbl = Instance.new("TextLabel")
            nameLbl.BackgroundTransparency = 1
            nameLbl.Position = UDim2.new(0, 10, 0, 6)
            nameLbl.Size = UDim2.new(0.5, 0, 0, 16)
            nameLbl.Text = text
            nameLbl.TextColor3 = Theme.SubText
            nameLbl.Font = Enum.Font.Gotham
            nameLbl.TextSize = 11
            nameLbl.TextXAlignment = Enum.TextXAlignment.Left
            nameLbl.Parent = card

            local selLbl = Instance.new("TextLabel")
            selLbl.BackgroundTransparency = 1
            selLbl.Position = UDim2.new(0, 10, 0, 22)
            selLbl.Size = UDim2.new(0.6, 0, 0, 18)
            selLbl.Text = selected
            selLbl.TextColor3 = Theme.Text
            selLbl.Font = Enum.Font.GothamBold
            selLbl.TextSize = 13
            selLbl.TextXAlignment = Enum.TextXAlignment.Left
            selLbl.Parent = card

            -- realtime badge
            local rtLbl2
            if rtFunc then
                rtLbl2 = Instance.new("TextLabel")
                rtLbl2.BackgroundTransparency = 1
                rtLbl2.Position = UDim2.new(0.6, 0, 0, 22)
                rtLbl2.Size = UDim2.new(0.2, 0, 0, 18)
                rtLbl2.Text = tostring(rtFunc())
                rtLbl2.TextColor3 = Theme.Accent
                rtLbl2.Font = Enum.Font.GothamBold
                rtLbl2.TextSize = 11
                rtLbl2.TextXAlignment = Enum.TextXAlignment.Right
                rtLbl2.Parent = card
                RunService.Heartbeat:Connect(function()
                    local v = tostring(rtFunc())
                    if rtLbl2.Text ~= v then rtLbl2.Text = v end
                end)
            end

            local arrowBtn = Instance.new("TextButton")
            arrowBtn.BackgroundColor3 = Theme.Accent
            arrowBtn.Size = UDim2.new(0, 30, 0, 30)
            arrowBtn.Position = UDim2.new(1, -40, 0.5, -15)
            arrowBtn.Text = "▼"
            arrowBtn.TextColor3 = Color3.fromRGB(255,255,255)
            arrowBtn.Font = Enum.Font.GothamBold
            arrowBtn.TextSize = 12
            arrowBtn.Parent = card
            CreateCorner(arrowBtn, 6)

            -- dropdown list
            local dropList = Instance.new("Frame")
            dropList.BackgroundColor3 = Theme.Dropdown_BG
            dropList.Size = UDim2.new(1, 0, 0, #items * 30 + 8)
            dropList.Position = UDim2.new(0, 0, 1, 4)
            dropList.Visible = false
            dropList.ZIndex = 10
            dropList.Parent = card
            CreateCorner(dropList, 8)
            CreateStroke(dropList, Theme.Border)

            local dLayout = Instance.new("UIListLayout")
            dLayout.Padding = UDim.new(0, 2)
            dLayout.SortOrder = Enum.SortOrder.LayoutOrder
            dLayout.Parent = dropList
            local dPad = Instance.new("UIPadding")
            dPad.PaddingTop = UDim.new(0, 4)
            dPad.PaddingLeft = UDim.new(0, 4)
            dPad.PaddingRight = UDim.new(0, 4)
            dPad.Parent = dropList

            for _, item in ipairs(items) do
                local itemBtn = Instance.new("TextButton")
                itemBtn.BackgroundColor3 = Theme.Secondary
                itemBtn.Size = UDim2.new(1, 0, 0, 26)
                itemBtn.Text = "  " .. item
                itemBtn.TextColor3 = Theme.Text
                itemBtn.Font = Enum.Font.Gotham
                itemBtn.TextSize = 12
                itemBtn.TextXAlignment = Enum.TextXAlignment.Left
                itemBtn.ZIndex = 11
                itemBtn.Parent = dropList
                CreateCorner(itemBtn, 6)

                itemBtn.MouseButton1Click:Connect(function()
                    selected = item
                    selLbl.Text = item
                    isExpanded = false
                    dropList.Visible = false
                    arrowBtn.Text = "▼"
                    callback(item)
                end)
            end

            arrowBtn.MouseButton1Click:Connect(function()
                isExpanded = not isExpanded
                dropList.Visible = isExpanded
                arrowBtn.Text = isExpanded and "▲" or "▼"
            end)

            local DropAPI = {}
            function DropAPI:GetValue() return selected end
            function DropAPI:SetOptions(newOpts)
                items = newOpts
                for _, c in ipairs(dropList:GetChildren()) do
                    if c:IsA("TextButton") then c:Destroy() end
                end
                for _, item in ipairs(items) do
                    local itemBtn = Instance.new("TextButton")
                    itemBtn.BackgroundColor3 = Theme.Secondary
                    itemBtn.Size = UDim2.new(1, 0, 0, 26)
                    itemBtn.Text = "  " .. item
                    itemBtn.TextColor3 = Theme.Text
                    itemBtn.Font = Enum.Font.Gotham
                    itemBtn.TextSize = 12
                    itemBtn.TextXAlignment = Enum.TextXAlignment.Left
                    itemBtn.ZIndex = 11
                    itemBtn.Parent = dropList
                    CreateCorner(itemBtn, 6)
                    itemBtn.MouseButton1Click:Connect(function()
                        selected = item
                        selLbl.Text = item
                        isExpanded = false
                        dropList.Visible = false
                        arrowBtn.Text = "▼"
                        callback(item)
                    end)
                end
                dropList.Size = UDim2.new(1, 0, 0, #items * 30 + 8)
            end
            return DropAPI
        end

        -- ──────────────────────────────────────
        -- 📝 TextBox (Input)
        -- ──────────────────────────────────────
        function TabAPI:AddInput(opts3)
            opts3 = opts3 or {}
            local text       = opts3.Name or "Input"
            local placeholder= opts3.Placeholder or "พิมพ์ที่นี่..."
            local callback   = opts3.Callback or function() end

            local card = Instance.new("Frame")
            card.BackgroundColor3 = Theme.Secondary
            card.Size = UDim2.new(1, 0, 0, 60)
            card.Parent = tabFrame
            CreateCorner(card, 8)
            CreateStroke(card, Theme.Border)

            local nameLbl = Instance.new("TextLabel")
            nameLbl.BackgroundTransparency = 1
            nameLbl.Position = UDim2.new(0, 10, 0, 6)
            nameLbl.Size = UDim2.new(1, -20, 0, 16)
            nameLbl.Text = text
            nameLbl.TextColor3 = Theme.SubText
            nameLbl.Font = Enum.Font.Gotham
            nameLbl.TextSize = 11
            nameLbl.TextXAlignment = Enum.TextXAlignment.Left
            nameLbl.Parent = card

            local inputBG = Instance.new("Frame")
            inputBG.BackgroundColor3 = Theme.Input_BG
            inputBG.Size = UDim2.new(1, -20, 0, 28)
            inputBG.Position = UDim2.new(0, 10, 0, 26)
            inputBG.Parent = card
            CreateCorner(inputBG, 6)
            CreateStroke(inputBG, Theme.Border)

            local box = Instance.new("TextBox")
            box.BackgroundTransparency = 1
            box.Size = UDim2.new(1, -10, 1, 0)
            box.Position = UDim2.new(0, 6, 0, 0)
            box.PlaceholderText = placeholder
            box.PlaceholderColor3 = Theme.SubText
            box.TextColor3 = Theme.Text
            box.Font = Enum.Font.Gotham
            box.TextSize = 12
            box.TextXAlignment = Enum.TextXAlignment.Left
            box.ClearTextOnFocus = false
            box.Text = ""
            box.Parent = inputBG

            box.FocusLost:Connect(function(enter)
                if enter then callback(box.Text) end
            end)

            local InputAPI = {}
            function InputAPI:GetValue() return box.Text end
            function InputAPI:SetValue(v) box.Text = v end
            return InputAPI
        end

        return TabAPI
    end

    -- ═══════════════════════════════════════
    -- 🔔 Notify shortcut on WindowObj
    -- ═══════════════════════════════════════
    function WindowObj:Notify(opts2)
        EclipseLib:Notify(opts2)
    end

    return WindowObj
end

return EclipseLib
