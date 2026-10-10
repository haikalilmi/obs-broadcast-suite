-- lua/config.lua
local JSON = require("json")
local Config = {}
Config.settings = {}

function Config.load()
    local path = script_path() .. "app/config/settings.json"
    local file = io.open(path, "r")
    if file then
        local content = file:read("*a")
        file:close()
        local ok, result = pcall(JSON.decode, content)
        if ok and result and type(result) == "table" then Config.settings = result end
    end
    if type(Config.settings) ~= "table" or not next(Config.settings) then
        Config.settings = { port = 4456, theme = "modern" }
        Config.save()
    end
    return Config.settings
end

function Config.save()
    local path = script_path() .. "app/config/settings.json"
    local file = io.open(path, "w")
    if file then
        file:write(JSON.encode(Config.settings))
        file:close()
    end
end

return Config
