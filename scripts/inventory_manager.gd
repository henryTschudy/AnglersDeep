extends CanvasLayer

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
	update_inventory_tiles("Fish")

func update_inventory_tiles(inv_type):
	for i in len(inventory_tiles_array):
		#get array of items respective to the inv_type
		var item_array = Global.inventory.get(inv_type).keys()
		
		#for each inventory element, get the name, sprite, description, and quantity
		if(i < len(item_array)):
			#get tile + item_description data from inv array
			var item_key = item_array[i]
			var item_name = Global._get_fish_data(item_key).get("Name")
			var item_sprite_path = Global._get_fish_data(item_key).get("Location")
			var item_description = Global._get_fish_data(item_key).get("Metaphysical Notes")
			var item_quantity = Global.inventory.get("Fish").get(item_key).get("Quantity")
			
#			var item_name = Global.get_item_data(inv_type, item_array[i], "Name")
#			var item_sprite_path = Global.get_item_data(inv_type, item_array[i], "sprite_path")
#			var item_description = Global.get_item_data(inv_type, item_array[i], "description")
#			var item_quantity = Global.get_item_data(inv_type, item_array[i], "quantity")
			
			#update tile's display
			inventory_tiles_array[i].fill_tile(item_quantity, item_sprite_path)
			
			#update tile's data
			inventory_tiles_array[i].item_name = item_name
			inventory_tiles_array[i].item_sprite_path = item_sprite_path
			inventory_tiles_array[i].item_description = item_description
		
		#once there's no more inventory elements, make the rest of the tiles empty
		else:
			inventory_tiles_array[i].make_empty()
