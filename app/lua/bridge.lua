-- lua/bridge.lua
local JSON = require("json")
local Bridge = {}
Bridge.dataDir = ""
Bridge.lastCmdHash = ""
Bridge.lastStatusHash = ""

function Bridge.init(dataDir)
    Bridge.dataDir = dataDir
end

function Bridge.pollCommands()
    local path = Bridge.dataDir .. "command.json"
    local file = io.open(path, "r")
    if file then
        local content = file:read("*a")
        file:close()
        local hash = tostring(#content) .. (content:sub(1, 50) or "")
        if hash ~= Bridge.lastCmdHash then
            Bridge.lastCmdHash = hash
            local ok, cmd = pcall(JSON.decode, content)
            if ok and cmd and cmd.event then
                local fromIp = cmd._fromIp or cmd._from_ip or cmd.fromIp or "127.0.0.1"
                -- inject IP into data so handler di main.lua bisa log
                if cmd.data and type(cmd.data) == "table" then
                    cmd.data._fromIp = fromIp
                elseif not cmd.data then
                    cmd.data = { _fromIp = fromIp }
                end
                local tag = fromIp:match("^127%.0%.0%.") and "LOOPBACK" or "REMOTE"
                print(string.format("[bridge.lua] IP=%s %s EVENT=%s", fromIp, tag, cmd.event))
                local handler = Bridge.handlers and Bridge.handlers[cmd.event]
                if handler then
                    local ok2, result = pcall(handler, cmd.data or {})
                    if ok2 and result then
                        Bridge.writeResponse(result)
                    end
                    if not ok2 then
                        print(string.format("[bridge.lua] handler error IP=%s EVENT=%s err=%s", fromIp, cmd.event, tostring(result)))
                    end
                else
                    print(string.format("[bridge.lua] no handler IP=%s EVENT=%s", fromIp, cmd.event))
                end
            end
        end
    end
end

function Bridge.writeResponse(data)
    local path = Bridge.dataDir .. "response.json"
    local file = io.open(path, "w")
    if file then
        file:write(JSON.encode({ success = true, data = data, timestamp = os.time() }))
        file:close()
    end
end

function Bridge.broadcastStatus()
    local path = Bridge.dataDir .. "status.json"
    local file = io.open(path, "w")
    if file then
        local status = {
            runningText = Bridge.runningText or false,
            lowerThird = Bridge.lowerThird or false,
            pptVisible = Bridge.pptVisible or false,
            emergency = Bridge.emergency or false,
            activeScene = Bridge.activeScene or "",
            timestamp = os.time()
        }
        local content = JSON.encode(status)
        local hash = tostring(#content)
        if hash ~= Bridge.lastStatusHash then
            Bridge.lastStatusHash = hash
            file:write(content)
        end
        file:close()
    end
end

function Bridge.on(event, callback)
    if not Bridge.handlers then Bridge.handlers = {} end
    Bridge.handlers[event] = callback
end

return Bridge
