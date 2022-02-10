extends KinematicBody2D

onready var splash_particles = get_node("splash_particles")

var BOAT_ACCELERATION = 40
var BOAT_BACKWARDS_ACCELERATION = 10
var BOAT_MAX_SPEED = 200
var BOAT_RESISTANCE = 0.5
var BREAK_SPEED = 2
var BOAT_TURN_SPEED = 2

var boat_speed
#var boat_direction

var boat_accelerating
var boat_accelerating_backwards
var boat_rotating_left
var boat_rotating_right

# Called when the node enters the scene tree for the first time.
func _ready():
	boat_speed = 0
	#boat_direction = Vector2(0,0)
	
	boat_accelerating = false
	boat_accelerating_backwards = false
	boat_rotating_left = false
	boat_rotating_right = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _physics_process(delta):
	move_boat()
	#rotate_boat()
	do_boat_acceleration(delta)
	if (abs(boat_speed) > 50):
		splash_particles.emitting = true
	else:
		splash_particles.emitting = false
		
	if boat_rotating_left: #put this in physics so it can take delta into account
		rotation -= BOAT_TURN_SPEED*delta
	if boat_rotating_right:
		rotation += BOAT_TURN_SPEED*delta
	

func _unhandled_input(_event):
	#if Input.is_action_just_released("move_forward") || Input.is_action_just_released("move_backward"):
	#	boat_accelerating = false
	
	if Input.is_action_pressed("move_rotate_left"):
		#boat_direction += Vector2(-boat_turn_speed,0)
		boat_rotating_left = true
		#boat_accelerating = true
	else:
		boat_rotating_left = false
		
	if Input.is_action_pressed("move_rotate_right"):
		#boat_direction += Vector2(boat_turn_speed,0)
		boat_rotating_right = true
		#boat_accelerating = true
	else:
		boat_rotating_right = false
		
	if Input.is_action_pressed("move_forward"):
		#boat_direction += Vector2(0,-boat_turn_speed)
		boat_accelerating = true
		
	if Input.is_action_pressed("move_backward"):
		#boat_direction += Vector2(0,boat_turn_speed)
		boat_accelerating = true
		boat_accelerating_backwards = true
	else:
		boat_accelerating_backwards = false
		
	if !( Input.is_action_pressed("move_forward") || Input.is_action_pressed("move_backward") ):
		boat_accelerating = false
	
	#boat_direction = boat_direction.normalized()

func move_boat():
	#move_and_slide(boat_speed*boat_direction)
	move_and_slide(transform.x*boat_speed)

#func rotate_boat():
#	rotation = boat_direction.angle()
	
func do_boat_acceleration(delta):
	if (boat_accelerating && abs(boat_speed) < BOAT_MAX_SPEED):
		if !boat_accelerating_backwards:
			boat_speed += BOAT_ACCELERATION*delta
		else:
			boat_speed -= BOAT_BACKWARDS_ACCELERATION*delta
	if (!boat_accelerating): #real-life resistance would apply all the time, but it's easier to control of we just do it this way
		boat_speed = boat_speed - boat_speed*BOAT_RESISTANCE*delta
	if Input.is_action_pressed("move_stop"):
		boat_speed = boat_speed - boat_speed*BREAK_SPEED*delta
	#if (boat_speed <= 0):
	#	boat_speed = 0
#var target_position = $Target.transform.origin
#var new_transform = $Arrow.transform.looking_at(target_position, Vector3.UP)
#$Arrow.transform  = $Arrow.transform.interpolate_with(new_transform, speed * delta)
