simple_quests.register("tigris_story:next_steps", {
    shortdesc = "Next Steps",
    longdesc = function(state)
        return "The rich resources of the surface are now yours."
    end,
    superdesc = function(state)
        return "There are many simple yet useful things found on the surface. They include flowers, grass, and sheep. Harvest some of these resources for use in future endeavours. You may need to explore for more biomes and craft shears."
    end,

    init = function(state)
        state:objective("rose", simple_quests.ohelp.count.init{
            description = "Pick roses.",
            max_count = 3,
        })

        state:objective("jungle_grass", simple_quests.ohelp.count.init{
            description = "Harvest jungle grass.",
            max_count = 5,
        })

        state:objective("shear", simple_quests.ohelp.count.init{
            description = "Shear wool of any kind.",
            max_count = 3,
        })
    end,
})

simple_quests.ohelp.ereg.dig("tigris_story:next_steps", function(q, pos, node)
    for k,v in pairs{
        rose = "flowers:rose",
        jungle_grass = "default:junglegrass",
    } do
        if q.objectives[k] and not q.objectives[k].complete and node.name == v then
            simple_quests.ohelp.count.add(q, k, 1)
        end
    end
end)

local old = tigris.mobs.interactions.shear_wool.func
function tigris.mobs.interactions.shear_wool.func(self, context)
    local r = old(self, context)
    if r then
        local q = simple_quests.quest_active("tigris_story:next_steps", context.other:get_player_name())
        if q and q.objectives.shear and not q.objectives.shear.complete then
            q:objective_done("shear")
        end
    end
    return r
end
