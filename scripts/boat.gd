extends KinematicBody2D

onready var splash_particles = get_node("splash_particles")

var BOAT_ACCELERATION = 20
var BOAT_MAX_SPEED = 200
var BOAT_RESISTANCE = 80
var BREAK_SPEED = 100

var boat_speed
var boat_direction
var boat_turn_speed
var boat_accelerating


# Called when the node enters the scene tree for the first time.
func _ready():
	boat_speed = 0
	boat_direction = Vector2(0,0)
	boat_turn_speed = 0.1

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _physics_process(delta):
	move_boat()
	rotate_boat()
	do_boat_acceleration(delta)
	if (boat_speed > 50):
		splash_particles.emitting = true
	else:
		splash_particles.emitting = false
	

func _unhandled_input(_event):
	if Input.is_action_just_released("move_left") || Input.is_action_just_released("move_right") || Input.is_action_just_released("move_up") || Input.is_action_just_released("move_down"):
		boat_accelerating = false
	
	if Input.is_action_pressed("move_left"):
		boat_direction += Vector2(-boat_turn_speed,0)
		boat_accelerating = true
	if Input.is_action_pressed("move_right"):
		boat_direction += Vector2(boat_turn_speed,0)
		boat_accelerating = true
	if Input.is_action_pressed("move_up"):
		boat_direction += Vector2(0,-boat_turn_speed)
		boat_accelerating = true
	if Input.is_action_pressed("move_down"):
		boat_direction += Vector2(0,boat_turn_speed)
		boat_accelerating = true
	
	boat_direction = boat_direction.normalized()

func move_boat():
	move_and_slide(boat_speed*boat_direction)

func rotate_boat():
	rotation = boat_direction.angle()
	
func do_boat_acceleration(delta):
	if (boat_accelerating && boat_speed < BOAT_MAX_SPEED):
		boat_speed += BOAT_ACCELERATION*delta
	if (!boat_accelerating): #real-life resistance would apply all the time, but it's easier to control of we just do it this way
		boat_speed -= BOAT_RESISTANCE*delta
	if Input.is_action_pressed("move_stop"):
		boat_speed -= BREAK_SPEED*delta
	if (boat_speed <= 0):
		boat_speed = 0
#var target_position = $Target.transform.origin
#var new_transform = $Arrow.transform.looking_at(target_position, Vector3.UP)
#$Arrow.transform  = $Arrow.transform.interpolate_with(new_transform, speed * delta)
