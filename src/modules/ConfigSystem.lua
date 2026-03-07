-- 🌒 EclipseLib — Config System Module
-- ระบบ Save / Load config แบบ JSON-safe

local ConfigSystem = {}
ConfigSystem.__index = ConfigSystem
ConfigSystem._folder     = "EclipseLib"
ConfigSystem._data       = {}
ConfigSystem._registered = {}

-- ═══════════════════════════════════
-- 🛡️ Safe Encode / Decode (แก้ไข)
-- ป้องกัน value ที่มี = หรือ \n พัง parser
-- ═══════════════════════════════════

local function Encode(snapshot)
    local lines = {}
    for k, v in pairs(snapshot) do
        local vStr = tostring(v)
        -- escape \n และ = ใน value
        vStr = vStr:gsub("\\", "\\\\"):gsub("\n", "\\n"):gsub("=", "\\=")
        local kStr = tostring(k):gsub("\\", "\\\\"):gsub("\n", "\\n")
        table.insert(lines, kStr .. "=" .. vStr)
    end
    return table.concat(lines, "\n")
end

local function Decode(raw)
    local result = {}
    for line in (raw .. "\n"):gmatch("([^\n]*)\n") do
        if line ~= "" then
            -- split แค่ = ตัวแรกที่ไม่ได้ escape
            local k, v = line:match("^(.-)=(.*)")
            if k and v then
                -- unescape
                k = k:gsub("\\=", "="):gsub("\\n", "\n"):gsub("\\\\", "\\")
                v = v:gsub("\\=", "="):gsub("\\n", "\n"):gsub("\\\\", "\\")
                -- type coerce
                if v == "true" then v = true
                elseif v == "false" then v = false
                elseif tonumber(v) then v = tonumber(v) end
                result[k] = v
            end
        end
    end
    return result
end

-- ═══════════════════════════════════
-- 📁 Folder
-- ═══════════════════════════════════
function ConfigSystem:SetFolder(f)
    self._folder = f
end

-- ═══════════════════════════════════
-- 📝 Register
-- ═══════════════════════════════════
function ConfigSystem:Register(key, getFn, setFn)
    self._registered[key] = {get = getFn, set = setFn}
end

-- ═══════════════════════════════════
-- 📋 GetSaveList
-- ═══════════════════════════════════
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
    -- เพิ่มจาก in-memory ถ้ายังไม่มีในไฟล์
    for k in pairs(self._data) do
        local found = false
        for _, v in ipairs(list) do if v == k then found = true; break end end
        if not found then table.insert(list, k) end
    end
    if #list == 0 then table.insert(list, "(ยังไม่มีไฟล์)") end
    return list
end

-- ═══════════════════════════════════
-- 💾 Save
-- ═══════════════════════════════════
function ConfigSystem:Save(filename)
    if not filename or filename == "" or filename == "(ยังไม่มีไฟล์)" then return false end
    local snapshot = {}
    for key, fns in pairs(self._registered) do
        pcall(function() snapshot[key] = fns.get() end)
    end
    self._data[filename] = snapshot
    local ok = pcall(function()
        if not isfolder(self._folder) then makefolder(self._folder) end
        writefile(self._folder .. "/" .. filename .. ".eclipse", Encode(snapshot))
    end)
    return true
end

-- ═══════════════════════════════════
-- 📂 Load
-- ═══════════════════════════════════
function ConfigSystem:Load(filename)
    if not filename or filename == "" or filename == "(ยังไม่มีไฟล์)" then return false end
    local snapshot = self._data[filename]
    if not snapshot then
        snapshot = {}
        pcall(function()
            local path = self._folder .. "/" .. filename .. ".eclipse"
            if isfile(path) then
                snapshot = Decode(readfile(path))
            end
        end)
    end
    for key, fns in pairs(self._registered) do
        if snapshot[key] ~= nil then
            pcall(function() fns.set(snapshot[key]) end)
        end
    end
    return true
end

-- ═══════════════════════════════════
-- 🗑️ Delete
-- ═══════════════════════════════════
function ConfigSystem:Delete(filename)
    if not filename or filename == "" or filename == "(ยังไม่มีไฟล์)" then return false end
    self._data[filename] = nil
    pcall(function()
        local path = self._folder .. "/" .. filename .. ".eclipse"
        if isfile(path) then delfile(path) end
    end)
    return true
end

return ConfigSystem
