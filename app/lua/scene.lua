-- lua/scene.lua
local obs = obslua
local Scene = {}

function Scene.list()
    return obs.obs_frontend_get_scene_names() or {}
end

function Scene.switch(name)
    local source = obs.obs_get_source_by_name(name)
    if source then
        obs.obs_frontend_set_current_scene(source)
        obs.obs_source_release(source)
        return true
    end
    return false, "Scene not found"
end

function Scene.getActive()
    local source = obs.obs_frontend_get_current_scene()
    if source then
        local name = obs.obs_source_get_name(source)
        obs.obs_source_release(source)
        return name
    end
    return nil
end

return Scene
