extends Camera2D

onready var boat = get_node("../boat")
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	position = boat.position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position = boat.position
