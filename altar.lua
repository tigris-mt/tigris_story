local give_items = {
    ItemStack("default:pick_wood"),
    ItemStack("default:stick 2"),
    ItemStack("default:torch 2"),
    ItemStack("default:apple 4"),
}

local function register(name, description, tile, image, action, func)
    minetest.register_node(name, {
        description = description,
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
        tiles = {tile},
        groups = {cracky = 1, level = 3},
        sounds = default.node_sound_stone_defaults(),

        on_construct = function(pos)
            local meta = minetest.get_meta(pos)
            meta:set_string("formspec", [[
                size[1,3]
                image[0,0;1,1;]] .. image .. [[]
                button_exit[0,1;1,1;pray;]] .. action .. [[]
                button_exit[0,2;1,1;mock;Mock]
            ]])
            meta:set_string("infotext", description)
        end,

        on_receive_fields = function(pos, _, fields, sender)
            local name = sender:get_player_name()
            if fields.pray then
                if minetest.get_gametime() - sender:get_meta():get_int("tigris_story:last_pray") < 10 then
                    minetest.chat_send_player(name, "Inemyde does not appreciate mindless, rapid devotion. Return after a moment of reflection.")
                else
                    func(sender)
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
end

register("tigris_story:altar",
    "Altar of Inemyde", "default_diamond_block.png", "flowers_rose.png", "Pray",
    function(player)
        local name = player:get_player_name()
        if simple_quests.quest_active("tigris_story:first_mining", name, "previous") == "pray" then
            local q = simple_quests.quest_active("tigris_story:first_mining", name)
            q:objective_done("pray")
        elseif simple_quests.quest_active("tigris_story:hunting", name, "previous") == "pray" then
            local q = simple_quests.quest_active("tigris_story:hunting", name)
            q:objective_done("pray")
        else
            local inv = player:get_inventory()
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
    end)

register("tigris_story:golden_altar",
    "Golden Altar of Inemyde", "default_gold_block.png", "flowers_tulip_black.png", "Ascend",
    function(player)
        local name = player:get_player_name()
        local q = simple_quests.quest("tigris_story:surface", name)
        if not q or not q:flagged("ascend") then
            minetest.chat_send_player(name, "You must prove yourself before receiving this altar's blessing.")
            return
        end

        if not q.complete then
            q:objective_done("pray")
        end

        player:setpos(tigris.story.surface_spawn())
    end)
