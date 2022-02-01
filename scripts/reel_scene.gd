extends Node2D

var reel_scene = preload("res://scenes/reel_scene.tscn").instance()

# Called when the node enters the scene tree for the first time.
func _ready():
	add_child(reel_scene)
	
	#reel_scene.position = camera.position
	reel_scene.scale = Vector2(0.25, 0.25)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	var parent_rotation = get_parent().rotation
#	set_rotation(-parent_rotation)
