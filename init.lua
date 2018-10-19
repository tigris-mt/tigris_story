local m = {}
tigris.story = m

local storage = minetest.get_mod_storage()
function m.give_quest(name, player)
    storage:set_string("lquest:" .. player, name)
    if simple_quests.quests[name] then
        simple_quests.give(name, player)
    else
        minetest.chat_send_player(player, "The next quest does not exist. Use /continue_story to resume playing the story once it is implemented.")
    end
end

minetest.register_chatcommand("continue_story", {
    description = "Continue the story from where you left off.",
    func = function(name)
        local lq = storage:get_string("lquest:" .. name)
        if simple_quests.quests[lq] then
            minetest.chat_send_player(name, "Your current quest has been reset.")
            m.give_quest(lq, name)
        else
            minetest.chat_send_player(name, "The current story quest is not (yet) available.")
        end
    end,
})

tigris.include("spawn.lua")
