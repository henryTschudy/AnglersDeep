extends Node

var slingshot_scene = preload("res://scenes/slingshot_scene.tscn").instance()

# Called when the node enters the scene tree for the first time.
func _ready():
	add_child(slingshot_scene)
	
	slingshot_scene.position = slingshot_scene.position + slingshot_scene.get_node("slingshot").position
	#slingshot_scene.scale = Vector2(0.3, 0.3)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#slingshot.global_position = boat.position
