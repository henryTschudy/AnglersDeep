extends Node

#scenes
var main_menu_path = "res://scenes/main_menu.tscn"
var pause_menu_path = "res://scenes/pause_menu.tscn"
var overworld_path = "res://scenes/overworld.tscn"
var journal_path = "res://scenes/Journal.tscn"
var current_scene_path = "res://scenes/main_menu.tscn"
var prev_scene_path
var child_scene
var journal_instance


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
