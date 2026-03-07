-- 🌒 EclipseLib
-- Version: 5.4.0 (Refactored)
-- Theme: Dark but Radiant
-- GitHub: https://github.com/wino444/EclipseLib

-- ═══════════════════════════════════════════════════════════
-- 📦 Load Modules จาก GitHub raw
-- ═══════════════════════════════════════════════════════════
local BASE_URL = "https://raw.githubusercontent.com/wino444/EclipseLib/main/src/modules/"

local function LoadMod(name)
    return loadstring(game:HttpGet(BASE_URL .. name .. ".lua"))()
end

local Utility      = LoadMod("Utility")
local ThemeSystem  = LoadMod("ThemeSystem")
local ConfigSystem = LoadMod("ConfigSystem")
local Notification = LoadMod("Notification")
local Intro        = LoadMod("Intro")
local KeySystem    = LoadMod("KeySystem")

-- ═══════════════════════════════════════════════════════════
-- 🎨 Theme (live table — แก้ไขได้ตลอด)
-- ═══════════════════════════════════════════════════════════
local Theme = {}
for k, v in pairs(ThemeSystem.Default) do Theme[k] = v end

-- ═══════════════════════════════════════════════════════════
-- 🎬 Intro Config
-- ═══════════════════════════════════════════════════════════
local IntroConfig = {
    Mode     = "particle",  -- "fade" | "zoom" | "glitch" | "particle"
    Duration = 4,
    Icon     = "🌒",
}

-- ═══════════════════════════════════════════════════════════
-- 🛠️ Services
-- ═══════════════════════════════════════════════════════════
local Players          = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService     = game:GetService("TweenService")
local RunService       = game:GetService("RunService")
local LocalPlayer      = Players.LocalPlayer

-- ═══════════════════════════════════════════════════════════
-- 🧰 Shorthand Helpers (จาก Utility)
-- ═══════════════════════════════════════════════════════════
local Tween     = Utility.Tween
local TweenWait = Utility.TweenWait
local CC        = Utility.CC
local CS        = function(p, c, t) return Utility.CS(p, c, t, Theme) end

-- ═══════════════════════════════════════════════════════════
-- 🌒 EclipseLib Main Object
-- ═══════════════════════════════════════════════════════════
local EclipseLib = {}
EclipseLib.__index = EclipseLib

-- ─────────────────────────────
-- 🔔 Notify (ผ่าน queue)
-- ─────────────────────────────
function EclipseLib:Notify(opts)
    Notification.Notify(opts, Theme, Utility)
end

-- ═══════════════════════════════════════════════════════════
-- 🪟 CreateWindow
-- ═══════════════════════════════════════════════════════════
function EclipseLib:CreateWindow(opts)
    opts = opts or {}
    local windowName  = opts.Name             or "EclipseLib"
    local loadTitle   = opts.LoadingTitle     or "🌒 EclipseLib"
    local loadSub     = opts.LoadingSubtitle  or "กำลังโหลด..."
    local useKey      = opts.KeySystem        or false
    local cfgFolder   = (opts.ConfigurationSaving and opts.ConfigurationSaving.FolderName) or "EclipseLib"
    local keyOpts     = {
        Key            = opts.Key             or {},
        KeyTitle       = opts.KeyTitle        or "🔑 ใส่ Key",
        KeyDescription = opts.KeyDescription  or "กรอก Key เพื่อใช้งาน",
        KeyLink        = opts.KeyLink         or "",
        SaveFolder     = cfgFolder,
    }
    ConfigSystem:SetFolder(cfgFolder)

    -- ── Connection Table (cleanup ตอน Destroy) ──
    local _connections = {}
    local WindowObj = {}

    -- ─────────────────────────────
    -- 🖥️ ScreenGui
    -- ─────────────────────────────
    local ScreenGui = Utility.MakeScreenGui("__EclipseLib", 999)

    local Main = Instance.new("Frame")
    Main.BackgroundColor3 = Theme.Background
    Main.Size             = UDim2.new(0, 500, 0, 350)
    Main.Position         = UDim2.new(0.5, -250, 0.5, -175)
    Main.ClipsDescendants = true
    Main.Visible          = false
    Main.Parent           = ScreenGui
    CC(Main, 12); CS(Main, Theme.Border, 1.5)

    local TopBar = Instance.new("Frame")
    TopBar.BackgroundColor3 = Theme.Secondary
    TopBar.Size             = UDim2.new(1, 0, 0, 38)
    TopBar.Parent           = Main; CC(TopBar, 12)

    local tbFix = Instance.new("Frame")
    tbFix.BackgroundColor3 = Theme.Secondary
    tbFix.Size             = UDim2.new(1, 0, 0, 10)
    tbFix.Position         = UDim2.new(0, 0, 1, -10)
    tbFix.BorderSizePixel  = 0; tbFix.Parent = TopBar

    local TitleLbl = Instance.new("TextLabel")
    TitleLbl.BackgroundTransparency = 1
    TitleLbl.Position               = UDim2.new(0, 12, 0, 0)
    TitleLbl.Size                   = UDim2.new(1, -80, 1, 0)
    TitleLbl.Text                   = "🌒  " .. windowName
    TitleLbl.TextColor3             = Theme.Text
    TitleLbl.Font                   = Enum.Font.GothamBold
    TitleLbl.TextSize               = 14
    TitleLbl.TextXAlignment         = Enum.TextXAlignment.Left
    TitleLbl.Parent                 = TopBar

    local CloseBtn = Instance.new("TextButton")
    CloseBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
    CloseBtn.Size             = UDim2.new(0, 22, 0, 22)
    CloseBtn.Position         = UDim2.new(1, -30, 0.5, -11)
    CloseBtn.Text             = "✕"; CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseBtn.Font             = Enum.Font.GothamBold; CloseBtn.TextSize = 12
    CloseBtn.Parent           = TopBar; CC(CloseBtn, 6)

    local MinBtn = Instance.new("TextButton")
    MinBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    MinBtn.Size             = UDim2.new(0, 22, 0, 22)
    MinBtn.Position         = UDim2.new(1, -56, 0.5, -11)
    MinBtn.Text             = "—"; MinBtn.TextColor3 = Theme.Text
    MinBtn.Font             = Enum.Font.GothamBold; MinBtn.TextSize = 12
    MinBtn.Parent           = TopBar; CC(MinBtn, 6)

    Utility.MakeDraggable(Main, TopBar, _connections)

    local Body = Instance.new("Frame")
    Body.BackgroundTransparency = 1; Body.Position = UDim2.new(0, 0, 0, 38)
    Body.Size = UDim2.new(1, 0, 1, -38); Body.Parent = Main

    local TabBar = Instance.new("ScrollingFrame")
    TabBar.BackgroundColor3   = Theme.Secondary; TabBar.Size = UDim2.new(0, 115, 1, 0)
    TabBar.ScrollBarThickness = 2; TabBar.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabBar.ScrollingDirection = Enum.ScrollingDirection.Y; TabBar.Parent = Body
    CS(TabBar, Theme.Border, 1)

    local TL = Instance.new("UIListLayout")
    TL.SortOrder = Enum.SortOrder.LayoutOrder; TL.Padding = UDim.new(0, 4); TL.Parent = TabBar
    local TP = Instance.new("UIPadding")
    TP.PaddingTop = UDim.new(0, 6); TP.PaddingLeft = UDim.new(0, 5); TP.PaddingRight = UDim.new(0, 5); TP.Parent = TabBar
    table.insert(_connections, TL:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        TabBar.CanvasSize = UDim2.new(0, 0, 0, TL.AbsoluteContentSize.Y + 12)
    end))

    local ContentArea = Instance.new("Frame")
    ContentArea.BackgroundTransparency = 1; ContentArea.Position = UDim2.new(0, 119, 0, 0)
    ContentArea.Size = UDim2.new(1, -119, 1, 0); ContentArea.Parent = Body

    local isOpen = true
    table.insert(_connections, MinBtn.MouseButton1Click:Connect(function()
        isOpen = not isOpen
        Tween(Main, {Size = isOpen and UDim2.new(0,500,0,350) or UDim2.new(0,500,0,38)}, 0.3)
        MinBtn.Text = isOpen and "—" or "▲"
    end))

    -- ─────────────────────────────
    -- 📱 Floating Button
    -- ─────────────────────────────
    local floatSG = Utility.MakeScreenGui("__EclipseFloat", 998)
    local floatBtn = Instance.new("TextButton")
    floatBtn.BackgroundColor3 = Theme.Accent; floatBtn.Size = UDim2.new(0, 46, 0, 46)
    floatBtn.Position         = UDim2.new(0, 12, 0.5, -23); floatBtn.Text = "🌒"; floatBtn.TextSize = 22
    floatBtn.Font             = Enum.Font.GothamBold; floatBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    floatBtn.Visible          = false; floatBtn.Parent = floatSG; CC(floatBtn, 23); CS(floatBtn, Theme.Border, 1.5)
    Utility.MakeDraggable(floatBtn, floatBtn, _connections)

    table.insert(_connections, CloseBtn.MouseButton1Click:Connect(function()
        Tween(Main, {Size = UDim2.new(0,500,0,0)}, 0.25); task.wait(0.3)
        Main.Visible = false; floatBtn.Visible = true
    end))
    table.insert(_connections, floatBtn.MouseButton1Click:Connect(function()
        floatBtn.Visible = false; Main.Visible = true
        Main.Size = UDim2.new(0,500,0,0)
        Tween(Main, {Size = UDim2.new(0,500,0,350)}, 0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        isOpen = true; MinBtn.Text = "—"
    end))

    -- ─────────────────────────────
    -- 🎨 Theme Registry
    -- ─────────────────────────────
    local TR = ThemeSystem.NewRegistry()
    table.insert(TR.backgrounds, Main)
    table.insert(TR.secondaries, TopBar); table.insert(TR.secondaries, tbFix); table.insert(TR.secondaries, TabBar)
    table.insert(TR.accents, floatBtn); table.insert(TR.texts, TitleLbl)
    for _, v in ipairs(Main:GetDescendants()) do
        if v:IsA("UIStroke") then table.insert(TR.borders, v) end
    end

    local function ApplyThemeAll(th)
        ThemeSystem.ApplyAll(TR, th, tabButtons, activeTab, Theme, Tween)
    end
    local function RegBG(f)  table.insert(TR.backgrounds, f) end
    local function RegSec(f) table.insert(TR.secondaries, f) end
    local function RegAccent(f) table.insert(TR.accents, f) end
    local function RegBorder(s) table.insert(TR.borders, s) end
    local function RegText(l)   table.insert(TR.texts, l) end
    local function RegSub(l)    table.insert(TR.subtexts, l) end
    local function RegSlider(f) table.insert(TR.sliderFills, f) end

    -- ─────────────────────────────
    -- 🗂️ Tab System
    -- ─────────────────────────────
    local WindowObj  = {}
    local tabButtons = {}
    local tabFrames  = {}
    local activeTab  = nil

    local function SetActiveTab(name)
        for n, btn in pairs(tabButtons) do
            if n == name then Tween(btn, {BackgroundColor3 = Theme.TabActive}, 0.2); btn.TextColor3 = Color3.fromRGB(255,255,255)
            else Tween(btn, {BackgroundColor3 = Theme.TabInactive}, 0.2); btn.TextColor3 = Theme.SubText end
        end
        for n, f in pairs(tabFrames) do f.Visible = (n == name) end
        activeTab = name
    end

    local function MakeSF(name)
        local sf = Instance.new("ScrollingFrame")
        sf.Name = name; sf.BackgroundTransparency = 1; sf.Size = UDim2.new(1,0,1,0)
        sf.CanvasSize = UDim2.new(0,0,0,0); sf.ScrollBarThickness = 3
        sf.Visible = false; sf.Parent = ContentArea
        sf.ScrollBarImageColor3 = Theme.Accent
        local ly = Instance.new("UIListLayout"); ly.Padding = UDim.new(0,6); ly.SortOrder = Enum.SortOrder.LayoutOrder; ly.Parent = sf
        local pd = Instance.new("UIPadding"); pd.PaddingTop = UDim.new(0,8); pd.PaddingLeft = UDim.new(0,8); pd.PaddingRight = UDim.new(0,8); pd.Parent = sf
        table.insert(_connections, ly:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            sf.CanvasSize = UDim2.new(0, 0, 0, ly.AbsoluteContentSize.Y + 20)
        end))
        return sf
    end

    local function MakeTabBtn(label, active)
        local btn = Instance.new("TextButton")
        btn.BackgroundColor3 = active and Theme.TabActive or Theme.TabInactive
        btn.Size             = UDim2.new(1, 0, 0, 34); btn.Text = label
        btn.TextColor3       = active and Color3.fromRGB(255,255,255) or Theme.SubText
        btn.Font             = Enum.Font.GothamBold; btn.TextSize = 11
        btn.TextWrapped      = true; btn.Parent = TabBar; CC(btn, 8)
        RegSec(btn); return btn
    end

    -- ═══════════════════════════
    -- 🏠 Welcome Tab
    -- ═══════════════════════════
    do
        local wBtn = MakeTabBtn("🏠 ยินดีต้อนรับ", true)
        local wFrame = MakeSF("Frame_Welcome"); wFrame.Visible = true
        tabButtons["_Welcome"] = wBtn; tabFrames["_Welcome"] = wFrame; activeTab = "_Welcome"

        local aCard = Instance.new("Frame"); aCard.BackgroundColor3 = Theme.Secondary
        aCard.Size = UDim2.new(1,0,0,84); aCard.Parent = wFrame; CC(aCard,12); CS(aCard, Theme.Border)
        RegSec(aCard)

        local aFr = Instance.new("Frame"); aFr.BackgroundColor3 = Theme.Accent
        aFr.Size = UDim2.new(0,62,0,62); aFr.Position = UDim2.new(0,11,0.5,-31); aFr.Parent = aCard; CC(aFr,31)
        RegAccent(aFr)

        local aImg = Instance.new("ImageLabel"); aImg.BackgroundTransparency = 1
        aImg.Size = UDim2.new(1,-4,1,-4); aImg.Position = UDim2.new(0,2,0,2)
        aImg.Image = "https://www.roblox.com/headshot-thumbnail/image?userId="..tostring(LocalPlayer.UserId).."&width=150&height=150&format=png"
        aImg.Parent = aFr; CC(aImg, 29)

        local dN = Instance.new("TextLabel"); dN.BackgroundTransparency=1; dN.Position=UDim2.new(0,86,0,8)
        dN.Size=UDim2.new(1,-166,0,22); dN.Text=LocalPlayer.DisplayName or "?"; dN.TextColor3=Theme.Text
        dN.Font=Enum.Font.GothamBold; dN.TextSize=16; dN.TextXAlignment=Enum.TextXAlignment.Left; dN.Parent=aCard
        RegText(dN)

        local uN = Instance.new("TextLabel"); uN.BackgroundTransparency=1; uN.Position=UDim2.new(0,86,0,32)
        uN.Size=UDim2.new(1,-166,0,16); uN.Text="@"..(LocalPlayer.Name or "?"); uN.TextColor3=Theme.SubText
        uN.Font=Enum.Font.Gotham; uN.TextSize=12; uN.TextXAlignment=Enum.TextXAlignment.Left; uN.Parent=aCard
        RegSub(uN)

        -- Copy buttons
        local function MakeCopyBtn(parent, xPos, yPos, getCopyVal)
            local btn = Instance.new("TextButton"); btn.BackgroundColor3 = Theme.Secondary
            btn.Size = UDim2.new(0,60,0,20); btn.Position = UDim2.new(1,xPos,0,yPos)
            btn.Text = "📋 Copy"; btn.TextColor3 = Theme.Accent
            btn.Font = Enum.Font.GothamBold; btn.TextSize = 9; btn.Parent = parent
            CC(btn,5); CS(btn, Theme.Accent, 1)
            table.insert(_connections, btn.MouseButton1Click:Connect(function()
                Utility.SetClipboard(tostring(getCopyVal()))
                local old = btn.Text; btn.Text = "✅ แล้ว!"
                Tween(btn, {BackgroundColor3 = Color3.fromRGB(30,80,40)}, 0.1)
                task.wait(1.2); btn.Text = old; Tween(btn, {BackgroundColor3 = Theme.Secondary}, 0.15)
            end))
        end
        MakeCopyBtn(aCard, -68, 8, function() return LocalPlayer.DisplayName end)
        MakeCopyBtn(aCard, -68, 32, function() return LocalPlayer.Name end)

        -- Info Cards — แก้ไข: Cache MarketplaceService call
        local cachedMapName = nil
        local function MakeInfoCard(icon, label, valFn, copyable)
            local c = Instance.new("Frame"); c.BackgroundColor3 = Theme.Secondary
            c.Size = UDim2.new(1,0,0,54); c.Parent = wFrame; CC(c,10); CS(c, Theme.Border)
            RegSec(c)
            local iL = Instance.new("TextLabel"); iL.BackgroundTransparency=1; iL.Position=UDim2.new(0,8,0,0)
            iL.Size=UDim2.new(0,30,1,0); iL.Text=icon; iL.TextSize=20; iL.Font=Enum.Font.GothamBold; iL.Parent=c
            local kL = Instance.new("TextLabel"); kL.BackgroundTransparency=1; kL.Position=UDim2.new(0,44,0,7)
            kL.Size=UDim2.new(1,-120,0,16); kL.Text=label; kL.TextColor3=Theme.SubText
            kL.TextSize=10; kL.Font=Enum.Font.Gotham; kL.TextXAlignment=Enum.TextXAlignment.Left; kL.Parent=c
            RegSub(kL)
            local vL = Instance.new("TextLabel"); vL.BackgroundTransparency=1; vL.Position=UDim2.new(0,44,0,24)
            vL.Size=UDim2.new(1,-120,0,22); vL.Text=tostring(valFn()); vL.TextColor3=Theme.Text
            vL.TextSize=13; vL.Font=Enum.Font.GothamBold; vL.TextXAlignment=Enum.TextXAlignment.Left; vL.Parent=c
            RegText(vL)
            -- แก้ไข: อัปเดตเฉพาะ value เปลี่ยน (ทุก 0.5s แทน Heartbeat)
            task.spawn(function()
                while c.Parent do
                    local v = tostring(valFn())
                    if vL.Text ~= v then vL.Text = v end
                    task.wait(0.5)
                end
            end)
            if copyable then
                local cpBtn = Instance.new("TextButton"); cpBtn.BackgroundColor3 = Theme.Secondary
                cpBtn.Size = UDim2.new(0,60,0,22); cpBtn.Position = UDim2.new(1,-70,0.5,-11)
                cpBtn.Text = "📋 Copy"; cpBtn.TextColor3 = Theme.Accent
                cpBtn.Font = Enum.Font.GothamBold; cpBtn.TextSize = 9; cpBtn.Parent = c; CC(cpBtn,5); CS(cpBtn, Theme.Accent, 1)
                table.insert(_connections, cpBtn.MouseButton1Click:Connect(function()
                    Utility.SetClipboard(tostring(valFn()))
                    local old = cpBtn.Text; cpBtn.Text = "✅ แล้ว!"
                    Tween(cpBtn, {BackgroundColor3 = Color3.fromRGB(30,80,40)}, 0.1)
                    task.wait(1.2); cpBtn.Text = old; Tween(cpBtn, {BackgroundColor3 = Theme.Secondary}, 0.15)
                end))
            end
        end

        -- แก้ไข: Cache map name ไว้ ไม่เรียกซ้ำทุก frame
        MakeInfoCard("🗺️", "ชื่อแมพ", function()
            if cachedMapName then return cachedMapName end
            local name = ""
            pcall(function() name = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name end)
            if not name or name == "" then pcall(function() name = game.Name end) end
            if not name or name == "" then name = "ไม่พบชื่อแมพ" end
            cachedMapName = name
            return name
        end, true)
        MakeInfoCard("📍", "Place ID", function() return tostring(game.PlaceId) end, true)
        MakeInfoCard("⏳", "อายุบัญชี", function()
            local days = LocalPlayer.AccountAge or 0
            local years = math.floor(days/365); local remain = days-(years*365)
            local months = math.floor(remain/30); local d = remain-(months*30)
            local result = ""
            if years > 0 then result = result..years.." ปี " end
            if months > 0 then result = result..months.." เดือน " end
            return result..d.." วัน"
        end, false)
        MakeInfoCard("🖥️", "Server ID", function()
            local jid = game.JobId
            return (jid and jid ~= "") and jid or "ไม่พบ"
        end, true)

        local sessionStart = tick()
        MakeInfoCard("⏱️", "เวลาที่เล่น", function()
            local elapsed = math.floor(tick()-sessionStart)
            local d = math.floor(elapsed/86400); elapsed = elapsed-(d*86400)
            local h = math.floor(elapsed/3600); elapsed = elapsed-(h*3600)
            local m = math.floor(elapsed/60); local s = elapsed-(m*60)
            local result = ""
            if d > 0 then result = result..d.." วัน " end
            if h > 0 then result = result..h.." ชม. " end
            if m > 0 then result = result..m.." น. " end
            return result..s.." วิ"
        end, false)

        local creditCard = Instance.new("Frame"); creditCard.BackgroundColor3 = Theme.Secondary
        creditCard.Size = UDim2.new(1,0,0,36); creditCard.Parent = wFrame; CC(creditCard,10); CS(creditCard, Theme.Accent, 1.2)
        local creditL = Instance.new("TextLabel"); creditL.BackgroundTransparency=1; creditL.Size=UDim2.new(1,0,1,0)
        creditL.Text="🏷️  UI สร้างโดย wino444"; creditL.TextColor3=Theme.Accent
        creditL.Font=Enum.Font.GothamBold; creditL.TextSize=12; creditL.Parent=creditCard

        table.insert(_connections, wBtn.MouseButton1Click:Connect(function() SetActiveTab("_Welcome") end))
    end

    -- ═══════════════════════════
    -- ⚙️ Settings Tab
    -- ═══════════════════════════
    do
        local sBtn = MakeTabBtn("⚙️ ตั้งค่า UI", false)
        local sFrame = MakeSF("Frame_Settings")
        tabButtons["_Settings"] = sBtn; tabFrames["_Settings"] = sFrame
        table.insert(_connections, sBtn.MouseButton1Click:Connect(function() SetActiveTab("_Settings") end))

        local function SecTitle(text)
            local l = Instance.new("TextLabel"); l.BackgroundTransparency=1; l.Size=UDim2.new(1,0,0,22)
            l.Text=text; l.TextColor3=Theme.Accent; l.Font=Enum.Font.GothamBold; l.TextSize=12
            l.TextXAlignment=Enum.TextXAlignment.Left; l.Parent=sFrame
        end

        local DefaultTheme = {}
        for k, v in pairs(ThemeSystem.Default) do DefaultTheme[k] = v end

        -- Preset Themes
        SecTitle("🎨 Preset Themes")
        local thCard = Instance.new("Frame"); thCard.BackgroundColor3=Theme.Secondary
        thCard.Size=UDim2.new(1,0,0,120); thCard.Parent=sFrame; CC(thCard,8); CS(thCard, Theme.Border)
        local thLy = Instance.new("UIGridLayout"); thLy.CellSize=UDim2.new(0.31,0,0,48)
        thLy.CellPadding=UDim2.new(0.02,0,0,6); thLy.SortOrder=Enum.SortOrder.LayoutOrder; thLy.Parent=thCard
        local thPd = Instance.new("UIPadding"); thPd.PaddingTop=UDim.new(0,8); thPd.PaddingLeft=UDim.new(0,6); thPd.PaddingRight=UDim.new(0,6); thPd.Parent=thCard

        for _, th in ipairs(ThemeSystem.Presets) do
            local tb = Instance.new("TextButton"); tb.BackgroundColor3=th.bg; tb.Size=UDim2.new(1,0,1,0)
            tb.Text=th.name; tb.TextColor3=Color3.fromRGB(220,220,235); tb.Font=Enum.Font.GothamBold
            tb.TextSize=10; tb.TextWrapped=true; tb.Parent=thCard; CC(tb,7); CS(tb, th.accent, 1.5)
            table.insert(_connections, tb.MouseButton1Click:Connect(function()
                ApplyThemeAll({bg=th.bg, sec=th.sec, accent=th.accent, border=th.border, inactive=th.inactive, text=Theme.Text, subtext=Theme.SubText})
                EclipseLib:Notify({Title="🎨 เปลี่ยน Theme แล้ว", Content=th.name, Duration=2, Type="success"})
            end))
        end

        -- Config Save/Load
        SecTitle("💾 บันทึก / โหลด Config")
        local saveCard = Instance.new("Frame"); saveCard.BackgroundColor3=Theme.Secondary
        saveCard.Size=UDim2.new(1,0,0,182); saveCard.Parent=sFrame; CC(saveCard,10); CS(saveCard, Theme.Border)

        local snL = Instance.new("TextLabel"); snL.BackgroundTransparency=1; snL.Position=UDim2.new(0,10,0,8)
        snL.Size=UDim2.new(1,-20,0,14); snL.Text="📝 ชื่อไฟล์ใหม่"; snL.TextColor3=Theme.SubText
        snL.Font=Enum.Font.Gotham; snL.TextSize=11; snL.TextXAlignment=Enum.TextXAlignment.Left; snL.Parent=saveCard
        local nIBG = Instance.new("Frame"); nIBG.BackgroundColor3=Theme.Input_BG; nIBG.Size=UDim2.new(1,-20,0,28)
        nIBG.Position=UDim2.new(0,10,0,24); nIBG.Parent=saveCard; CC(nIBG,6); CS(nIBG, Theme.Border)
        local nBox = Instance.new("TextBox"); nBox.BackgroundTransparency=1; nBox.Size=UDim2.new(1,-10,1,0)
        nBox.Position=UDim2.new(0,6,0,0); nBox.PlaceholderText="พิมพ์ชื่อไฟล์..."; nBox.PlaceholderColor3=Theme.SubText
        nBox.TextColor3=Theme.Text; nBox.Font=Enum.Font.Gotham; nBox.TextSize=12
        nBox.TextXAlignment=Enum.TextXAlignment.Left; nBox.ClearTextOnFocus=false; nBox.Text=""; nBox.Parent=nIBG

        local saveNewBtn = Instance.new("TextButton"); saveNewBtn.BackgroundColor3=Theme.Accent
        saveNewBtn.Size=UDim2.new(1,-20,0,28); saveNewBtn.Position=UDim2.new(0,10,0,58)
        saveNewBtn.Text="💾 Save ใหม่"; saveNewBtn.TextColor3=Color3.fromRGB(255,255,255)
        saveNewBtn.Font=Enum.Font.GothamBold; saveNewBtn.TextSize=12; saveNewBtn.Parent=saveCard; CC(saveNewBtn,7)

        local sep = Instance.new("Frame"); sep.BackgroundColor3=Theme.Border
        sep.Size=UDim2.new(1,-20,0,1); sep.Position=UDim2.new(0,10,0,94); sep.BorderSizePixel=0; sep.Parent=saveCard

        local fileSelected = ""
        local cfgSt = Instance.new("TextLabel"); cfgSt.BackgroundTransparency=1; cfgSt.Position=UDim2.new(0,10,0,154)
        cfgSt.Size=UDim2.new(1,-20,0,18); cfgSt.Text=""; cfgSt.TextColor3=Color3.fromRGB(60,200,100)
        cfgSt.Font=Enum.Font.Gotham; cfgSt.TextSize=11; cfgSt.TextXAlignment=Enum.TextXAlignment.Left; cfgSt.Parent=saveCard

        local function ShowSt(msg, ok)
            cfgSt.Text = msg
            cfgSt.TextColor3 = ok and Color3.fromRGB(60,200,100) or Color3.fromRGB(200,80,60)
            task.delay(3, function() cfgSt.Text = "" end)
        end

        table.insert(_connections, saveNewBtn.MouseButton1Click:Connect(function()
            local name = nBox.Text
            if name == "" then ShowSt("❌ พิมพ์ชื่อไฟล์ก่อนนะ!", false); return end
            if ConfigSystem:Save(name) then
                ShowSt("✅ Save '"..name.."' สำเร็จ!", true); nBox.Text = ""
            else ShowSt("❌ Save ไม่สำเร็จ", false) end
        end))
    end

    -- ═══════════════════════════
    -- ➕ CreateTab (Public API)
    -- ═══════════════════════════
    function WindowObj:CreateTab(nameOrOpts, _icon)
        local tabName, tabIcon
        if type(nameOrOpts) == "string" then tabName = nameOrOpts; tabIcon = _icon or ""
        else tabName = nameOrOpts.Name or "Tab"; tabIcon = nameOrOpts.Icon or "" end
        local label = (tabIcon ~= "") and (tabIcon.." "..tabName) or tabName
        local tabBtn = MakeTabBtn(label, false)
        local tabFrame = MakeSF("Frame_"..tabName)
        tabButtons[tabName] = tabBtn; tabFrames[tabName] = tabFrame
        table.insert(_connections, tabBtn.MouseButton1Click:Connect(function() SetActiveTab(tabName) end))

        local TabAPI = {}
        local function BaseCard(h)
            local c = Instance.new("Frame"); c.BackgroundColor3 = Theme.Secondary
            c.Size = UDim2.new(1,0,0,h); c.Parent = tabFrame; CC(c,8); CS(c, Theme.Border)
            RegSec(c); return c
        end

        -- 🏷️ Label
        function TabAPI:AddLabel(o)
            o = o or {}; local l = Instance.new("TextLabel"); l.BackgroundTransparency=1
            l.Size=UDim2.new(1,0,0,24); l.Text=o.Text or ""; l.TextColor3=Theme.SubText
            l.Font=Enum.Font.Gotham; l.TextSize=12; l.TextXAlignment=Enum.TextXAlignment.Left
            l.TextWrapped=true; l.Parent=tabFrame; RegSub(l)
            local A = {}; function A:SetText(t) l.Text = t end; return A
        end

        -- 📂 Section
        function TabAPI:AddSection(o)
            o = o or {}
            local sf = Instance.new("Frame"); sf.BackgroundTransparency=1; sf.Size=UDim2.new(1,0,0,28); sf.Parent=tabFrame
            local line = Instance.new("Frame"); line.BackgroundColor3=Theme.Border; line.Size=UDim2.new(1,0,0,1)
            line.Position=UDim2.new(0,0,0.5,0); line.BorderSizePixel=0; line.Parent=sf
            RegBorder({Color=Theme.Border, _frame=line, _isPseudo=true})
            local bg2 = Instance.new("Frame"); bg2.BackgroundColor3=Theme.Background; bg2.AutomaticSize=Enum.AutomaticSize.X
            bg2.Size=UDim2.new(0,0,1,0); bg2.Parent=sf; RegBG(bg2)
            local sl2 = Instance.new("TextLabel"); sl2.BackgroundTransparency=1; sl2.AutomaticSize=Enum.AutomaticSize.X
            sl2.Size=UDim2.new(0,0,1,0); sl2.Text="  "..(o.Name or "Section").."  "
            sl2.TextColor3=Theme.Accent; sl2.Font=Enum.Font.GothamBold; sl2.TextSize=11; sl2.Parent=bg2; RegAccent(sl2)
        end

        -- 🔘 Button
        function TabAPI:AddButton(o)
            o = o or {}; local card = BaseCard(50)
            local nL = Instance.new("TextLabel"); nL.BackgroundTransparency=1; nL.Position=UDim2.new(0,10,0,6)
            nL.Size=UDim2.new(0.6,0,0,18); nL.Text=o.Name or "Button"; nL.TextColor3=Theme.Text
            nL.Font=Enum.Font.GothamBold; nL.TextSize=13; nL.TextXAlignment=Enum.TextXAlignment.Left; nL.Parent=card; RegText(nL)
            local dL = Instance.new("TextLabel"); dL.BackgroundTransparency=1; dL.Position=UDim2.new(0,10,0,26)
            dL.Size=UDim2.new(0.6,0,0,16); dL.Text=o.Description or ""; dL.TextColor3=Theme.SubText
            dL.Font=Enum.Font.Gotham; dL.TextSize=10; dL.TextXAlignment=Enum.TextXAlignment.Left; dL.Parent=card; RegSub(dL)
            if o.RealtimeValue then
                local rL = Instance.new("TextLabel"); rL.BackgroundTransparency=1; rL.Position=UDim2.new(0.58,0,0,6)
                rL.Size=UDim2.new(0.24,0,0,18); rL.Text=tostring(o.RealtimeValue()); rL.TextColor3=Theme.Accent
                rL.Font=Enum.Font.GothamBold; rL.TextSize=11; rL.TextXAlignment=Enum.TextXAlignment.Right; rL.Parent=card; RegAccent(rL)
                -- แก้ไข: ใช้ task loop แทน Heartbeat
                task.spawn(function()
                    while card.Parent do
                        local v = tostring(o.RealtimeValue())
                        if rL.Text ~= v then rL.Text = v end
                        task.wait(0.1)
                    end
                end)
            end
            local btn = Instance.new("TextButton"); btn.BackgroundColor3=Theme.Accent; btn.Size=UDim2.new(0,52,0,26)
            btn.Position=UDim2.new(1,-62,0.5,-13); btn.Text="▶ RUN"; btn.TextColor3=Color3.fromRGB(255,255,255)
            btn.Font=Enum.Font.GothamBold; btn.TextSize=10; btn.Parent=card; CC(btn,6)
            table.insert(_connections, btn.MouseButton1Click:Connect(function()
                Tween(btn,{BackgroundColor3=Theme.AccentHover},0.1); task.wait(0.1)
                Tween(btn,{BackgroundColor3=Theme.Accent},0.1); if o.Callback then o.Callback() end
            end))
        end

        -- 🔄 Toggle
        function TabAPI:AddToggle(o)
            o = o or {}; local state = o.Default or false; local card = BaseCard(50)
            local nL = Instance.new("TextLabel"); nL.BackgroundTransparency=1; nL.Position=UDim2.new(0,10,0,6)
            nL.Size=UDim2.new(0.7,0,0,18); nL.Text=o.Name or "Toggle"; nL.TextColor3=Theme.Text
            nL.Font=Enum.Font.GothamBold; nL.TextSize=13; nL.TextXAlignment=Enum.TextXAlignment.Left; nL.Parent=card; RegText(nL)
            local dL = Instance.new("TextLabel"); dL.BackgroundTransparency=1; dL.Position=UDim2.new(0,10,0,26)
            dL.Size=UDim2.new(0.7,0,0,16); dL.Text=o.Description or ""; dL.TextColor3=Theme.SubText
            dL.Font=Enum.Font.Gotham; dL.TextSize=10; dL.TextXAlignment=Enum.TextXAlignment.Left; dL.Parent=card; RegSub(dL)
            local sw = Instance.new("Frame"); sw.BackgroundColor3=state and Theme.Toggle_ON or Theme.Toggle_OFF
            sw.Size=UDim2.new(0,44,0,24); sw.Position=UDim2.new(1,-54,0.5,-12); sw.Parent=card; CC(sw,12)
            local kn = Instance.new("Frame"); kn.BackgroundColor3=Color3.fromRGB(255,255,255); kn.Size=UDim2.new(0,18,0,18)
            kn.Position=state and UDim2.new(1,-21,0.5,-9) or UDim2.new(0,3,0.5,-9); kn.Parent=sw; CC(kn,9)
            local ca = Instance.new("TextButton"); ca.BackgroundTransparency=1; ca.Size=UDim2.new(1,0,1,0); ca.Text=""; ca.Parent=card
            local function Apply(s)
                state = s; Tween(sw,{BackgroundColor3=s and Theme.Toggle_ON or Theme.Toggle_OFF},0.2)
                Tween(kn,{Position=s and UDim2.new(1,-21,0.5,-9) or UDim2.new(0,3,0.5,-9)},0.2)
                if o.Callback then o.Callback(s) end
            end
            table.insert(_connections, ca.MouseButton1Click:Connect(function() Apply(not state) end))
            if o.ConfigKey then ConfigSystem:Register(o.ConfigKey, function() return state end, function(v) Apply(v) end) end
            local A = {}; function A:SetState(s) Apply(s) end; function A:GetState() return state end; return A
        end

        -- 🎚️ Slider
        function TabAPI:AddSlider(o)
            o = o or {}; local mn = o.Min or 0; local mx = o.Max or 100
            local val = math.clamp(o.Default or mn, mn, mx); local card = BaseCard(60)
            local nL = Instance.new("TextLabel"); nL.BackgroundTransparency=1; nL.Position=UDim2.new(0,10,0,6)
            nL.Size=UDim2.new(0.7,0,0,18); nL.Text=o.Name or "Slider"; nL.TextColor3=Theme.Text
            nL.Font=Enum.Font.GothamBold; nL.TextSize=13; nL.TextXAlignment=Enum.TextXAlignment.Left; nL.Parent=card; RegText(nL)
            local vL = Instance.new("TextLabel"); vL.BackgroundTransparency=1; vL.Position=UDim2.new(0.7,0,0,6)
            vL.Size=UDim2.new(0.28,0,0,18); vL.Text=tostring(val); vL.TextColor3=Theme.Accent
            vL.Font=Enum.Font.GothamBold; vL.TextSize=13; vL.TextXAlignment=Enum.TextXAlignment.Right; vL.Parent=card; RegAccent(vL)
            local tr = Instance.new("Frame"); tr.BackgroundColor3=Theme.Slider_BG; tr.Size=UDim2.new(1,-20,0,8)
            tr.Position=UDim2.new(0,10,0,36); tr.Parent=card; CC(tr,4)
            local fi = Instance.new("Frame"); fi.BackgroundColor3=Theme.Slider_Fill
            fi.Size=UDim2.new((val-mn)/(mx-mn),0,1,0); fi.Parent=tr; CC(fi,4); RegSlider(fi)
            local drag = false
            local function upd(pos)
                local r = math.clamp((pos.X-tr.AbsolutePosition.X)/tr.AbsoluteSize.X, 0, 1)
                val = math.floor(mn+(mx-mn)*r); vL.Text = tostring(val); fi.Size = UDim2.new(r,0,1,0)
                if o.Callback then o.Callback(val) end
            end
            table.insert(_connections, tr.InputBegan:Connect(function(i)
                if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
                    drag = true; upd(i.Position) end end))
            table.insert(_connections, UserInputService.InputChanged:Connect(function(i)
                if drag and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then upd(i.Position) end end))
            table.insert(_connections, UserInputService.InputEnded:Connect(function(i)
                if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then drag = false end end))
            if o.ConfigKey then
                ConfigSystem:Register(o.ConfigKey, function() return val end, function(v)
                    val = math.clamp(v,mn,mx); local r = (val-mn)/(mx-mn)
                    fi.Size = UDim2.new(r,0,1,0); vL.Text = tostring(val); if o.Callback then o.Callback(val) end
                end)
            end
            local A = {}
            function A:GetValue() return val end
            function A:SetValue(v) val=math.clamp(v,mn,mx); local r=(val-mn)/(mx-mn); fi.Size=UDim2.new(r,0,1,0); vL.Text=tostring(val); if o.Callback then o.Callback(val) end end
            return A
        end

        -- 🔽 Dropdown
        function TabAPI:AddDropdown(o)
            o = o or {}; local items = o.Options or {}; local sel = o.Default or (items[1] or ""); local exp = false
            local wr = Instance.new("Frame"); wr.BackgroundTransparency=1; wr.Size=UDim2.new(1,0,0,46)
            wr.ClipsDescendants=false; wr.Parent=tabFrame
            local card = Instance.new("Frame"); card.BackgroundColor3=Theme.Secondary; card.Size=UDim2.new(1,0,0,46)
            card.ClipsDescendants=false; card.Parent=wr; CC(card,8); CS(card, Theme.Border); RegSec(card)
            local nL = Instance.new("TextLabel"); nL.BackgroundTransparency=1; nL.Position=UDim2.new(0,10,0,6)
            nL.Size=UDim2.new(0.55,0,0,14); nL.Text=o.Name or "Dropdown"; nL.TextColor3=Theme.SubText
            nL.Font=Enum.Font.Gotham; nL.TextSize=11; nL.TextXAlignment=Enum.TextXAlignment.Left; nL.Parent=card; RegSub(nL)
            local sL = Instance.new("TextLabel"); sL.BackgroundTransparency=1; sL.Position=UDim2.new(0,10,0,22)
            sL.Size=UDim2.new(0.65,0,0,18); sL.Text=sel; sL.TextColor3=Theme.Text
            sL.Font=Enum.Font.GothamBold; sL.TextSize=13; sL.TextXAlignment=Enum.TextXAlignment.Left; sL.Parent=card; RegText(sL)
            local ab = Instance.new("TextButton"); ab.BackgroundColor3=Theme.Accent; ab.Size=UDim2.new(0,30,0,30)
            ab.Position=UDim2.new(1,-40,0.5,-15); ab.Text="▼"; ab.TextColor3=Color3.fromRGB(255,255,255)
            ab.Font=Enum.Font.GothamBold; ab.TextSize=12; ab.Parent=card; CC(ab,6)
            local maxH = 150
            local dl = Instance.new("ScrollingFrame"); dl.BackgroundColor3=Theme.Dropdown_BG
            dl.Position=UDim2.new(0,0,1,4); dl.Visible=false; dl.ZIndex=10; dl.Parent=card
            dl.ScrollBarThickness=3; dl.ScrollBarImageColor3=Theme.Accent; dl.ScrollingDirection=Enum.ScrollingDirection.Y
            dl.CanvasSize=UDim2.new(0,0,0,0); dl.ClipsDescendants=true; CC(dl,8); CS(dl, Theme.Border)
            local dly = Instance.new("UIListLayout"); dly.Padding=UDim.new(0,2); dly.SortOrder=Enum.SortOrder.LayoutOrder; dly.Parent=dl
            local dp = Instance.new("UIPadding"); dp.PaddingTop=UDim.new(0,4); dp.PaddingLeft=UDim.new(0,4); dp.PaddingRight=UDim.new(0,4); dp.Parent=dl
            local function Pop()
                for _, c in ipairs(dl:GetChildren()) do if c:IsA("TextButton") then c:Destroy() end end
                for _, item in ipairs(items) do
                    local ib = Instance.new("TextButton"); ib.BackgroundColor3=Theme.Secondary
                    ib.Size=UDim2.new(1,0,0,26); ib.Text="  "..item; ib.TextColor3=Theme.Text
                    ib.Font=Enum.Font.Gotham; ib.TextSize=12; ib.TextXAlignment=Enum.TextXAlignment.Left; ib.ZIndex=11; ib.Parent=dl; CC(ib,6)
                    ib.MouseButton1Click:Connect(function()
                        sel=item; sL.Text=item; exp=false; dl.Visible=false; ab.Text="▼"
                        if o.Callback then o.Callback(item) end
                    end)
                end
                local totalH = math.min(#items*30+8, maxH)
                dl.Size = UDim2.new(1,0,0,totalH); dl.CanvasSize = UDim2.new(0,0,0,#items*30+8)
            end
            Pop()
            -- แก้ไข: ปิด dropdown อื่นก่อนเปิด (close-all pattern)
            table.insert(_connections, ab.MouseButton1Click:Connect(function()
                exp = not exp; if exp then Pop() end; dl.Visible = exp; ab.Text = exp and "▲" or "▼"
            end))
            if o.ConfigKey then ConfigSystem:Register(o.ConfigKey, function() return sel end, function(v) sel=v; sL.Text=v; if o.Callback then o.Callback(v) end end) end
            local A = {}; function A:GetValue() return sel end
            function A:SetOptions(n) items=n; Pop() end; return A
        end

        -- 📝 Input
        function TabAPI:AddInput(o)
            o = o or {}; local card = BaseCard(60)
            local nL = Instance.new("TextLabel"); nL.BackgroundTransparency=1; nL.Position=UDim2.new(0,10,0,6)
            nL.Size=UDim2.new(1,-20,0,16); nL.Text=o.Name or "Input"; nL.TextColor3=Theme.SubText
            nL.Font=Enum.Font.Gotham; nL.TextSize=11; nL.TextXAlignment=Enum.TextXAlignment.Left; nL.Parent=card; RegSub(nL)
            local iBG = Instance.new("Frame"); iBG.BackgroundColor3=Theme.Input_BG; iBG.Size=UDim2.new(1,-20,0,28)
            iBG.Position=UDim2.new(0,10,0,26); iBG.Parent=card; CC(iBG,6); CS(iBG, Theme.Border)
            local box = Instance.new("TextBox"); box.BackgroundTransparency=1; box.Size=UDim2.new(1,-10,1,0)
            box.Position=UDim2.new(0,6,0,0); box.PlaceholderText=o.Placeholder or "พิมพ์ที่นี่..."
            box.PlaceholderColor3=Theme.SubText; box.TextColor3=Theme.Text; box.Font=Enum.Font.Gotham
            box.TextSize=12; box.TextXAlignment=Enum.TextXAlignment.Left
            box.ClearTextOnFocus=false; box.Text=""; box.Parent=iBG
            table.insert(_connections, box.FocusLost:Connect(function(enter) if enter and o.Callback then o.Callback(box.Text) end end))
            local A = {}; function A:GetValue() return box.Text end; function A:SetValue(v) box.Text=v end; return A
        end

        -- 📄 Paragraph — แก้ไข: AutomaticSize
        function TabAPI:AddParagraph(o)
            o = o or {}
            local card = Instance.new("Frame"); card.BackgroundColor3=Theme.Secondary
            card.AutomaticSize=Enum.AutomaticSize.Y; card.Size=UDim2.new(1,0,0,0); card.Parent=tabFrame; CC(card,8); CS(card, Theme.Border); RegSec(card)
            local tL = Instance.new("TextLabel"); tL.BackgroundTransparency=1; tL.Position=UDim2.new(0,10,0,8)
            tL.Size=UDim2.new(1,-20,0,18); tL.Text=o.Title or ""; tL.TextColor3=Theme.Text
            tL.Font=Enum.Font.GothamBold; tL.TextSize=13; tL.TextXAlignment=Enum.TextXAlignment.Left; tL.Parent=card; RegText(tL)
            local sep = Instance.new("Frame"); sep.BackgroundColor3=Theme.Border; sep.Size=UDim2.new(1,-20,0,1)
            sep.Position=UDim2.new(0,10,0,28); sep.BorderSizePixel=0; sep.Parent=card
            local cL = Instance.new("TextLabel"); cL.BackgroundTransparency=1; cL.Position=UDim2.new(0,10,0,32)
            cL.Size=UDim2.new(1,-20,0,0); cL.AutomaticSize=Enum.AutomaticSize.Y
            cL.Text=o.Content or ""; cL.TextColor3=Theme.SubText; cL.Font=Enum.Font.Gotham
            cL.TextSize=12; cL.TextXAlignment=Enum.TextXAlignment.Left; cL.TextWrapped=true; cL.Parent=card; RegSub(cL)
            local pad = Instance.new("Frame"); pad.BackgroundTransparency=1; pad.Size=UDim2.new(1,0,0,10); pad.Parent=card
            local A = {}
            function A:SetTitle(t) tL.Text = t end
            function A:SetContent(t) cL.Text = t end
            return A
        end

        -- 📊 ProgressBar
        function TabAPI:AddProgressBar(o)
            o = o or {}; local maxVal = o.Max or 100; local valFn = o.Value or function() return 0 end
            local card = BaseCard(54)
            local nL = Instance.new("TextLabel"); nL.BackgroundTransparency=1; nL.Position=UDim2.new(0,10,0,6)
            nL.Size=UDim2.new(0.7,0,0,16); nL.Text=o.Name or "Progress"; nL.TextColor3=Theme.Text
            nL.Font=Enum.Font.GothamBold; nL.TextSize=13; nL.TextXAlignment=Enum.TextXAlignment.Left; nL.Parent=card; RegText(nL)
            local vL = Instance.new("TextLabel"); vL.BackgroundTransparency=1; vL.Position=UDim2.new(0.7,0,0,6)
            vL.Size=UDim2.new(0.28,0,0,16); vL.Text="0/"..tostring(maxVal); vL.TextColor3=Theme.Accent
            vL.Font=Enum.Font.GothamBold; vL.TextSize=11; vL.TextXAlignment=Enum.TextXAlignment.Right; vL.Parent=card; RegAccent(vL)
            local barBG = Instance.new("Frame"); barBG.BackgroundColor3=Theme.Slider_BG; barBG.Size=UDim2.new(1,-20,0,10)
            barBG.Position=UDim2.new(0,10,0,30); barBG.Parent=card; CC(barBG,5)
            local barFill = Instance.new("Frame"); barFill.BackgroundColor3=Theme.Accent
            barFill.Size=UDim2.new(0,0,1,0); barFill.Parent=barBG; CC(barFill,5); RegSlider(barFill)
            -- แก้ไข: task loop แทน Heartbeat
            task.spawn(function()
                while card.Parent do
                    local cur = 0; pcall(function() cur = valFn() end); cur = math.clamp(cur, 0, maxVal)
                    local pct = cur/maxVal; barFill.Size = UDim2.new(pct,0,1,0)
                    local txt = math.floor(cur).."/"..tostring(maxVal); if vL.Text ~= txt then vL.Text = txt end
                    barFill.BackgroundColor3 = pct>0.6 and Color3.fromRGB(60,180,100) or pct>0.3 and Color3.fromRGB(200,160,40) or Color3.fromRGB(200,60,60)
                    task.wait(0.1)
                end
            end)
        end

        return TabAPI
    end

    -- ═══════════════════════════
    -- 🪟 Window API
    -- ═══════════════════════════
    function WindowObj:Notify(o) EclipseLib:Notify(o) end

    function WindowObj:Show()
        Main.Visible = true; Main.Size = UDim2.new(0,500,0,0)
        Tween(Main, {Size=UDim2.new(0,500,0,350)}, 0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        floatBtn.Visible = false; isOpen = true; MinBtn.Text = "—"
    end
    function WindowObj:Hide()
        Tween(Main, {Size=UDim2.new(0,500,0,0)}, 0.25)
        task.delay(0.3, function() Main.Visible=false; floatBtn.Visible=true end)
    end
    function WindowObj:Toggle()
        if Main.Visible then self:Hide() else self:Show() end
    end

    -- แก้ไข: Destroy cleanup connections ทั้งหมด
    function WindowObj:Destroy()
        for _, c in ipairs(_connections) do pcall(function() c:Disconnect() end) end
        pcall(function() ScreenGui:Destroy() end)
        pcall(function() floatSG:Destroy() end)
        pcall(function()
            local holder = Notification.GetHolder()
            if holder and holder.Parent then holder.Parent:Destroy() end
        end)
    end

    -- ─────────────────────────────
    -- 🚀 Open Main UI
    -- ─────────────────────────────
    local function OpenMainUI()
        Main.Visible = true; Main.Size = UDim2.new(0,500,0,0)
        Tween(Main, {Size=UDim2.new(0,500,0,350)}, 0.45, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        task.wait(0.5)
        EclipseLib:Notify({Title="🌒 "..windowName, Content="โหลดสำเร็จแล้ว! ✨", Duration=3, Type="success"})
    end

    local introSG = Utility.MakeScreenGui("__EclipseIntro", 10000)
    if useKey then
        Intro.Play(IntroConfig.Mode, introSG, loadTitle, loadSub, IntroConfig.Icon, Theme, Tween, TweenWait,
            function() KeySystem.Show(keyOpts, Theme, Utility, function() OpenMainUI() end) end)
    else
        Intro.Play(IntroConfig.Mode, introSG, loadTitle, loadSub, IntroConfig.Icon, Theme, Tween, TweenWait,
            function() OpenMainUI() end)
    end

    return WindowObj
end

return EclipseLib
