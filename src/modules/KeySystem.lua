-- 🌒 EclipseLib — Key System Module
-- ระบบ Key Authentication พร้อม Save Key

local KeySystem = {}

-- ═══════════════════════════════════
-- 🔑 Show Key UI
-- ═══════════════════════════════════
function KeySystem.Show(opts, Theme, Utility, onSuccess)
    local keyList   = opts.Key            or {}
    local keyTitle  = opts.KeyTitle       or "🔑 ใส่ Key"
    local keyDesc   = opts.KeyDescription or "กรอก Key เพื่อใช้งาน"
    local keyLink   = opts.KeyLink        or ""
    local saveFolder = opts.SaveFolder    or "EclipseLib"
    local keyFile   = saveFolder .. "/eclipse_key.dat"

    -- ─────────────────────────────
    -- ✅ ตรวจ Key ที่บันทึกไว้
    -- ─────────────────────────────
    local function CheckSavedKey()
        local ok, saved = pcall(function()
            if not isfolder(saveFolder) then return nil end
            if not isfile(keyFile) then return nil end
            return readfile(keyFile)
        end)
        if not ok or not saved or saved == "" then return false end
        for _, k in ipairs(keyList) do
            if k == saved then return true end
        end
        pcall(function() delfile(keyFile) end)
        return false
    end

    local function SaveKey(key)
        pcall(function()
            if not isfolder(saveFolder) then makefolder(saveFolder) end
            writefile(keyFile, key)
        end)
    end

    if CheckSavedKey() then
        onSuccess(); return
    end

    -- ─────────────────────────────
    -- 🖼️ Build Key UI
    -- ─────────────────────────────
    local sg = Utility.MakeScreenGui("__EclipseKey", 10001)

    local bgO = Instance.new("Frame")
    bgO.BackgroundColor3 = Color3.fromRGB(0,0,0); bgO.BackgroundTransparency = 0.5
    bgO.Size = UDim2.new(1,0,1,0); bgO.Parent = sg

    local card = Instance.new("Frame")
    card.BackgroundColor3 = Theme.Background
    card.Size = UDim2.new(0,320,0,300)
    card.Position = UDim2.new(0.5,-160,0.5,-150)
    card.BackgroundTransparency = 1; card.Parent = sg
    Utility.CC(card, 14); Utility.CS(card, Theme.Accent, 1.5, Theme)

    local gb = Instance.new("Frame"); gb.BackgroundColor3 = Theme.Accent
    gb.Size = UDim2.new(1,0,0,3); gb.BorderSizePixel = 0; gb.Parent = card

    local iL = Instance.new("TextLabel"); iL.BackgroundTransparency=1
    iL.Position=UDim2.new(0,0,0,16); iL.Size=UDim2.new(1,0,0,36)
    iL.Text="🔑"; iL.TextSize=28; iL.Font=Enum.Font.GothamBold
    iL.TextTransparency=1; iL.Parent=card

    local tL2 = Instance.new("TextLabel"); tL2.BackgroundTransparency=1
    tL2.Position=UDim2.new(0,0,0,58); tL2.Size=UDim2.new(1,0,0,28)
    tL2.Text=keyTitle; tL2.TextColor3=Theme.Text
    tL2.Font=Enum.Font.GothamBold; tL2.TextSize=18; tL2.TextTransparency=1; tL2.Parent=card

    local dL2 = Instance.new("TextLabel"); dL2.BackgroundTransparency=1
    dL2.Position=UDim2.new(0,20,0,90); dL2.Size=UDim2.new(1,-40,0,36)
    dL2.Text=keyDesc; dL2.TextColor3=Theme.SubText; dL2.TextWrapped=true
    dL2.Font=Enum.Font.Gotham; dL2.TextSize=12; dL2.TextTransparency=1; dL2.Parent=card

    local iBG = Instance.new("Frame"); iBG.BackgroundColor3=Theme.Input_BG
    iBG.Size=UDim2.new(1,-40,0,36); iBG.Position=UDim2.new(0,20,0,134)
    iBG.BackgroundTransparency=1; iBG.Parent=card
    Utility.CC(iBG, 8); Utility.CS(iBG, Theme.Border, 1, Theme)

    local box = Instance.new("TextBox"); box.BackgroundTransparency=1
    box.Size=UDim2.new(1,-16,1,0); box.Position=UDim2.new(0,8,0,0)
    box.PlaceholderText="ใส่ Key ที่นี่..."; box.PlaceholderColor3=Theme.SubText
    box.TextColor3=Theme.Text; box.Font=Enum.Font.Gotham; box.TextSize=13
    box.TextXAlignment=Enum.TextXAlignment.Left; box.ClearTextOnFocus=false
    box.Text=""; box.Parent=iBG

    local errL = Instance.new("TextLabel"); errL.BackgroundTransparency=1
    errL.Position=UDim2.new(0,20,0,176); errL.Size=UDim2.new(1,-40,0,20)
    errL.Text=""; errL.TextColor3=Color3.fromRGB(220,60,60)
    errL.Font=Enum.Font.Gotham; errL.TextSize=11; errL.TextTransparency=1; errL.Parent=card

    local submitBtn = Instance.new("TextButton")
    submitBtn.BackgroundColor3=Theme.Accent; submitBtn.Size=UDim2.new(1,-40,0,36)
    submitBtn.Position=UDim2.new(0,20,0,202); submitBtn.Text="✅ ยืนยัน Key"
    submitBtn.TextColor3=Color3.fromRGB(255,255,255); submitBtn.Font=Enum.Font.GothamBold
    submitBtn.TextSize=13; submitBtn.BackgroundTransparency=1; submitBtn.Parent=card
    Utility.CC(submitBtn, 8)

    local linkBtn
    if keyLink ~= "" then
        linkBtn = Instance.new("TextButton"); linkBtn.BackgroundColor3=Theme.Secondary
        linkBtn.Size=UDim2.new(1,-40,0,28); linkBtn.Position=UDim2.new(0,20,0,246)
        linkBtn.Text="🔗 รับ Key"; linkBtn.TextColor3=Theme.Accent
        linkBtn.Font=Enum.Font.GothamBold; linkBtn.TextSize=11
        linkBtn.BackgroundTransparency=1; linkBtn.Parent=card
        Utility.CC(linkBtn, 7)
        Utility.CS(linkBtn, Theme.Border, 1, Theme)
    end

    -- animate in
    Utility.Tween(bgO, {BackgroundTransparency=0.5}, 0.3)
    Utility.Tween(card, {BackgroundTransparency=0}, 0.3)
    Utility.Tween(iL, {TextTransparency=0}, 0.4)
    Utility.Tween(tL2, {TextTransparency=0}, 0.4)
    task.wait(0.1)
    Utility.Tween(dL2, {TextTransparency=0}, 0.35)
    Utility.Tween(iBG, {BackgroundTransparency=0}, 0.35)
    Utility.Tween(submitBtn, {BackgroundTransparency=0}, 0.35)
    if linkBtn then Utility.Tween(linkBtn, {BackgroundTransparency=0}, 0.35) end

    -- submit
    submitBtn.MouseButton1Click:Connect(function()
        local entered = box.Text
        local valid = false
        for _, k in ipairs(keyList) do
            if k == entered then valid = true; break end
        end
        if valid then
            SaveKey(entered)
            Utility.Tween(card, {BackgroundTransparency=1}, 0.3)
            Utility.Tween(bgO, {BackgroundTransparency=1}, 0.3)
            task.wait(0.35); sg:Destroy(); onSuccess()
        else
            errL.Text = "❌ Key ไม่ถูกต้อง"
            errL.TextTransparency = 0
            Utility.Tween(card, {BackgroundColor3=Color3.fromRGB(40,15,15)}, 0.15)
            task.wait(0.5)
            Utility.Tween(card, {BackgroundColor3=Theme.Background}, 0.2)
            task.delay(2, function() errL.Text="" end)
        end
    end)

    if linkBtn then
        linkBtn.MouseButton1Click:Connect(function()
            pcall(function()
                if setclipboard then setclipboard(keyLink)
                elseif toclipboard then toclipboard(keyLink) end
            end)
            linkBtn.Text = "✅ คัดลอก Link แล้ว!"
            task.delay(2, function() linkBtn.Text = "🔗 รับ Key" end)
        end)
    end
end

return KeySystem
