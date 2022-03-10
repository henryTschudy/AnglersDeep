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
var volume
var window_width
var window_height
var isFullscreen

func _unhandled_input(_event):
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
	fish_json.open("res://data/fish data.json", File.READ) #open the fish json set ro read mode
	var fish_text = fish_json.get_as_text() #read the fish json as text
	var parsed_json_dictionary = parse_json(fish_text) #parse the fish json text 
	return parsed_json_dictionary.get("Fish") #get the dictionary at key "Fish" and return it

