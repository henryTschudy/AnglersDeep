extends CanvasLayer

var inventory_array = Global.inventory

var inventory_tiles_array = []
var num_tiles = 6
var equipped_item = "basic fishing rod"

# Called when the node enters the scene tree for the first time.
func _ready():
	#add all inv_tile_button nodes to the inventory_tiles_array
	for i in num_tiles:
		var tile_name = "inv_tile_button" + str(i+1)
		var tile_to_add = get_node(tile_name)
		inventory_tiles_array.append(tile_to_add)
	
	find_equipped_item()
	update_equipment_tiles()
	update_equipped_item_display()

func update_equipment_tiles():
	for i in len(inventory_tiles_array):
		#get array of items respective to the inv_type
		var item_array = Global.inventory.get("equipment").keys()
		
		#for each inventory element, get the name, sprite, description, and quantity
		if(i < len(item_array)):
			#get name, sprite + item_description data from inventory
			var item_name = Global.get_item_data("equipment", item_array[i], "name")
			var item_sprite_path = Global.get_item_data("equipment", item_array[i], "sprite_path")
			var item_description = Global.get_item_data("equipment", item_array[i], "description")
			
			#update tile's display
			inventory_tiles_array[i].fill_tile(item_sprite_path)
			
			#update tile's data
			inventory_tiles_array[i].item_name = item_name
			inventory_tiles_array[i].item_sprite_path = item_sprite_path
			inventory_tiles_array[i].item_description = item_description
		
		#once there's no more inventory elements, make the rest of the tiles empty
		else:
			inventory_tiles_array[i].make_empty()

func equip_item(item_to_equip):
	Global.inventory.get("equipment").get(equipped_item)["equipped"] = false
	Global.inventory.get("equipment").get(item_to_equip)["equipped"] = true
	equipped_item = item_to_equip
	update_equipped_item_display()

func update_equipped_item_display():
	get_node("inv_tile_button7/item_sprite").texture = load(Global.inventory.get("equipment").get(equipped_item).get("sprite_path"))

func find_equipped_item():
	var equipment_keys = Global.inventory["equipment"].keys()
	for i in len(equipment_keys):
		if(Global.inventory["equipment"][equipment_keys[i]]["equipped"]):
			equipped_item = Global.inventory["equipment"][equipment_keys[i]]["name"]
