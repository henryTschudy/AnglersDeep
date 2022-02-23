extends Node

#signals
signal pause_node()
signal unpause_node()

#scenes
var main_menu_path = "res://scenes/main_menu.tscn"
var pause_menu_path = "res://scenes/pause_menu.tscn"
var overworld_path = "res://scenes/overworld.tscn"
var journal_path = "res://scenes/Journal.tscn"
var fish_display_path = "res://scenes/fish_display.tscn"
var current_scene_path = "res://scenes/main_menu.tscn"
var prev_scene_path
onready var map = get_node("../../map_node")

#scene states
#overworld, reel game, pause menu, journal
<<<<<<< Updated upstream
var current_scene_state
=======
>>>>>>> Stashed changes
enum scene_state{
	main_menu_state = 0,
	overworld_state = 1,
	reel_state = 2,
	pause_menu_state = 3,
	journal_state = 4
}
var current_scene_state = scene_state.main_menu_state

var child_scene_instance
#var journal_instance

#temp example data for inventory
var inventory = {
	"fish" : {
		"fish1" : {
			"name" : "fish 1",
			"sprite_path" : "res://textures/anger_fish.png",
			"description" : "scary guy",
			"quantity" : 2
		},
		"fish2" : {
			"name" : "fish 2",
			"sprite_path" : "res://textures/mobius_eel.png",
			"description" : "scary eel guy",
			"quantity" : 3
		}
	},
	"items" : {
		"item1" : {
			"name" : "item 1",
			"sprite_path" : "res://textures/mobius_eel.png",
			"description" : "scary item aaah",
			"quantity" : 1
		},
		"item2" : {
			"name" : "item 2",
			"sprite_path" : "res://textures/anger_fish.png",
			"description" : "scary item aah, but different this time",
			"quantity" : 5
		},
	},
	"equipment" : {
		"fishing_rod" : {
			"name" : "basic fishing rod",
			"sprite_path" : "res://textures/fishy.png",
			"description" : "rod for fishing"
		}
	}
}

#settings
var volume
var window_width
var window_height
var isFullscreen

#func _unhandled_input(_event):
#	if Input.is_action_just_pressed("ui_cancel"):
#		print('esc')
	
func _unhandled_input(_event):
	match current_scene_state:
		(scene_state.overworld_state):
			if Input.is_action_just_pressed("ui_cancel"):
				current_scene_state = scene_state.pause_menu_state
				instance_child_scene(pause_menu_path, true)
#				instance_child_scene(pause_menu_path, true)

			elif Input.is_action_just_pressed("open_journal"):
				#open journal scene
				current_scene_state = scene_state.journal_state
		(scene_state.reel_state):
			if Input.is_action_just_pressed("ui_cancel"):
				#quit out of reel minigame
				current_scene_state = scene_state.overworld_state
		(scene_state.journal_state):
			if Input.is_action_just_pressed("ui_cancel"):
				current_scene_state = scene_state.overworld_state

			elif Input.is_action_just_pressed("open_journal"):
				current_scene_state = scene_state.overworld_state
				pass
		(scene_state.pause_menu_state):
			if Input.is_action_pressed("ui_cancel"):
				current_scene_state = scene_state.overworld_state
				instance_child_scene(pause_menu_path, false)
				#unpause overworld scene

#open_or_close == true -> open pause menu, open_or_close == false -> close pause menu
func instance_child_scene(child_scene_path, open_or_close, sizeX = 0.5, sizeY = 0.5):
	if(open_or_close):
#		pause_overworld()
		print("instance pls")
		print(get_current_scene().get_node("overworld_camera").position)
		print(get_current_scene().get_node("overworld_camera").to_global(get_current_scene().get_node("overworld_camera").position))
		var world_cam = get_current_scene().get_node("overworld_camera")
		var child_scene = load(child_scene_path)
		child_scene_instance = child_scene.instance()
		child_scene_instance.scale = Vector2(sizeX, sizeY)
		child_scene_instance.position = world_cam.to_global(world_cam.position)
		get_current_scene().add_child(child_scene_instance)
	else:
		
#		unpause_overworld()
		child_scene_instance.queue_free()

func pause_overworld():
	map.set_pause(true)

func unpause_overworld():
	map.set_pause(false)

func pause_node(node):
	node.set_pause(true)

func unpause_node(node):
	node.set_pause(false)

func change_scene(next_scene_path):
	print(current_scene_state)
	match next_scene_path:
		(main_menu_path):
			current_scene_state = scene_state.main_menu_state
		(overworld_path):
			current_scene_state = scene_state.overworld_state
		(journal_path):
			current_scene_state = scene_state.journal_state
		(pause_menu_path):
			current_scene_state = scene_state.pause_menu_state
			
	get_tree().change_scene(next_scene_path)

func get_current_scene_path():
	return get_tree().current_scene.filename

func get_current_scene():
	return get_tree().current_scene

func get_item_data(inv_type, item_name, data_type):
	return inventory.get(inv_type).get(item_name).get(data_type)

func _make_fish_dictionary():
	var fish_json = File.new() #create a new file variable to read the fish json
	fish_json.open("res://data/fish data.json", File.READ) #open the fish json set ro read mode
	var fish_text = fish_json.get_as_text() #read the fish json as text
	var parsed_json_dictionary = parse_json(fish_text) #parse the fish json text 
	return parsed_json_dictionary.get("Fish") #get the dictionary at key "Fish" and return it

