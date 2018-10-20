local surface_spawn = minetest.setting_get_pos("tigris.surface_spawn")

local function find_spawn()
    for level=0,10 do
        local r = level * 100
        for x=-r,r,50 do
        for z=-r,r,50 do
            local y = minetest.get_spawn_level(x, z)
            if y then
                return vector.new(x, y, z)
            end
        end
        end
    end
end

function tigris.story.surface_spawn()
    surface_spawn = surface_spawn or find_spawn()
    assert(surface_spawn, "Unable to find surface spawn. Perhaps set tigris.surface_spawn in minetest.conf.")
    return surface_spawn
end
