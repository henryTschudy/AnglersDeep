extends Node2D

onready var slingshot = get_node("../../../boat/cast_scene/Node2D/slingshot") #ticking time bomb
#var slingshot = load("res://scripts/slingshot_handle.gd")
var reel_scene = preload("res://scenes/reel_scene.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	slingshot.connect("shadow_fish_collision", self, "_on_shadow_fish_collision")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	var parent_rotation = get_parent().rotation
#	set_rotation(-parent_rotation)

func _on_shadow_fish_collision():
	var new_reel_scene = reel_scene.instance()
	add_child(new_reel_scene)
	new_reel_scene.scale = Vector2(0.25, 0.25)
