-- 🌒 EclipseLib — Utility Module
-- ฟังก์ชันพื้นฐานที่ใช้ทั่วทั้ง library

local Utility = {}

local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players          = game:GetService("Players")
local CoreGui          = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer

-- ═══════════════════════════
-- 🎬 Tween Helpers
-- ═══════════════════════════

function Utility.Tween(obj, props, t, style, dir)
    local tw = TweenService:Create(obj,
        TweenInfo.new(t or 0.2, style or Enum.EasingStyle.Quad, dir or Enum.EasingDirection.Out),
        props)
    tw:Play()
    return tw
end

function Utility.TweenWait(obj, props, t, style, dir)
    local tw = Utility.Tween(obj, props, t, style, dir)
    tw.Completed:Wait()
end

-- ═══════════════════════════
-- 🖱️ Draggable (Mobile Safe)
-- ═══════════════════════════
-- แก้ไข: เก็บ connection ไว้ใน table เพื่อ Disconnect ได้
function Utility.MakeDraggable(frame, handle, connectionTable)
    local dragging, dragStart, startPos = false, nil, nil
    local conns = connectionTable or {}

    local c1 = handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging  = true
            dragStart = input.Position
            startPos  = frame.Position
        end
    end)

    -- แก้ไข: ใช้ threshold 5px ป้องกัน UI กระตุกบนมือถือ
    local c2 = UserInputService.InputChanged:Connect(function(input)
        if not dragging then return end
        if input.UserInputType ~= Enum.UserInputType.MouseMovement
        and input.UserInputType ~= Enum.UserInputType.Touch then return end
        local d = input.Position - dragStart
        if math.abs(d.X) < 5 and math.abs(d.Y) < 5 then return end
        frame.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + d.X,
            startPos.Y.Scale, startPos.Y.Offset + d.Y
        )
    end)

    local c3 = UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    table.insert(conns, c1)
    table.insert(conns, c2)
    table.insert(conns, c3)
end

-- ═══════════════════════════
-- 🎨 UI Helpers
-- ═══════════════════════════

function Utility.CC(p, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, r or 8)
    c.Parent = p
end

function Utility.CS(p, color, t, theme)
    local s = Instance.new("UIStroke")
    s.Color  = color or (theme and theme.Border) or Color3.fromRGB(50,40,80)
    s.Thickness = t or 1
    s.Parent = p
    return s
end

-- ═══════════════════════════
-- 📋 Clipboard
-- ═══════════════════════════

function Utility.SetClipboard(text)
    pcall(function()
        if setclipboard then setclipboard(text)
        elseif toclipboard then toclipboard(text)
        elseif Clipboard then Clipboard.set(text) end
    end)
end

-- ═══════════════════════════
-- 🖥️ ScreenGui Factory
-- ═══════════════════════════

function Utility.MakeScreenGui(name, order)
    local sg = Instance.new("ScreenGui")
    sg.Name           = name
    sg.ResetOnSpawn   = false
    sg.IgnoreGuiInset = true
    sg.DisplayOrder   = order or 999
    pcall(function() sg.Parent = CoreGui end)
    if not sg.Parent or sg.Parent ~= CoreGui then
        sg.Parent = LocalPlayer:WaitForChild("PlayerGui")
    end
    return sg
end

return Utility
