-- lua/emergency.lua
local obs = obslua
local Emergency = {}
local active = false

function Emergency.enable()
    active = true
    local source = obs.obs_get_source_by_name("Emergency Overlay")
    if source then
        obs.obs_source_set_enabled(source, true)
        obs.obs_source_release(source)
    end
    local scene = obs.obs_get_source_by_name("Emergency")
    if scene then
        obs.obs_frontend_set_current_scene(scene)
        obs.obs_source_release(scene)
    end
    return true
end

function Emergency.disable()
    active = false
    local source = obs.obs_get_source_by_name("Emergency Overlay")
    if source then
        obs.obs_source_set_enabled(source, false)
        obs.obs_source_release(source)
    end
    return true
end

function Emergency.getStatus()
    return { active = active }
end

return Emergency
