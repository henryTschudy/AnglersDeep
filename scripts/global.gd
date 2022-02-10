extends Node

#scenes
var main_menu_path = "res://scenes/main_menu.tscn"
var pause_menu_path = "res://scenes/pause_menu.tscn"
var prev_scene_path
var current_scene_path = "res://scenes/main_menu.tscn"
onready var map = get_node("../../../map_node")

#scene states
#overworld, reel game, pause menu, journal
var current_scene_state
enum scene_state{
	main_menu_state,
	overworld_state,
	reel_state,
	pause_menu_state,
	journal_state
}

#settings
var volume
var window_width
var window_height
var isFullscreen

#func _unhandled_input(_event):
#	if Input.is_action_pressed("ui_cancel") && current_scene_path != main_menu_path:
#		_escape()

func _unhandled_input(_event):
	match current_scene_state:
		_:
			#default state is main menu
			current_scene_state = scene_state.main_menu_state
		(scene_state.overworld_state):
			print("overworld scene")
			if Input.is_action_pressed("ui_cancel"):
				current_scene_state = scene_state.pause_menu_state
				#open pause menu
				_pause_menu(true)
				
			if Input.is_action_pressed("open_journal"):
				#open journal scene
				current_scene_state = scene_state.journal_state
		(scene_state.reel_state):
			if Input.is_action_pressed("ui_cancel"):
				#quit out of reel minigame
				current_scene_state = scene_state.overworld_state
		(scene_state.journal_state):
			if Input.is_action_pressed("ui_cancel"):
				current_scene_state = scene_state.overworld_state
				#quit out of reel minigame
		(scene_state.pause_menu_state):
			if Input.is_action_pressed("ui_cancel"):
				current_scene_state = scene_state.overworld_state
				_pause_menu(false)
				#unpause overworld scene

#open_or_close == true -> open pause menu, open_or_close == false -> close pause menu
func _pause_menu(open_or_close):
	if(open_or_close):
		map.pause_mode = PAUSE_MODE_STOP
		var pause_menu = load(pause_menu_path)
		var pause_menu_instance = pause_menu.instance()
		add_child(pause_menu_instance)
	if(!open_or_close):
		queue_free()

#func _escape():
#	if current_scene_path != pause_menu_path:
#		_change_scene(_get_current_scene_path(),pause_menu_path)
#	else:
#		_change_scene(_get_current_scene_path(),prev_scene_path)

func _change_scene_2(scene):
	current_scene_state = scene

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
