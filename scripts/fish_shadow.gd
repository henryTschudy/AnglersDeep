extends KinematicBody2D

var COLLISION_RADIUS = 10

var fish_type = "placeholder" #might want to change this to like an index or something, could use enums even idk, use 
var fish_direction
var fish_speed

var fish_collision_shape
var fish_sprite

# Called when the node enters the scene tree for the first time.
func _ready(): #may need to do some freeing
	random_speed_and_direction()
	
	fish_collision_shape = CollisionShape2D.new()
	fish_collision_shape.shape = CircleShape2D.new()
	fish_collision_shape.shape.set_radius(COLLISION_RADIUS)
	
	fish_sprite = Sprite.new()
	fish_sprite.set_texture(load("res://textures/fish_shadows/shadowfish.png"))
	
	set_collision_layer_bit(0, false)
	set_collision_layer_bit(1, true)
	set_collision_mask_bit(0, false)
	set_collision_mask_bit(1, true)
	
	add_child(fish_collision_shape)
	add_child(fish_sprite)

func _physics_process(delta):
	swim()

func set_fish_type(given_string): #this function could call another function that gets info from a json and sets it
	set_meta("shadowfish", "given_string") #makes a metadata category called fish and sets its value to "shadowfish_generic"

func get_fish_type():
	return fish_type

func swim():
	move_and_slide(fish_speed*fish_direction)

func random_speed_and_direction():
	change_direction_random()
	change_speed_random()

func change_direction_random():
	fish_direction = Vector2(rand_range(-1, 1),rand_range(-1,1)).normalized()
	
func change_direction(given_direction): #please give a Vector2
	fish_direction = given_direction

func change_speed_random():
	fish_speed = rand_range(0, 5)
	
func change_speed(given_speed):
	fish_speed = given_speed

func is_in_distance(center, x_distance, y_distance):
	return position.x > center.x - x_distance && position.x < center.x + x_distance && position.y > center.y - y_distance && position.y < center.y + y_distance

func despawn():
	queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
