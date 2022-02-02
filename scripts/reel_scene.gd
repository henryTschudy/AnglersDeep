extends Node2D

onready var slingshot = get_node("../../../boat/cast_scene/Node2D/slingshot") #ticking time bomb
onready var boat = get_node("../../../boat")
onready var map = get_node("../../../map_node")

#var slingshot = load("res://scripts/slingshot_handle.gd")
var reel_scene = preload("res://scenes/reel_scene.tscn")
var reel_scene_manager

# Called when the node enters the scene tree for the first time.
func _ready():
	slingshot.connect("shadow_fish_collision", self, "_on_shadow_fish_collision")
	#reel_scene.connect("reel_game_over", self, "_on_reel_game_end")
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	var parent_rotation = get_parent().rotation
#	set_rotation(-parent_rotation)

func _on_shadow_fish_collision():
	var new_reel_scene = reel_scene.instance()
	add_child(new_reel_scene)
	new_reel_scene.scale = Vector2(0.25, 0.25)
	
	boat.pause_mode = PAUSE_MODE_STOP
	map.pause_mode = PAUSE_MODE_STOP
	
	reel_scene_manager = get_node("reel_scene_manager")
	reel_scene_manager.connect("reel_game_over", self, "_on_reel_game_end")

func _on_reel_game_end(game_won: bool, fish_type: String):
	reel_scene_manager.queue_free()
	boat.pause_mode = PAUSE_MODE_INHERIT
	map.pause_mode = PAUSE_MODE_INHERIT
