-- 👥 EclipseFragment — Players Module
-- ดึงข้อมูลผู้เล่นทุกคนในเกม

local Players = game:GetService("Players")
local Module = {}

-- ❤️ ดึง HP ทุกคน
function Module:GetAllHP()
    local result = {}
    for _, p in ipairs(Players:GetPlayers()) do
        local hp = 0
        local maxHp = 0
        pcall(function()
            local hum = p.Character:FindFirstChildOfClass("Humanoid")
            hp = hum.Health
            maxHp = hum.MaxHealth
        end)
        table.insert(result, {
            Name   = p.Name,
            HP     = hp,
            MaxHP  = maxHp,
        })
    end
    return result
end

-- ❤️ ดึง HP คนเดียว
function Module:GetHP(playerName)
    local p = Players:FindFirstChild(playerName)
    if not p then return nil end
    local hp, maxHp = 0, 0
    pcall(function()
        local hum = p.Character:FindFirstChildOfClass("Humanoid")
        hp = hum.Health
        maxHp = hum.MaxHealth
    end)
    return {Name=p.Name, HP=hp, MaxHP=maxHp}
end

-- 📍 ดึงตำแหน่งทุกคน
function Module:GetAllPositions()
    local result = {}
    for _, p in ipairs(Players:GetPlayers()) do
        local pos = nil
        pcall(function()
            pos = p.Character.HumanoidRootPart.Position
        end)
        table.insert(result, {
            Name     = p.Name,
            Position = pos,
        })
    end
    return result
end

-- 🔧 ดึง Tool ที่ถือในมือ
function Module:GetTool(playerName)
    local p = Players:FindFirstChild(playerName)
    if not p or not p.Character then return nil end
    local tool = p.Character:FindFirstChildOfClass("Tool")
    return tool and tool.Name or "ไม่มี"
end

-- 📊 ดึงข้อมูล Player ทั้งหมด
function Module:GetAllInfo()
    local result = {}
    for _, p in ipairs(Players:GetPlayers()) do
        local hp, maxHp, pos, tool = 0, 0, nil, "ไม่มี"
        pcall(function()
            local hum = p.Character:FindFirstChildOfClass("Humanoid")
            hp = hum.Health
            maxHp = hum.MaxHealth
            pos = p.Character.HumanoidRootPart.Position
            local t = p.Character:FindFirstChildOfClass("Tool")
            if t then tool = t.Name end
        end)
        table.insert(result, {
            Name     = p.Name,
            HP       = hp,
            MaxHP    = maxHp,
            Position = pos,
            Tool     = tool,
            Team     = tostring(p.Team),
            UserID   = p.UserId,
        })
    end
    return result
end

return Module
