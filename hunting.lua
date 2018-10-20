simple_quests.register("tigris_story:hunting", {
    shortdesc = "Hunting",
    longdesc = function(state)
        return "There are many creatures of this world that provide valuable resources."
    end,
    superdesc = function(state)
        return "You are not the only form of animal life on this world. There exist many others, ranging from the lowly worms to the manifested Aspects of Bulorset. You have been given dominion over it all, and the blessing of Inemyde permits you to take what is yours.\n\nProve your claim by slaying a number of these resources. You will find them wandering the cave systems, though they will not draw near to the Room of Light."
    end,
    init = function(state)
        state:objective("kill", simple_quests.ohelp.count.init{
            description = "Hunt whatever you can find.",
            max_count = 5,
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
    if q.objectives.kill and not q.objectives.kill.complete then
        simple_quests.ohelp.count.add(q, "kill", 1)
    end
end)
