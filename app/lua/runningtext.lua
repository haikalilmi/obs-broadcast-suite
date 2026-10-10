-- lua/runningtext.lua
local obs = obslua
local RunningText = {}
local active = false

function RunningText.show()
    active = true
    local source = obs.obs_get_source_by_name("Running Text")
    if source then
        obs.obs_source_set_enabled(source, true)
        obs.obs_source_release(source)
    end
    return true
end

function RunningText.hide()
    active = false
    local source = obs.obs_get_source_by_name("Running Text")
    if source then
        obs.obs_source_set_enabled(source, false)
        obs.obs_source_release(source)
    end
    return true
end

function RunningText.update(data)
    if data.text then
        local source = obs.obs_get_source_by_name("Running Text Source")
        if source then
            local settings = obs.obs_source_get_settings(source)
            obs.obs_data_set_string(settings, "text", data.text)
            obs.obs_source_update(source, settings)
            obs.obs_data_release(settings)
            obs.obs_source_release(source)
        end
    end
end

function RunningText.getStatus()
    return { active = active }
end

return RunningText
