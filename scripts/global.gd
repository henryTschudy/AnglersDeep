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
var inventory = {
	"fish" : {
		"fish 1" : {
			"name" : "fish 1",
			"sprite_path" : "res://textures/anger_fish.png",
			"description" : "scary guy",
			"quantity" : 2
		},
		"fish 2" : {
			"name" : "fish 2",
			"sprite_path" : "res://textures/mobius_eel.png",
			"description" : "scary eel guy",
			"quantity" : 3
		}
	},
	"items" : {
		"item 1" : {
			"name" : "item 1",
			"sprite_path" : "res://textures/mobius_eel.png",
			"description" : "scary item aaah",
			"quantity" : 3
		},
		"item 2" : {
			"name" : "item 2",
			"sprite_path" : "res://textures/anger_fish.png",
			"description" : "scary item aah, but different this time",
			"quantity" : 5
		},
	},
	"equipment" : {
		"basic fishing rod" : {
			"name" : "basic fishing rod",
			"sprite_path" : "res://textures/bloated_rudefish.png",
			"description" : "rod for fishing",
			"recipe" : ["item 1","item 1","item 1"],
			"equipped" : true,
		},
		"different fishing rod" : {
			"name" : "different fishing rod",
			"sprite_path" : "res://textures/void_fish.png",
			"description" : "another unique rod for fishing",
			"recipe" : ["item 2","item 1","item 2"],
			"equipped" : false,
		}
	},
}

#temp example data for item_dictionary
var item_dictionary = {
	"fish" : {
		"fish 1" : {
			"name" : "fish 1",
			"sprite_path" : "res://textures/anger_fish.png",
			"description" : "scary guy",
			"have_caught" : true
		},
		"fish 2" : {
			"name" : "fish 2",
			"sprite_path" : "res://textures/mobius_eel.png",
			"description" : "scary eel guy",
			"have_caught" : true
		},
		"fish 3" : {
			"name" : "fish 3",
			"sprite_path" : "res://textures/void_fish.png",
			"description" : "you haven't caught this guy yet",
			"have_caught" : false
		},
		"fish 4" : {
			"name" : "fish 4",
			"sprite_path" : "res://textures/bloated_rudefish.png",
			"description" : "you have caught this guy tho",
			"have_caught" : true
		}
	},
	"items" : {
		"item 1" : {
			"name" : "item 1",
			"sprite_path" : "res://textures/mobius_eel.png",
			"description" : "scary item aaah",
		},
		"item 2" : {
			"name" : "item 2",
			"sprite_path" : "res://textures/anger_fish.png",
			"description" : "scary item aah, but different this time",
		},
	},
	"equipment" : {
		"basic fishing rod" : {
			"name" : "basic fishing rod",
			"sprite_path" : "res://textures/bloated_rudefish.png",
			"description" : "rod for fishing",
			"recipe" : ["item 1","item 1","item 1"]
		},
		"different fishing rod" : {
			"name" : "different fishing rod",
			"sprite_path" : "res://textures/void_fish.png",
			"description" : "another unique rod for fishing",
			"recipe" : ["item 1","item 2","item 2"]
		},
		"third fishing rod" : {
			"name" : "third fishing rod",
			"sprite_path" : "res://textures/mobius_eel.png",
			"description" : "yarr this here be the third fishing rod",
			"recipe" : ["item 2","item 2","item 2"]
		}
	},
}

#settings
var master_volume
var music_volume
var sound_fx_volume
var window_width
var window_height
var isFullscreen

#data structures
var fish_dictionary
var region_arrays

var FISH_JSON_PATH = "res://data/fish data.json"
var REGION_JSON_PATH = "res://data/FishRegions.json"

func _ready():
	fish_dictionary = _make_fish_dictionary()
	region_arrays = _make_region_arrays()

func _unhandled_input(_event):
	if Input.is_action_just_pressed("move_rotate_left"):
		SoundFx.play_sound("boat_continuous")
	if Input.is_action_just_pressed("move_rotate_right"):
		SoundFx.stop_sound("boat_continuous")
	if Input.is_action_just_pressed("ui_cancel") && current_scene_path != main_menu_path:
		_escape()
	if Input.is_action_just_pressed("open_journal"):
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

func _get_current_scene_path():
	return get_tree().current_scene.filename

func get_item_data(inv_type, item_name, data_type):
	if(item_name == "all"):
		#change to use full items JSON later, rn it just uses inventory
		return inventory.get(inv_type).keys()
	else:
		return inventory.get(inv_type).get(item_name).get(data_type)

func _make_fish_dictionary():
	var fish_json = File.new() #create a new file variable to read the fish json
	fish_json.open(FISH_JSON_PATH, File.READ) #open the fish json set ro read mode
	var fish_text = fish_json.get_as_text() #read the fish json as text
	var parsed_json_dictionary = parse_json(fish_text) #parse the fish json text 
	return parsed_json_dictionary

func _make_region_arrays():
	var region_json = File.new() #create a new file variable to read the fish json
	region_json.open(REGION_JSON_PATH, File.READ) #open the fish json set ro read mode
	var region_text = region_json.get_as_text() #read the fish json as text
	var parsed_json_dictionary = parse_json(region_text) #parse the fish json text 
	return parsed_json_dictionary.get("Regions") #get the dictionary at key "Fish" and return it

func _get_fish_data(fish_key):
	print(fish_key)
	return fish_dictionary.get(fish_key)
	
func _get_region_array(region_key):
	if region_arrays != null:
		return region_arrays.get(region_key)
	else:
		return null

func _get_random_fish_from_region(region_key):
	var region_array = _get_region_array(region_key)
	if region_array != null:
		var random_index = rand_range(0, region_array.size())
		return region_array[random_index]
	return null
