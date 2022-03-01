extends Node2D

var inventory_tiles_array = []
var inventory_items_array = Global.inventory.get("items").keys()
var recipes_dictionary = {}
var equipment_keys = Global.get_item_data("equipment", "all", "recipe")
var num_tiles = 12
onready var component1 = get_node("ritual_tile1")
onready var component2 = get_node("ritual_tile2")
onready var component3 = get_node("ritual_tile3")
onready var output = get_node("ritual_tile4")


# Called when the node enters the scene tree for the first time.
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
		recipes_dictionary[item_key] = Global.get_item_data("equipment", item_key, "recipe")
	test_recipes() #remove later

func update_item_tiles():
	for i in len(inventory_tiles_array):
		#for each inventory element, get the name, sprite, description, and quantity
		if(i < len(inventory_items_array)):
			#get name, sprite + item_description data from inventory
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
	if(component1.item_quantity == 0):
		component1.fill_tile(1, inv_tile.item_sprite_path, inv_tile.item_name)
		inv_tile.add_quantity(-1)
	elif(component2.item_quantity == 0):
		component2.fill_tile(1, inv_tile.item_sprite_path, inv_tile.item_name)
		inv_tile.add_quantity(-1)
	elif(component3.item_quantity == 0):
		#play interact sound
		component3.fill_tile(1, inv_tile.item_sprite_path, inv_tile.item_name)
		inv_tile.add_quantity(-1)
	else:
		print("components full")
		#play error sound
	test_recipes()

func remove_item_from_crafting(component_tile):
	match component_tile:
		component1:
			return_item_to_inv(component_tile)
			if(component3.item_quantity > 0):
				component1.fill_tile(1, component2.item_sprite_path)
				component2.fill_tile(1, component3.item_sprite_path)
				component3.make_empty()
			elif(component2.item_quantity > 0):
				component1.fill_tile(1, component2.item_sprite_path)
				component2.make_empty()
			else:
				component1.make_empty()
		component2:
			return_item_to_inv(component_tile)
			if(component3.item_quantity > 0):
				component2.fill_tile(1, component3.item_sprite_path)
				component3.make_empty()
			else:
				component2.make_empty()
				
		component3:
			return_item_to_inv(component_tile)
			component3.make_empty()
	test_recipes()

func return_item_to_inv(tile_to_return):
	for i in len(inventory_items_array):
		var current_tile = inventory_tiles_array[i]
		if(current_tile.item_sprite_path == tile_to_return.item_sprite_path):
			current_tile.add_quantity(1)

func test_recipes():
	var component_keys_array = get_component_keys()
	var recipe_keys_array = recipes_dictionary.keys()
	for i in len(recipe_keys_array):
		var i_recipe_array = recipes_dictionary.get(recipe_keys_array[i])
		i_recipe_array.sort()
		if(i_recipe_array == component_keys_array):
			#display the possible craftable item, recipe_keys_array[i]
			display_craftable_item(recipe_keys_array[i])
			break
		else:
			display_craftable_item("clear")

func get_component_keys():
	var component_sprite_path_array = [component1.item_sprite_path, component2.item_sprite_path, component3.item_sprite_path]
#	var component_sprite_path_array = ["res://textures/anger_fish.png", "res://textures/anger_fish.png", "res://textures/mobius_eel.png"]
	#SUPER IMPORTANT!!! CHANGE INVENTORY TO GLOBAL ITEM DICTIONARY ONCE IT IS IMPLEMENTED
	var item_inventory_array = Global.inventory["items"].keys()
	var item_key_array = []
	for i in len(component_sprite_path_array):
		for j in len(item_inventory_array):
			var item_key = item_inventory_array[j]
			var component_item_key_sprite_path = Global.inventory["items"][item_key]["sprite_path"]	
			if(component_sprite_path_array[i] == component_item_key_sprite_path):
				item_key_array.append(item_key)
	item_key_array.sort()
	return item_key_array

func display_craftable_item(craftable_item_name):
	if(craftable_item_name == "clear"):
		output.make_empty()
	else:
		#SUPER IMPORTANT!!! CHANGE INVENTORY TO GLOBAL ITEM DICTIONARY ONCE IT IS IMPLEMENTED
		var craftable_item_sprite_path = Global.inventory["equipment"][craftable_item_name]["sprite_path"]
		output.fill_tile(1, craftable_item_sprite_path, craftable_item_name)
	
func craft_item(craftable_item_name):
	print(Global.inventory["items"][component1.item_name]["quantity"])
	if(!Global.inventory["equipment"].get(craftable_item_name)):
		#SUPER IMPORTANT!!! CHANGE INVENTORY ON RIGHT SIDE TO GLOBAL ITEM DICTIONARY ONCE IT IS IMPLEMENTED
		Global.inventory["equipment"][craftable_item_name] = Global.inventory["equipment"][craftable_item_name]
#		Global.inventory["items"][component1.item_name]["quantity"] -= 1
		component1.make_empty()
		component2.make_empty()
		component3.make_empty()
		output.make_empty()
	pass
