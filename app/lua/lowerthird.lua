-- lua/lowerthird.lua
local obs = obslua
local LowerThird = {}
local active = false

function LowerThird.show(data)
    active = true
    local source = obs.obs_get_source_by_name("Lower Third")
    if source then
        obs.obs_source_set_enabled(source, true)
        obs.obs_source_release(source)
    end
    if data.duration and data.duration > 0 then
        -- Auto hide after duration
        -- In real implementation: obs.timer_add(hide, data.duration * 1000)
    end
    return true
end

function LowerThird.hide()
    active = false
    local source = obs.obs_get_source_by_name("Lower Third")
    if source then
        obs.obs_source_set_enabled(source, false)
        obs.obs_source_release(source)
    end
    return true
end

function LowerThird.getStatus()
    return { active = active }
end

return LowerThird
