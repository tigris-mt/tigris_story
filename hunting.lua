simple_quests.register("tigris_story:hunting", {
    shortdesc = "Hunting",
    init = function(state)
        state.longdesc = "There are many creatures of this world that provide valuable resources."
        state.superdesc = "You are not the only form of animal life on this world. There exist many others, ranging from the lowly worms to the manifested Aspects of Bulorset. You have been given dominion over it all, and the blessing of Inemyde permits you to take what is yours.\n\nProve your claim by slaying a number of these resources. You will find them wandering the cave systems, though they will not draw near to the Room of Light."

        state:objective("clay_worm", simple_quests.ohelp.count.init{
            description = "Kill a clay worm.",
            max_count = 1,
        })

        state:objective("rat", simple_quests.ohelp.count.init{
            description = "Kill rats.",
            max_count = 3,
        })

        state:objective("spitter", simple_quests.ohelp.count.init{
            description = "Kill an obsidian spitter.",
            max_count = 1,
        })

        state.step = "pray"
    end,

    steps = {
        pray = function(state)
            state:objective("pray", {
                description = "Pray at the Altar of Inemyde.",
            })
            state:set_step("done")
        end,
    },

    done = function(state)
        tigris.story.give_quest("tigris_story:surface", state.quest.player)
    end,
})

tigris.story.kill_helper("tigris_story:hunting", function(q, mob)
    for k,v in pairs{
        clay_worm = "tigris_mobs:clay_worm",
        rat = "tigris_mobs:rat",
        spitter = "tigris_mobs:obsidian_spitter",
    } do
        if q.objectives[k] and not q.objectives[k].complete and mob.name == v then
            simple_quests.ohelp.count.add(q, k, 1)
        end
    end
end)
