simple_quests.register("tigris_story:surface", {
    shortdesc = "Journey to the Surface",
    longdesc = function(state)
        return "Conquer the surface! Your true purpose begins."
    end,
    superdesc = function(state)
        return table.concat({
            "Your grand mission, given by Inemyde, is to conquer the world, transform it, and defeat the demonic Aspects of Bulorset.",
            "The Underground is but one third of the world you are now in, the other two domains being the Surface and the Sky. Unfortunantely the latter two domains are ruled by the Sun, which is toxic to the power of Inemyde.",
            "In order to protect yourself against the direct power of the burning rays, you must use Amulets of Solar Shield.",
            "Once you have done this, you will be prepared for ascension."
        }, "\n")
    end,

    flags = {"ascend"},

    init = function(state)
        state:objective("amulet", {
            description = "Craft an Amulet of Solar Shield.",
        })

        state.step = "pray"
    end,

    steps = {
        pray = function(state)
            state:flag("ascend")

            state:objective("pray", {
                description = "Pray at the Golden Altar of Inemyde.",
            })

            state:set_step("done")
        end,
    },
})

simple_quests.ohelp.ereg.craft("tigris_story:surface", function(q, stack)
    if stack:get_name() == "tigris_magic:solar_shield_amulet" and q.objectives.amulet and not q.objectives.amulet.complete then
        q:objective_done("amulet")
    end
end)
