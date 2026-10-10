-- lua/theme.lua
local JSON = require("json")
local Theme = {}
Theme.current = nil

function Theme.load(name)
    local path = script_path() .. "app/themes/" .. name .. ".json"
    local file = io.open(path, "r")
    if file then
        local content = file:read("*a")
        file:close()
        local ok, data = pcall(JSON.decode, content)
        if ok and data then Theme.current = data end
    end
    return Theme.current
end

function Theme.list()
    return {"modern", "minimal", "flat", "islamic"}
end

return Theme
