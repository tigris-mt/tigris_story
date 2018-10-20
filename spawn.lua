simple_quests.register("tigris_story:arrival", {
    shortdesc = "Arrival",
    init = function(state)
        state.longdesc = "Your first orders after arrival in the new world."
        state.superdesc = "Welcome to the Room of Light.\nThe time has come for you to conquer this world.\nApproach the altar of Anemyde the Merciful and receive her blessing."

        state:objective("pray", {
            description = "Pray at the altar.",
        })
    end,

    done = function(state)
        tigris.story.give_quest("tigris_story:first_mining", state.quest.player)
    end,
})

local function try_begin(player)
    if player:get_meta():get_int("tigris_story_begun") ~= 1 then
        tigris.story.give_quest("tigris_story:arrival", player:get_player_name())
        player:get_meta():set_int("tigris_story_begun", 1)
    end
end

minetest.register_on_newplayer(function(player)
    if underground_start.done then
        try_begin(player)
    end
end)

minetest.register_on_joinplayer(function(player)
    if underground_start.done then
        try_begin(player)
    end
end)

local old = underground_start.generation_callback
function underground_start.generation_callback(...)
    minetest.set_node(vector.add(({underground_start.box()})[1], vector.new(0, 0, 3)), {name = "tigris_story:altar"})

    for _,t in ipairs(underground_start.tunnels) do
        local pos = vector.divide(vector.add(t.min, t.max), 2)
        pos.y = t.min.y + 1
        minetest.set_node(pos, {name = "tigris_story:lightwood_spawner"})
    end

    for _,player in ipairs(minetest.get_connected_players()) do
        try_begin(player)
    end
    return old(...)
end

-- Timed device to respawn lightwood in the nearby caves.
-- This is necessary to ensure that new players always have enough lightwood to complete the initial quests.
minetest.register_node("tigris_story:lightwood_spawner", {
    description = "Lightwood Spawner",
    tiles = {"default_diamond_block.png^tigris_underworld_lightwood_sapling.png"},
    sounds = default.node_sound_stone_defaults(),

    on_construct = function(pos)
        minetest.get_node_timer(pos):start(1)
        minetest.get_meta(pos):set_string("infotext", "Sowing Hand of Anemyde\nThis sacred device applies the slow but inevitable power of Anemyde to ensure the nearby caves will never run out of lightwood.")
    end,

    on_timer = function(pos)
        local r = vector.new(50, 20, 50)
        local min, max = vector.subtract(pos, r), vector.add(pos, r)

        local function pod()
            local poses = minetest.find_nodes_in_area_under_air(min, max, {"tigris_underworld:lightwood_trunk"})
            while #poses > 0 do
                local i = math.random(#poses)
                local pos = poses[i]
                table.remove(poses, i)

                minetest.log("action", ("Respawned lightwood pod on tree at %s."):format(minetest.pos_to_string(pos)))
                minetest.set_node(vector.add(pos, vector.new(0, 1, 0)), {name = "tigris_underworld:lightwood_pod"})
                return true
            end
            return false
        end

        local function tree(nodes)
            local poses = minetest.find_nodes_in_area_under_air(min, max, nodes)
            while #poses > 0 do
                local i = math.random(#poses)
                local pos = poses[i]
                table.remove(poses, i)

                local height = math.random(2, 5)
                while height >= 2 do
                    local clear = true
                    for yadd=1,height do
                        if minetest.get_node(vector.add(pos, vector.new(0, yadd, 0))).name ~= "air" then
                            clear = false
                            break
                        end
                    end
                    if clear then
                        break
                    end
                    height = height - 1
                end

                if height >= 2 then
                    minetest.log("action", ("Respawned lightwood tree (height %d) at %s."):format(height, minetest.pos_to_string(pos)))
                    local ht = height - 1
                    for yadd=1,ht do
                        minetest.set_node(vector.add(pos, vector.new(0, yadd, 0)), {name = "tigris_underworld:lightwood_trunk"})
                    end
                    minetest.set_node(vector.add(pos, vector.new(0, height, 0)), {name = "tigris_underworld:lightwood_pod"})
                    return true
                end
            end
            return false
        end

        -- If there's less than 10 pods in the area, spawn more.
        if #minetest.find_nodes_in_area(min, max, {"tigris_underworld:lightwood_pod"}) < 10 then
            -- First try least invasive option, just replacing on a trunk.
            if not pod() then
                -- Then try spawning a tree on coal.
                if not tree({"default:stone_with_coal", "default:coalblock"}) then
                    -- Final fallback, try spawning on any stone.
                    tree({"group:stone"})
                end
            end
        end
        minetest.get_node_timer(pos):start(math.random(20 * 60, 40 * 60))
    end,
})
