extends Node

#scenes
var main_menu_path = "res://scenes/main_menu.tscn"
var pause_menu_path = "res://scenes/pause_menu.tscn"
var overworld_path = "res://scenes/overworld.tscn"
var journal_path = "res://scenes/Journal.tscn"
var fish_display_path = "res://scenes/fish_display.tscn"
var current_scene_path = "res://scenes/main_menu.tscn"
var prev_scene_path
var child_scene
var journal_instance

#temp example data for inventory
var fish_1_data = ["fish1", "res://textures/anger_fish.png", "fish1 description"]
var fish_2_data = ["fish2", "res://textures/mobius_eel.png", "fish2 description"]
var fish_3_data = ["fish3", "res://textures/mobius_eel.png", "fish3 description"]
var item_1_data = ["item1", "res://textures/mobius_eel.png", "item1 description"]
var item_2_data = ["item2", "res://textures/anger_fish.png", "item2 description"]
var fish_1 = [fish_1_data, 1]
var fish_2 = [fish_2_data, 8]
var fish_3 = [fish_3_data, 2]
var item_1 = [item_1_data, 3]
var item_2 = [item_2_data, 4]
var fish_inventory = [fish_1, fish_2, fish_3]
var item_inventory = [item_1, item_2]
var inventory = [fish_inventory, item_inventory]

#settings
var volume
var window_width
var window_height
var isFullscreen

func _unhandled_input(_event):
	if Input.is_action_pressed("ui_cancel") && current_scene_path != main_menu_path:
		_escape()
	if Input.is_action_pressed("open_journal"):
		if(current_scene_path != main_menu_path && current_scene_path != pause_menu_path):
			if(current_scene_path != journal_path):
				_change_scene(_get_current_scene_path(),journal_path)
			else:
				_change_scene(_get_current_scene_path(),overworld_path)

func _escape():
	if current_scene_path != pause_menu_path:
		_change_scene(_get_current_scene_path(),pause_menu_path)
	else:
		_change_scene(_get_current_scene_path(),prev_scene_path)
		
func _change_scene(current_scene,next_scene):
	prev_scene_path = current_scene
	current_scene_path = next_scene
	get_tree().change_scene(next_scene)
	print(current_scene_path)
	print("^ current scene ^")
	print(prev_scene_path)
	print("^ prev scene ^")

func _get_current_scene_path():
	return get_tree().current_scene.filename
	
func _get_item_data(inv_type_index, item_index, item_data_index):
	#return requested data
	if(item_data_index == "name"):
		return inventory[inv_type_index][item_index][0][0]
	elif(item_data_index == "sprite_path"):
		return inventory[inv_type_index][item_index][0][1]
	elif(item_data_index == "description"):
		return inventory[inv_type_index][item_index][0][2]
	elif(item_data_index == "quantity"):
		return inventory[inv_type_index][item_index][1]

func _make_fish_dictionary():
	var fish_json = File.new() #create a new file variable to read the fish json
	fish_json.open("res://data/fish data.json", File.READ) #open the fish json set ro read mode
	var fish_text = fish_json.get_as_text() #read the fish json as text
	var parsed_json_dictionary = parse_json(fish_text) #parse the fish json text 
	return parsed_json_dictionary.get("Fish") #get the dictionary at key "Fish" and return it
