-- lua/websocket.lua
local JSON = require("json")
local WebSocket = {}
WebSocket.clients = {}
WebSocket.handlers = {}

function WebSocket.start(port)
    print("OBS Broadcast Suite: WebSocket starting on port " .. port)
end

function WebSocket.on(event, callback)
    WebSocket.handlers[event] = callback
end

function WebSocket.handleMessage(json_msg)
    local ok, msg = pcall(JSON.decode, json_msg)
    if not ok or not msg or not msg.event then return end

    local handler = WebSocket.handlers[msg.event]
    if handler then
        local ok, result = pcall(handler, msg.data or {})
        if ok and result then
            WebSocket.sendResponse(msg.event, result)
        end
    end

    local wildcard = WebSocket.handlers["*"]
    if wildcard then
        pcall(wildcard, msg)
    end
end

function WebSocket.sendResponse(event, data)
    local payload = {
        success = true,
        event = event,
        data = data,
        message = "ok",
        timestamp = os.time()
    }
    WebSocket.broadcast(payload.event, payload.data)
end

function WebSocket.sendError(event, error_msg)
    local payload = {
        success = false,
        event = event,
        error = error_msg,
        message = error_msg,
        timestamp = os.time()
    }
    WebSocket.broadcast(payload.event, payload)
end

function WebSocket.broadcast(event, data)
    local payload = {
        event = event,
        data = data,
        timestamp = os.time()
    }
    for _, client in ipairs(WebSocket.clients) do
        client:send(payload)
    end
end

function WebSocket.addClient(client)
    table.insert(WebSocket.clients, client)
end

function WebSocket.removeClient(client)
    for i, c in ipairs(WebSocket.clients) do
        if c == client then
            table.remove(WebSocket.clients, i)
            break
        end
    end
end

return WebSocket
