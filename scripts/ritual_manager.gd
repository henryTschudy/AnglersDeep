extends Node2D

var inventory_tiles_array = []
var inventory_items_array = Global.inventory["items"].keys()
var recipes_dictionary = {}
var equipment_keys = Global.item_dictionary["equipment"].keys()
var num_tiles = 12
onready var component1 = get_node("ritual_tile1")
onready var component2 = get_node("ritual_tile2")
onready var component3 = get_node("ritual_tile3")
onready var output = get_node("ritual_tile4")


func _ready():
	#add all inv_tile_button nodes to the inventory_tiles_array
	for i in num_tiles:
		var tile_name = "ritual_inv_tile" + str(i+1)
		var tile_to_add = get_node(tile_name)
		inventory_tiles_array.append(tile_to_add)
	update_item_tiles()
	
	#generate recipes dictionary
	for i in len(equipment_keys):
		var item_key = equipment_keys[i]	
		recipes_dictionary[item_key] = Global.item_dictionary["equipment"][item_key]["recipe"]

func update_item_tiles():
	for i in len(inventory_tiles_array):
		#for each inventory element, get the name, sprite, description, and quantity
		if(i < len(inventory_items_array)):
			#get name, sprite + quantity data from inventory
			var item_name = Global.get_item_data("items", inventory_items_array[i], "name")
			var item_quantity = Global.get_item_data("items", inventory_items_array[i], "quantity")
			var item_sprite_path = Global.get_item_data("items", inventory_items_array[i], "sprite_path")
			
			#update tile's display
			inventory_tiles_array[i].fill_tile(item_quantity, item_sprite_path)
			
			#update tile's data
			inventory_tiles_array[i].item_name = item_name
			inventory_tiles_array[i].item_sprite_path = item_sprite_path
			inventory_tiles_array[i].item_quantity = item_quantity
		
		#once there's no more inventory elements, make the rest of the tiles empty
		else:
			inventory_tiles_array[i].make_empty()

func add_item_to_crafting(inv_tile):
	var component_tile
	if(component1.item_quantity == 0):
		component_tile = component1
	elif(component2.item_quantity == 0):
		component_tile = component2
	elif(component3.item_quantity == 0):
		component_tile = component3
	else:
		#play error sound
		print("components full")
		return
	#play interact sound
	component_tile.fill_tile(1, inv_tile.item_sprite_path, inv_tile.item_name)
	inv_tile.add_quantity(-1)
	test_recipes()

func remove_item_from_crafting(component_tile):
	match component_tile:
		component1:
			if(component3.item_quantity > 0):
				component1.fill_tile(1, component2.item_sprite_path, component2.item_name)
				component2.fill_tile(1, component3.item_sprite_path, component3.item_name)
				component3.make_empty()
			elif(component2.item_quantity > 0):
				component1.fill_tile(1, component2.item_sprite_path, component2.item_name)
				component2.make_empty()
			else:
				component1.make_empty()
		component2:
			if(component3.item_quantity > 0):
				component2.fill_tile(1, component3.item_sprite_path, component3.item_name)
				component3.make_empty()
			else:
				component2.make_empty()

		component3:
			component3.make_empty()
	return_item_to_inv(component_tile)
	test_recipes()

func return_item_to_inv(tile_to_return):
	for i in len(inventory_items_array):
		var current_tile = inventory_tiles_array[i]
		if(current_tile.item_sprite_path == tile_to_return.item_sprite_path):
			current_tile.add_quantity(1)

func test_recipes():
#	var component_keys_array = get_component_keys()
	var component_keys_array = [component1.item_name, component2.item_name, component3.item_name]
	component_keys_array.sort()
	var recipe_keys_array = recipes_dictionary.keys()
	for i in len(recipe_keys_array):
		var i_recipe_array = recipes_dictionary.get(recipe_keys_array[i])
		i_recipe_array.sort()
		if(i_recipe_array == component_keys_array):
			display_craftable_item(recipe_keys_array[i])
			break
		else:
			display_craftable_item("clear")

func display_craftable_item(craftable_item_name):
	if(craftable_item_name == "clear"):
		output.make_empty()
	else:
		var craftable_item_sprite_path = Global.item_dictionary["equipment"][craftable_item_name]["sprite_path"]
		output.fill_tile(1, craftable_item_sprite_path, craftable_item_name)
	
func craft_item():
	if(!Global.inventory["equipment"].get(output.item_name)):
		Global.inventory["equipment"][output.item_name] = Global.item_dictionary["equipment"][output.item_name]
		Global.inventory["equipment"][output.item_name]["equipped"] = false
		Global.inventory["items"][component1.item_name]["quantity"] -= 1
		Global.inventory["items"][component2.item_name]["quantity"] -= 1
		Global.inventory["items"][component3.item_name]["quantity"] -= 1
		update_item_tiles()
		component1.make_empty()
		component2.make_empty()
		component3.make_empty()
		output.make_empty()
	else:
		update_item_tiles()
		component1.make_empty()
		component2.make_empty()
		component3.make_empty()
		output.make_empty()
		print("already have this item")
		#play error sound
