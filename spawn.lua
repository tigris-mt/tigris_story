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

minetest.register_on_newplayer(function(player)
    if underground_start.done then
        tigris.story.give_quest("tigris_story:arrival", player:get_player_name())
    end
end)

local old = underground_start.generation_callback
function underground_start.generation_callback(...)
    minetest.set_node(vector.add(({underground_start.box()})[1], vector.new(0, 0, 3)), {name = "tigris_story:altar"})

    for _,player in ipairs(minetest.get_connected_players()) do
        tigris.story.give_quest("tigris_story:arrival", player:get_player_name())
    end
    return old(...)
end
