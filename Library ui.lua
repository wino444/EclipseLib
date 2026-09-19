--[[
    🌒 EclipseLib — v6.5.2 Rainbow Fix Edition
    ═══════════════════════════════════════════
    Fixes:
    - ✅ Welcome Tab Locked (อยู่บนสุดของ TabBar)
    - ✅ Tab Alignment ถูกต้อง
    - ✅ Settings ⚙️ บน TopBar
    - ✅ Rainbow 100% — ทุก component เปลี่ยนสี
    - ✅ BG สว่างขึ้น มองเห็นชัด
    - ✅ Tab Indicator ใหญ่ขึ้น + Glow (แก้ใหม่)
    ═══════════════════════════════════════════
]]

local EclipseLib = {}
EclipseLib.__index = EclipseLib

local IntroConfig = { Mode = "particle", Duration = 4, Icon = "🌒" }

local Theme = {
    Background=Color3.fromRGB(12,10,18), Secondary=Color3.fromRGB(20,17,30),
    Accent=Color3.fromRGB(120,70,230), AccentHover=Color3.fromRGB(148,98,255),
    Text=Color3.fromRGB(232,226,248), SubText=Color3.fromRGB(152,142,180),
    Border=Color3.fromRGB(62,46,105), TabActive=Color3.fromRGB(120,70,230),
    TabInactive=Color3.fromRGB(28,24,44), Toggle_ON=Color3.fromRGB(120,70,230),
    Toggle_OFF=Color3.fromRGB(55,48,78), Slider_Fill=Color3.fromRGB(120,70,230),
    Slider_BG=Color3.fromRGB(38,33,60), Notif_BG=Color3.fromRGB(16,13,26),
    Notif_Border=Color3.fromRGB(120,70,230), Input_BG=Color3.fromRGB(24,20,40),
    Dropdown_BG=Color3.fromRGB(22,18,36),
}

local Rainbow = {}
Rainbow.Colors = {
    Red=Color3.fromRGB(255,60,60), Orange=Color3.fromRGB(255,150,40),
    Yellow=Color3.fromRGB(255,235,60), Green=Color3.fromRGB(60,220,100),
    Cyan=Color3.fromRGB(60,220,220), Blue=Color3.fromRGB(60,130,255),
    Purple=Color3.fromRGB(170,80,255), Pink=Color3.fromRGB(255,100,200),
}
Rainbow.ColorSequence = ColorSequence.new({
    ColorSequenceKeypoint.new(0.00, Rainbow.Colors.Red),
    ColorSequenceKeypoint.new(0.14, Rainbow.Colors.Orange),
    ColorSequenceKeypoint.new(0.28, Rainbow.Colors.Yellow),
    ColorSequenceKeypoint.new(0.42, Rainbow.Colors.Green),
    ColorSequenceKeypoint.new(0.57, Rainbow.Colors.Cyan),
    ColorSequenceKeypoint.new(0.71, Rainbow.Colors.Blue),
    ColorSequenceKeypoint.new(0.85, Rainbow.Colors.Purple),
    ColorSequenceKeypoint.new(1.00, Rainbow.Colors.Red),
})
Rainbow.Animators = {}
Rainbow.HueColor = function(h) return Color3.fromHSV(h % 1, 0.85, 0.95) end

local function getService(name)
    local service = game:GetService(name)
    return if cloneref then cloneref(service) else service
end

local Players = getService("Players")
local UserInputService = getService("UserInputService")
local TweenService = getService("TweenService")
local RunService = getService("RunService")
local CoreGui = getService("CoreGui")
local HttpService = getService("HttpService")
local LocalPlayer = Players.LocalPlayer

local function Tween(obj, props, t, style, dir)
    local tw = TweenService:Create(obj, TweenInfo.new(t or 0.2, style or Enum.EasingStyle.Quad, dir or Enum.EasingDirection.Out), props)
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
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true; dragStart = input.Position; startPos = frame.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local d = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end
    end)
end

local function CC(p, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, r or 8)
    c.Parent = p
    return c
end

local function CS(p, color, t)
    local s = Instance.new("UIStroke")
    s.Color = color or Theme.Border
    s.Thickness = t or 1
    s.Parent = p
    return s
end

local function SetClipboard(text)
    pcall(function()
        if setclipboard then setclipboard(text)
        elseif toclipboard then toclipboard(text)
        elseif Clipboard then Clipboard.set(text) end
    end)
end

local SCREEN_GUI_FALLBACK = false

local function MakeScreenGui(name, order)
    local sg = Instance.new("ScreenGui")
    sg.Name = name
    sg.ResetOnSpawn = false
    sg.IgnoreGuiInset = true
    sg.DisplayOrder = order or 999
    local coreOk = pcall(function() sg.Parent = CoreGui end)
    if coreOk and sg.Parent then return sg end
    if gethui then
        local hiddenOK = pcall(function() sg.Parent = gethui() end)
        if hiddenOK and sg.Parent then return sg end
    end
    if not SCREEN_GUI_FALLBACK then
        warn("[EclipseLib] ⚠️ CoreGui ไม่พร้อม — ใช้ PlayerGui แทน")
        SCREEN_GUI_FALLBACK = true
    end
    pcall(function() sg.Parent = LocalPlayer:WaitForChild("PlayerGui", 3) end)
    return sg
end

local UI = {}

function UI.Label(parent, opts)
    opts = opts or {}
    local l = Instance.new("TextLabel")
    l.BackgroundTransparency = 1
    l.Position = opts.Position or UDim2.new(0,10,0,6)
    l.Size = opts.Size or UDim2.new(1,-20,0,18)
    l.Text = opts.Text or ""
    l.TextColor3 = opts.Color or Theme.Text
    l.Font = opts.Font or Enum.Font.GothamBold
    l.TextSize = opts.TextSize or 13
    l.TextXAlignment = opts.Align or Enum.TextXAlignment.Left
    l.TextYAlignment = opts.YAlign or Enum.TextYAlignment.Center
    l.TextWrapped = opts.Wrap or false
    l.ZIndex = opts.Z or 1
    l.Parent = parent
    return l
end

function UI.Frame(parent, opts)
    opts = opts or {}
    local f = Instance.new("Frame")
    f.BackgroundColor3 = opts.BG or Theme.Secondary
    f.BackgroundTransparency = opts.Transparency or 0
    f.Size = opts.Size or UDim2.new(1,0,0,50)
    f.Position = opts.Position or UDim2.new(0,0,0,0)
    f.BorderSizePixel = 0
    f.ZIndex = opts.Z or 1
    f.ClipsDescendants = opts.Clips or false
    f.Parent = parent
    if opts.Radius then CC(f, opts.Radius) end
    if opts.Stroke then CS(f, opts.StrokeColor or Theme.Border, opts.StrokeSize or 1) end
    return f
end

function UI.Scroll(parent, opts)
    opts = opts or {}
    local s = Instance.new("ScrollingFrame")
    s.BackgroundTransparency = opts.Transparency or 1
    s.BackgroundColor3 = opts.BG or Theme.Secondary
    s.Size = opts.Size or UDim2.new(1,0,1,0)
    s.Position = opts.Position or UDim2.new(0,0,0,0)
    s.BorderSizePixel = 0
    s.ScrollBarThickness = opts.ScrollThickness or 3
    s.ScrollBarImageColor3 = opts.ScrollColor or Theme.Accent
    s.CanvasSize = UDim2.new(0,0,0,0)
    s.ScrollingDirection = opts.Direction or Enum.ScrollingDirection.Y
    s.ZIndex = opts.Z or 1
    s.Parent = parent
    if opts.Radius then CC(s, opts.Radius) end
    if opts.Stroke then CS(s, opts.StrokeColor or Theme.Border, opts.StrokeSize or 1) end
    return s
end

function UI.Button(parent, opts)
    opts = opts or {}
    local b = Instance.new("TextButton")
    b.BackgroundColor3 = opts.BG or Theme.Accent
    b.BackgroundTransparency = opts.Transparency or 0
    b.Size = opts.Size or UDim2.new(0,80,0,28)
    b.Position = opts.Position or UDim2.new(1,-90,0.5,-14)
    b.Text = opts.Text or "Button"
    b.TextColor3 = opts.Color or Color3.fromRGB(255,255,255)
    b.Font = opts.Font or Enum.Font.GothamBold
    b.TextSize = opts.TextSize or 12
    b.TextWrapped = opts.Wrap or false
    b.AutoButtonColor = opts.AutoButton ~= false
    b.ZIndex = opts.Z or 1
    b.Parent = parent
    CC(b, opts.Radius or 7)
    if opts.Stroke then CS(b, opts.StrokeColor or Theme.Border, opts.StrokeSize or 1) end
    return b
end

function UI.TextBox(parent, opts)
    opts = opts or {}
    local bg = UI.Frame(parent, {
        BG = opts.BG or Theme.Input_BG,
        Size = opts.Size or UDim2.new(1,-20,0,28),
        Position = opts.Position or UDim2.new(0,10,0,26),
        Radius = 6, Stroke = true,
    })
    local box = Instance.new("TextBox")
    box.BackgroundTransparency = 1
    box.Size = UDim2.new(1,-12,1,0)
    box.Position = UDim2.new(0,6,0,0)
    box.PlaceholderText = opts.Placeholder or "..."
    box.PlaceholderColor3 = Theme.SubText
    box.TextColor3 = Theme.Text
    box.Font = opts.Font or Enum.Font.Gotham
    box.TextSize = opts.TextSize or 12
    box.TextXAlignment = opts.Align or Enum.TextXAlignment.Left
    box.TextYAlignment = opts.YAlign or Enum.TextYAlignment.Center
    box.ClearTextOnFocus = false
    box.MultiLine = opts.MultiLine or false
    box.TextWrapped = opts.Wrap or false
    box.Text = opts.Value or ""
    box.ZIndex = 2
    box.Parent = bg
    return box, bg
end

function UI.Image(parent, opts)
    opts = opts or {}
    local i = Instance.new("ImageLabel")
    i.BackgroundTransparency = opts.Transparency or 1
    i.BackgroundColor3 = opts.BG or Theme.Input_BG
    i.Size = opts.Size or UDim2.new(1,-4,1,-4)
    i.Position = opts.Position or UDim2.new(0,2,0,2)
    i.Image = opts.Image or ""
    i.ScaleType = opts.ScaleType or Enum.ScaleType.Fit
    i.ZIndex = opts.Z or 1
    i.Parent = parent
    if opts.Radius then CC(i, opts.Radius) end
    return i
end

function UI.Layout(parent, opts)
    opts = opts or {}
    local l = Instance.new("UIListLayout")
    l.Padding = opts.Padding or UDim.new(0, 6)
    l.SortOrder = opts.Sort or Enum.SortOrder.LayoutOrder
    l.FillDirection = opts.Direction or Enum.FillDirection.Vertical
    l.HorizontalAlignment = opts.HAlign or Enum.HorizontalAlignment.Left
    l.VerticalAlignment = opts.VAlign or Enum.VerticalAlignment.Top
    l.Parent = parent
    return l
end

function UI.Padding(parent, opts)
    opts = opts or {}
    local p = Instance.new("UIPadding")
    if opts.Top then p.PaddingTop = opts.Top end
    if opts.Bottom then p.PaddingBottom = opts.Bottom end
    if opts.Left then p.PaddingLeft = opts.Left end
    if opts.Right then p.PaddingRight = opts.Right end
    p.Parent = parent
    return p
end

function UI.Grid(parent, opts)
    opts = opts or {}
    local g = Instance.new("UIGridLayout")
    g.CellSize = opts.CellSize or UDim2.new(0, 82, 0, 46)
    g.CellPadding = opts.CellPadding or UDim2.new(0, 6, 0, 6)
    g.SortOrder = opts.Sort or Enum.SortOrder.LayoutOrder
    if opts.MaxCells then g.FillDirectionMaxCells = opts.MaxCells end
    g.Parent = parent
    return g
end

function Rainbow.Attach(obj, opts)
    opts = opts or {}
    local speed = opts.Speed or 30
    local rotation = opts.Rotation or "h"
    local grad = obj:FindFirstChildOfClass("UIGradient")
    if not grad then grad = Instance.new("UIGradient"); grad.Parent = obj end
    grad.Color = Rainbow.ColorSequence
    local baseRot = 0
    if rotation == "v" then baseRot = 90
    elseif rotation == "d" then baseRot = 45 end
    grad.Rotation = baseRot
    if opts.AutoStart == false then return grad end
    local angle = 0
    local conn = RunService.RenderStepped:Connect(function(dt)
        angle = (angle + speed * dt) % 360
        grad.Rotation = baseRot + angle
    end)
    Rainbow.Animators[obj] = conn
    return grad, conn
end

function Rainbow.Detach(obj)
    if Rainbow.Animators[obj] then
        Rainbow.Animators[obj]:Disconnect()
        Rainbow.Animators[obj] = nil
    end
end

EclipseLib.Themes = {
    Eclipse = { Background=Color3.fromRGB(12,10,18), Secondary=Color3.fromRGB(20,17,30), Accent=Color3.fromRGB(120,70,230), AccentHover=Color3.fromRGB(148,98,255), Text=Color3.fromRGB(232,226,248), SubText=Color3.fromRGB(152,142,180), Border=Color3.fromRGB(62,46,105), TabActive=Color3.fromRGB(120,70,230), TabInactive=Color3.fromRGB(28,24,44), Toggle_ON=Color3.fromRGB(120,70,230), Toggle_OFF=Color3.fromRGB(55,48,78), Slider_Fill=Color3.fromRGB(120,70,230), Slider_BG=Color3.fromRGB(38,33,60), Notif_BG=Color3.fromRGB(16,13,26), Notif_Border=Color3.fromRGB(120,70,230), Input_BG=Color3.fromRGB(24,20,40), Dropdown_BG=Color3.fromRGB(22,18,36) },
    Ocean = { Background=Color3.fromRGB(8,14,26), Secondary=Color3.fromRGB(12,22,42), Accent=Color3.fromRGB(35,145,255), AccentHover=Color3.fromRGB(65,170,255), Text=Color3.fromRGB(215,235,255), SubText=Color3.fromRGB(120,165,215), Border=Color3.fromRGB(22,68,128), TabActive=Color3.fromRGB(35,145,255), TabInactive=Color3.fromRGB(15,30,58), Toggle_ON=Color3.fromRGB(35,145,255), Toggle_OFF=Color3.fromRGB(22,48,88), Slider_Fill=Color3.fromRGB(35,145,255), Slider_BG=Color3.fromRGB(16,36,68), Notif_BG=Color3.fromRGB(10,18,36), Notif_Border=Color3.fromRGB(35,145,255), Input_BG=Color3.fromRGB(14,26,52), Dropdown_BG=Color3.fromRGB(12,22,46) },
    Forest = { Background=Color3.fromRGB(8,14,10), Secondary=Color3.fromRGB(12,24,16), Accent=Color3.fromRGB(48,195,105), AccentHover=Color3.fromRGB(70,215,125), Text=Color3.fromRGB(215,242,222), SubText=Color3.fromRGB(120,178,138), Border=Color3.fromRGB(26,85,45), TabActive=Color3.fromRGB(48,195,105), TabInactive=Color3.fromRGB(15,34,22), Toggle_ON=Color3.fromRGB(48,195,105), Toggle_OFF=Color3.fromRGB(22,52,32), Slider_Fill=Color3.fromRGB(48,195,105), Slider_BG=Color3.fromRGB(16,40,24), Notif_BG=Color3.fromRGB(10,18,13), Notif_Border=Color3.fromRGB(48,195,105), Input_BG=Color3.fromRGB(14,28,18), Dropdown_BG=Color3.fromRGB(12,24,16) },
    Inferno = { Background=Color3.fromRGB(16,8,5), Secondary=Color3.fromRGB(26,13,8), Accent=Color3.fromRGB(245,92,28), AccentHover=Color3.fromRGB(255,118,55), Text=Color3.fromRGB(255,236,220), SubText=Color3.fromRGB(195,148,122), Border=Color3.fromRGB(105,40,18), TabActive=Color3.fromRGB(245,92,28), TabInactive=Color3.fromRGB(40,18,11), Toggle_ON=Color3.fromRGB(245,92,28), Toggle_OFF=Color3.fromRGB(62,28,17), Slider_Fill=Color3.fromRGB(245,92,28), Slider_BG=Color3.fromRGB(46,20,12), Notif_BG=Color3.fromRGB(20,10,6), Notif_Border=Color3.fromRGB(245,92,28), Input_BG=Color3.fromRGB(32,15,9), Dropdown_BG=Color3.fromRGB(28,13,8) },
    Sakura = { Background=Color3.fromRGB(16,10,16), Secondary=Color3.fromRGB(26,16,26), Accent=Color3.fromRGB(242,92,158), AccentHover=Color3.fromRGB(255,118,178), Text=Color3.fromRGB(255,232,245), SubText=Color3.fromRGB(198,152,182), Border=Color3.fromRGB(105,40,84), TabActive=Color3.fromRGB(242,92,158), TabInactive=Color3.fromRGB(40,20,38), Toggle_ON=Color3.fromRGB(242,92,158), Toggle_OFF=Color3.fromRGB(62,28,56), Slider_Fill=Color3.fromRGB(242,92,158), Slider_BG=Color3.fromRGB(46,22,42), Notif_BG=Color3.fromRGB(20,12,19), Notif_Border=Color3.fromRGB(242,92,158), Input_BG=Color3.fromRGB(32,16,30), Dropdown_BG=Color3.fromRGB(28,14,26) },
    Midnight = { Background=Color3.fromRGB(6,6,9), Secondary=Color3.fromRGB(12,12,18), Accent=Color3.fromRGB(178,178,205), AccentHover=Color3.fromRGB(205,205,230), Text=Color3.fromRGB(232,232,242), SubText=Color3.fromRGB(132,132,155), Border=Color3.fromRGB(46,46,65), TabActive=Color3.fromRGB(178,178,205), TabInactive=Color3.fromRGB(18,18,26), Toggle_ON=Color3.fromRGB(178,178,205), Toggle_OFF=Color3.fromRGB(36,36,52), Slider_Fill=Color3.fromRGB(178,178,205), Slider_BG=Color3.fromRGB(26,26,38), Notif_BG=Color3.fromRGB(10,10,15), Notif_Border=Color3.fromRGB(178,178,205), Input_BG=Color3.fromRGB(16,16,24), Dropdown_BG=Color3.fromRGB(14,14,20) },
    Rainbow = { Background=Color3.fromRGB(8,8,14), Secondary=Color3.fromRGB(16,14,24), Accent=Color3.fromRGB(255,60,60), AccentHover=Color3.fromRGB(255,150,40), Text=Color3.fromRGB(245,240,255), SubText=Color3.fromRGB(160,155,180), Border=Color3.fromRGB(120,80,200), TabActive=Color3.fromRGB(255,60,60), TabInactive=Color3.fromRGB(24,22,36), Toggle_ON=Color3.fromRGB(60,220,100), Toggle_OFF=Color3.fromRGB(48,44,64), Slider_Fill=Color3.fromRGB(60,130,255), Slider_BG=Color3.fromRGB(30,26,48), Notif_BG=Color3.fromRGB(12,10,20), Notif_Border=Color3.fromRGB(170,80,255), Input_BG=Color3.fromRGB(20,18,34), Dropdown_BG=Color3.fromRGB(18,16,30) },
}

local Sounds = {
    Enabled = true,
    Notify = "rbxasset://sounds/electronicpingshort.wav",
    Click = "rbxasset://sounds/electronicpingshort.wav",
    Toggle = "rbxasset://sounds/switch.wav",
    Error = "rbxasset://sounds/uuhhh.mp3",
}
local SoundCache = {}

local function _playSound(id)
    if not Sounds.Enabled or not id then return end
    pcall(function()
        local snd = SoundCache[id]
        if not snd or not snd.Parent then
            snd = Instance.new("Sound")
            snd.SoundId = id
            snd.Volume = 0.3
            snd.Parent = CoreGui
            SoundCache[id] = snd
        end
        snd:Play()
    end)
end

function EclipseLib:SetSounds(tbl)
    if type(tbl) ~= "table" then return end
    for k, v in pairs(tbl) do Sounds[k] = v end
end

function EclipseLib:SetSoundEnabled(b) Sounds.Enabled = b and true or false end
function EclipseLib:PlaySound(name) _playSound(Sounds[name]) end

EclipseLib.Icons = {
    Settings="rbxassetid://6031280882", Player="rbxassetid://6031075931",
    Alert="rbxassetid://6031075931", Check="rbxassetid://6031091004",
    Close="rbxassetid://6031094678", Search="rbxassetid://6031226223",
    Star="rbxassetid://6031226223", Home="rbxassetid://6031280882",
    Folder="rbxassetid://6031265976", Info="rbxassetid://6031075931",
}

local ConfigSystem = {}
ConfigSystem._folder = "EclipseLib"
ConfigSystem._data = {}
ConfigSystem._registered = {}
ConfigSystem._dirtyCallback = nil

function ConfigSystem:SetFolder(f) self._folder = f end
function ConfigSystem:Register(key, getFn, setFn)
    self._registered[key] = { get = getFn, set = function(v)
        if setFn then pcall(setFn, v) end
        if ConfigSystem._dirtyCallback then pcall(ConfigSystem._dirtyCallback) end
    end }
end

function ConfigSystem:GetSaveList()
    local list = {}
    pcall(function()
        if isfolder and isfolder(self._folder) then
            for _, f in ipairs(listfiles(self._folder)) do
                local name = f:match("([^/\\]+)%.eclipse$")
                if name then table.insert(list, name) end
            end
        end
    end)
    for k in pairs(self._data) do
        local found = false
        for _, v in ipairs(list) do if v == k then found = true; break end end
        if not found then table.insert(list, k) end
    end
    if #list == 0 then table.insert(list, "(ยังไม่มีไฟล์)") end
    return list
end

function ConfigSystem:Save(filename)
    if not filename or filename == "" or filename == "(ยังไม่มีไฟล์)" then return false end
    local snapshot = {}
    for key, fns in pairs(self._registered) do
        pcall(function() snapshot[key] = fns.get() end)
    end
    self._data[filename] = snapshot
    pcall(function()
        if not isfolder(self._folder) then makefolder(self._folder) end
        local encoded = ""
        for k, v in pairs(snapshot) do encoded = encoded .. tostring(k) .. "=" .. tostring(v) .. "\n" end
        writefile(self._folder .. "/" .. filename .. ".eclipse", encoded)
    end)
    return true
end

function ConfigSystem:Load(filename)
    if not filename or filename == "" or filename == "(ยังไม่มีไฟล์)" then return false end
    local snapshot = self._data[filename]
    if not snapshot then
        snapshot = {}
        pcall(function()
            local path = self._folder .. "/" .. filename .. ".eclipse"
            if isfile(path) then
                for line in readfile(path):gmatch("[^\n]+") do
                    local k, v = line:match("^(.-)=(.+)$")
                    if k and v then
                        if v == "true" then v = true
                        elseif v == "false" then v = false
                        elseif tonumber(v) then v = tonumber(v) end
                        snapshot[k] = v
                    end
                end
            end
        end)
    end
    for key, fns in pairs(self._registered) do
        if snapshot[key] ~= nil then pcall(function() fns.set(snapshot[key]) end) end
    end
    return true
end

function EclipseLib:Log(msg, level)
    level = level or "info"
    if level == "error" then warn("[EclipseLib] ❌ " .. tostring(msg))
    elseif level == "warn" then warn("[EclipseLib] ⚠️ " .. tostring(msg))
    else print("[EclipseLib] " .. tostring(msg)) end
end

function EclipseLib:Alert(o)
    o = o or {}
    local title = o.Title or "Alert"
    local message = o.Message or ""
    local buttons = o.Buttons or {"OK"}
    local result = nil
    local sg = MakeScreenGui("__EclipseAlert", 10500)
    local bg = UI.Frame(sg, { BG=Color3.fromRGB(0,0,0), Transparency=1, Size=UDim2.new(1,0,1,0) })
    local card = UI.Frame(sg, { BG=Theme.Background, Size=UDim2.new(0,360,0,180), Position=UDim2.new(0.5,-180,0.5,-90), Transparency=1, Radius=12, Stroke=true, StrokeColor=Theme.Accent, StrokeSize=1.5 })
    local iconColors = { info=Color3.fromRGB(120,70,230), warning=Color3.fromRGB(240,180,40), error=Color3.fromRGB(220,60,60), success=Color3.fromRGB(60,200,100) }
    local iconColor = iconColors[o.Type or "info"] or iconColors.info
    local tL = UI.Label(card, { Text=title, Position=UDim2.new(0,0,0,16), Size=UDim2.new(1,0,0,24), Color=Theme.Text, TextSize=16, Align=Enum.TextXAlignment.Center })
    tL.TextTransparency = 1
    local mL = UI.Label(card, { Text=message, Position=UDim2.new(0,16,0,50), Size=UDim2.new(1,-32,0,60), Color=Theme.SubText, Font=Enum.Font.Gotham, TextSize=13, Wrap=true, Align=Enum.TextXAlignment.Center })
    mL.TextTransparency = 1
    local btnRow = UI.Frame(card, { BG=Color3.new(0,0,0), Transparency=1, Position=UDim2.new(0,16,1,-50), Size=UDim2.new(1,-32,0,34) })
    local btnLayout = Instance.new("UIListLayout")
    btnLayout.FillDirection = Enum.FillDirection.Horizontal
    btnLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
    btnLayout.Padding = UDim.new(0,8)
    btnLayout.Parent = btnRow
    for i, label in ipairs(buttons) do
        local b = UI.Button(btnRow, { BG=i==#buttons and iconColor or Theme.Secondary, Size=UDim2.new(0,100,1,0), Text=label, Color=i==#buttons and Color3.fromRGB(255,255,255) or Theme.Text })
        b.TextTransparency = 1; b.BackgroundTransparency = 1
        b.MouseButton1Click:Connect(function()
            result = i
            Tween(card, {BackgroundTransparency=1}, 0.2)
            Tween(bg, {BackgroundTransparency=1}, 0.25)
            task.wait(0.25)
            sg:Destroy()
        end)
    end
    task.spawn(function()
        Tween(bg, {BackgroundTransparency=0.5}, 0.25)
        Tween(card, {BackgroundTransparency=0}, 0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        task.wait(0.15)
        Tween(tL, {TextTransparency=0}, 0.25)
        Tween(mL, {TextTransparency=0}, 0.25)
        for _, c in ipairs(btnRow:GetChildren()) do
            if c:IsA("TextButton") then Tween(c, {TextTransparency=0, BackgroundTransparency=0}, 0.25) end
        end
    end)
    while not result and sg.Parent do task.wait(0.1) end
    return result
end

function EclipseLib:Prompt(o)
    o = o or {}
    local title = o.Title or "Input"
    local placeholder = o.Placeholder or "Type here..."
    local default = o.Default or ""
    local result = nil
    local sg = MakeScreenGui("__EclipsePrompt", 10500)
    local bg = UI.Frame(sg, { BG=Color3.fromRGB(0,0,0), Transparency=1, Size=UDim2.new(1,0,1,0) })
    local card = UI.Frame(sg, { BG=Theme.Background, Size=UDim2.new(0,360,0,160), Position=UDim2.new(0.5,-180,0.5,-80), Transparency=1, Radius=12, Stroke=true, StrokeColor=Theme.Accent, StrokeSize=1.5 })
    local tL = UI.Label(card, { Text=title, Position=UDim2.new(0,0,0,16), Size=UDim2.new(1,0,0,24), Color=Theme.Text, TextSize=16, Align=Enum.TextXAlignment.Center })
    tL.TextTransparency = 1
    local box, iBG = UI.TextBox(card, { Placeholder=placeholder, Value=default, Size=UDim2.new(1,-32,0,32), Position=UDim2.new(0,16,0,52), TextSize=13 })
    iBG.BackgroundTransparency = 1; box.TextTransparency = 1
    local okB = UI.Button(card, { BG=Theme.Accent, Size=UDim2.new(0,100,0,30), Position=UDim2.new(1,-116,1,-46), Text="OK" })
    okB.BackgroundTransparency = 1; okB.TextTransparency = 1
    local cancelB = UI.Button(card, { BG=Theme.Secondary, Size=UDim2.new(0,100,0,30), Position=UDim2.new(1,-224,1,-46), Text="Cancel", Color=Theme.Text })
    cancelB.BackgroundTransparency = 1; cancelB.TextTransparency = 1
    local closed = false
    local function close(val)
        if closed then return end
        closed = true; result = val
        Tween(card, {BackgroundTransparency=1}, 0.2)
        Tween(bg, {BackgroundTransparency=1}, 0.25)
        task.wait(0.25); sg:Destroy()
    end
    okB.MouseButton1Click:Connect(function() close(box.Text) end)
    cancelB.MouseButton1Click:Connect(function() close(false) end)
    task.spawn(function()
        Tween(bg, {BackgroundTransparency=0.5}, 0.25)
        Tween(card, {BackgroundTransparency=0}, 0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        task.wait(0.15)
        Tween(tL, {TextTransparency=0}, 0.25)
        Tween(iBG, {BackgroundTransparency=0}, 0.25)
        Tween(box, {TextTransparency=0}, 0.25)
        Tween(okB, {TextTransparency=0, BackgroundTransparency=0}, 0.25)
        Tween(cancelB, {TextTransparency=0, BackgroundTransparency=0}, 0.25)
    end)
    while not closed and sg.Parent do task.wait(0.1) end
    if result == false then return nil end
    return result
end

function EclipseLib:Toast(o)
    o = o or {}
    local title = o.Title or "Toast"
    local content = o.Content or ""
    local duration = o.Duration or 3
    local sg = MakeScreenGui("__EclipseToast", 10500)
    local card = UI.Frame(sg, { BG=Theme.Secondary, Size=UDim2.new(0,320,0,90), Position=UDim2.new(0.5,-160,0.5,-45), Transparency=1, Radius=12, Stroke=true, StrokeColor=Theme.Accent, StrokeSize=1.5 })
    local tL = UI.Label(card, { Text=title, Position=UDim2.new(0,0,0,12), Size=UDim2.new(1,0,0,22), Color=Theme.Text, TextSize=15, Align=Enum.TextXAlignment.Center })
    tL.TextTransparency = 1
    local cL = UI.Label(card, { Text=content, Position=UDim2.new(0,12,0,38), Size=UDim2.new(1,-24,0,40), Color=Theme.SubText, Font=Enum.Font.Gotham, TextSize=12, Wrap=true, Align=Enum.TextXAlignment.Center })
    cL.TextTransparency = 1
    task.spawn(function()
        Tween(card, {BackgroundTransparency=0}, 0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        task.wait(0.1)
        Tween(tL, {TextTransparency=0}, 0.25)
        Tween(cL, {TextTransparency=0}, 0.25)
        task.wait(duration)
        Tween(card, {BackgroundTransparency=1}, 0.3)
        task.wait(0.35)
        sg:Destroy()
    end)
end

function EclipseLib:Confirm(message)
    return EclipseLib:Alert({ Title="⚠️ ยืนยัน", Message=message or "คุณแน่ใจหรือไม่?", Type="warning", Buttons={"ยกเลิก","ยืนยัน"} }) == 2
end

function EclipseLib:ShowContextMenu(items, pos)
    local oldMenu = CoreGui:FindFirstChild("__EclipseContextMenu")
    if oldMenu then oldMenu:Destroy() end
    if not items or #items == 0 then return end
    local sg = Instance.new("ScreenGui")
    sg.Name = "__EclipseContextMenu"
    sg.ResetOnSpawn = false
    sg.DisplayOrder = 11000
    pcall(function() sg.Parent = CoreGui end)
    if not sg.Parent then sg.Parent = LocalPlayer:WaitForChild("PlayerGui") end
    local menu = UI.Frame(sg, { BG=Theme.Secondary, Size=UDim2.new(0,150,0,#items*28+8), Position=UDim2.new(0,pos.X,0,pos.Y), Radius=8, Stroke=true, StrokeSize=1.5 })
    local ly = Instance.new("UIListLayout")
    ly.Padding = UDim.new(0,2)
    ly.Parent = menu
    local pd = Instance.new("UIPadding")
    pd.PaddingTop = UDim.new(0,4)
    pd.PaddingLeft = UDim.new(0,4)
    pd.PaddingRight = UDim.new(0,4)
    pd.Parent = menu
    for _, item in ipairs(items) do
        local btn = UI.Button(menu, { BG=Theme.Accent, Size=UDim2.new(1,0,0,24), Text="  "..(item[1] or "?"), Color=Theme.Text, Font=Enum.Font.Gotham, TextSize=12, Align=Enum.TextXAlignment.Left, Radius=4 })
        btn.BackgroundTransparency = 1; btn.AutoButtonColor = false
        btn.MouseEnter:Connect(function() btn.BackgroundTransparency = 0.85 end)
        btn.MouseLeave:Connect(function() btn.BackgroundTransparency = 1 end)
        btn.MouseButton1Click:Connect(function()
            if item[2] then pcall(item[2]) end
            sg:Destroy()
        end)
    end
    local blocker = Instance.new("TextButton")
    blocker.BackgroundTransparency = 1
    blocker.Size = UDim2.new(1,0,1,0)
    blocker.Text = ""
    blocker.Parent = sg
    blocker.MouseButton1Click:Connect(function() sg:Destroy() end)
    menu.ZIndex = 2
end

local function RunIntro_Fade(sg, title, subtitle, onDone)
    local bg = UI.Frame(sg, { BG=Color3.fromRGB(8,8,12), Size=UDim2.new(1,0,1,0), Transparency=1 })
    local glow = UI.Frame(bg, { BG=Theme.Accent, Transparency=1, Size=UDim2.new(0,180,0,180), Position=UDim2.new(0.5,-90,0.5,-90), Radius=90 })
    local iconL = UI.Label(bg, { Text=IntroConfig.Icon, Size=UDim2.new(0,80,0,80), Position=UDim2.new(0.5,-40,0.5,-50), TextSize=56, Align=Enum.TextXAlignment.Center })
    iconL.TextTransparency = 1
    local titleL = UI.Label(bg, { Text=title, Size=UDim2.new(1,0,0,36), Position=UDim2.new(0,0,0.5,20), Color=Theme.Text, TextSize=22, Align=Enum.TextXAlignment.Center })
    titleL.TextTransparency = 1
    local subL = UI.Label(bg, { Text=subtitle, Size=UDim2.new(1,0,0,24), Position=UDim2.new(0,0,0.5,58), Color=Theme.SubText, Font=Enum.Font.Gotham, TextSize=14, Align=Enum.TextXAlignment.Center })
    subL.TextTransparency = 1
    local barBG = UI.Frame(bg, { BG=Theme.Slider_BG, Transparency=1, Size=UDim2.new(0,220,0,3), Position=UDim2.new(0.5,-110,0.5,90), Radius=3 })
    local barFill = UI.Frame(barBG, { BG=Theme.Accent, Size=UDim2.new(0,0,1,0), Radius=3 })
    task.spawn(function()
        TweenWait(bg, {BackgroundTransparency=0}, 0.4)
        Tween(glow, {BackgroundTransparency=0.88, Size=UDim2.new(0,200,0,200), Position=UDim2.new(0.5,-100,0.5,-100)}, 0.6, Enum.EasingStyle.Sine)
        TweenWait(iconL, {TextTransparency=0, Position=UDim2.new(0.5,-40,0.5,-70)}, 0.5, Enum.EasingStyle.Quint)
        task.wait(0.1); TweenWait(titleL, {TextTransparency=0}, 0.45)
        task.wait(0.1); TweenWait(subL, {TextTransparency=0}, 0.4)
        task.wait(0.1); TweenWait(barBG, {BackgroundTransparency=0}, 0.3)
        TweenWait(barFill, {Size=UDim2.new(1,0,1,0)}, 1.2, Enum.EasingStyle.Quint)
        task.wait(0.25)
        Tween(iconL, {TextTransparency=1, Position=UDim2.new(0.5,-40,0.5,-90)}, 0.45)
        Tween(titleL, {TextTransparency=1}, 0.45)
        Tween(subL, {TextTransparency=1}, 0.45)
        Tween(barBG, {BackgroundTransparency=1}, 0.45)
        Tween(glow, {BackgroundTransparency=1}, 0.45)
        TweenWait(bg, {BackgroundTransparency=1}, 0.5)
        sg:Destroy()
        onDone()
    end)
end

local function RunIntro_Particle(sg, title, subtitle, onDone)
    local bg = UI.Frame(sg, { BG=Color3.fromRGB(8,8,12), Size=UDim2.new(1,0,1,0), Transparency=1 })
    local parts = {}
    math.randomseed(os.clock() * 1000)
    for i = 1, 28 do
        local sz = math.random(2, 6)
        local p = UI.Frame(bg, { BG=(math.random()>0.5) and Theme.Accent or Color3.fromRGB(180,140,255), Size=UDim2.new(0,sz,0,sz), Radius=sz })
        local a = math.rad(math.random(0,360))
        local d = math.random(80,200)
        p.Position = UDim2.new(0.5+math.cos(a)*d/600, -sz/2, 0.5+math.sin(a)*d/600, -sz/2)
        table.insert(parts, p)
    end
    local iconL = UI.Label(bg, { Text=IntroConfig.Icon, Size=UDim2.new(0,80,0,80), Position=UDim2.new(0.5,-40,0.5,-70), TextSize=12, Align=Enum.TextXAlignment.Center })
    iconL.TextTransparency = 1
    local titleL = UI.Label(bg, { Text=title, Size=UDim2.new(1,0,0,36), Position=UDim2.new(0,0,0.5,20), Color=Theme.Text, TextSize=22, Align=Enum.TextXAlignment.Center })
    titleL.TextTransparency = 1
    local subL = UI.Label(bg, { Text=subtitle, Size=UDim2.new(1,0,0,24), Position=UDim2.new(0,0,0.5,58), Color=Theme.SubText, Font=Enum.Font.Gotham, TextSize=14, Align=Enum.TextXAlignment.Center })
    subL.TextTransparency = 1
    local barBG = UI.Frame(bg, { BG=Theme.Slider_BG, Transparency=1, Size=UDim2.new(0,220,0,3), Position=UDim2.new(0.5,-110,0.5,90), Radius=3 })
    local barFill = UI.Frame(barBG, { BG=Theme.Accent, Size=UDim2.new(0,0,1,0), Radius=3 })
    task.spawn(function()
        TweenWait(bg, {BackgroundTransparency=0}, 0.3)
        for _, p in ipairs(parts) do
            Tween(p, {Position=UDim2.new(0.5,-3,0.5,-3), BackgroundTransparency=0.3, Size=UDim2.new(0,4,0,4)}, 0.7, Enum.EasingStyle.Quint)
        end
        task.wait(0.65)
        for _, p in ipairs(parts) do
            Tween(p, {BackgroundTransparency=1, Size=UDim2.new(0,0,0,0)}, 0.2)
        end
        TweenWait(iconL, {TextTransparency=0, TextSize=56}, 0.45, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        task.wait(0.1); TweenWait(titleL, {TextTransparency=0}, 0.4)
        task.wait(0.1); TweenWait(subL, {TextTransparency=0}, 0.35)
        task.wait(0.1); TweenWait(barBG, {BackgroundTransparency=0}, 0.25)
        TweenWait(barFill, {Size=UDim2.new(1,0,1,0)}, 1.1, Enum.EasingStyle.Quint)
        task.wait(0.2)
        Tween(iconL, {TextTransparency=1}, 0.4)
        Tween(titleL, {TextTransparency=1}, 0.4)
        Tween(subL, {TextTransparency=1}, 0.4)
        Tween(barBG, {BackgroundTransparency=1}, 0.4)
        TweenWait(bg, {BackgroundTransparency=1}, 0.5)
        sg:Destroy()
        onDone()
    end)
end

local function RunIntro_Zoom(sg, title, subtitle, onDone)
    local bg = UI.Frame(sg, { BG=Color3.fromRGB(8,8,12), Size=UDim2.new(1,0,1,0), Transparency=1 })
    local iconL = UI.Label(bg, { Text=IntroConfig.Icon, Size=UDim2.new(0,20,0,20), Position=UDim2.new(0.5,-10,0.5,-60), TextSize=12, Align=Enum.TextXAlignment.Center })
    iconL.TextTransparency = 0.8
    local titleL = UI.Label(bg, { Text=title, Size=UDim2.new(1,0,0,36), Position=UDim2.new(0,0,0.5,20), Color=Theme.Text, TextSize=22, Align=Enum.TextXAlignment.Center })
    titleL.TextTransparency = 1
    local subL = UI.Label(bg, { Text=subtitle, Size=UDim2.new(1,0,0,24), Position=UDim2.new(0,0,0.5,58), Color=Theme.SubText, Font=Enum.Font.Gotham, TextSize=14, Align=Enum.TextXAlignment.Center })
    subL.TextTransparency = 1
    local barBG = UI.Frame(bg, { BG=Theme.Slider_BG, Transparency=1, Size=UDim2.new(0,220,0,3), Position=UDim2.new(0.5,-110,0.5,90), Radius=3 })
    local barFill = UI.Frame(barBG, { BG=Theme.Accent, Size=UDim2.new(0,0,1,0), Radius=3 })
    task.spawn(function()
        TweenWait(bg, {BackgroundTransparency=0}, 0.3)
        TweenWait(iconL, {TextSize=72, TextTransparency=0, Size=UDim2.new(0,80,0,80), Position=UDim2.new(0.5,-40,0.5,-70)}, 0.55, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        TweenWait(iconL, {TextSize=56, Size=UDim2.new(0,70,0,70)}, 0.2, Enum.EasingStyle.Bounce)
        task.wait(0.05); TweenWait(titleL, {TextTransparency=0}, 0.4)
        task.wait(0.1); TweenWait(subL, {TextTransparency=0}, 0.35)
        task.wait(0.1); TweenWait(barBG, {BackgroundTransparency=0}, 0.25)
        TweenWait(barFill, {Size=UDim2.new(1,0,1,0)}, 1.2, Enum.EasingStyle.Quint)
        task.wait(0.2)
        Tween(iconL, {TextTransparency=1, TextSize=100}, 0.5)
        Tween(titleL, {TextTransparency=1}, 0.4)
        Tween(subL, {TextTransparency=1}, 0.4)
        Tween(barBG, {BackgroundTransparency=1}, 0.4)
        TweenWait(bg, {BackgroundTransparency=1}, 0.5)
        sg:Destroy()
        onDone()
    end)
end

local function PlayIntro(title, subtitle, onDone)
    local sg = MakeScreenGui("__EclipseIntro", 10000)
    local m = IntroConfig.Mode
    if m == "zoom" then RunIntro_Zoom(sg, title, subtitle, onDone)
    elseif m == "particle" then RunIntro_Particle(sg, title, subtitle, onDone)
    else RunIntro_Fade(sg, title, subtitle, onDone) end
end

-- NOTIFY SYSTEM
local _NotifyQueue = {}
local _NotifyShowing = false
local NotifHolder = nil
local NotifConfig = { Position = UDim2.new(1,-320,0,60), IsRight = true }

local function SetNotifPosition(side)
    if side == "right" then
        NotifConfig.IsRight = true
        NotifConfig.Position = UDim2.new(1,-320,0,60)
    elseif side == "left" then
        NotifConfig.IsRight = false
        NotifConfig.Position = UDim2.new(0,20,0,60)
    end
    if NotifHolder and NotifHolder.Parent then NotifHolder.Position = NotifConfig.Position end
end

local function EnsureNotifHolder()
    if NotifHolder and NotifHolder.Parent then return NotifHolder end
    local sg = MakeScreenGui("__EclipseNotif", 9999)
    local holder = UI.Frame(sg, { BG=Color3.fromRGB(0,0,0), Transparency=1, Size=UDim2.new(0,300,1,0), Position=NotifConfig.Position })
    holder.Name = "NotifHolder"
    NotifHolder = holder
    return holder
end

local function _showNextNotify()
    if _NotifyShowing or #_NotifyQueue == 0 then return end
    _NotifyShowing = true
    local data = table.remove(_NotifyQueue, 1)
    local holder = EnsureNotifHolder()
    local frame = UI.Frame(holder, { BG=Theme.Notif_BG, Size=UDim2.new(1,0,0,70), Radius=12 })
    frame.Position = NotifConfig.IsRight and UDim2.new(1,300,0,0) or UDim2.new(-1,-300,0,0)
    CS(frame, Theme.Notif_Border, 2)
    local icon = UI.Label(frame, { Text="🌒", Size=UDim2.new(0,40,1,0), Position=UDim2.new(0,5,0,0), TextSize=24, Align=Enum.TextXAlignment.Center })
    icon.TextScaled = true
    UI.Label(frame, { Text=data.title or "EclipseLib", Size=UDim2.new(1,-55,0,28), Position=UDim2.new(0,50,0,5), Color=Theme.Accent, TextSize=15 })
    UI.Label(frame, { Text=data.text or "", Size=UDim2.new(1,-55,0,28), Position=UDim2.new(0,50,0,30), Color=Theme.Text, Font=Enum.Font.Code, TextSize=13, Wrap=true })
    local bar = UI.Frame(frame, { BG=Theme.Notif_Border, Size=UDim2.new(1,0,0,3), Position=UDim2.new(0,0,1,-3), Radius=4 })
    Tween(frame, {Position=UDim2.new(0,0,0,0)}, 0.3, Enum.EasingStyle.Quart)
    local duration = data.duration or 3
    Tween(bar, {Size=UDim2.new(0,0,0,3)}, duration, Enum.EasingStyle.Linear)
    task.delay(duration, function()
        Tween(frame, {Position=NotifConfig.IsRight and UDim2.new(1,300,0,0) or UDim2.new(-1,-300,0,0)}, 0.3, Enum.EasingStyle.Quart)
        task.wait(0.3)
        frame:Destroy()
        _NotifyShowing = false
        _showNextNotify()
    end)
end

function EclipseLib:Notify(opts)
    opts = opts or {}
    table.insert(_NotifyQueue, {
        title = opts.Title or opts.title or "EclipseLib",
        text = opts.Content or opts.text or "",
        duration = opts.Duration or opts.duration or 3,
        type = opts.Type or "info",
    })
    if opts.Silent ~= true then
        if opts.Type == "error" then _playSound(Sounds.Error)
        else _playSound(Sounds.Notify) end
    end
    _showNextNotify()
end

-- KEY SYSTEM
local function SimpleHash(str)
    local hash = 5381
    for i = 1, #str do hash = ((hash * 33) + str:byte(i)) % 2147483647 end
    local hex = string.format("%08X", hash)
    return HttpService:Base64Encode(hex .. "|" .. #str)
end

local function ShowKeySystem(opts, onSuccess)
    local keyList = opts.Key or {}
    local keyTitle = opts.KeyTitle or "🔑 ใส่ Key"
    local keyDesc = opts.KeyDescription or "กรอก Key เพื่อใช้งาน"
    local keyLink = opts.KeyLink or ""
    local saveFolder = opts.SaveFolder or "EclipseLib"
    local keyFile = saveFolder .. "/eclipse_key.dat"

    local function CheckSavedKey()
        local ok, saved = pcall(function()
            if not isfolder(saveFolder) then return nil end
            if not isfile(keyFile) then return nil end
            return readfile(keyFile)
        end)
        if not ok or not saved or saved == "" then return false end
        for _, k in ipairs(keyList) do if SimpleHash(k) == saved then return true end end
        pcall(function() delfile(keyFile) end)
        return false
    end

    local function SaveKey(key)
        pcall(function()
            if not isfolder(saveFolder) then makefolder(saveFolder) end
            writefile(keyFile, SimpleHash(key))
        end)
    end

    if CheckSavedKey() then onSuccess(); return end

    local sg = MakeScreenGui("__EclipseKey", 10001)
    local bgO = UI.Frame(sg, { BG=Color3.fromRGB(0,0,0), Transparency=1, Size=UDim2.new(1,0,1,0) })
    local card = UI.Frame(sg, { BG=Theme.Background, Size=UDim2.new(0,320,0,240), Position=UDim2.new(0.5,-160,0.5,-120), Transparency=1, Radius=14, Stroke=true, StrokeColor=Theme.Accent, StrokeSize=1.5 })
    UI.Frame(card, { BG=Theme.Accent, Size=UDim2.new(1,0,0,3) })
    local iL = UI.Label(card, { Text="🔑", Position=UDim2.new(0,0,0,16), Size=UDim2.new(1,0,0,36), TextSize=28, Align=Enum.TextXAlignment.Center })
    iL.TextTransparency = 1
    local tL = UI.Label(card, { Text=keyTitle, Position=UDim2.new(0,0,0,54), Size=UDim2.new(1,0,0,24), Color=Theme.Text, TextSize=16, Align=Enum.TextXAlignment.Center })
    tL.TextTransparency = 1
    local dL = UI.Label(card, { Text=keyDesc, Position=UDim2.new(0,16,0,80), Size=UDim2.new(1,-32,0,30), Color=Theme.SubText, Font=Enum.Font.Gotham, TextSize=12, Wrap=true, Align=Enum.TextXAlignment.Center })
    dL.TextTransparency = 1
    local iBox, iBG = UI.TextBox(card, { Placeholder="🔐 กรอก Key ที่นี่...", Size=UDim2.new(1,-32,0,36), Position=UDim2.new(0,16,0,118), TextSize=13 })
    iBG.BackgroundTransparency = 1; iBox.TextTransparency = 1
    local stL = UI.Label(card, { Text="", Position=UDim2.new(0,16,0,160), Size=UDim2.new(1,-32,0,16), Color=Color3.fromRGB(200,60,60), Font=Enum.Font.Gotham, TextSize=11, Align=Enum.TextXAlignment.Center })
    local glB = UI.Button(card, { BG=Theme.Secondary, Text="🔗 Get Key", Color=Theme.Accent, Size=UDim2.new(0,120,0,34), Position=UDim2.new(0,16,0,184) })
    glB.BackgroundTransparency = 1; glB.TextTransparency = 1
    CS(glB, Theme.Accent, 1)
    local suB = UI.Button(card, { BG=Theme.Accent, Text="✅ ยืนยัน Key", Size=UDim2.new(0,130,0,34), Position=UDim2.new(1,-146,0,184) })
    suB.BackgroundTransparency = 1; suB.TextTransparency = 1
    task.spawn(function()
        Tween(bgO, {BackgroundTransparency=0.5}, 0.3)
        Tween(card, {BackgroundTransparency=0}, 0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        task.wait(0.15)
        for _, o in ipairs({iL, tL, dL, glB, suB}) do
            Tween(o, {TextTransparency=0}, 0.3)
            pcall(function() Tween(o, {BackgroundTransparency=0}, 0.3) end)
            task.wait(0.05)
        end
        Tween(iBG, {BackgroundTransparency=0}, 0.3)
        Tween(iBox, {TextTransparency=0}, 0.3)
    end)
    glB.MouseButton1Click:Connect(function()
        SetClipboard(keyLink)
        local old = glB.Text
        glB.Text = "✅ คัดลอกแล้ว!"
        Tween(glB, {BackgroundColor3=Color3.fromRGB(30,80,40)}, 0.2)
        task.wait(2)
        glB.Text = old
        Tween(glB, {BackgroundColor3=Theme.Secondary}, 0.2)
    end)
    suB.MouseButton1Click:Connect(function()
        local entered = iBox.Text
        local valid = false
        for _, k in ipairs(keyList) do if k == entered then valid = true; break end end
        if valid then
            SaveKey(entered)
            stL.TextColor3 = Color3.fromRGB(60,200,100)
            stL.Text = "✅ Key ถูกต้อง!"
            task.wait(0.5)
            for i = 1, 3 do
                Tween(bgO, {BackgroundTransparency=i%2==0 and 0.5 or 0.1}, 0.06)
                task.wait(0.06)
            end
            Tween(card, {BackgroundTransparency=1, Size=UDim2.new(0,320,0,0)}, 0.25)
            Tween(bgO, {BackgroundTransparency=1}, 0.3)
            task.wait(0.35)
            sg:Destroy()
            onSuccess()
        else
            stL.TextColor3 = Color3.fromRGB(200,60,60)
            stL.Text = "❌ Key ไม่ถูกต้อง!"
            Tween(iBG, {BackgroundColor3=Color3.fromRGB(60,20,20)}, 0.12)
            local op = iBG.Position
            for i = 1, 4 do
                Tween(iBG, {Position=UDim2.new(op.X.Scale, op.X.Offset+(i%2==0 and 6 or -6), op.Y.Scale, op.Y.Offset)}, 0.05)
                task.wait(0.05)
            end
            Tween(iBG, {Position=op, BackgroundColor3=Theme.Input_BG}, 0.1)
        end
    end)
end

local _registeredWindows = {}

-- ═══════════════════════════════════════════
-- 🏗️ CREATE WINDOW
-- ═══════════════════════════════════════════
function EclipseLib:CreateWindow(opts)
    opts = opts or {}
    local windowName = opts.Name or "EclipseLib"
    local loadTitle = opts.LoadingTitle or "🌒 EclipseLib"
    local loadSub = opts.LoadingSubtitle or "กำลังโหลด..."
    local useKey = opts.KeySystem or false
    local cfgFolder = (opts.ConfigurationSaving and opts.ConfigurationSaving.FolderName) or "EclipseLib"
    local keyOpts = {
        Key = opts.Key or {},
        KeyTitle = opts.KeyTitle or "🔑 ใส่ Key",
        KeyDescription = opts.KeyDescription or "กรอก Key เพื่อใช้งาน",
        KeyLink = opts.KeyLink or "",
        SaveFolder = cfgFolder,
    }
    ConfigSystem:SetFolder(cfgFolder)

    local allConnections = {}
    local function SafeConnect(event, callback)
        local conn = event:Connect(callback)
        table.insert(allConnections, conn)
        return conn
    end

    local RealtimeUpdaters = {}
    local function RegisterRealtime(label, fn)
        table.insert(RealtimeUpdaters, { label = label, fn = fn })
    end

    local themeUpdaters = {}
    local function RegisterUpdater(fn)
        table.insert(themeUpdaters, fn)
    end
    local function RunAllUpdaters()
        for _, fn in ipairs(themeUpdaters) do pcall(fn) end
    end

    local rainbowOn = false
    local rainbowConn = nil
    local myRainbowAnimators = {}
    local savedThemeSnapshot = nil

    local ScreenGui = MakeScreenGui("__EclipseLib", 999)
    local Main = UI.Frame(ScreenGui, { BG=Theme.Background, Size=UDim2.new(0,500,0,350), Position=UDim2.new(0.5,-250,0.5,-175), Radius=12, Stroke=true, StrokeSize=1.5, Clips=true })
    Main.Visible = false

    local savedPos = ConfigSystem._data["_window_pos"]
    if savedPos and type(savedPos) == "table" and savedPos.x and savedPos.y then
        pcall(function() Main.Position = UDim2.new(0, savedPos.x, 0, savedPos.y) end)
    end

    -- TOPBAR
    local TopBar = UI.Frame(Main, { BG=Theme.Secondary, Size=UDim2.new(1,0,0,38), Radius=12 })
    UI.Frame(TopBar, { BG=Theme.Secondary, Size=UDim2.new(1,0,0,10), Position=UDim2.new(0,0,1,-10) })
    local TitleLbl = UI.Label(TopBar, { Text="🌒  "..windowName, Position=UDim2.new(0,12,0,0), Size=UDim2.new(1,-140,1,0), Color=Theme.Text, TextSize=14 })

    local CloseBtn = UI.Button(TopBar, { BG=Color3.fromRGB(180,50,50), Size=UDim2.new(0,22,0,22), Position=UDim2.new(1,-30,0.5,-11), Text="✕", TextSize=12, Radius=6 })
    local MinBtn = UI.Button(TopBar, { BG=Color3.fromRGB(60,60,80), Size=UDim2.new(0,22,0,22), Position=UDim2.new(1,-56,0.5,-11), Text="—", Color=Theme.Text, TextSize=12, Radius=6 })
    local ToggleTabBtn = UI.Button(TopBar, { BG=Color3.fromRGB(60,60,80), Size=UDim2.new(0,22,0,22), Position=UDim2.new(1,-82,0.5,-11), Text="☰", Color=Theme.Text, TextSize=12, Radius=6 })
    local SettingsBtn = UI.Button(TopBar, { BG=Color3.fromRGB(60,60,80), Size=UDim2.new(0,22,0,22), Position=UDim2.new(1,-108,0.5,-11), Text="⚙️", Color=Theme.Text, TextSize=12, Radius=6 })

    MakeDraggable(Main, TopBar)

    local Body = UI.Frame(Main, { BG=Color3.new(0,0,0), Transparency=1, Position=UDim2.new(0,0,0,38), Size=UDim2.new(1,0,1,-38) })

    -- TabBarContainer
    local TabBarContainer = UI.Frame(Body, { BG=Theme.Secondary, Size=UDim2.new(0,115,1,0), Position=UDim2.new(0,0,0,0) })
    TabBarContainer.Name = "TabBarContainer"
    CS(TabBarContainer, Theme.Border, 1)

    -- TabBar
    local TabBar = UI.Scroll(TabBarContainer, { Transparency=1, Size=UDim2.new(1,0,1,0), ScrollThickness=2 })
    TabBar.Name = "TabBar"
    local TL = UI.Layout(TabBar, { Padding=UDim.new(0,4) })
    UI.Padding(TabBar, { Top=UDim.new(0,6), Left=UDim.new(0,5), Right=UDim.new(0,5), Bottom=UDim.new(0,6) })
    SafeConnect(TL:GetPropertyChangedSignal("AbsoluteContentSize"), function()
        TabBar.CanvasSize = UDim2.new(0,0,0,TL.AbsoluteContentSize.Y+12)
    end)

    -- ✅ Welcome Button with glow
    local welcomeBtn = UI.Button(TabBar, { BG=Theme.TabActive, Size=UDim2.new(1,0,0,34), Text="🏠 ยินดีต้อนรับ", Color=Color3.fromRGB(255,255,255), TextSize=11, Radius=8, Wrap=true })
    welcomeBtn.LayoutOrder = 0
    -- ✅ Glow ก่อน
    local welcomeGlow = Instance.new("Frame")
    welcomeGlow.Name = "_IndicatorGlow"
    welcomeGlow.BackgroundColor3 = Theme.Accent
    welcomeGlow.BackgroundTransparency = 0.55
    welcomeGlow.Size = UDim2.new(0,12,1,-6)
    welcomeGlow.Position = UDim2.new(0,-3,0,3)
    welcomeGlow.BorderSizePixel = 0
    welcomeGlow.ZIndex = welcomeBtn.ZIndex - 1
    welcomeGlow.Parent = welcomeBtn
    CC(welcomeGlow, 6)
    -- ✅ Indicator ใหญ่ขึ้น 5px
    local welcomeInd = UI.Frame(welcomeBtn, { BG=Theme.Accent, Size=UDim2.new(0,5,1,-10), Position=UDim2.new(0,0,0,5), Radius=3, Z=welcomeBtn.ZIndex+1 })
    welcomeInd.Name = "_Indicator"

    -- Divider
    local div = UI.Frame(TabBar, { BG=Theme.Border, Size=UDim2.new(1,0,0,1) })
    div.LayoutOrder = 1

    local ContentArea = UI.Frame(Body, { BG=Color3.new(0,0,0), Transparency=1, Position=UDim2.new(0,119,0,0), Size=UDim2.new(1,-119,1,0) })

    local tabVisible = true
    local tabBarWidth = 115
    local tabBarGap = 4
    local minWindowWidth = 420

    local function UpdateLayout(animate)
        local targetWidth = tabVisible and tabBarWidth or 0
        local contentOffset = targetWidth + tabBarGap
        local duration = animate and 0.2 or 0.01
        Tween(TabBarContainer, { Size=UDim2.new(0,targetWidth,1,0) }, duration)
        Tween(ContentArea, { Position=UDim2.new(0,contentOffset,0,0), Size=UDim2.new(1,-contentOffset,1,0) }, duration)
    end

    ToggleTabBtn.MouseButton1Click:Connect(function()
        tabVisible = not tabVisible
        Tween(ToggleTabBtn, { Rotation = tabVisible and 0 or 90 }, 0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
        Tween(ToggleTabBtn, { BackgroundColor3 = tabVisible and Color3.fromRGB(60,60,80) or Theme.Accent }, 0.2)
        UpdateLayout(true)
    end)

    local resizeDebounceToken = 0
    SafeConnect(Main:GetPropertyChangedSignal("AbsoluteSize"), function()
        resizeDebounceToken = resizeDebounceToken + 1
        local myToken = resizeDebounceToken
        task.delay(0.1, function()
            if myToken ~= resizeDebounceToken then return end
            local w = Main.AbsoluteSize.X
            if w < minWindowWidth and tabBarWidth == 115 then
                tabBarWidth = 85
                UpdateLayout(true)
            elseif w >= minWindowWidth and tabBarWidth == 85 then
                tabBarWidth = 115
                UpdateLayout(true)
            end
        end)
    end)

    local isOpen = true
    MinBtn.MouseButton1Click:Connect(function()
        isOpen = not isOpen
        Tween(Main, { Size=isOpen and UDim2.new(0,500,0,350) or UDim2.new(0,500,0,38) }, 0.3)
        MinBtn.Text = isOpen and "—" or "▲"
    end)

    local floatSG = MakeScreenGui("__EclipseFloat", 998)
    local floatBtn = UI.Button(floatSG, { BG=Theme.Accent, Size=UDim2.new(0,46,0,46), Position=UDim2.new(0,12,0.5,-23), Text="🌒", TextSize=22, Radius=23 })
    CS(floatBtn, Theme.Border, 1.5)
    floatBtn.Visible = false
    MakeDraggable(floatBtn, floatBtn)

    CloseBtn.MouseButton1Click:Connect(function()
        Tween(Main, { Size=UDim2.new(0,500,0,0) }, 0.25)
        task.wait(0.3)
        Main.Visible = false
        floatBtn.Visible = true
    end)

    floatBtn.MouseButton1Click:Connect(function()
        floatBtn.Visible = false
        Main.Visible = true
        Main.Size = UDim2.new(0,500,0,0)
        Tween(Main, { Size=UDim2.new(0,500,0,350) }, 0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        isOpen = true
        MinBtn.Text = "—"
    end)

    local WindowObj = {}
    local tabButtons = {}
    local tabFrames = {}
    local activeTab = nil

    local TR = {
        backgrounds = { Main },
        secondaries = { TopBar, TabBarContainer, TabBar },
        accents = { floatBtn },
        borders = {},
        texts = { TitleLbl },
        subtexts = {},
    }
    for _, v in ipairs(Main:GetDescendants()) do
        if v:IsA("UIStroke") then table.insert(TR.borders, v) end
    end

    local ThemeCache = { frames = {}, strokes = {}, dirty = true }
    local function RebuildThemeCache()
        ThemeCache.frames = {}
        ThemeCache.strokes = {}
        for _, v in ipairs(Main:GetDescendants()) do
            if v:IsA("Frame") or v:IsA("ScrollingFrame") then
                table.insert(ThemeCache.frames, v)
            elseif v:IsA("UIStroke") then
                table.insert(ThemeCache.strokes, v)
            end
        end
        ThemeCache.dirty = false
    end

    local function ApplyThemeAll(th)
        for _, f in ipairs(TR.backgrounds) do pcall(function() Tween(f, {BackgroundColor3=th.bg or Theme.Background}, 0.3) end) end
        for _, f in ipairs(TR.secondaries) do pcall(function() Tween(f, {BackgroundColor3=th.sec or Theme.Secondary}, 0.3) end) end
        for _, f in ipairs(TR.accents) do
            pcall(function()
                if f:IsA("TextLabel") or f:IsA("TextButton") then f.TextColor3 = th.accent or Theme.Accent
                else Tween(f, {BackgroundColor3=th.accent or Theme.Accent}, 0.3) end
            end)
        end
        for _, s in ipairs(TR.borders) do
            pcall(function()
                if s._isPseudo then s._frame.BackgroundColor3 = th.border or Theme.Border
                else s.Color = th.border or Theme.Border end
            end)
        end
        for _, l in ipairs(TR.texts) do pcall(function() l.TextColor3 = th.text or Theme.Text end) end
        for _, l in ipairs(TR.subtexts) do pcall(function() l.TextColor3 = th.subtext or Theme.SubText end) end
        for n, btn in pairs(tabButtons) do
            if n == activeTab then
                pcall(function() Tween(btn, {BackgroundColor3=th.accent or Theme.Accent}, 0.2) end)
            else
                pcall(function() Tween(btn, {BackgroundColor3=th.inactive or Theme.TabInactive}, 0.2) end)
            end
        end
        if th.oldBG or th.oldSec or th.oldBorder then
            if ThemeCache.dirty then RebuildThemeCache() end
            local function cEq(a,b)
                return math.abs(a.R-b.R)<0.02 and math.abs(a.G-b.G)<0.02 and math.abs(a.B-b.B)<0.02
            end
            for _, obj in ipairs(ThemeCache.frames) do
                pcall(function()
                    if obj.BackgroundTransparency < 0.5 then
                        local c = obj.BackgroundColor3
                        if th.oldBG and cEq(c, th.oldBG) then Tween(obj, {BackgroundColor3=th.bg}, 0.3)
                        elseif th.oldSec and cEq(c, th.oldSec) then Tween(obj, {BackgroundColor3=th.sec}, 0.3) end
                    end
                end)
            end
            for _, s in ipairs(ThemeCache.strokes) do
                pcall(function()
                    if th.oldBorder and cEq(s.Color, th.oldBorder) then
                        s.Color = th.border or Theme.Border
                    end
                end)
            end
        end
    end

    local function RegBG(f) table.insert(TR.backgrounds, f); ThemeCache.dirty = true end
    local function RegSec(f) table.insert(TR.secondaries, f); ThemeCache.dirty = true end
    local function RegAccent(f) table.insert(TR.accents, f); ThemeCache.dirty = true end
    local function RegBorder(s) table.insert(TR.borders, s) end
    local function RegText(l) table.insert(TR.texts, l); ThemeCache.dirty = true end
    local function RegSub(l) table.insert(TR.subtexts, l); ThemeCache.dirty = true end

    -- ✅ SetActiveTab — จัดการ glow ด้วย
    local function SetActiveTab(name)
        if activeTab == name then return end

        for n, f in pairs(tabFrames) do
            f.Visible = (n == name)
        end

        for n, btn in pairs(tabButtons) do
            local isAct = (n == name)
            Tween(btn, {BackgroundColor3 = isAct and Theme.TabActive or Theme.TabInactive}, 0.2)
            btn.TextColor3 = isAct and Color3.fromRGB(255,255,255) or Theme.SubText
            local ind = btn:FindFirstChild("_Indicator")
            if ind then
                ind.Visible = isAct
                ind.BackgroundColor3 = Theme.Accent
            end
            local glow = btn:FindFirstChild("_IndicatorGlow")
            if glow then
                glow.Visible = isAct
                glow.BackgroundColor3 = Theme.Accent
            end
        end

        local isWelcome = (name == "_Welcome")
        Tween(welcomeBtn, {BackgroundColor3 = isWelcome and Theme.TabActive or Theme.TabInactive}, 0.2)
        welcomeBtn.TextColor3 = isWelcome and Color3.fromRGB(255,255,255) or Theme.SubText
        welcomeInd.Visible = isWelcome
        welcomeInd.BackgroundColor3 = Theme.Accent
        welcomeGlow.Visible = isWelcome
        welcomeGlow.BackgroundColor3 = Theme.Accent

        local isSettings = (name == "_Settings")
        Tween(SettingsBtn, { BackgroundColor3 = isSettings and Theme.Accent or Color3.fromRGB(60,60,80) }, 0.2)

        activeTab = name
    end

    welcomeBtn.MouseButton1Click:Connect(function() SetActiveTab("_Welcome") end)

    SettingsBtn.MouseButton1Click:Connect(function()
        if activeTab == "_Settings" then SetActiveTab("_Welcome")
        else SetActiveTab("_Settings") end
    end)

    local function MakeSF(name)
        local sf = UI.Scroll(ContentArea, { Transparency=1, Size=UDim2.new(1,0,1,0), ScrollThickness=3 })
        sf.Name = name
        sf.Visible = false
        local ly = UI.Layout(sf, { Padding=UDim.new(0,6) })
        UI.Padding(sf, { Top=UDim.new(0,8), Left=UDim.new(0,8), Right=UDim.new(0,8) })
        SafeConnect(ly:GetPropertyChangedSignal("AbsoluteContentSize"), function()
            sf.CanvasSize = UDim2.new(0,0,0,ly.AbsoluteContentSize.Y+20)
        end)
        return sf
    end

    -- ✅ MakeTabBtn — Indicator ใหญ่ขึ้น 5px + Glow
    local function MakeTabBtn(label, active)
        local btn = UI.Button(TabBar, { BG=active and Theme.TabActive or Theme.TabInactive, Size=UDim2.new(1,0,0,34), Text=label, Color=active and Color3.fromRGB(255,255,255) or Theme.SubText, TextSize=11, Radius=8, Wrap=true })
        -- ✅ Glow ก่อน (อยู่หลัง indicator)
        local glow = Instance.new("Frame")
        glow.Name = "_IndicatorGlow"
        glow.BackgroundColor3 = Theme.Accent
        glow.BackgroundTransparency = 0.55
        glow.Size = UDim2.new(0,12,1,-6)
        glow.Position = UDim2.new(0,-3,0,3)
        glow.BorderSizePixel = 0
        glow.ZIndex = btn.ZIndex - 1
        glow.Visible = active
        glow.Parent = btn
        CC(glow, 6)
        -- ✅ Indicator ใหญ่ขึ้น
        local ind = UI.Frame(btn, { BG=Theme.Accent, Size=UDim2.new(0,5,1,-10), Position=UDim2.new(0,0,0,5), Radius=3, Z=btn.ZIndex+1 })
        ind.Name = "_Indicator"
        ind.Visible = active
        RegSec(btn)
        return btn
    end

    -- ═══════════════════════════════════════
    -- CREATE TAB
    -- ═══════════════════════════════════════
    function WindowObj:CreateTab(nameOrOpts, _icon)
        local tabName, tabIcon
        if type(nameOrOpts) == "string" then tabName = nameOrOpts; tabIcon = _icon or ""
        else tabName = nameOrOpts.Name or "Tab"; tabIcon = nameOrOpts.Icon or "" end
        local label = (tabIcon ~= "") and (tabIcon .. " " .. tabName) or tabName
        local tabBtn = MakeTabBtn(label, false)
        local tabFrame = MakeSF("Frame_" .. tabName)
        tabButtons[tabName] = tabBtn
        tabFrames[tabName] = tabFrame
        tabBtn.MouseButton1Click:Connect(function() SetActiveTab(tabName) end)

        local TabAPI = {}

        local function BaseCard(h)
            local c = UI.Frame(tabFrame, { BG=Theme.Secondary, Size=UDim2.new(1,0,0,h), Radius=8, Stroke=true })
            local grad = Instance.new("UIGradient")
            grad.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(40,36,58)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(22,22,30)),
            })
            grad.Rotation = 90
            grad.Parent = c
            local bar = UI.Frame(c, { BG=Theme.Accent, Size=UDim2.new(0,3,1,-16), Position=UDim2.new(0,0,0,8), Radius=2 })
            RegSec(c)
            RegisterUpdater(function()
                bar.BackgroundColor3 = Theme.Accent
            end)
            return c
        end

        function TabAPI:AddLabel(o)
            o = o or {}
            local l = UI.Label(tabFrame, { Text=o.Text or "", Size=UDim2.new(1,0,0,24), Color=Theme.SubText, Font=Enum.Font.Gotham, TextSize=12, Wrap=true, Position=UDim2.new(0,0,0,0) })
            RegSub(l)
            local A = {}
            function A:SetText(t) l.Text = t end
            return A
        end

        function TabAPI:AddSection(o)
            o = o or {}
            local sf = UI.Frame(tabFrame, { BG=Color3.new(0,0,0), Transparency=1, Size=UDim2.new(1,0,0,28) })
            local line = UI.Frame(sf, { BG=Theme.Border, Size=UDim2.new(1,0,0,1), Position=UDim2.new(0,0,0.5,0) })
            RegBorder({ Color=Theme.Border, _frame=line, _isPseudo=true })
            local bg2 = UI.Frame(sf, { BG=Theme.Background, Size=UDim2.new(0,0,1,0) })
            bg2.AutomaticSize = Enum.AutomaticSize.X
            RegBG(bg2)
            local sl2 = UI.Label(bg2, { Text="  "..(o.Name or "Section").."  ", Size=UDim2.new(0,0,1,0), Color=Theme.Accent, TextSize=11 })
            sl2.AutomaticSize = Enum.AutomaticSize.X
            RegAccent(sl2)
            local A = {}
            function A:SetText(t) sl2.Text = "  " .. t .. "  " end
            function A:Destroy() pcall(function() sf:Destroy() end) end
            function A:GetFrame() return sf end
            return A
        end

        function TabAPI:AddButton(o)
            o = o or {}
            local card = BaseCard(50)
            UI.Label(card, { Text=o.Name or "Button", Size=UDim2.new(0.6,0,0,18), TextSize=13 })
            UI.Label(card, { Text=o.Description or "", Position=UDim2.new(0,10,0,26), Size=UDim2.new(0.6,0,0,16), Color=Theme.SubText, Font=Enum.Font.Gotham, TextSize=10 })
            if o.RealtimeValue then
                local rL = UI.Label(card, { Text=tostring(o.RealtimeValue()), Position=UDim2.new(0.58,0,0,6), Size=UDim2.new(0.24,0,0,18), Color=Theme.Accent, TextSize=11, Align=Enum.TextXAlignment.Right })
                RegisterRealtime(rL, o.RealtimeValue)
            end
            local btn = UI.Button(card, { BG=Theme.Accent, Size=UDim2.new(0,52,0,26), Position=UDim2.new(1,-62,0.5,-13), Text="▶ RUN", TextSize=10, Radius=6 })
            RegAccent(btn)
            local glow = UI.Frame(btn, { BG=Color3.fromRGB(255,255,255), Transparency=0.82, Size=UDim2.new(1,0,0.5,0), Position=UDim2.new(0,0,0,0), Radius=6, Z=btn.ZIndex+1 })
            glow.Name = "_Glow"
            btn.MouseButton1Down:Connect(function() Tween(glow, {BackgroundTransparency=0.95}, 0.08) end)
            btn.MouseButton1Up:Connect(function() Tween(glow, {BackgroundTransparency=0.82}, 0.15) end)
            btn.MouseButton1Click:Connect(function()
                Tween(btn, {BackgroundColor3=Theme.AccentHover}, 0.1)
                task.wait(0.1)
                Tween(btn, {BackgroundColor3=Theme.Accent}, 0.1)
                if o.Callback then o.Callback() end
            end)
        end

        function TabAPI:AddToggle(o)
            o = o or {}
            local state = o.Default or false
            local card = BaseCard(50)
            UI.Label(card, { Text=o.Name or "Toggle", Size=UDim2.new(0.7,0,0,18), TextSize=13 })
            UI.Label(card, { Text=o.Description or "", Position=UDim2.new(0,10,0,26), Size=UDim2.new(0.7,0,0,16), Color=Theme.SubText, Font=Enum.Font.Gotham, TextSize=10 })
            local sw = UI.Frame(card, { BG=state and Theme.Toggle_ON or Theme.Toggle_OFF, Size=UDim2.new(0,44,0,24), Position=UDim2.new(1,-54,0.5,-12), Radius=12 })
            local kn = UI.Frame(sw, { BG=Color3.fromRGB(255,255,255), Size=UDim2.new(0,18,0,18), Position=state and UDim2.new(1,-21,0.5,-9) or UDim2.new(0,3,0.5,-9), Radius=9 })
            local ca = Instance.new("TextButton")
            ca.BackgroundTransparency = 1
            ca.Size = UDim2.new(1,0,1,0)
            ca.Text = ""
            ca.Parent = card
            local function Apply(s)
                state = s
                Tween(sw, {BackgroundColor3=s and Theme.Toggle_ON or Theme.Toggle_OFF}, 0.2)
                Tween(kn, {Position=s and UDim2.new(1,-21,0.5,-9) or UDim2.new(0,3,0.5,-9)}, 0.2)
                if o.Callback then o.Callback(s) end
            end
            ca.MouseButton1Click:Connect(function() Apply(not state) end)
            if o.ConfigKey then
                ConfigSystem:Register(o.ConfigKey, function() return state end, function(v) Apply(v) end)
            end
            RegisterUpdater(function()
                sw.BackgroundColor3 = state and Theme.Toggle_ON or Theme.Toggle_OFF
            end)
            local A = {}
            function A:SetState(s) Apply(s) end
            function A:GetState() return state end
            return A
        end

        function TabAPI:AddSlider(o)
            o = o or {}
            local mn = o.Min or 0
            local mx = o.Max or 100
            local val = math.clamp(o.Default or mn, mn, mx)
            local card = BaseCard(60)
            UI.Label(card, { Text=o.Name or "Slider", Size=UDim2.new(0.7,0,0,18), TextSize=13 })
            local vL = UI.Label(card, { Text=tostring(val), Position=UDim2.new(0.7,0,0,6), Size=UDim2.new(0.28,0,0,18), Color=Theme.Accent, TextSize=13, Align=Enum.TextXAlignment.Right })
            RegAccent(vL)
            local tr = UI.Frame(card, { BG=Theme.Slider_BG, Size=UDim2.new(1,-20,0,8), Position=UDim2.new(0,10,0,36), Radius=4 })
            local fi = UI.Frame(tr, { BG=Theme.Slider_Fill, Size=UDim2.new((val-mn)/(mx-mn),0,1,0), Radius=4 })
            local drag = false
            local function upd(pos)
                local r = math.clamp((pos.X - tr.AbsolutePosition.X) / tr.AbsoluteSize.X, 0, 1)
                val = math.floor(mn + (mx-mn)*r)
                vL.Text = tostring(val)
                fi.Size = UDim2.new(r,0,1,0)
                if o.Callback then o.Callback(val) end
            end
            tr.InputBegan:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                    drag = true; upd(i.Position)
                end
            end)
            SafeConnect(UserInputService.InputChanged, function(i)
                if drag and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
                    upd(i.Position)
                end
            end)
            SafeConnect(UserInputService.InputEnded, function(i)
                if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then drag = false end
            end)
            if o.ConfigKey then
                ConfigSystem:Register(o.ConfigKey, function() return val end, function(v)
                    val = math.clamp(v, mn, mx)
                    local r = (val-mn)/(mx-mn)
                    fi.Size = UDim2.new(r,0,1,0)
                    vL.Text = tostring(val)
                    if o.Callback then o.Callback(val) end
                end)
            end
            RegisterUpdater(function()
                tr.BackgroundColor3 = Theme.Slider_BG
                fi.BackgroundColor3 = Theme.Slider_Fill
            end)
            local A = {}
            function A:GetValue() return val end
            function A:SetValue(v)
                val = math.clamp(v, mn, mx)
                local r = (val-mn)/(mx-mn)
                fi.Size = UDim2.new(r,0,1,0)
                vL.Text = tostring(val)
                if o.Callback then o.Callback(val) end
            end
            return A
        end

        function TabAPI:AddDropdown(o)
            o = o or {}
            local items = o.Options or {}
            local sel = o.Default or (items[1] or "")
            local exp = false
            local card = BaseCard(46)
            card.ClipsDescendants = false
            UI.Label(card, { Text=o.Name or "Dropdown", Size=UDim2.new(0.55,0,0,14), Color=Theme.SubText, Font=Enum.Font.Gotham, TextSize=11 })
            local sL = UI.Label(card, { Text=sel, Position=UDim2.new(0,10,0,22), Size=UDim2.new(0.65,0,0,18), TextSize=13 })
            if o.RealtimeValue then
                local rL = UI.Label(card, { Text=tostring(o.RealtimeValue()), Position=UDim2.new(0.6,0,0,22), Size=UDim2.new(0.2,0,0,18), Color=Theme.Accent, TextSize=11, Align=Enum.TextXAlignment.Right })
                RegisterRealtime(rL, o.RealtimeValue)
            end
            local ab = UI.Button(card, { BG=Theme.Accent, Size=UDim2.new(0,30,0,30), Position=UDim2.new(1,-40,0.5,-15), Text="▼", TextSize=12, Radius=6 })
            RegAccent(ab)
            local dl = UI.Scroll(card, { BG=Theme.Dropdown_BG, Position=UDim2.new(0,0,1,4), Size=UDim2.new(1,0,0,0), ScrollThickness=3, Radius=8, Stroke=true })
            dl.Visible = false
            dl.ZIndex = 10
            UI.Layout(dl, { Padding=UDim.new(0,2) })
            UI.Padding(dl, { Top=UDim.new(0,4), Left=UDim.new(0,4), Right=UDim.new(0,4) })
            local function Pop()
                for _, c in ipairs(dl:GetChildren()) do if c:IsA("TextButton") then c:Destroy() end end
                for _, item in ipairs(items) do
                    local ib = UI.Button(dl, { BG=Theme.Secondary, Size=UDim2.new(1,0,0,26), Text="  "..item, Color=Theme.Text, Font=Enum.Font.Gotham, TextSize=12, Align=Enum.TextXAlignment.Left, Radius=6, Z=11 })
                    ib.MouseButton1Click:Connect(function()
                        sel = item; sL.Text = item
                        exp = false; dl.Visible = false; ab.Text = "▼"
                        if o.Callback then o.Callback(item) end
                    end)
                end
                dl.Size = UDim2.new(1,0,0,math.min(#items*30+8, 150))
                dl.CanvasSize = UDim2.new(0,0,0,#items*30+8)
            end
            Pop()
            ab.MouseButton1Click:Connect(function()
                exp = not exp
                dl.Visible = exp
                ab.Text = exp and "▲" or "▼"
            end)
            if o.ConfigKey then
                ConfigSystem:Register(o.ConfigKey, function() return sel end, function(v)
                    sel = v; sL.Text = v
                    if o.Callback then o.Callback(v) end
                end)
            end
            RegisterUpdater(function()
                dl.BackgroundColor3 = Theme.Dropdown_BG
            end)
            local A = {}
            function A:GetValue() return sel end
            function A:SetOptions(n) items = n; Pop() end
            return A
        end

        function TabAPI:AddInput(o)
            o = o or {}
            local card = BaseCard(60)
            UI.Label(card, { Text=o.Name or "Input", Size=UDim2.new(1,-20,0,16), Color=Theme.SubText, Font=Enum.Font.Gotham, TextSize=11 })
            local box, boxBG = UI.TextBox(card, { Placeholder=o.Placeholder or "พิมพ์ที่นี่..." })
            box.FocusLost:Connect(function(enter)
                if enter and o.Callback then o.Callback(box.Text) end
            end)
            RegisterUpdater(function()
                boxBG.BackgroundColor3 = Theme.Input_BG
            end)
            local A = {}
            function A:GetValue() return box.Text end
            function A:SetValue(v) box.Text = v end
            return A
        end

        function TabAPI:AddParagraph(o)
            o = o or {}
            local card = UI.Frame(tabFrame, { BG=Theme.Secondary, Size=UDim2.new(1,0,0,0), Radius=8, Stroke=true, Clips=true })
            card.AutomaticSize = Enum.AutomaticSize.Y
            local grad = Instance.new("UIGradient")
            grad.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromRGB(40,36,58)), ColorSequenceKeypoint.new(1, Color3.fromRGB(22,22,30)) })
            grad.Rotation = 90
            grad.Parent = card
            local bar = UI.Frame(card, { BG=Theme.Accent, Size=UDim2.new(0,3,1,-16), Position=UDim2.new(0,0,0,8), Radius=2 })
            RegSec(card)
            local inner = UI.Frame(card, { BG=Color3.new(0,0,0), Transparency=1, Size=UDim2.new(1,-12,0,0), Position=UDim2.new(0,10,0,0) })
            inner.AutomaticSize = Enum.AutomaticSize.Y
            UI.Layout(inner, { Padding=UDim.new(0,4) })
            UI.Padding(inner, { Top=UDim.new(0,8), Bottom=UDim.new(0,10) })
            local tL = UI.Label(inner, { Text=o.Title or "", Size=UDim2.new(1,0,0,18), TextSize=13 })
            tL.LayoutOrder = 1
            local sep = UI.Frame(inner, { BG=Theme.Border, Size=UDim2.new(1,0,0,1) })
            sep.LayoutOrder = 2
            RegBorder({ Color=Theme.Border, _frame=sep, _isPseudo=true })
            local cL = UI.Label(inner, { Text=o.Content or "", Size=UDim2.new(1,0,0,0), Color=Theme.SubText, Font=Enum.Font.Gotham, TextSize=12, Wrap=true })
            cL.AutomaticSize = Enum.AutomaticSize.Y
            cL.LayoutOrder = 3
            RegisterUpdater(function()
                bar.BackgroundColor3 = Theme.Accent
            end)
            local A = {}
            function A:SetTitle(t) tL.Text = t end
            function A:SetContent(t) cL.Text = t end
            return A
        end

        function TabAPI:AddColorPicker(o)
            o = o or {}
            local defColor = o.Default or Color3.fromRGB(100,60,200)
            local H, S, V = Color3.toHSV(defColor)
            local r, g, b = math.floor(defColor.R*255), math.floor(defColor.G*255), math.floor(defColor.B*255)
            local card = BaseCard(200)
            UI.Label(card, { Text=o.Name or "ColorPicker", Size=UDim2.new(0.5,0,0,16), TextSize=13 })
            local preview = UI.Frame(card, { BG=defColor, Size=UDim2.new(0.42,0,0,60), Position=UDim2.new(0.56,0,0,30), Radius=8, Stroke=true, StrokeSize=1.5 })
            local hueBar = UI.Frame(card, { BG=Color3.fromRGB(255,255,255), Size=UDim2.new(0.52,0,0,16), Position=UDim2.new(0,10,0,30), Radius=8, Stroke=true })
            local hueGrad = Instance.new("UIGradient")
            hueGrad.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255,0,0)),
                ColorSequenceKeypoint.new(0.17, Color3.fromRGB(255,255,0)),
                ColorSequenceKeypoint.new(0.33, Color3.fromRGB(0,255,0)),
                ColorSequenceKeypoint.new(0.50, Color3.fromRGB(0,255,255)),
                ColorSequenceKeypoint.new(0.67, Color3.fromRGB(0,0,255)),
                ColorSequenceKeypoint.new(0.83, Color3.fromRGB(255,0,255)),
                ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255,0,0)),
            })
            hueGrad.Parent = hueBar
            local hueKnob = UI.Frame(hueBar, { BG=Color3.fromRGB(255,255,255), Size=UDim2.new(0,6,1,4), Position=UDim2.new(H,-3,0.5,-2), Radius=3 })
            CS(hueKnob, Color3.fromRGB(0,0,0), 1.5)
            local svBox = UI.Frame(card, { BG=Color3.fromHSV(H,1,1), Size=UDim2.new(0.52,0,0,90), Position=UDim2.new(0,10,0,54), Radius=8, Stroke=true, Clips=true })
            local satGrad = UI.Frame(svBox, { BG=Color3.fromRGB(255,255,255), Size=UDim2.new(1,0,1,0) })
            local satUg = Instance.new("UIGradient")
            satUg.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0,0), NumberSequenceKeypoint.new(1,1) })
            satUg.Parent = satGrad
            local valGrad = UI.Frame(svBox, { BG=Color3.fromRGB(0,0,0), Size=UDim2.new(1,0,1,0) })
            local valUg = Instance.new("UIGradient")
            valUg.Rotation = 90
            valUg.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0,1), NumberSequenceKeypoint.new(1,0) })
            valUg.Parent = valGrad
            local cursor = UI.Frame(svBox, { BG=Color3.new(0,0,0), Transparency=1, Size=UDim2.new(0,14,0,14), Position=UDim2.new(S,-7,1-V,-7) })
            local cursorRing = UI.Frame(cursor, { BG=Color3.new(0,0,0), Transparency=1, Size=UDim2.new(1,0,1,0), Radius=7 })
            CS(cursorRing, Color3.fromRGB(255,255,255), 2)
            local cursorInner = UI.Frame(cursor, { BG=defColor, Size=UDim2.new(0,8,0,8), Position=UDim2.new(0.5,-4,0.5,-4), Radius=4 })
            local hexBox, hexBG = UI.TextBox(card, { Value="#FFFFFF", Placeholder="#RRGGBB", Size=UDim2.new(0.42,0,0,26), Position=UDim2.new(0.56,0,0,98), Font=Enum.Font.Code, TextSize=12 })
            local rgbLbl = UI.Label(card, { Text=string.format("RGB(%d, %d, %d)",r,g,b), Position=UDim2.new(0.56,0,0,128), Size=UDim2.new(0.42,0,0,16), Color=Theme.SubText, Font=Enum.Font.Code, TextSize=10, Align=Enum.TextXAlignment.Center })
            local copyBtn = UI.Button(card, { BG=Theme.Secondary, Text="📋 Copy Color3", Color=Theme.Text, Size=UDim2.new(0.42,0,0,26), Position=UDim2.new(0.56,0,0,150), TextSize=11, Radius=6 })
            CS(copyBtn, Theme.Border, 1)
            local function toHex(c)
                return string.format("#%02X%02X%02X", math.floor(c.R*255), math.floor(c.G*255), math.floor(c.B*255))
            end
            local function updateAll(fromHex)
                local c = Color3.fromHSV(H, S, V)
                r, g, b = math.floor(c.R*255), math.floor(c.G*255), math.floor(c.B*255)
                preview.BackgroundColor3 = c
                cursorInner.BackgroundColor3 = c
                svBox.BackgroundColor3 = Color3.fromHSV(H, 1, 1)
                hueKnob.Position = UDim2.new(H, -3, 0.5, -2)
                cursor.Position = UDim2.new(S, -7, 1 - V, -7)
                if not fromHex then hexBox.Text = toHex(c) end
                rgbLbl.Text = string.format("RGB(%d, %d, %d)", r, g, b)
                if o.Callback then o.Callback(c) end
            end
            local hueDrag = false
            hueBar.InputBegan:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                    hueDrag = true
                    H = math.clamp((i.Position.X - hueBar.AbsolutePosition.X) / hueBar.AbsoluteSize.X, 0, 1)
                    updateAll()
                end
            end)
            local svDrag = false
            svBox.InputBegan:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                    svDrag = true
                    S = math.clamp((i.Position.X - svBox.AbsolutePosition.X) / svBox.AbsoluteSize.X, 0, 1)
                    V = 1 - math.clamp((i.Position.Y - svBox.AbsolutePosition.Y) / svBox.AbsoluteSize.Y, 0, 1)
                    updateAll()
                end
            end)
            SafeConnect(UserInputService.InputChanged, function(i)
                if hueDrag and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
                    H = math.clamp((i.Position.X - hueBar.AbsolutePosition.X) / hueBar.AbsoluteSize.X, 0, 1)
                    updateAll()
                elseif svDrag and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
                    S = math.clamp((i.Position.X - svBox.AbsolutePosition.X) / svBox.AbsoluteSize.X, 0, 1)
                    V = 1 - math.clamp((i.Position.Y - svBox.AbsolutePosition.Y) / svBox.AbsoluteSize.Y, 0, 1)
                    updateAll()
                end
            end)
            SafeConnect(UserInputService.InputEnded, function(i)
                if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                    hueDrag = false; svDrag = false
                end
            end)
            hexBox.FocusLost:Connect(function()
                local text = hexBox.Text:gsub("#", "")
                if #text == 6 then
                    local rr = tonumber(text:sub(1,2), 16)
                    local gg = tonumber(text:sub(3,4), 16)
                    local bb = tonumber(text:sub(5,6), 16)
                    if rr and gg and bb then
                        local c = Color3.fromRGB(rr, gg, bb)
                        H, S, V = Color3.toHSV(c)
                        updateAll(true)
                        return
                    end
                end
                hexBox.Text = toHex(Color3.fromHSV(H, S, V))
            end)
            copyBtn.MouseButton1Click:Connect(function()
                SetClipboard(string.format("Color3.fromRGB(%d, %d, %d)", r, g, b))
                local old = copyBtn.Text
                copyBtn.Text = "✅ คัดลอกแล้ว!"
                Tween(copyBtn, {BackgroundColor3=Color3.fromRGB(30, 80, 40)}, 0.15)
                task.wait(1.5)
                copyBtn.Text = old
                Tween(copyBtn, {BackgroundColor3=Theme.Secondary}, 0.15)
            end)
            RegisterUpdater(function()
                hexBG.BackgroundColor3 = Theme.Input_BG
            end)
            updateAll()
            local A = {}
            function A:GetColor() return Color3.fromHSV(H, S, V) end
            function A:SetColor(c) H, S, V = Color3.toHSV(c); updateAll() end
            return A
        end

        function TabAPI:AddKeybind(o)
            o = o or {}
            local currentKey = o.Default or Enum.KeyCode.F
            local isListening = false
            local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
            local card = BaseCard(50)
            UI.Label(card, { Text=o.Name or "Keybind", Size=UDim2.new(0.55,0,0,18), TextSize=13 })
            UI.Label(card, { Text=o.Description or "", Position=UDim2.new(0,10,0,26), Size=UDim2.new(0.55,0,0,16), Color=Theme.SubText, Font=Enum.Font.Gotham, TextSize=10 })
            local keyBtn = UI.Button(card, { Size=UDim2.new(0,80,0,28), Position=UDim2.new(1,-90,0.5,-14), TextSize=11 })
            if isMobile then
                keyBtn.BackgroundColor3 = Theme.Accent
                keyBtn.Text = "▶ กด"
                keyBtn.MouseButton1Click:Connect(function() if o.Callback then o.Callback() end end)
                RegAccent(keyBtn)
            else
                keyBtn.BackgroundColor3 = Color3.fromRGB(40,36,60)
                keyBtn.Text = "["..tostring(currentKey.Name).."]"
                CS(keyBtn, Theme.Accent, 1.5)
                keyBtn.MouseButton1Click:Connect(function()
                    if isListening then return end
                    isListening = true
                    keyBtn.Text = "[...]"
                    keyBtn.BackgroundColor3 = Color3.fromRGB(80,40,120)
                    local conn
                    conn = UserInputService.InputBegan:Connect(function(input, gp)
                        if gp then return end
                        if input.UserInputType == Enum.UserInputType.Keyboard then
                            currentKey = input.KeyCode
                            keyBtn.Text = "["..tostring(currentKey.Name).."]"
                            keyBtn.BackgroundColor3 = Color3.fromRGB(40,36,60)
                            isListening = false
                            conn:Disconnect()
                        end
                    end)
                end)
                SafeConnect(UserInputService.InputBegan, function(input, gp)
                    if gp or isListening then return end
                    if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == currentKey then
                        if o.Callback then o.Callback() end
                    end
                end)
            end
            local A = {}
            function A:GetKey() return currentKey end
            function A:SetKey(k) currentKey = k; if not isMobile then keyBtn.Text = "["..tostring(k.Name).."]" end end
            function A:IsMobile() return isMobile end
            function A:Trigger() if o.Callback then o.Callback() end end
            return A
        end

        function TabAPI:AddCard(o)
            o = o or {}
            local h = o.Height or 80
            local card = BaseCard(h)
            local tL = UI.Label(card, { Text=o.Title or "Card", Position=UDim2.new(0,10,0,8), Size=UDim2.new(1,-20,0,18), TextSize=13 })
            UI.Frame(card, { BG=Theme.Border, Size=UDim2.new(1,-20,0,1), Position=UDim2.new(0,10,0,28) })
            local cL = UI.Label(card, { Text=o.Content or "", Position=UDim2.new(0,10,0,32), Size=UDim2.new(1,-20,0,h-38), Color=Theme.SubText, Font=Enum.Font.Gotham, TextSize=12, Wrap=true })
            local A = {}
            function A:SetTitle(t) tL.Text = t end
            function A:SetContent(t) cL.Text = t end
            return A
        end

        function TabAPI:AddProgressBar(o)
            o = o or {}
            local maxVal = o.Max or 100
            local valFn = o.Value or function() return 0 end
            local manualValue = nil
            local card = BaseCard(54)
            UI.Label(card, { Text=o.Name or "Progress", Size=UDim2.new(0.7,0,0,16), TextSize=13 })
            local vL = UI.Label(card, { Text="0/"..tostring(maxVal), Position=UDim2.new(0.7,0,0,6), Size=UDim2.new(0.28,0,0,16), Color=Theme.Accent, TextSize=11, Align=Enum.TextXAlignment.Right })
            RegAccent(vL)
            local barBG = UI.Frame(card, { BG=Theme.Slider_BG, Size=UDim2.new(1,-20,0,10), Position=UDim2.new(0,10,0,30), Radius=5 })
            local barFill = UI.Frame(barBG, { BG=Theme.Accent, Size=UDim2.new(0,0,1,0), Radius=5 })
            RegisterRealtime(vL, function()
                local cur = manualValue
                if cur == nil then
                    local ok, v = pcall(valFn)
                    cur = ok and v or 0
                end
                cur = math.clamp(cur or 0, 0, maxVal)
                local pct = cur / maxVal
                barFill.Size = UDim2.new(pct,0,1,0)
                barFill.BackgroundColor3 = pct > 0.6 and Color3.fromRGB(60,180,100)
                    or pct > 0.3 and Color3.fromRGB(200,160,40)
                    or Color3.fromRGB(200,60,60)
                return math.floor(cur) .. "/" .. tostring(maxVal)
            end)
            RegisterUpdater(function()
                barBG.BackgroundColor3 = Theme.Slider_BG
            end)
            local A = {}
            function A:SetValue(v) manualValue = tonumber(v) or 0 end
            function A:GetValue()
                if manualValue then return manualValue end
                local ok, v = pcall(valFn)
                return ok and v or 0
            end
            function A:Reset() manualValue = nil end
            return A
        end

        function TabAPI:AddMultiDropdown(o)
            o = o or {}
            local items = o.Options or {}
            local selected = {}
            for _, v in ipairs(o.Default or {}) do selected[v] = true end
            local exp = false
            local card = BaseCard(46)
            card.ClipsDescendants = false
            UI.Label(card, { Text=o.Name or "MultiDropdown", Size=UDim2.new(0.55,0,0,14), Color=Theme.SubText, Font=Enum.Font.Gotham, TextSize=11 })
            local sL = UI.Label(card, { Text="เลือก 0 รายการ", Position=UDim2.new(0,10,0,22), Size=UDim2.new(0.65,0,0,18), TextSize=13 })
            local ab = UI.Button(card, { BG=Theme.Accent, Size=UDim2.new(0,30,0,30), Position=UDim2.new(1,-40,0.5,-15), Text="▼", TextSize=12, Radius=6 })
            RegAccent(ab)
            local dl = UI.Scroll(card, { BG=Theme.Dropdown_BG, Position=UDim2.new(0,0,1,4), Size=UDim2.new(1,0,0,0), ScrollThickness=3, Radius=8, Stroke=true })
            dl.Visible = false
            dl.ZIndex = 10
            UI.Layout(dl, { Padding=UDim.new(0,2) })
            UI.Padding(dl, { Top=UDim.new(0,4), Left=UDim.new(0,4), Right=UDim.new(0,4) })
            local function updateLabel()
                local cnt = 0
                for _ in pairs(selected) do cnt = cnt + 1 end
                sL.Text = "เลือก " .. cnt .. " รายการ"
            end
            local function Pop()
                for _, c in ipairs(dl:GetChildren()) do if c:IsA("TextButton") then c:Destroy() end end
                for _, item in ipairs(items) do
                    local row = UI.Button(dl, { BG=Theme.Secondary, Size=UDim2.new(1,0,0,26), Text="", Radius=6, Z=11 })
                    local cb = UI.Frame(row, { BG=selected[item] and Theme.Toggle_ON or Theme.Toggle_OFF, Size=UDim2.new(0,16,0,16), Position=UDim2.new(0,5,0.5,-8), Radius=4 })
                    local ck = UI.Label(cb, { Text=selected[item] and "✓" or "", Size=UDim2.new(1,0,1,0), Color=Color3.fromRGB(255,255,255), TextSize=11, Align=Enum.TextXAlignment.Center })
                    UI.Label(row, { Text=item, Position=UDim2.new(0,28,0,0), Size=UDim2.new(1,-33,1,0), Color=Theme.Text, Font=Enum.Font.Gotham, TextSize=12 })
                    row.MouseButton1Click:Connect(function()
                        if selected[item] then selected[item] = nil else selected[item] = true end
                        cb.BackgroundColor3 = selected[item] and Theme.Toggle_ON or Theme.Toggle_OFF
                        ck.Text = selected[item] and "✓" or ""
                        updateLabel()
                        if o.Callback then
                            local arr = {}
                            for k in pairs(selected) do table.insert(arr, k) end
                            pcall(o.Callback, arr)
                        end
                    end)
                end
                dl.Size = UDim2.new(1,0,0,math.min(#items*30+8, 200))
                dl.CanvasSize = UDim2.new(0,0,0,#items*30+8)
            end
            Pop()
            updateLabel()
            ab.MouseButton1Click:Connect(function()
                exp = not exp
                if exp then Pop() end
                dl.Visible = exp
                ab.Text = exp and "▲" or "▼"
            end)
            RegisterUpdater(function()
                dl.BackgroundColor3 = Theme.Dropdown_BG
            end)
            local A = {}
            function A:GetSelected()
                local arr = {}
                for k in pairs(selected) do table.insert(arr, k) end
                return arr
            end
            function A:SetSelected(arr)
                selected = {}
                for _, v in ipairs(arr) do selected[v] = true end
                updateLabel()
                Pop()
            end
            return A
        end

        function TabAPI:AddNumberInput(o)
            o = o or {}
            local mn = o.Min or 0
            local mx = o.Max or 999999
            local step = o.Step or 1
            local val = math.clamp(o.Default or mn, mn, mx)
            local card = BaseCard(60)
            UI.Label(card, { Text=o.Name or "NumberInput", Size=UDim2.new(1,-20,0,16), TextSize=13 })
            local function fmt() return tostring(math.floor(val * 100) / 100) end
            local minusBtn = UI.Button(card, { BG=Theme.Secondary, Size=UDim2.new(0,30,0,28), Position=UDim2.new(0,10,0,26), Text="−", Color=Theme.Text, TextSize=14, Radius=6 })
            CS(minusBtn, Theme.Border, 1)
            local box, boxBG = UI.TextBox(card, { Value=fmt(), Size=UDim2.new(1,-90,0,28), Position=UDim2.new(0,45,0,26) })
            local plusBtn = UI.Button(card, { BG=Theme.Accent, Size=UDim2.new(0,30,0,28), Position=UDim2.new(1,-40,0,26), Text="+", TextSize=14, Radius=6 })
            RegAccent(plusBtn)
            local function Set(v)
                val = math.clamp(v, mn, mx)
                box.Text = fmt()
                if o.Callback then o.Callback(val) end
            end
            minusBtn.MouseButton1Click:Connect(function() Set(val - step) end)
            plusBtn.MouseButton1Click:Connect(function() Set(val + step) end)
            box.FocusLost:Connect(function()
                local n = tonumber(box.Text)
                if n then Set(n) else box.Text = fmt() end
            end)
            RegisterUpdater(function()
                boxBG.BackgroundColor3 = Theme.Input_BG
            end)
            local A = {}
            function A:GetValue() return val end
            function A:SetValue(v) Set(v) end
            return A
        end

        function TabAPI:AddTextArea(o)
            o = o or {}
            local h = o.Height or 100
            local card = BaseCard(h+34)
            UI.Label(card, { Text=o.Name or "TextArea", Size=UDim2.new(1,-20,0,16), TextSize=13 })
            local box, boxBG = UI.TextBox(card, { Placeholder=o.Placeholder or "พิมพ์ที่นี่...", Size=UDim2.new(1,-20,0,h), Position=UDim2.new(0,10,0,26), MultiLine=true, Wrap=true, YAlign=Enum.TextYAlignment.Top, Font=Enum.Font.Code })
            box.FocusLost:Connect(function()
                if o.Callback then o.Callback(box.Text) end
            end)
            RegisterUpdater(function()
                boxBG.BackgroundColor3 = Theme.Input_BG
            end)
            local A = {}
            function A:GetValue() return box.Text end
            function A:SetValue(v) box.Text = v end
            return A
        end

        function TabAPI:AddDivider(o)
            o = o or {}
            local card = UI.Frame(tabFrame, { BG=Color3.new(0,0,0), Transparency=1, Size=UDim2.new(1,0,0,24) })
            local line = UI.Frame(card, { BG=Theme.Border, Size=UDim2.new(1,0,0,o.Thickness or 1), Position=UDim2.new(0,0,0.5,0) })
            RegBorder({ Color=Theme.Border, _frame=line, _isPseudo=true })
            if o.Text then
                local lb = UI.Label(card, { Text="  "..o.Text.."  ", Size=UDim2.new(0,0,1,0), Position=UDim2.new(0.5,0,0,0), Color=Theme.SubText, Font=Enum.Font.Gotham, TextSize=11, Align=Enum.TextXAlignment.Center })
                lb.AutomaticSize = Enum.AutomaticSize.X
                lb.AnchorPoint = Vector2.new(0.5, 0)
                RegBG(lb)
            end
        end

        function TabAPI:AddImage(o)
            o = o or {}
            local h = o.Height or 100
            local card = BaseCard(h+30)
            UI.Label(card, { Text=o.Name or "Image", Size=UDim2.new(1,-20,0,16), TextSize=13 })
            local iBG = UI.Frame(card, { BG=Theme.Input_BG, Size=UDim2.new(1,-20,0,h), Position=UDim2.new(0,10,0,26), Radius=6, Stroke=true })
            local img = UI.Image(iBG, { Image=o.Image or "", ScaleType=o.ScaleType or Enum.ScaleType.Fit, Radius=6 })
            RegisterUpdater(function()
                iBG.BackgroundColor3 = Theme.Input_BG
            end)
            local A = {}
            function A:SetImage(id) img.Image = id end
            return A
        end

        function TabAPI:AddSearch(o)
            o = o or {}
            local card = BaseCard(60)
            UI.Label(card, { Text="🔍 "..(o.Name or "ค้นหา"), Size=UDim2.new(1,-20,0,16), TextSize=13 })
            local box, boxBG = UI.TextBox(card, { Placeholder=o.Placeholder or "พิมพ์เพื่อค้นหา..." })
            local debounce = os.clock()
            SafeConnect(box:GetPropertyChangedSignal("Text"), function()
                local now = os.clock()
                if now - debounce < 0.15 then return end
                debounce = now
                if o.OnSearch then o.OnSearch(box.Text) end
            end)
            box.FocusLost:Connect(function()
                if o.Callback then o.Callback(box.Text) end
            end)
            RegisterUpdater(function()
                boxBG.BackgroundColor3 = Theme.Input_BG
            end)
            local A = {}
            function A:GetValue() return box.Text end
            function A:SetValue(v) box.Text = v end
            return A
        end

        function TabAPI:AddTreeView(o)
            o = o or {}
            local data = o.Data or {}
            local card = BaseCard(30)
            card.AutomaticSize = Enum.AutomaticSize.Y
            card.Size = UDim2.new(1,0,0,30)
            local container = UI.Frame(card, { BG=Color3.new(0,0,0), Transparency=1, Size=UDim2.new(1,-20,0,0), Position=UDim2.new(0,10,0,6) })
            container.AutomaticSize = Enum.AutomaticSize.Y
            UI.Layout(container, { Padding=UDim.new(0,2) })
            local expanded = {}
            local function makeNode(node, depth, parentFrame)
                local row = UI.Button(parentFrame, { BG=Theme.Secondary, Size=UDim2.new(1, -depth*14, 0, 24), Position=UDim2.new(0, depth*14, 0, 0), Text="", Radius=4 })
                local icon = UI.Label(row, { Text=(node.Children and #node.Children>0) and (expanded[node] and "▼" or "▶") or "•", Size=UDim2.new(0,20,1,0), Position=UDim2.new(0,2,0,0), Color=Theme.Accent, TextSize=11 })
                RegAccent(icon)
                UI.Label(row, { Text=node.Name or "?", Position=UDim2.new(0,22,0,0), Size=UDim2.new(1,-25,1,0), Color=Theme.Text, Font=Enum.Font.Gotham, TextSize=11 })
                local childFrame = nil
                local function buildChildren()
                    if childFrame then childFrame:Destroy() end
                    if not node.Children or #node.Children == 0 then return end
                    childFrame = UI.Frame(parentFrame, { BG=Color3.new(0,0,0), Transparency=1, Size=UDim2.new(1,0,0,0) })
                    childFrame.AutomaticSize = Enum.AutomaticSize.Y
                    UI.Layout(childFrame, { Padding=UDim.new(0,2) })
                    for _, c in ipairs(node.Children) do makeNode(c, depth + 1, childFrame) end
                end
                row.MouseButton1Click:Connect(function()
                    if node.Children and #node.Children > 0 then
                        expanded[node] = not expanded[node]
                        icon.Text = expanded[node] and "▼" or "▶"
                        if expanded[node] then buildChildren()
                        else if childFrame then childFrame:Destroy(); childFrame = nil end end
                    end
                    if o.Callback then o.Callback(node) end
                end)
                if expanded[node] then buildChildren() end
            end
            for _, n in ipairs(data) do makeNode(n, 0, container) end
            return {
                Refresh = function(_, newData)
                    data = newData
                    for _, c in ipairs(container:GetChildren()) do
                        if not c:IsA("UIListLayout") then c:Destroy() end
                    end
                    for _, n in ipairs(data) do makeNode(n, 0, container) end
                end,
            }
        end

        function TabAPI:AddAccordion(o)
            o = o or {}
            local name = o.Name or "Accordion"
            local isOpenAcc = o.Default == true
            local header = UI.Button(tabFrame, { BG=Theme.Secondary, Size=UDim2.new(1,0,0,32), Text="", Radius=8 })
            CS(header, Theme.Border, 1)
            RegSec(header)
            local iconL = UI.Label(header, { Text=isOpenAcc and "▼" or "▶", Size=UDim2.new(0,24,1,0), Position=UDim2.new(0,8,0,0), Color=Theme.Accent, TextSize=12 })
            RegAccent(iconL)
            local nameL = UI.Label(header, { Text=name, Position=UDim2.new(0,34,0,0), Size=UDim2.new(1,-40,1,0), TextSize=12 })
            RegText(nameL)
            local body = UI.Frame(tabFrame, { BG=Color3.new(0,0,0), Transparency=1, Size=UDim2.new(1,0,0,0) })
            body.AutomaticSize = Enum.AutomaticSize.Y
            body.Visible = isOpenAcc
            UI.Layout(body, { Padding=UDim.new(0,6) })
            header.MouseButton1Click:Connect(function()
                isOpenAcc = not isOpenAcc
                iconL.Text = isOpenAcc and "▼" or "▶"
                body.Visible = isOpenAcc
            end)
            local SubTabAPI = {}
            for k, fn in pairs(TabAPI) do SubTabAPI[k] = fn end
            local wrapper = {}
            for k, fn in pairs(SubTabAPI) do
                wrapper[k] = function(self, ...)
                    local oldFrame = tabFrame
                    tabFrame = body
                    local a, b, c = fn(TabAPI, ...)
                    tabFrame = oldFrame
                    return a, b, c
                end
            end
            wrapper.AddAccordion = nil
            return wrapper
        end

        return TabAPI
    end

    -- WINDOW METHODS
    function WindowObj:Notify(o) EclipseLib:Notify(o) end

    function WindowObj:Show()
        Main.Visible = true
        Main.Size = UDim2.new(0,500,0,0)
        local sPos = ConfigSystem._data["_window_pos"]
        if sPos and type(sPos) == "table" and sPos.x and sPos.y then
            Main.Position = UDim2.new(0, sPos.x, 0, sPos.y)
        end
        Tween(Main, {Size=UDim2.new(0,500,0,350)}, 0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        floatBtn.Visible = false
        isOpen = true
        MinBtn.Text = "—"
    end

    function WindowObj:Hide()
        pcall(function()
            ConfigSystem._data["_window_pos"] = {
                x = Main.Position.X.Offset,
                y = Main.Position.Y.Offset,
            }
            if autosaveName and autosaveName ~= "" then
                ConfigSystem:Save(autosaveName .. "_pos")
            end
        end)
        Tween(Main, {Size=UDim2.new(0,500,0,0)}, 0.25)
        task.delay(0.3, function()
            Main.Visible = false
            floatBtn.Visible = true
        end)
    end

    function WindowObj:Toggle()
        if Main.Visible then self:Hide() else self:Show() end
    end

    function WindowObj:Destroy()
        if rainbowConn then rainbowConn:Disconnect(); rainbowConn = nil end
        for _, entry in ipairs(myRainbowAnimators) do
            pcall(function()
                if entry.conn then entry.conn:Disconnect() end
                if entry.grad then entry.grad:Destroy() end
            end)
        end
        myRainbowAnimators = {}
        for _, c in ipairs(allConnections) do pcall(function() c:Disconnect() end) end
        allConnections = {}
        pcall(function() ScreenGui:Destroy() end)
        pcall(function() floatSG:Destroy() end)
        pcall(function()
            if NotifHolder and NotifHolder.Parent then NotifHolder.Parent:Destroy() end
        end)
    end

    function WindowObj:SetNotifPosition(side) SetNotifPosition(side) end

    function WindowObj:ToggleTabBar()
        tabVisible = not tabVisible
        Tween(ToggleTabBtn, { Rotation = tabVisible and 0 or 90 }, 0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
        Tween(ToggleTabBtn, { BackgroundColor3 = tabVisible and Color3.fromRGB(60,60,80) or Theme.Accent }, 0.2)
        UpdateLayout(true)
    end

    local globalHotkeys = {}
    SafeConnect(UserInputService.InputBegan, function(input, gp)
        if gp then return end
        for _, hk in ipairs(globalHotkeys) do
            if input.KeyCode == hk.key then pcall(hk.callback) end
        end
    end)
    function WindowObj:AddGlobalHotkey(o)
        o = o or {}
        local hk = { key = o.Default or Enum.KeyCode.F, callback = o.Callback or function() end, name = o.Name or "Hotkey" }
        table.insert(globalHotkeys, hk)
        return { GetKey = function() return hk.key end, SetKey = function(k) hk.key = k end }
    end

    local autosaveEnabled = false
    local autosaveInterval = 30
    local autosaveName = "autosave"
    local autosaveDirty = false
    local lastAutosave = 0
    ConfigSystem._dirtyCallback = function() autosaveDirty = true end
    task.spawn(function()
        while Main.Parent do
            task.wait(5)
            if autosaveEnabled and autosaveDirty then
                if (os.clock() - lastAutosave) >= autosaveInterval then
                    lastAutosave = os.clock()
                    autosaveDirty = false
                    pcall(function() ConfigSystem:Save(autosaveName) end)
                end
            end
        end
    end)
    function WindowObj:SetAutosave(enabled, name, interval)
        autosaveEnabled = enabled and true or false
        if name then autosaveName = name end
        if interval then autosaveInterval = interval end
    end

    local resizeHandle = UI.Frame(Main, { BG=Color3.new(0,0,0), Transparency=1, Size=UDim2.new(0,24,0,24), Position=UDim2.new(1,-24,1,-24) })
    resizeHandle.Visible = false
    local resizeVisual = UI.Frame(resizeHandle, { BG=Theme.Accent, Transparency=0.4, Size=UDim2.new(0,14,0,14), Position=UDim2.new(1,-3,1,-3), Radius=4 })
    resizeHandle.MouseEnter:Connect(function() Tween(resizeVisual, {BackgroundTransparency=0.2}, 0.15) end)
    resizeHandle.MouseLeave:Connect(function() Tween(resizeVisual, {BackgroundTransparency=0.4}, 0.15) end)
    local resizing, resizeStart, startSize = false, nil, nil
    resizeHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            resizing = true; resizeStart = input.Position; startSize = Main.Size
        end
    end)
    SafeConnect(UserInputService.InputChanged, function(input)
        if resizing and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local d = input.Position - resizeStart
            local newX = math.max(400, startSize.X.Offset + d.X)
            local newY = math.max(280, startSize.Y.Offset + d.Y)
            Main.Size = UDim2.new(0, newX, 0, newY)
        end
    end)
    SafeConnect(UserInputService.InputEnded, function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then resizing = false end
    end)
    function WindowObj:SetResizable(b) resizeHandle.Visible = b and true or false end

    function WindowObj:Alert(o) return EclipseLib:Alert(o) end
    function WindowObj:Prompt(o) return EclipseLib:Prompt(o) end
    function WindowObj:Toast(o) return EclipseLib:Toast(o) end
    function WindowObj:Confirm(msg) return EclipseLib:Confirm(msg) end
    function WindowObj:Log(msg, level) return EclipseLib:Log(msg, level) end
    function WindowObj:ShowContextMenu(items, pos) return EclipseLib:ShowContextMenu(items, pos) end
    function WindowObj:PlaySound(name) return EclipseLib:PlaySound(name) end

    task.spawn(function()
        while Main.Parent do
            RunService.Heartbeat:Wait()
            for i = #RealtimeUpdaters, 1, -1 do
                local item = RealtimeUpdaters[i]
                if not item.label.Parent then
                    table.remove(RealtimeUpdaters, i)
                else
                    pcall(function()
                        local v = tostring(item.fn())
                        if item.label.Text ~= v then item.label.Text = v end
                    end)
                end
            end
        end
    end)

    -- WELCOME TAB
    do
        local wFrame = MakeSF("Frame_Welcome")
        wFrame.Visible = true
        tabFrames["_Welcome"] = wFrame
        activeTab = "_Welcome"

        local aCard = UI.Frame(wFrame, { BG=Theme.Secondary, Size=UDim2.new(1,0,0,84), Radius=12, Stroke=true })
        RegSec(aCard)
        local aFr = UI.Frame(aCard, { BG=Theme.Accent, Size=UDim2.new(0,62,0,62), Position=UDim2.new(0,11,0.5,-31), Radius=31 })
        CS(aFr, Theme.Accent, 2)
        RegAccent(aFr)
        UI.Image(aFr, { Image="https://www.roblox.com/headshot-thumbnail/image?userId="..tostring(LocalPlayer.UserId).."&width=150&height=150&format=png", Radius=29 })
        local dN = UI.Label(aCard, { Text=LocalPlayer.DisplayName or "?", Position=UDim2.new(0,86,0,8), Size=UDim2.new(1,-166,0,22), Color=Theme.Text, TextSize=16 })
        RegText(dN)
        local uN = UI.Label(aCard, { Text="@"..(LocalPlayer.Name or "?"), Position=UDim2.new(0,86,0,32), Size=UDim2.new(1,-166,0,16), Color=Theme.SubText, Font=Enum.Font.Gotham, TextSize=12 })
        RegSub(uN)
        local idB = UI.Frame(aCard, { BG=Theme.Accent, Size=UDim2.new(0,100,0,18), Position=UDim2.new(0,86,0,54), Radius=6 })
        RegAccent(idB)
        UI.Label(idB, { Text="🆔 "..tostring(LocalPlayer.UserId), Size=UDim2.new(1,0,1,0), Color=Color3.fromRGB(255,255,255), TextSize=10, Align=Enum.TextXAlignment.Center })

        local function MakeCopyBtn(parent, xPos, yPos, getCopyVal)
            local btn = UI.Button(parent, { BG=Theme.Secondary, Size=UDim2.new(0,60,0,20), Position=UDim2.new(1,xPos,0,yPos), Text="📋 Copy", Color=Theme.Accent, TextSize=9, Radius=5 })
            CS(btn, Theme.Accent, 1)
            btn.MouseButton1Click:Connect(function()
                SetClipboard(tostring(getCopyVal()))
                local old = btn.Text
                btn.Text = "✅ แล้ว!"
                Tween(btn, {BackgroundColor3=Color3.fromRGB(30,80,40)}, 0.1)
                task.wait(1.2)
                btn.Text = old
                Tween(btn, {BackgroundColor3=Theme.Secondary}, 0.15)
            end)
        end
        MakeCopyBtn(aCard, -68, 8, function() return LocalPlayer.DisplayName end)
        MakeCopyBtn(aCard, -68, 32, function() return LocalPlayer.Name end)

        local function MakeInfoCard(icon, label, valFn, copyable)
            local c = UI.Frame(wFrame, { BG=Theme.Secondary, Size=UDim2.new(1,0,0,54), Radius=10, Stroke=true })
            RegSec(c)
            UI.Label(c, { Text=icon, Position=UDim2.new(0,8,0,0), Size=UDim2.new(0,30,1,0), TextSize=20, Align=Enum.TextXAlignment.Center })
            UI.Label(c, { Text=label, Position=UDim2.new(0,44,0,7), Size=UDim2.new(1,-120,0,16), Color=Theme.SubText, Font=Enum.Font.Gotham, TextSize=10 })
            local vL = UI.Label(c, { Text=tostring(valFn()), Position=UDim2.new(0,44,0,24), Size=UDim2.new(1,-120,0,22), TextSize=13 })
            RegText(vL)
            RegisterRealtime(vL, valFn)
            if copyable then
                local cpBtn = UI.Button(c, { BG=Theme.Secondary, Size=UDim2.new(0,60,0,22), Position=UDim2.new(1,-70,0.5,-11), Text="📋 Copy", Color=Theme.Accent, TextSize=9, Radius=5 })
                CS(cpBtn, Theme.Accent, 1)
                cpBtn.MouseButton1Click:Connect(function()
                    SetClipboard(tostring(valFn()))
                    local old = cpBtn.Text
                    cpBtn.Text = "✅ แล้ว!"
                    Tween(cpBtn, {BackgroundColor3=Color3.fromRGB(30,80,40)}, 0.1)
                    task.wait(1.2)
                    cpBtn.Text = old
                    Tween(cpBtn, {BackgroundColor3=Theme.Secondary}, 0.15)
                end)
            end
        end

        MakeInfoCard("🗺️", "ชื่อแมพ", function()
            local ok, info = pcall(function() return game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId) end)
            if ok and info and info.Name then return info.Name end
            return "ไม่พบ"
        end, true)
        MakeInfoCard("⏳", "อายุบัญชี", function()
            local days = LocalPlayer.AccountAge or 0
            local years = math.floor(days / 365)
            local remain = days - (years * 365)
            local months = math.floor(remain / 30)
            local d = remain - (months * 30)
            local result = ""
            if years > 0 then result = result .. years .. " ปี " end
            if months > 0 then result = result .. months .. " เดือน " end
            result = result .. d .. " วัน"
            return result
        end, false)
        MakeInfoCard("📍", "Place ID", function() return tostring(game.PlaceId) end, true)
        MakeInfoCard("🖥️", "Server ID", function()
            local jid = game.JobId
            return (jid and jid ~= "") and jid or "ไม่พบ"
        end, true)
        local sessionStart = time()
        MakeInfoCard("⏱️", "เวลาที่เล่น", function()
            local elapsed = math.floor(time() - sessionStart)
            local d = math.floor(elapsed/86400); elapsed = elapsed - (d*86400)
            local h = math.floor(elapsed/3600); elapsed = elapsed - (h*3600)
            local m = math.floor(elapsed/60); local s = elapsed - (m*60)
            local result = ""
            if d > 0 then result = result .. d .. " วัน " end
            if h > 0 then result = result .. h .. " ชั่วโมง " end
            if m > 0 then result = result .. m .. " นาที " end
            result = result .. s .. " วินาที"
            return result
        end, false)

        local creditCard = UI.Frame(wFrame, { BG=Theme.Secondary, Size=UDim2.new(1,0,0,36), Radius=10, Stroke=true, StrokeColor=Theme.Accent, StrokeSize=1.2 })
        UI.Label(creditCard, { Text="🏷️  UI สร้างโดย wino444 | v6.5.2", Size=UDim2.new(1,0,1,0), Color=Theme.Accent, TextSize=12, Align=Enum.TextXAlignment.Center })
    end

    -- SETTINGS TAB
    do
        local sFrame = MakeSF("Frame_Settings")
        tabFrames["_Settings"] = sFrame

        local function SecTitle(text)
            UI.Label(sFrame, { Text=text, Size=UDim2.new(1,0,0,22), Color=Theme.Accent, TextSize=12 })
        end

        SecTitle("🎨 Preset Themes")
        local themeOrder = {"Eclipse","Ocean","Forest","Inferno","Sakura","Midnight","Rainbow"}
        local themeEmoji = { Eclipse="🌒", Ocean="🌊", Forest="🌲", Inferno="🔥", Sakura="🌸", Midnight="🖤", Rainbow="🌈" }
        local thCard = UI.Frame(sFrame, { BG=Theme.Secondary, Size=UDim2.new(1,0,0,170), Radius=8, Stroke=true })
        UI.Grid(thCard, { CellSize=UDim2.new(0,82,0,46), CellPadding=UDim2.new(0,6,0,6), MaxCells=3 })
        UI.Padding(thCard, { Top=UDim.new(0,8), Left=UDim.new(0,8), Right=UDim.new(0,8), Bottom=UDim.new(0,8) })
        for _, themeName in ipairs(themeOrder) do
            local th = EclipseLib.Themes[themeName]
            if th then
                local tb = UI.Button(thCard, { BG=th.Background, Size=UDim2.new(1,0,1,0), Text=themeEmoji[themeName].."\n"..themeName, Color=th.Text, TextSize=10, Radius=7, Wrap=true })
                CS(tb, th.Accent, 1.5)
                tb.MouseButton1Click:Connect(function()
                    if rainbowOn then return end
                    local oldBG, oldSec, oldBorder = Theme.Background, Theme.Secondary, Theme.Border
                    for k, v in pairs(th) do Theme[k] = v end
                    ApplyThemeAll({ bg=th.Background, sec=th.Secondary, accent=th.Accent, border=th.Border, inactive=th.TabInactive, text=th.Text, subtext=th.SubText, oldBG=oldBG, oldSec=oldSec, oldBorder=oldBorder })
                    RunAllUpdaters()
                    EclipseLib:Notify({Title="🎨 เปลี่ยน Theme", Content=themeName, Duration=2})
                end)
            end
        end

        SecTitle("🌈 Rainbow Mode")
        local rbCard = UI.Frame(sFrame, { BG=Theme.Secondary, Size=UDim2.new(1,0,0,54), Radius=8, Stroke=true })
        UI.Label(rbCard, { Text="🌈 Rainbow RGB", Position=UDim2.new(0,10,0,6), Size=UDim2.new(0.65,0,0,18), TextSize=13 })
        UI.Label(rbCard, { Text="ไฟ RGB หมุนรอบ (BG ด้วย)", Position=UDim2.new(0,10,0,26), Size=UDim2.new(0.65,0,0,16), Color=Theme.SubText, Font=Enum.Font.Gotham, TextSize=10 })
        local rbSw = UI.Frame(rbCard, { BG=Theme.Toggle_OFF, Size=UDim2.new(0,44,0,24), Position=UDim2.new(1,-54,0.5,-12), Radius=12 })
        local rbKn = UI.Frame(rbSw, { BG=Color3.fromRGB(255,255,255), Size=UDim2.new(0,18,0,18), Position=UDim2.new(0,3,0.5,-9), Radius=9 })
        local rbBtn = Instance.new("TextButton")
        rbBtn.BackgroundTransparency = 1
        rbBtn.Size = UDim2.new(1,0,1,0)
        rbBtn.Text = ""
        rbBtn.Parent = rbCard

        rbBtn.MouseButton1Click:Connect(function()
            rainbowOn = not rainbowOn
            Tween(rbSw, {BackgroundColor3=rainbowOn and Theme.Toggle_ON or Theme.Toggle_OFF}, 0.2)
            Tween(rbKn, {Position=rainbowOn and UDim2.new(1,-21,0.5,-9) or UDim2.new(0,3,0.5,-9)}, 0.2)

            if rainbowOn then
                savedThemeSnapshot = {}
                for _, k in ipairs({"Accent","AccentHover","TabActive","Toggle_ON","Slider_Fill","Slider_BG","Notif_Border","Background","Secondary","Border","Input_BG","Dropdown_BG"}) do
                    savedThemeSnapshot[k] = Theme[k]
                end

                rainbowConn = RunService.RenderStepped:Connect(function()
                    local hue = (os.clock() * 0.15) % 1
                    local accentColor   = Color3.fromHSV(hue, 0.85, 0.95)
                    local bgColor       = Color3.fromHSV(hue, 0.50, 0.15)
                    local secColor      = Color3.fromHSV(hue, 0.45, 0.22)
                    local borderColor   = Color3.fromHSV(hue, 0.70, 0.55)
                    local inputColor    = Color3.fromHSV(hue, 0.45, 0.25)
                    local sliderColor   = Color3.fromHSV(hue, 0.45, 0.28)
                    local dropdownColor = Color3.fromHSV(hue, 0.48, 0.22)

                    Theme.Accent       = accentColor
                    Theme.AccentHover  = Color3.fromHSV((hue + 0.05) % 1, 0.85, 1)
                    Theme.TabActive    = accentColor
                    Theme.Toggle_ON    = accentColor
                    Theme.Slider_Fill  = accentColor
                    Theme.Notif_Border = accentColor
                    Theme.Background   = bgColor
                    Theme.Secondary    = secColor
                    Theme.Border       = borderColor
                    Theme.Input_BG     = inputColor
                    Theme.Slider_BG    = sliderColor
                    Theme.Dropdown_BG  = dropdownColor

                    pcall(function()
                        for _, f in ipairs(TR.backgrounds) do f.BackgroundColor3 = bgColor end
                        for _, f in ipairs(TR.secondaries) do f.BackgroundColor3 = secColor end
                        for _, f in ipairs(TR.accents) do
                            if f:IsA("TextLabel") or f:IsA("TextButton") then f.TextColor3 = accentColor
                            else f.BackgroundColor3 = accentColor end
                        end
                        for _, s in ipairs(TR.borders) do
                            if s._isPseudo then s._frame.BackgroundColor3 = borderColor
                            else s.Color = borderColor end
                        end
                        for n, btn in pairs(tabButtons) do
                            if n == activeTab then btn.BackgroundColor3 = accentColor
                            else btn.BackgroundColor3 = Color3.fromHSV(hue, 0.42, 0.20) end
                            -- ✅ อัปเดต indicator + glow
                            local ind = btn:FindFirstChild("_Indicator")
                            if ind then ind.BackgroundColor3 = accentColor end
                            local glow = btn:FindFirstChild("_IndicatorGlow")
                            if glow then glow.BackgroundColor3 = accentColor end
                        end
                        if activeTab == "_Welcome" then welcomeBtn.BackgroundColor3 = accentColor end
                        welcomeInd.BackgroundColor3 = accentColor
                        welcomeGlow.BackgroundColor3 = accentColor
                        RunAllUpdaters()
                    end)
                end)

                for _, v in ipairs(Main:GetDescendants()) do
                    if v:IsA("UIStroke") then
                        pcall(function()
                            local grad, conn = Rainbow.Attach(v, {Speed = 60})
                            table.insert(myRainbowAnimators, { obj = v, conn = conn, grad = grad })
                        end)
                    end
                end

                EclipseLib:Notify({Title="🌈 Rainbow Mode", Content="เปิดแล้ว!", Duration=2})
            else
                if rainbowConn then rainbowConn:Disconnect(); rainbowConn = nil end
                for _, entry in ipairs(myRainbowAnimators) do
                    pcall(function()
                        if entry.conn then entry.conn:Disconnect() end
                        if entry.grad then entry.grad:Destroy() end
                    end)
                end
                myRainbowAnimators = {}
                if savedThemeSnapshot then
                    for k, v in pairs(savedThemeSnapshot) do Theme[k] = v end
                    savedThemeSnapshot = nil
                end
                for _, v in ipairs(Main:GetDescendants()) do
                    if v:IsA("UIStroke") then
                        pcall(function()
                            local grad = v:FindFirstChildOfClass("UIGradient")
                            if grad then grad:Destroy() end
                            v.Color = Theme.Border
                        end)
                    end
                end
                ApplyThemeAll({ bg=Theme.Background, sec=Theme.Secondary, accent=Theme.Accent, border=Theme.Border, inactive=Theme.TabInactive, text=Theme.Text, subtext=Theme.SubText })
                RunAllUpdaters()
                EclipseLib:Notify({Title="⚫ Rainbow Mode", Content="ปิดแล้ว", Duration=2})
            end
        end)

        SecTitle("📏 ขนาด UI")
        local szP = { {"เล็ก", UDim2.new(0,420,0,300)}, {"กลาง", UDim2.new(0,500,0,350)}, {"ใหญ่", UDim2.new(0,600,0,420)} }
        local szRow = UI.Frame(sFrame, { BG=Theme.Secondary, Size=UDim2.new(1,0,0,48), Radius=8, Stroke=true })
        UI.Layout(szRow, { Direction=Enum.FillDirection.Horizontal, Padding=UDim.new(0,6), HAlign=Enum.HorizontalAlignment.Center, VAlign=Enum.VerticalAlignment.Center })
        for _, sz in ipairs(szP) do
            local b = UI.Button(szRow, { BG=Theme.TabInactive, Size=UDim2.new(0,80,0,30), Text=sz[1], Color=Theme.Text, Radius=8 })
            b.MouseButton1Click:Connect(function()
                if isOpen then
                    Tween(Main, {Size=sz[2]}, 0.3)
                    Main.Position = UDim2.new(0.5, -sz[2].X.Offset/2, 0.5, -sz[2].Y.Offset/2)
                end
            end)
        end

        SecTitle("🔔 ตำแหน่ง Notification")
        local nRow = UI.Frame(sFrame, { BG=Theme.Secondary, Size=UDim2.new(1,0,0,48), Radius=8, Stroke=true })
        UI.Layout(nRow, { Direction=Enum.FillDirection.Horizontal, Padding=UDim.new(0,6), HAlign=Enum.HorizontalAlignment.Center, VAlign=Enum.VerticalAlignment.Center })
        local notifBtns = {}
        local function HighlightNotifBtn(active)
            for side, btn in pairs(notifBtns) do
                if side == active then
                    Tween(btn, {BackgroundColor3=Theme.Accent}, 0.2)
                    btn.TextColor3 = Color3.fromRGB(255,255,255)
                else
                    Tween(btn, {BackgroundColor3=Theme.TabInactive}, 0.2)
                    btn.TextColor3 = Theme.Text
                end
            end
        end
        local rb = UI.Button(nRow, { BG=Theme.Accent, Size=UDim2.new(0,110,0,30), Text="🔔 มุมขวาบน", Color=Color3.new(1,1,1), TextSize=11, Radius=8 })
        notifBtns.right = rb
        rb.MouseButton1Click:Connect(function()
            SetNotifPosition("right"); HighlightNotifBtn("right")
            EclipseLib:Notify({Title="🔔 เปลี่ยนตำแหน่ง", Content="มุมขวาบน", Duration=2})
        end)
        local lb = UI.Button(nRow, { BG=Theme.TabInactive, Size=UDim2.new(0,110,0,30), Text="🔔 มุมซ้ายบน", Color=Theme.Text, TextSize=11, Radius=8 })
        notifBtns.left = lb
        lb.MouseButton1Click:Connect(function()
            SetNotifPosition("left"); HighlightNotifBtn("left")
            EclipseLib:Notify({Title="🔔 เปลี่ยนตำแหน่ง", Content="มุมซ้ายบน", Duration=2})
        end)
        local testNotifBtn = UI.Button(sFrame, { BG=Theme.Secondary, Size=UDim2.new(1,0,0,28), Text="🧪 ทดสอบ Notify", Color=Theme.Accent, TextSize=11, Radius=7 })
        CS(testNotifBtn, Theme.Accent, 1)
        testNotifBtn.MouseButton1Click:Connect(function()
            EclipseLib:Notify({Title="📢 ทดสอบ", Content="ดูตำแหน่งที่เปลี่ยนไป!", Duration=2})
        end)

        SecTitle("💾 บันทึก / โหลด Config")
        local saveCard = UI.Frame(sFrame, { BG=Theme.Secondary, Size=UDim2.new(1,0,0,182), Radius=10, Stroke=true })
        UI.Label(saveCard, { Text="📝 ชื่อไฟล์ใหม่", Position=UDim2.new(0,10,0,8), Size=UDim2.new(1,-20,0,14), Color=Theme.SubText, Font=Enum.Font.Gotham, TextSize=11 })
        local nBox = UI.TextBox(saveCard, { Placeholder="พิมพ์ชื่อไฟล์...", Size=UDim2.new(1,-20,0,28), Position=UDim2.new(0,10,0,24) })
        local saveNewBtn = UI.Button(saveCard, { BG=Theme.Accent, Size=UDim2.new(1,-20,0,28), Position=UDim2.new(0,10,0,58), Text="💾 Save ใหม่", Radius=7 })
        UI.Frame(saveCard, { BG=Theme.Border, Size=UDim2.new(1,-20,0,1), Position=UDim2.new(0,10,0,94) })
        UI.Label(saveCard, { Text="📂 ไฟล์ที่บันทึกไว้", Position=UDim2.new(0,10,0,100), Size=UDim2.new(1,-20,0,14), Color=Theme.SubText, Font=Enum.Font.Gotham, TextSize=11 })
        local fileSelected = ""
        local fdBG = UI.Frame(saveCard, { BG=Theme.Dropdown_BG, Size=UDim2.new(0.48,0,0,28), Position=UDim2.new(0,10,0,118), Radius=6, Stroke=true })
        local fdLbl = UI.Label(fdBG, { Text="(ยังไม่มีไฟล์)", Size=UDim2.new(1,-26,1,0), Position=UDim2.new(0,6,0,0), TextSize=11 })
        local fdArrow = UI.Button(fdBG, { BG=Color3.new(0,0,0), Transparency=1, Size=UDim2.new(0,24,1,0), Position=UDim2.new(1,-26,0,0), Text="▼", Color=Theme.Accent, TextSize=12 })
        local fdList = UI.Frame(fdBG, { BG=Theme.Dropdown_BG, Size=UDim2.new(1,0,0,0), Position=UDim2.new(0,0,1,2), Radius=6, Stroke=true, Z=20 })
        fdList.Visible = false
        UI.Layout(fdList, { Padding=UDim.new(0,2) })
        UI.Padding(fdList, { Top=UDim.new(0,4), Left=UDim.new(0,4), Right=UDim.new(0,4) })
        local fdExp = false
        local function RefreshFileList()
            for _, c in ipairs(fdList:GetChildren()) do if c:IsA("TextButton") then c:Destroy() end end
            local files = ConfigSystem:GetSaveList()
            for _, fname in ipairs(files) do
                local fb = UI.Button(fdList, { BG=Theme.Secondary, Size=UDim2.new(1,0,0,24), Text="  "..fname, Color=Theme.Text, Font=Enum.Font.Gotham, TextSize=11, Align=Enum.TextXAlignment.Left, Radius=5, Z=21 })
                fb.MouseButton1Click:Connect(function()
                    fileSelected = fname
                    fdLbl.Text = fname
                    fdExp = false
                    fdList.Visible = false
                    fdArrow.Text = "▼"
                end)
            end
            fdList.Size = UDim2.new(1,0,0,#files*28+8)
        end
        RefreshFileList()
        fdArrow.MouseButton1Click:Connect(function()
            fdExp = not fdExp
            if fdExp then RefreshFileList() end
            fdList.Visible = fdExp
            fdArrow.Text = fdExp and "▲" or "▼"
        end)
        local loadBtn = UI.Button(saveCard, { BG=Color3.fromRGB(40,110,190), Size=UDim2.new(0.23,0,0,28), Position=UDim2.new(0.52,0,0,118), Text="📂 Load", TextSize=11, Radius=7 })
        local overBtn = UI.Button(saveCard, { BG=Color3.fromRGB(150,70,10), Size=UDim2.new(0.23,0,0,28), Position=UDim2.new(0.77,0,0,118), Text="✏️ ทับ", TextSize=11, Radius=7 })
        local cfgSt = UI.Label(saveCard, { Text="", Position=UDim2.new(0,10,0,154), Size=UDim2.new(1,-20,0,18), Color=Color3.fromRGB(60,200,100), Font=Enum.Font.Gotham, TextSize=11 })
        local function ShowSt(msg, ok)
            cfgSt.Text = msg
            cfgSt.TextColor3 = ok and Color3.fromRGB(60,200,100) or Color3.fromRGB(200,80,60)
            task.delay(3, function() cfgSt.Text = "" end)
        end
        saveNewBtn.MouseButton1Click:Connect(function()
            local name = nBox.Text
            if name == "" then ShowSt("❌ พิมพ์ชื่อไฟล์ก่อนนะ!", false); return end
            if ConfigSystem:Save(name) then
                ShowSt("✅ Save สำเร็จ!", true)
                nBox.Text = ""
                RefreshFileList()
            else
                ShowSt("❌ Save ไม่สำเร็จ", false)
            end
        end)
        loadBtn.MouseButton1Click:Connect(function()
            if fileSelected == "" or fileSelected == "(ยังไม่มีไฟล์)" then ShowSt("❌ เลือกไฟล์ก่อน", false); return end
            if ConfigSystem:Load(fileSelected) then ShowSt("✅ Load สำเร็จ!", true)
            else ShowSt("❌ ไม่พบไฟล์", false) end
        end)
        overBtn.MouseButton1Click:Connect(function()
            if fileSelected == "" or fileSelected == "(ยังไม่มีไฟล์)" then ShowSt("❌ เลือกไฟล์ก่อน", false); return end
            if ConfigSystem:Save(fileSelected) then ShowSt("✅ Save ทับสำเร็จ!", true)
            else ShowSt("❌ ไม่สำเร็จ", false) end
        end)

        SecTitle("⚠️ Danger Zone")
        local dangerCard = UI.Frame(sFrame, { BG=Color3.fromRGB(40,15,15), Size=UDim2.new(1,0,0,60), Radius=8 })
        CS(dangerCard, Color3.fromRGB(180,50,50), 1.5)
        UI.Label(dangerCard, { Text="🗑️ ทำลาย UI", Position=UDim2.new(0,10,0,6), Size=UDim2.new(0.55,0,0,18), Color=Color3.fromRGB(255,200,200), TextSize=13 })
        UI.Label(dangerCard, { Text="ลบ UI ทั้งหมด — ไม่สามารถกู้คืน", Position=UDim2.new(0,10,0,26), Size=UDim2.new(0.5,0,0,16), Color=Color3.fromRGB(180,130,130), Font=Enum.Font.Gotham, TextSize=10 })
        local resetBtn = UI.Button(dangerCard, { BG=Color3.fromRGB(100,60,30), Size=UDim2.new(0,90,0,30), Position=UDim2.new(1,-200,0.5,-15), Text="🔄 Reset", TextSize=11, Radius=7 })
        local destroyBtn = UI.Button(dangerCard, { BG=Color3.fromRGB(180,50,50), Size=UDim2.new(0,100,0,30), Position=UDim2.new(1,-105,0.5,-15), Text="🗑️ Destroy", TextSize=12, Radius=7 })
        resetBtn.MouseButton1Click:Connect(function()
            if EclipseLib:Confirm("รีเซ็ต UI กลับค่าเริ่มต้น?") then
                if rainbowOn then
                    rainbowOn = false
                    if rainbowConn then rainbowConn:Disconnect(); rainbowConn = nil end
                    for _, entry in ipairs(myRainbowAnimators) do
                        pcall(function()
                            if entry.conn then entry.conn:Disconnect() end
                            if entry.grad then entry.grad:Destroy() end
                        end)
                    end
                    myRainbowAnimators = {}
                end
                local default = EclipseLib.Themes.Eclipse
                for k, v in pairs(default) do Theme[k] = v end
                ApplyThemeAll({ bg=default.Background, sec=default.Secondary, accent=default.Accent, border=default.Border, inactive=default.TabInactive, text=default.Text, subtext=default.SubText })
                RunAllUpdaters()
                Tween(Main, {Size=UDim2.new(0,500,0,350)}, 0.3)
                Main.Position = UDim2.new(0.5,-250,0.5,-175)
                EclipseLib:Notify({Title="🔄 รีเซ็ต UI", Content="กลับค่าเริ่มต้นแล้ว", Duration=2})
            end
        end)
        destroyBtn.MouseButton1Click:Connect(function()
            if EclipseLib:Confirm("ลบ UI ทั้งหมด? การกระทำนี้ไม่สามารถย้อนกลับได้!") then
                EclipseLib:Notify({Title="🗑️ กำลังทำลาย UI...", Content="ลาก่อน! 👋", Duration=2})
                task.wait(0.5)
                WindowObj:Destroy()
            end
        end)
    end

    -- OPEN
    local function OpenMainUI()
        Main.Visible = true
        Main.Size = UDim2.new(0,500,0,0)
        Tween(Main, {Size=UDim2.new(0,500,0,350)}, 0.45, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        task.wait(0.5)
        EclipseLib:Notify({Title="🌒 " .. windowName, Content="โหลดสำเร็จแล้ว! ✨", Duration=3})
    end

    table.insert(_registeredWindows, {
        destroy = function() WindowObj:Destroy() end,
        getWindow = function() return WindowObj end,
    })

    if useKey then
        PlayIntro(loadTitle, loadSub, function()
            ShowKeySystem(keyOpts, function() OpenMainUI() end)
        end)
    else
        PlayIntro(loadTitle, loadSub, function() OpenMainUI() end)
    end

    return WindowObj
end

-- UNLOAD
function EclipseLib:Unload()
    print("[EclipseLib] 🧹 กำลัง Unload...")
    local count = 0
    for _, entry in ipairs(_registeredWindows) do
        pcall(function() entry.destroy(); count = count + 1 end)
    end
    _registeredWindows = {}
    pcall(function()
        if NotifHolder and NotifHolder.Parent then
            NotifHolder.Parent:Destroy()
            NotifHolder = nil
        end
    end)
    pcall(function()
        for obj, conn in pairs(Rainbow.Animators) do
            if conn then conn:Disconnect() end
        end
        Rainbow.Animators = {}
    end)
    pcall(function()
        for _, snd in pairs(SoundCache) do
            if snd and snd.Parent then snd:Destroy() end
        end
        SoundCache = {}
    end)
    pcall(function()
        for _, name in ipairs({
            "__EclipseLib", "__EclipseFloat", "__EclipseNotif",
            "__EclipseAlert", "__EclipsePrompt", "__EclipseToast",
            "__EclipseKey", "__EclipseIntro", "__EclipseContextMenu",
        }) do
            local existing = CoreGui:FindFirstChild(name)
            if existing then existing:Destroy() end
        end
    end)
    ConfigSystem._registered = {}
    ConfigSystem._data = {}
    ConfigSystem._dirtyCallback = nil
    print(string.format("[EclipseLib] ✅ Unload สำเร็จ (%d window)", count))
    return count
end

function EclipseLib:IsUsingFallback()
    return SCREEN_GUI_FALLBACK
end

return EclipseLib
