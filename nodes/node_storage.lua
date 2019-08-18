-- internationalization boilerplate
local MP = minetest.get_modpath(minetest.get_current_modname())
local S, NS = dofile(MP.."/intllib.lua")

--local pipeworks_path = minetest.get_modpath("pipeworks")

local get_inventory_formspec = function(pos, player_name)
	return "size[8,9.3]" ..
	default.gui_bg ..
	default.gui_bg_img ..
	default.gui_slots ..
	"label[0,0;" .. S("Inventory items") .. "]" ..
	"list[nodemeta:"..pos.x..","..pos.y..","..pos.z..";main;0,0.6;8,4;]" ..
	"list[current_player;main;0,5.15;8,1;]" ..
	"listring[]" ..
	"list[current_player;main;0,6.38;8,3;8]" ..
	default.get_hotbar_bg(0,5.15)
end

-- Storage buffer. Builder nodes draw from this inventory and digger nodes deposit into it.
-- Note that inventories are digtron group 2.
minetest.register_node("digtron:inventory", {
	description = S("Digtron Inventory Storage"),
	_doc_items_longdesc = digtron.doc.inventory_longdesc,
	_doc_items_usagehelp = digtron.doc.inventory_usagehelp,
	groups = {cracky = 3, oddly_breakable_by_hand=3, digtron = 2, tubedevice = 1, tubedevice_receiver = 1},
	sounds = digtron.metal_sounds,
	paramtype2= "facedir",
	drawtype = "nodebox",
	node_box = {
        type = "fixed",
        fixed = {
            {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5},
        },
    },
	paramtype = "light",
	is_ground_content = false,
	tiles = {
		"digtron_plate.png^digtron_crossbrace.png",
		"digtron_plate.png^digtron_crossbrace.png",
		"digtron_plate.png^digtron_crossbrace.png^digtron_storage.png",
		"digtron_plate.png^digtron_crossbrace.png^digtron_storage.png",
		"digtron_plate.png^digtron_crossbrace.png^digtron_storage.png",
		"digtron_plate.png^digtron_crossbrace.png^digtron_storage.png",
		},

	on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		local inv = meta:get_inventory()
		inv:set_size("main", 8*4)
	end,
	
	can_dig = function(pos,player)
		local meta = minetest.get_meta(pos)
		local inv = meta:get_inventory()
		return inv:is_empty("main") and meta:get_string("digtron_id") == ""
	end,
		
	on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
		local meta = minetest.get_meta(pos)
		local digtron_id = meta:get("digtron_id")
		local player_name = clicker:get_player_name()
		if digtron_id == nil then
			minetest.show_formspec(player_name,
				"digtron_inventory:"..minetest.pos_to_string(pos)..":"..player_name,
				get_inventory_formspec(pos, player_name))
		else
			minetest.chat_send_player(clicker:get_player_name(), "This Digtron is active, interact with its inventory via the controller node.")
		end
	end,

		
--	-- Pipeworks compatibility
--	----------------------------------------------------------------
--
--	tube = (function() if pipeworks_path then return {
--		insert_object = function(pos, node, stack, direction)
--			local meta = minetest.get_meta(pos)
--			local inv = meta:get_inventory()
--			return inv:add_item("main", stack)
--		end,
--		can_insert = function(pos, node, stack, direction)
--			local meta = minetest.get_meta(pos)
--			local inv = meta:get_inventory()
--			return inv:room_for_item("main", stack)
--		end,
--		input_inventory = "main",
--		connect_sides = {left = 1, right = 1, back = 1, front = 1, bottom = 1, top = 1}
--	} end end)(),
--	
--	after_place_node = (function() if pipeworks_path then return pipeworks.after_place end end)(),
--	after_dig_node = (function() if pipeworks_path then return pipeworks.after_dig end end)()
})

local get_fuelstore_formspec = function(pos, player_name)
	return "size[8,9.3]" ..
	default.gui_bg ..
	default.gui_bg_img ..
	default.gui_slots ..
	"label[0,0;" .. S("Fuel items") .. "]" ..
	"list[nodemeta:"..pos.x..","..pos.y..","..pos.z..";fuel;0,0.6;8,4;]" ..
	"list[current_player;main;0,5.15;8,1;]" ..
	"listring[]" ..
	"list[current_player;main;0,6.38;8,3;8]" ..
	default.get_hotbar_bg(0,5.15)
end

-- Fuel storage. Controller node draws fuel from here.
-- Note that fuel stores are digtron group 5.
minetest.register_node("digtron:fuelstore", {
	description = S("Digtron Fuel Storage"),
	_doc_items_longdesc = digtron.doc.fuelstore_longdesc,
	_doc_items_usagehelp = digtron.doc.fuelstore_usagehelp,
	groups = {cracky = 3,  oddly_breakable_by_hand=3, digtron = 5, tubedevice = 1, tubedevice_receiver = 1},
	sounds = digtron.metal_sounds,
	paramtype2= "facedir",
	drawtype = "nodebox",
	node_box = {
        type = "fixed",
        fixed = {
            {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5},
        },
    },
	paramtype = "light",
	is_ground_content = false,
	tiles = {
		"digtron_plate.png^digtron_crossbrace.png^digtron_flammable.png",
		"digtron_plate.png^digtron_crossbrace.png^digtron_flammable.png",
		"digtron_plate.png^digtron_crossbrace.png^digtron_flammable.png^digtron_storage.png",
		"digtron_plate.png^digtron_crossbrace.png^digtron_flammable.png^digtron_storage.png",
		"digtron_plate.png^digtron_crossbrace.png^digtron_flammable.png^digtron_storage.png",
		"digtron_plate.png^digtron_crossbrace.png^digtron_flammable.png^digtron_storage.png",
		},

	on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		local inv = meta:get_inventory()
		inv:set_size("fuel", 8*4)
	end,
	
	-- Only allow fuel items to be placed in fuel
	allow_metadata_inventory_put = function(pos, listname, index, stack, player)
		if listname == "fuel" then
			if minetest.get_craft_result({method="fuel", width=1, items={stack}}).time ~= 0 then
				return stack:get_count()
			else
				return 0
			end
		end
		return 0
	end,
	
	can_dig = function(pos,player)
		local meta = minetest.get_meta(pos)
		local inv = meta:get_inventory()
		return inv:is_empty("fuel") and meta:get_string("digtron_id") == ""
	end,
	
	on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
		local meta = minetest.get_meta(pos)
		local digtron_id = meta:get("digtron_id")
		local player_name = clicker:get_player_name()
		if digtron_id == nil then
			minetest.show_formspec(player_name,
				"digtron_fuelstore:"..minetest.pos_to_string(pos)..":"..player_name,
				get_fuelstore_formspec(pos, player_name))
		else
			minetest.chat_send_player(clicker:get_player_name(), "This Digtron is active, interact with its inventory via the controller node.")
		end
	end,

--		
--	-- Pipeworks compatibility
--	----------------------------------------------------------------
--
--	tube = (function() if pipeworks_path then return {
--		insert_object = function(pos, node, stack, direction)
--			if minetest.get_craft_result({method="fuel", width=1, items={stack}}).time ~= 0 then
--				local meta = minetest.get_meta(pos)
--				local inv = meta:get_inventory()
--				return inv:add_item("fuel", stack)
--			end
--			return stack
--		end,
--		can_insert = function(pos, node, stack, direction)
--			if minetest.get_craft_result({method="fuel", width=1, items={stack}}).time ~= 0 then
--				local meta = minetest.get_meta(pos)
--				local inv = meta:get_inventory()
--				return inv:room_for_item("fuel", stack)
--			end
--			return false
--		end,
--		input_inventory = "fuel",
--		connect_sides = {left = 1, right = 1, back = 1, front = 1, bottom = 1, top = 1}
--	} end end)(),
--	
--	after_place_node = (function() if pipeworks_path then return pipeworks.after_place end end)(),
--	after_dig_node = (function() if pipeworks_path then return pipeworks.after_dig end end)()
})
--
local get_combined_formspec = function(pos, player_name)
	return "size[8,9.9]" ..
	default.gui_bg ..
	default.gui_bg_img ..
	default.gui_slots ..
	"label[0,0;" .. S("Inventory items") .. "]" ..
	"list[nodemeta:"..pos.x..","..pos.y..","..pos.z..";main;0,0.6;8,3;]" ..
	"label[0,3.5;" .. S("Fuel items") .. "]" ..
	"list[nodemeta:"..pos.x..","..pos.y..","..pos.z..";fuel;0,4.1;8,1;]" ..
	"list[current_player;main;0,5.75;8,1;]" ..
	"list[current_player;main;0,6.98;8,3;8]" ..
	"listring[nodemeta:"..pos.x..","..pos.y..","..pos.z..";main]" ..
	"listring[current_player;main]" ..
	default.get_hotbar_bg(0,5.75)
end

-- Combined storage. Group 6 has both an inventory and a fuel store
minetest.register_node("digtron:combined_storage", {
	description = S("Digtron Combined Storage"),
	_doc_items_longdesc = digtron.doc.combined_storage_longdesc,
    _doc_items_usagehelp = digtron.doc.combined_storage_usagehelp,
	groups = {cracky = 3,  oddly_breakable_by_hand=3, digtron = 6, tubedevice = 1, tubedevice_receiver = 1},
	sounds = digtron.metal_sounds,
	paramtype2= "facedir",
	drawtype = "nodebox",
	node_box = {
        type = "fixed",
        fixed = {
            {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5},
        },
    },
	paramtype = "light",
	is_ground_content = false,
	tiles = {
		"digtron_plate.png^digtron_crossbrace.png^digtron_flammable_small.png^[transformR180^digtron_flammable_small.png",
		"digtron_plate.png^digtron_crossbrace.png^digtron_flammable_small.png^[transformR180^digtron_flammable_small.png",		"digtron_plate.png^digtron_crossbrace.png^digtron_flammable_small.png^digtron_storage.png",
		"digtron_plate.png^digtron_crossbrace.png^digtron_flammable_small.png^digtron_storage.png",
		"digtron_plate.png^digtron_crossbrace.png^digtron_flammable_small.png^digtron_storage.png",
		"digtron_plate.png^digtron_crossbrace.png^digtron_flammable_small.png^digtron_storage.png",
		},
	on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		local inv = meta:get_inventory()
		inv:set_size("main", 8*3)
		inv:set_size("fuel", 8*1)
	end,
	
	
	allow_metadata_inventory_put = function(pos, listname, index, stack, player)
		-- Only allow fuel items to be placed in fuel
		if listname == "fuel" then
			if minetest.get_craft_result({method="fuel", width=1, items={stack}}).time ~= 0 then
				return stack:get_count()
			else
				return 0
			end
		end
		return stack:get_count() -- otherwise, allow all drops
	end,
	
	allow_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
		if to_list == "main" then
			return count
		end
		
		local meta = minetest.get_meta(pos)
		local inv = meta:get_inventory()
		local stack = inv:get_stack(from_list, from_index)
		if minetest.get_craft_result({method="fuel", width=1, items={stack}}).time ~= 0 then
			return stack:get_count()
		end
		return 0
	end,
	
	can_dig = function(pos,player)
		local meta = minetest.get_meta(pos)
		local inv = meta:get_inventory()
		return inv:is_empty("fuel") and inv:is_empty("main") and meta:get_string("digtron_id") == ""
	end,
	
	on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
		local meta = minetest.get_meta(pos)
		local digtron_id = meta:get("digtron_id")
		local player_name = clicker:get_player_name()
		if digtron_id == nil then
			minetest.show_formspec(player_name,
				"digtron_combined_storage:"..minetest.pos_to_string(pos)..":"..player_name,
				get_combined_formspec(pos, player_name))
		else
			minetest.chat_send_player(clicker:get_player_name(), "This Digtron is active, interact with its inventory via the controller node.")
		end
	end,
--		
--	-- Pipeworks compatibility
--	----------------------------------------------------------------
--	tube = (function() if pipeworks_path then return {
--		insert_object = function(pos, node, stack, direction)
--			local meta = minetest.get_meta(pos)
--			local inv = meta:get_inventory()
--			if minetest.get_craft_result({method="fuel", width=1, items={stack}}).time ~= 0 and direction.y == 1 then
--				return inv:add_item("fuel", stack)
--			end
--			return inv:add_item("main", stack)
--		end,
--		can_insert = function(pos, node, stack, direction)
--			local meta = minetest.get_meta(pos)
--			local inv = meta:get_inventory()
--			if minetest.get_craft_result({method="fuel", width=1, items={stack}}).time ~= 0 and direction.y == 1 then
--				return inv:room_for_item("fuel", stack)
--			end
--			return inv:room_for_item("main", stack)
--		end,
--		input_inventory = "main",
--		connect_sides = {left = 1, right = 1, back = 1, front = 1, bottom = 1, top = 1}
--	} end end)(),
--	
--	after_place_node = (function() if pipeworks_path then return pipeworks.after_place end end)(),
--	after_dig_node = (function() if pipeworks_path then return pipeworks.after_dig end end)()
})
--
---- Hopper compatibility
--if minetest.get_modpath("hopper") and hopper ~= nil and hopper.add_container ~= nil then
--	hopper:add_container({
--		{"top", "digtron:inventory", "main"},
--		{"bottom", "digtron:inventory", "main"},
--		{"side", "digtron:inventory", "main"},
--
--		{"top", "digtron:fuelstore", "fuel"},
--		{"bottom", "digtron:fuelstore", "fuel"},
--		{"side", "digtron:fuelstore", "fuel"},
--	
--		{"top", "digtron:combined_storage", "main"},
--		{"bottom", "digtron:combined_storage", "main"},
--		{"side", "digtron:combined_storage", "fuel"},
--	})
--end
