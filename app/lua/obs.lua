-- lua/obs.lua
local obs = obslua

local OBS = {}

function OBS.getScenes()
    local scenes = {}
    local source_names = obs.obs_frontend_get_scene_names()
    for _, name in ipairs(source_names) do
        table.insert(scenes, name)
    end
    return scenes
end

function OBS.setCurrentScene(name)
    local source = obs.obs_get_source_by_name(name)
    if source then
        obs.obs_frontend_set_current_scene(source)
        obs.obs_source_release(source)
        return true
    end
    return false
end

function OBS.updateSourceText(source_name, text)
    local source = obs.obs_get_source_by_name(source_name)
    if source then
        local settings = obs.obs_source_get_settings(source)
        obs.obs_data_set_string(settings, "text", text)
        obs.obs_source_update(source, settings)
        obs.obs_data_release(settings)
        obs.obs_source_release(source)
    end
end

return OBS
