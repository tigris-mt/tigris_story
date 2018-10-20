local give_items = {
    ItemStack("default:pick_wood"),
    ItemStack("default:stick 2"),
    ItemStack("default:torch 2"),
    ItemStack("default:apple 2"),
}

minetest.register_node("tigris_story:altar", {
    description = "Altar of Inemyde",
    paramtype = "light",
    light_source = minetest.LIGHT_MAX,
    drawtype = "nodebox",
    node_box = {
        type = "fixed",
        fixed = {
            {-0.5, 0, -0.5, 0.5, 0.5, 0.5},
            {-0.35, -0.5, -0.35, 0.35, 0, 0.35},
        },
    },
    tiles = {"default_diamond_block.png"},
    groups = {cracky = 1, level = 3},
    sounds = default.node_sound_stone_defaults(),

    on_construct = function(pos)
        local meta = minetest.get_meta(pos)
        meta:set_string("formspec", [[
            size[1,3]
            image[0,0;1,1;flowers_rose.png]
            button_exit[0,1;1,1;pray;Pray]
            button_exit[0,2;1,1;mock;Mock]
        ]])
        meta:set_string("infotext", "Altar of Inemyde")
    end,

    on_receive_fields = function(pos, _, fields, sender)
        local name = sender:get_player_name()
        if fields.pray then
            if minetest.get_gametime() - sender:get_meta():get_int("tigris_story:last_pray") < 10 then
                minetest.chat_send_player(name, "Inemyde does not appreciate mindless, rapid devotion. Return after a moment of reflection.")
            else
                if simple_quests.quest_active("tigris_story:first_mining", name, "previous") == "pray" then
                    local q = simple_quests.quest_active("tigris_story:first_mining", name)
                    q:objective_done("pray")
                elseif simple_quests.quest_active("tigris_story:hunting", name, "previous") == "pray" then
                    local q = simple_quests.quest_active("tigris_story:hunting", name)
                    q:objective_done("pray")
                else
                    local inv = sender:get_inventory()
                    for _,stack in ipairs(give_items) do
                        if not inv:contains_item("main", stack) then
                            inv:add_item("main", stack)
                        end
                    end
                    minetest.chat_send_player(name, "Inemyde has ensured you have the most basic of tools.")
                    local q = simple_quests.quest_active("tigris_story:arrival", name)
                    if q then
                        q:objective_done("pray")
                    end
                end
                sender:get_meta():set_int("tigris_story:last_pray", minetest.get_gametime())
            end
        elseif fields.mock then
            if sender:get_hp() >= 2 then
                sender:set_hp(math.max(1, sender:get_hp() / 2))
                minetest.chat_send_player(name, "Inemyde will punish mockery of her own altar. Let humility guide your actions.")
            else
                minetest.chat_send_player(name, "Inemyde will forgive you for the sake of your grievous wounds.")
            end
        end
    end,
})
