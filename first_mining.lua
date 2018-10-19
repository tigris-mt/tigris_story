simple_quests.register("tigris_story:first_mining", {
    shortdesc = "First Mining",
    init = function(state)
        state.longdesc = "Begin your journey by mining important base materials."
        state.superdesc = "Venturing out of the Room of Light is a task in itself. Because Anemyde has situated it under the surface of the planet, you must tunnel and cave your way out.\nBegin by gathering materials necessary for your survival outside the Room of Light.\nDescend the ladder to the tunnels constructed by Anemyde herself.\nStone is readily found, but you may need to search within caves for Lightwood trees."
        state.step = "farm"

        state:objective("stone", simple_quests.ohelp.count.init{
            description = "Mine stone.",
            max_count = 20,
        })

        state:objective("lightwood_trunk", simple_quests.ohelp.count.init{
            description = "Mine lightwood trunks.",
            max_count = 2,
        })

        state:objective("lightwood_pod", simple_quests.ohelp.count.init{
            description = "Mine a lightwood seed pod.",
            max_count = 1,
        })
    end,

    steps = {
        farm = function(state)
            minetest.chat_send_player(state.quest.player, "Lightwood trees are important resources. You can grow new lightwood trees by placing their saplings on coal blocks or coal in stone. Be careful that there is enough empty space above the sapling for it to grow.")
            state:objective("place", simple_quests.ohelp.count.init{
                description = "Place a lightwood sapling on coal.",
                max_count = 1,
            })
            state:set_step("pray")
        end,
        pray = function(state)
            state:objective("pray", {
                description = "Pray at the Altar of Anemyde.",
            })

            state:set_step("done")
        end,
    },

    done = function(state)
        local player = minetest.get_player_by_name(state.quest.player)
        if player and player:get_meta():get_int("tigris_story:given_glasses") ~= 1 then
            minetest.add_item(player:get_pos(), player:get_inventory():add_item("main", ItemStack("tigris_magic:mapping_glasses")))
            minetest.chat_send_player(state.quest.player, "You receive Glasses of Mapping. Equip them like jewelry.")
            player:get_meta():set_int("tigris_story:given_glasses", 1)
        end
    end,
})

minetest.register_on_dignode(function(pos, node, digger)
    local name = digger:get_player_name()
    local q = simple_quests.quest_active("tigris_story:first_mining", name)
    if q then
        for k,v in pairs{
            stone = "default:stone",
            lightwood_trunk = "tigris_underworld:lightwood_trunk",
            lightwood_pod = "tigris_underworld:lightwood_pod",
        } do
            if q.objectives[k] and not q.objectives[k].complete and node.name == v then
                simple_quests.ohelp.count.add(q, k, 1)
            end
        end
    end
end)

minetest.register_on_placenode(function(pos, node, placer)
    local name = placer:get_player_name()
    local q = simple_quests.quest_active("tigris_story:first_mining", name)
    if q then
        if q.objectives.place and not q.objectives.place.complete and node.name == "tigris_underworld:lightwood_sapling" then
            local under = minetest.get_node(vector.add(pos, vector.new(0, -1, 0)))
            if under.name == "default:coalblock" or under.name == "default:stone_with_coal" then
                simple_quests.ohelp.count.add(q, "place", 1)
            end
        end
    end
end)
