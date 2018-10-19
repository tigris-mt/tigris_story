simple_quests.register("tigris_story:first_mining", {
    shortdesc = "First Mining",
    init = function(state)
        state.longdesc = "Begin your journey by mining important base materials."
        state.superdesc = "Venturing out of the Room of Light is a task in itself. Because Anemyde has situated it under the surface of the planet, you must tunnel and cave your way out.\nBegin by gathering materials necessary for your survival outside the Room of Light.\nDescend the ladder to the tunnels constructed by Anemyde herself.\nStone is readily found, but you may need to search within caves for Lightwood trees."
        state.step = "pray"

        state:objective("stone", simple_quests.ohelp.count.init{
            description = "Mine stone.",
            max_count = 10,
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
        pray = function(state)
            state:objective("pray", {
                description = "Pray at the Altar of Anemyde.",
            })

            state:set_step("done")
        end,
    },
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
            if not q.objectives[k].complete and node.name == v then
                simple_quests.ohelp.count.add(q, k, 1)
            end
        end
    end
end)
