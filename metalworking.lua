simple_quests.register("tigris_story:metalworking", {
    shortdesc = "Metalworking",
    longdesc = function(state)
        return "Mining and working metals are vital functions."
    end,
    superdesc = function(state)
        return "This world is rich in metals. You can make use of them all. Collect some of the most common metals and a furnace to smelt them in. You may need to explore beyond the Room of Light and it's tunnels. Once you have collected some metals, you can craft better tools."
    end,
    init = function(state)
        state:objective("iron", simple_quests.ohelp.count.init{
            description = "Mine iron.",
            max_count = 10,
        })
        state:objective("copper", simple_quests.ohelp.count.init{
            description = "Mine copper.",
            max_count = 10,
        })
        state:objective("tin", simple_quests.ohelp.count.init{
            description = "Mine tin.",
            max_count = 5,
        })
        state:objective("furnace", simple_quests.ohelp.count.init{
            description = "Place a furnace.",
            max_count = 1,
        })

        state.step = "pick"
    end,

    steps = {
        pick = function(state)
            state:objective("pick", simple_quests.ohelp.count.init{
                description = "Craft a bronze pick.",
                max_count = 1,
            })
            state:objective("sword", simple_quests.ohelp.count.init{
                description = "Craft a bronze sword.",
                max_count = 1,
            })

            state:set_step("done")
        end,
    },

    done = function(state)
        tigris.story.give_quest("tigris_story:hunting", state.quest.player)
    end,
})

simple_quests.ohelp.ereg.dig("tigris_story:metalworking", function(q, pos, node)
    for k,v in pairs{
        iron = "default:stone_with_iron",
        copper = "default:stone_with_copper",
        tin = "default:stone_with_tin",
    } do
        if q.objectives[k] and not q.objectives[k].complete and node.name == v then
            simple_quests.ohelp.count.add(q, k, 1)
        end
    end
end)

simple_quests.ohelp.ereg.place("tigris_story:metalworking", function(q, pos, node)
    for k,v in pairs{
        furnace = "default:furnace",
    } do
        if q.objectives[k] and not q.objectives[k].complete and node.name == v then
            simple_quests.ohelp.count.add(q, k, 1)
        end
    end
end)

simple_quests.ohelp.ereg.craft("tigris_story:metalworking", function(q, stack)
    for k,v in pairs{
        pick = "default:pick_bronze",
        sword = "default:sword_bronze",
    } do
        if q.objectives[k] and not q.objectives[k].complete and stack:get_name() == v then
            simple_quests.ohelp.count.add(q, k, 1)
        end
    end
end)
