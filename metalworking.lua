simple_quests.register("tigris_story:metalworking", {
    shortdesc = "Metalworking",
    init = function(state)
        state.longdesc = "Mining and working metals are vital functions."
        state.superdesc = "This world is rich in metals. You can make use of them all. Collect some of the most common metals and a furnace to smelt them in. You may need to explore beyond the Room of Light and it's tunnels."

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