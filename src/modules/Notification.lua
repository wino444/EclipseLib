-- 🌒 EclipseLib — Notification Module
-- ระบบแจ้งเตือนแบบ Queue (ไม่ stack ทับกัน)

local Notification = {}
Notification.__index = Notification

local TweenService = game:GetService("TweenService")

-- ═══════════════════════════
-- 🔔 Internal State
-- ═══════════════════════════
local NotifHolder    = nil
local notifQueue     = {}
local isProcessing   = false
local activeNotifs   = 0
local MAX_VISIBLE    = 4  -- แสดงพร้อมกันสูงสุด 4 อัน

local function EnsureNotifHolder(Utility)
    if NotifHolder and NotifHolder.Parent then return end
    local sg = Utility.MakeScreenGui("__EclipseNotif", 9999)
    NotifHolder = Instance.new("Frame")
    NotifHolder.BackgroundTransparency = 1
    NotifHolder.Position = UDim2.new(1, -220, 0, 60)
    NotifHolder.Size     = UDim2.new(0, 210, 1, -120)
    NotifHolder.Parent   = sg
    local ly = Instance.new("UIListLayout")
    ly.SortOrder          = Enum.SortOrder.LayoutOrder
    ly.Padding            = UDim.new(0, 8)
    ly.VerticalAlignment  = Enum.VerticalAlignment.Top
    ly.Parent             = NotifHolder
end

-- ═══════════════════════════
-- 🎨 Type Colors
-- ═══════════════════════════
local TYPE_COLORS = {
    info    = Color3.fromRGB(100, 60, 200),
    success = Color3.fromRGB(60, 180, 100),
    error   = Color3.fromRGB(200, 60, 60),
    warn    = Color3.fromRGB(200, 160, 40),
}

-- ═══════════════════════════
-- 🔔 Show Notification
-- ═══════════════════════════
local function ShowNotif(opts, Theme, Utility)
    local title    = opts.Title    or "🌒 EclipseLib"
    local content  = opts.Content  or ""
    local duration = opts.Duration or 4
    local ntype    = opts.Type     or "info"
    local accent   = TYPE_COLORS[ntype] or TYPE_COLORS.info

    EnsureNotifHolder(Utility)
    activeNotifs = activeNotifs + 1

    local card = Instance.new("Frame")
    card.BackgroundColor3 = Theme.Notif_BG
    card.Size             = UDim2.new(1, 0, 0, 70)
    card.ClipsDescendants = true
    card.Parent           = NotifHolder
    Utility.CC(card, 10)
    Utility.CS(card, accent, 1.5)

    local bar = Instance.new("Frame")
    bar.BackgroundColor3 = accent
    bar.Size             = UDim2.new(0, 4, 1, 0)
    bar.BorderSizePixel  = 0
    bar.Parent           = card
    Utility.CC(bar, 4)

    local tL = Instance.new("TextLabel")
    tL.BackgroundTransparency = 1
    tL.Position               = UDim2.new(0, 12, 0, 8)
    tL.Size                   = UDim2.new(1, -16, 0, 20)
    tL.Text                   = title
    tL.TextColor3             = Theme.Text
    tL.Font                   = Enum.Font.GothamBold
    tL.TextSize               = 13
    tL.TextXAlignment         = Enum.TextXAlignment.Left
    tL.Parent                 = card

    local cL = Instance.new("TextLabel")
    cL.BackgroundTransparency = 1
    cL.Position               = UDim2.new(0, 12, 0, 30)
    cL.Size                   = UDim2.new(1, -16, 0, 32)
    cL.Text                   = content
    cL.TextColor3             = Theme.SubText
    cL.Font                   = Enum.Font.Gotham
    cL.TextSize               = 11
    cL.TextXAlignment         = Enum.TextXAlignment.Left
    cL.TextWrapped            = true
    cL.Parent                 = card

    local prog = Instance.new("Frame")
    prog.BackgroundColor3 = accent
    prog.Size             = UDim2.new(1, 0, 0, 2)
    prog.Position         = UDim2.new(0, 0, 1, -2)
    prog.BorderSizePixel  = 0
    prog.Parent           = card

    -- slide in
    card.Position = UDim2.new(1, 10, 0, 0)
    Utility.Tween(card, {Position = UDim2.new(0, 0, 0, 0)}, 0.3)

    -- progress bar timer
    TweenService:Create(prog, TweenInfo.new(duration, Enum.EasingStyle.Linear), {Size = UDim2.new(0, 0, 0, 2)}):Play()

    -- auto dismiss
    task.delay(duration, function()
        Utility.Tween(card, {Position = UDim2.new(1, 10, 0, 0)}, 0.3)
        task.wait(0.35)
        card:Destroy()
        activeNotifs = activeNotifs - 1
    end)
end

-- ═══════════════════════════
-- 📬 Queue Processor
-- ═══════════════════════════
local function ProcessQueue(Theme, Utility)
    if isProcessing then return end
    isProcessing = true
    task.spawn(function()
        while #notifQueue > 0 do
            if activeNotifs < MAX_VISIBLE then
                local opts = table.remove(notifQueue, 1)
                ShowNotif(opts, Theme, Utility)
            end
            task.wait(0.1)
        end
        isProcessing = false
    end)
end

-- ═══════════════════════════
-- 📢 Public API
-- ═══════════════════════════
function Notification.Notify(opts, Theme, Utility)
    table.insert(notifQueue, opts)
    ProcessQueue(Theme, Utility)
end

function Notification.SetPosition(pos)
    if NotifHolder then
        NotifHolder.Position = pos
    end
end

function Notification.GetHolder()
    return NotifHolder
end

return Notification
