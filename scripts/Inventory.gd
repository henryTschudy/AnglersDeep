extends Node2D

var inventory_array = Global.inventory

var inventory_tiles_array = []
var num_tiles = 9


# Called when the node enters the scene tree for the first time.
func _ready():
	#add all inv_tile_button nodes to the inventory_tiles_array
	for i in num_tiles:
		var tile_name = "inv_tile_button" + str(i+1)
		var tile_to_add = get_node(tile_name)
		inventory_tiles_array.append(tile_to_add)
	
	#when inventory tab is opened, default inv_type is fish
	_update_inventory_tiles("fish")

func _update_inventory_tiles(type):
	for i in len(inventory_tiles_array):
		#select either fish inventory or item inventory and get the corresponding inventory_type_index
		var inventory_type_index
		if(type == "fish"):
			inventory_type_index = 0
		elif(type == "item"):
			inventory_type_index = 1
		
		#for each inventory element, get the name, sprite, description, and quantity
		if(i < len(inventory_array[inventory_type_index])):
			#get tile + item_description data from inv array
			var item_name = Global._get_item_data(inventory_type_index, i, "name")
			var item_sprite_path = Global._get_item_data(inventory_type_index, i, "sprite_path")
			var item_description = Global._get_item_data(inventory_type_index, i, "description")
			var item_quantity = Global._get_item_data(inventory_type_index, i, "quantity")
			
			#update tile's display
			inventory_tiles_array[i]._fill_tile(item_quantity, item_sprite_path)
			
			#update tile's data
			inventory_tiles_array[i].item_name = item_name
			inventory_tiles_array[i].item_sprite_path = item_sprite_path
			inventory_tiles_array[i].item_description = item_description
		
		#once there's no more inventory items, make the rest of the tiles empty
		else:
			inventory_tiles_array[i]._make_empty()
