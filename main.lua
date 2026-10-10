-- main.lua
local obs = obslua

local script_dir = script_path()
package.path = script_dir .. "app/?.lua;" .. script_dir .. "app/lua/?.lua;" .. package.path

local config = require("config")
local websocket = require("websocket")
local bridge = require("bridge")
local obs_helper = require("obs")
local theme = require("theme")
local scene = require("scene")
local runningtext = require("runningtext")
local lowerthird = require("lowerthird")
local ppt = require("ppt")
local emergency = require("emergency")

function script_description()
    return "OBS Broadcast Suite v1.0\nProfessional broadcast tools for OBS Studio."
end

function script_load(settings)
    local cfg = config.load()
    websocket.start(cfg.port)
    local bindPort = cfg.port or 4455
    print(string.format("[main.lua] bind IP=127.0.0.1 PORT=%s (dock http://127.0.0.1:%s/dock/ ws ws://127.0.0.1:%s)", tostring(bindPort), tostring(bindPort), tostring(bindPort)))

    local function launch_server()
        local port = cfg.port or 4455
        print(string.format("[main.lua] launch server.ps1 IP=127.0.0.1 PORT=%s", tostring(port)))
        local cmd = 'start "" /min powershell -NoProfile -WindowStyle Hidden -ExecutionPolicy Bypass -File "' .. script_dir .. 'app/server.ps1" -Port ' .. tostring(port)
        os.execute(cmd)
    end
    launch_server()

    bridge.init(script_path() .. "app/data/")
    bridge.runningText = true
    bridge.activeScene = scene.getActive()
    obs.timer_add(function() bridge.pollCommands() end, 200)
    obs.timer_add(function() bridge.broadcastStatus() end, 500)

    obs.obs_frontend_add_event_callback(function(event)
        if event == obs.OBS_FRONTEND_EVENT_SCENE_CHANGED then
            local name = scene.getActive()
            bridge.activeScene = name
            websocket.broadcast("scene.active", { scene = name })
        end
    end)

    local function reg(event, fn)
        local function wrapped(data)
            local ip = (data and data._fromIp) or "127.0.0.1"
            local tag = ip:match("^127%.0%.0%.") and "LOOPBACK" or "REMOTE"
            print(string.format("[main.lua] IP=%s %s EVENT=%s", ip, tag, event))
            return fn(data)
        end
        websocket.on(event, wrapped)
        bridge.on(event, wrapped)
    end

    reg("scene.list", function()
        return { scenes = scene.list() }
    end)

    reg("scene.change", function(data)
        local ok, err = scene.switch(data.scene)
        if ok then
            bridge.activeScene = data.scene
            websocket.broadcast("scene.active", { scene = data.scene })
        end
        return { ok = ok, error = err }
    end)

    reg("runningtext.show", function()
        runningtext.show()
        bridge.runningText = true
        websocket.broadcast("status.update", { runningText = true })
        return { ok = true }
    end)

    reg("runningtext.hide", function()
        runningtext.hide()
        bridge.runningText = false
        websocket.broadcast("status.update", { runningText = false })
        return { ok = true }
    end)

    reg("runningtext.update", function(data)
        runningtext.update(data)
        return { ok = true }
    end)

    reg("lowerthird.show", function(data)
        lowerthird.show(data)
        bridge.lowerThird = true
        websocket.broadcast("status.update", { lowerThird = true })
        return { ok = true }
    end)

    reg("lowerthird.hide", function()
        lowerthird.hide()
        bridge.lowerThird = false
        websocket.broadcast("status.update", { lowerThird = false })
        return { ok = true }
    end)

    reg("ppt.show", function()
        ppt.show()
        bridge.pptVisible = true
        websocket.broadcast("status.update", { pptVisible = true })
        return { ok = true }
    end)

    reg("ppt.hide", function()
        ppt.hide()
        bridge.pptVisible = false
        websocket.broadcast("status.update", { pptVisible = false })
        return { ok = true }
    end)

    reg("ppt.next", function()
        local cur = ppt.next()
        websocket.broadcast("ppt.update", { current = cur, total = ppt.getCurrent().total })
        return { ok = true, current = cur }
    end)

    reg("ppt.previous", function()
        local cur = ppt.previous()
        websocket.broadcast("ppt.update", { current = cur, total = ppt.getCurrent().total })
        return { ok = true, current = cur }
    end)

    reg("ppt.current", function()
        return ppt.getCurrent()
    end)

    reg("emergency.enable", function()
        emergency.enable()
        bridge.emergency = true
        websocket.broadcast("status.update", { emergency = true })
        return { ok = true }
    end)

    reg("emergency.disable", function()
        emergency.disable()
        bridge.emergency = false
        websocket.broadcast("status.update", { emergency = false })
        return { ok = true }
    end)

    reg("theme.list", function()
        return { themes = theme.list() }
    end)

    reg("theme.change", function(data)
        config.settings.theme = data.theme
        config.save()
        theme.load(data.theme)
        return { ok = true }
    end)

    reg("config.save", function(data)
        if data and type(data) == "table" then
            for k, v in pairs(data) do
                if k ~= "_fromIp" then config.settings[k] = v end
            end
        elseif data and type(data) == "string" then
            print("[main.lua] config.save dapat string bukan table: " .. tostring(data))
        end
        config.save()
        print(string.format("[main.lua] config.save IP=%s logoPath=%s", tostring(data and data._fromIp or "unknown"), tostring(config.settings.logoPath or "")))
        return { ok = true }
    end)

    reg("config.load", function()
        return config.settings
    end)

    reg("ppt.browse", function()
        local path = ppt.browse()
        if path then
            return { ok = true, path = path }
        end
        return { ok = false }
    end)

    reg("ppt.export", function(data)
        local ok, totalOrErr = ppt.export(data.path)
        if ok then
            ppt.setTotal(totalOrErr)
            websocket.broadcast("ppt.export.done", { current = 1, total = totalOrErr })
            return { ok = true, total = totalOrErr }
        else
            websocket.broadcast("ppt.export.error", { message = totalOrErr })
            return { ok = false, error = totalOrErr }
        end
    end)
end

function script_unload()
    ppt.cleanup()
end
