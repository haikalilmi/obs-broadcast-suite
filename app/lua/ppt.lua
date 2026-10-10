-- lua/ppt.lua
local obs = obslua
local PPT = {}
local currentSlide = 1
local totalSlides = 0

function PPT.show()
    local source = obs.obs_get_source_by_name("PPT Overlay")
    if source then
        obs.obs_source_set_enabled(source, true)
        obs.obs_source_release(source)
    end
    return true
end

function PPT.hide()
    local source = obs.obs_get_source_by_name("PPT Overlay")
    if source then
        obs.obs_source_set_enabled(source, false)
        obs.obs_source_release(source)
    end
    return true
end

function PPT.next()
    if currentSlide < totalSlides then
        currentSlide = currentSlide + 1
    end
    return currentSlide
end

function PPT.previous()
    if currentSlide > 1 then
        currentSlide = currentSlide - 1
    end
    return currentSlide
end

function PPT.setTotal(n)
    totalSlides = n
end

function PPT.getCurrent()
    return { current = currentSlide, total = totalSlides }
end

function PPT.browse()
    local cmd = 'powershell -ExecutionPolicy Bypass -File "' .. script_path() .. 'app/browse-ppt.ps1"'
    local handle = io.popen(cmd, "r")
    if handle then
        local result = handle:read("*a"):gsub("%s+$", "")
        handle:close()
        if result ~= "CANCELLED" and result ~= "" then
            local pathFile = script_path() .. "app/data/ppt-path.txt"
            local f = io.open(pathFile, "w")
            if f then f:write(result); f:close() end
            return result
        end
    end
    return nil
end

function PPT.export(pptPath)
    local dataDir = script_path() .. "app/data/ppt-cache/"
    os.execute('if not exist "' .. dataDir .. '" mkdir "' .. dataDir .. '"')
    local cmd = 'powershell -ExecutionPolicy Bypass -File "' .. script_path() .. 'app/export-ppt.ps1" -pptPath "' .. pptPath .. '" -outputDir "' .. dataDir .. '"'
    local hasPopen, popen = pcall(function() return io.popen end)
    if hasPopen then
        local handle = io.popen(cmd, "r")
        if handle then
            local result = handle:read("*a")
            handle:close()
            for line in result:gmatch("[^\r\n]+") do
                if line:match("^DONE:") then
                    local num = line:match("%d+")
                    if num then totalSlides = tonumber(num) end
                    currentSlide = 1; PPT.saveState()
                    return true, totalSlides
                end
                if line:match("^ERROR:") then
                    return false, line:match("ERROR:(.+)")
                end
            end
        end
        return false, "Export failed"
    else
        os.execute(cmd)
        -- Assume success after execution
        totalSlides = 10; currentSlide = 1; PPT.saveState()
        return true, totalSlides
    end
end

function PPT.saveState()
    local JSON = require("json")
    local path = script_path() .. "app/data/ppt.json"
    local file = io.open(path, "w")
    if file then
        file:write(JSON.encode({ current = currentSlide, total = totalSlides }))
        file:close()
    end
end

function PPT.cleanup()
    local dataDir = script_path() .. "app/data/ppt-cache/"
    os.execute('if exist "' .. dataDir .. '" rmdir /s /q "' .. dataDir .. '"')
    os.execute('mkdir "' .. dataDir .. '"')
end

return PPT
