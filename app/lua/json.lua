-- lua/json.lua - Simple JSON parser/encoder for OBS Lua
local JSON = {}

local function escapeStr(s)
    s = s:gsub("\\", "\\\\")
    s = s:gsub('"', '\\"')
    s = s:gsub("\n", "\\n")
    s = s:gsub("\r", "\\r")
    s = s:gsub("\t", "\\t")
    return s
end

local function unescapeStr(s)
    s = s:gsub("\\t", "\t")
    s = s:gsub("\\r", "\r")
    s = s:gsub("\\n", "\n")
    s = s:gsub('\\"', '"')
    s = s:gsub("\\\\", "\\")
    return s
end

function JSON.encode(t)
    if type(t) ~= "table" then return JSON.encodeValue(t) end
    local parts = {}
    local isArray = true
    for k in pairs(t) do
        if type(k) ~= "number" then isArray = false; break end
    end
    if isArray then
        for i, v in ipairs(t) do
            table.insert(parts, JSON.encodeValue(v))
        end
        return "[" .. table.concat(parts, ",") .. "]"
    end
    for k, v in pairs(t) do
        table.insert(parts, '"' .. escapeStr(tostring(k)) .. '":' .. JSON.encodeValue(v))
    end
    return "{" .. table.concat(parts, ",") .. "}"
end

function JSON.encodeValue(v)
    local t = type(v)
    if t == "string" then return '"' .. escapeStr(v) .. '"'
    elseif t == "number" then return tostring(v)
    elseif t == "boolean" then return tostring(v)
    elseif t == "table" then return JSON.encode(v)
    elseif v == nil then return "null"
    else return '"' .. escapeStr(tostring(v)) .. '"'
    end
end

-- robust recursive decode, handle nested objects/arrays, BOM, spaces in paths
function JSON.decode(str)
    if not str or str == "" then return nil end
    if str:sub(1,3) == string.char(239,187,191) then str = str:sub(4) end
    local pos = 1
    local len = #str

    local function skipWs()
        while pos <= len and str:sub(pos,pos):match("%s") do pos = pos + 1 end
    end

    local function parseString()
        -- assumes pos at opening "
        pos = pos + 1
        local raw = ""
        while pos <= len do
            local c = str:sub(pos,pos)
            if c == "\\" then
                raw = raw .. c .. str:sub(pos+1,pos+1)
                pos = pos + 2
            elseif c == '"' then
                pos = pos + 1
                break
            else
                raw = raw .. c
                pos = pos + 1
            end
        end
        return unescapeStr(raw)
    end

    local parseValue, parseObject, parseArray

    parseValue = function()
        skipWs()
        if pos > len then return nil end
        local c = str:sub(pos,pos)
        if c == '"' then
            return parseString()
        elseif c == "{" then
            return parseObject()
        elseif c == "[" then
            return parseArray()
        else
            local start = pos
            while pos <= len and not str:sub(pos,pos):match("[,%]}]") do pos = pos + 1 end
            local raw = str:sub(start, pos-1):match("^%s*(.-)%s*$")
            if raw == "true" then return true
            elseif raw == "false" then return false
            elseif raw == "null" then return nil
            elseif tonumber(raw) then return tonumber(raw)
            else return raw end
        end
    end

    parseObject = function()
        -- assumes pos at {
        pos = pos + 1
        local obj = {}
        skipWs()
        if pos <= len and str:sub(pos,pos) == "}" then pos = pos + 1; return obj end
        while pos <= len do
            skipWs()
            if str:sub(pos,pos) ~= '"' then break end
            local key = parseString()
            skipWs()
            if str:sub(pos,pos) == ":" then pos = pos + 1 end
            local val = parseValue()
            obj[key] = val
            skipWs()
            local d = str:sub(pos,pos)
            if d == "," then pos = pos + 1
            elseif d == "}" then pos = pos + 1; break end
        end
        return obj
    end

    parseArray = function()
        pos = pos + 1
        local arr = {}
        skipWs()
        if pos <= len and str:sub(pos,pos) == "]" then pos = pos + 1; return arr end
        while pos <= len do
            local val = parseValue()
            table.insert(arr, val)
            skipWs()
            local d = str:sub(pos,pos)
            if d == "," then pos = pos + 1
            elseif d == "]" then pos = pos + 1; break end
        end
        return arr
    end

    skipWs()
    local c = str:sub(pos,pos)
    if c == "{" then return parseObject()
    elseif c == "[" then return parseArray()
    else return parseValue() end
end

function JSON.parseValue(v)
    if v == "true" then return true
    elseif v == "false" then return false
    elseif v == "null" then return nil
    elseif tonumber(v) then return tonumber(v)
    elseif v:match('^".*"$') then
        local inner = v:sub(2,-2)
        return unescapeStr(inner)
    else return v
    end
end

return JSON
