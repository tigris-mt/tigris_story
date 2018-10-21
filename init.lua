local m = {}
tigris.story = m

local storage = minetest.get_mod_storage()
-- Give story quest <name> to <player>. If the quest does not exist, the player can try to activate it again at any time.
function m.give_quest(name, player)
    -- Set quest storage.
    storage:set_string("lquest:" .. player, name)
    -- Try to give normally.
    if simple_quests.quests[name] then
        simple_quests.give(name, player)
    -- Otherwise tell the player they can activate it.
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

function m.kill_helper(quest, func)
    local old = tigris.mobs.death_callback
    function tigris.mobs.death_callback(mob, player)
        if player and player:is_player() then
            local name = player:get_player_name()
            local q = simple_quests.quest_active(quest, name)
            if q then
                func(q, mob)
            end
        end
        return old(mob, player)
    end
end

-- Prayer mechanic (chatcommands with gameplay effects like teleportation).
tigris.include("prayer.lua")

-- Surface spawn location.
tigris.include("surface_spawn.lua")

-- The focal point of early quests.
tigris.include("altar.lua")

-- Spawning and initial arrival quest.
tigris.include("spawn.lua")

-- Get the player mining basic materials and farming lightwood.
tigris.include("first_mining.lua")

-- Demonstrate more mining and metalworking, send the player deeper.
tigris.include("metalworking.lua")

-- Get the player started on hunting.
tigris.include("hunting.lua")

-- Transportation to the surface.
tigris.include("surface.lua")

-- Guide the player to find useful surface materials like flowers.
tigris.include("next_steps.lua")
