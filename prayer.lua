local function prayer_function(id, label, icon, mana, delay, func)
    local ename = "tigris_story:effect_" .. id

    local players = {}

    local function alert(player, message)
        minetest.chat_send_player(player:get_player_name(), "[" .. label .. "] " .. message)
    end

    playereffects.register_effect_type(ename, label, icon, {ename}, function(player)
        local state = players[player:get_player_name()]
        if not state then
            playereffects.cancel_effect_type(ename, true, player:get_player_name())
            return false
        end

        if player:get_hp() < state.hp or vector.distance(state.pos, player:getpos()) > 1 then
            alert(player, "Your body was disrupted.")
            playereffects.cancel_effect_type(ename, true, player:get_player_name())
            return false
        end

        state.times = state.times + 1
        if state.times >= delay then
            func(player, function(message)
                alert(player, message)
            end)
            return false
        end
    end,
    function(effect, player)
    end, false, true, 1)

    minetest.register_on_leaveplayer(function(player)
        playereffects.cancel_effect_type(ename, true, player:get_player_name())
    end)

    return (function(name)
        local player = minetest.get_player_by_name(name)
        if not player then
            return
        end
        if tigris.magic.mana(player) < mana then
            alert(player, "Your mana is too weak.")
            return
        end
        tigris.magic.mana(player, -mana, true)

        players[name] = {
            pos = player:getpos(),
            hp = player:get_hp(),
            times = 0,
        }

        playereffects.apply_effect_type(ename, delay, player)
    end)
end

local prayers = {
    recall = {
        description = "Call upon Inemyde for transportation to the Room of Light.",
        func = prayer_function("recall", "Recall", "tigris_story_prayer_recall.png", 10, 5, function(player)
            player:setpos(({underground_start.box()})[1])
            player:set_look_horizontal(0)
        end)
    },
}

for k,v in pairs(prayers) do
    minetest.register_chatcommand(k, {
        description = v.description,
        func = v.func,
    })
end

-- Override home function.
local old = minetest.registered_chatcommands["home"].func
minetest.override_chatcommand("home", {
    description = "Channel the power of Inemyde and warp to your home location.",
    privs = {home = true},
    func = prayer_function("home", "Home", "tigris_story_prayer_home.png", 10, 7, function(player, alert)
        local _, message = old(player:get_player_name())
        alert(message)
    end)
})

if minetest.settings:get_bool("tigris.story.force_home_priv", true) then
    minetest.register_on_newplayer(function(player)
        local privs = minetest.get_player_privs(player:get_player_name())
        privs.home = true
        minetest.set_player_privs(player:get_player_name(), privs)
    end)
end
