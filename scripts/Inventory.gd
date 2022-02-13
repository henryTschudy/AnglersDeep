extends Node2D

var inventory_array = Global.inventory

var inventory_tiles_array = []
var num_tiles = 9
#data needed: item name str, sprite path str, item description str


# Called when the node enters the scene tree for the first time.
func _ready():
	#add all inv_tile_button nodes to the inventory_tiles_array
	for i in num_tiles:
		var tile_name = "inv_tile_button" + str(i+1)
		var tile_to_add = get_node(tile_name)
		inventory_tiles_array.append(tile_to_add)
	_update_inventory_tiles("fish")

func _update_inventory_tiles(type):
	for i in len(inventory_tiles_array):
		var inventory_index
		#select either fish inventory or item inventory
		if(type == "fish"):
			inventory_index = 0
		elif(type == "item"):
			inventory_index = 1
		
		if(i < len(inventory_array[inventory_index])):
			var item_name = inventory_array[inventory_index][i][0][0]
			var item_sprite_path = inventory_array[inventory_index][i][0][1]
			var item_description = inventory_array[inventory_index][i][0][2]
			var item_quantity = inventory_array[inventory_index][i][1]
			
			#update tile's display
			inventory_tiles_array[i]._fill_tile(item_quantity, item_sprite_path)
			
			#update tile's data
			inventory_tiles_array[i].item_name = item_name
			inventory_tiles_array[i].item_sprite_path = item_sprite_path
			inventory_tiles_array[i].item_description = item_description
		else:
			inventory_tiles_array[i]._make_empty()


func _update_item_description(item_data):
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
