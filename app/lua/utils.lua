-- lua/utils.lua
local Utils = {}

function Utils.fileExists(path)
    local file = io.open(path, "r")
    if file then
        file:close()
        return true
    end
    return false
end

function Utils.readJSON(path)
    local file = io.open(path, "r")
    if not file then return nil end
    local content = file:read("*a")
    file:close()
    local ok, result = pcall(function()
        -- Using basic parser or external json module
        return content
    end)
    if ok then return result end
    return nil
end

function Utils.writeJSON(path, data)
    local file = io.open(path, "w")
    if not file then return false end
    file:write(data)
    file:close()
    return true
end

return Utils
