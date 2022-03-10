extends CanvasLayer

var inventory_tiles_array = []
var num_tiles = 10


# Called when the node enters the scene tree for the first time.
func _ready():
	#add all inv_tile_button nodes to the inventory_tiles_array
	for i in num_tiles:
		var tile_name = "ScrollContainer/VBoxContainer/research_tile" + str(i+1)
		var tile_to_add = get_node(tile_name)
		inventory_tiles_array.append(tile_to_add)
	
	#when inventory tab is opened, default inv_type is fish
	update_research_tiles()

func update_research_tiles():
	#get array of fish from the item_dictionary
	var fish_array = Global.item_dictionary.get("fish").keys()
	for i in len(inventory_tiles_array):
		#for each inventory element, get the name, sprite, description, and quantity
		if(i < len(fish_array)):
			#get tile + item_description data from inv array
			var fish_caught = Global.item_dictionary["fish"][fish_array[i]]["have_caught"]
			if(fish_caught):
				var fish_name = fish_array[i]
				var fish_sprite_path = Global.item_dictionary["fish"][fish_array[i]]["sprite_path"]
				var fish_description = Global.item_dictionary["fish"][fish_array[i]]["description"]
				inventory_tiles_array[i].fill_tile(fish_name, fish_sprite_path, fish_description)
			else:
				inventory_tiles_array[i].make_empty()
				pass
		#if there's extra research_tiles, make the rest of them unknown
		else:
			inventory_tiles_array[i].make_empty()
			pass
