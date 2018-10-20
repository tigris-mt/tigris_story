local prayers = {
    recall = {
        description = "Call upon Inemyde for transportation to the Room of Light.",
        func = function(name)
            local player = minetest.get_player_by_name(name)
            if not player then
                return
            end
            local pos, hp = player:getpos(), player:get_hp()
            minetest.chat_send_player(name, "Your prayer has been heard. Remain stationary and calm while power gathers.")
            tigris.magic.mana(player, -25, true)
            minetest.after(5, function()
                local player = minetest.get_player_by_name(name)
                if not player or player:get_hp() ~= hp or vector.distance(pos, player:getpos()) > 1 then
                    minetest.chat_send_player(name, "Your body was disturbed and unable to teleport.")
                    return
                end
                minetest.chat_send_player(name, "The warmth of Inemyde envelops you.")
                player:setpos(({underground_start.box()})[1])
                player:set_look_horizontal(0)
            end)
        end,
    },
}

for k,v in pairs(prayers) do
    minetest.register_chatcommand("p" .. k, {
        description = v.description,
        func = v.func,
    })
end
