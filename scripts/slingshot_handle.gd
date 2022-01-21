#https://www.davidepesce.com/2019/10/14/godot-tutorial-5-1-dragging-player-with-mouse/

extends KinematicBody2D

var DRAG_SPEED = 20
var RETURN_SPEED = 18
var CORD_DISTANCE = 200
var MOMENTUM_MULT = 1.5
var PROJECTILE_SPEED_DIVISOR = 5

var being_dragged = false
var movement = Vector2(0,0)
var projectile_movement = Vector2(0,0)
var projectile_target_position = Vector2(0,0)
var base_position
var last_vector = Vector2(0,0)
var can_throw_projectile = true;
var being_thrown = false

onready var cord = get_node("cord")
onready var target = get_node("target")
onready var projectile = get_node("projectile")

# Called when the node enters the scene tree for the first time.
func _ready():
	set_pickable(true) #allows object to detect mouse entering and exiting, should be true by default, this is here for clarity
	base_position = global_position
	target.visible = false
	projectile.visible = false

func _input_event(_viewport, event, _shape_idx): #for mouse events that specifically involve this object
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT:
			being_dragged = event.pressed

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and not event.pressed:
			being_dragged = false

func _physics_process(_delta):
	if being_dragged:
		var new_position = get_viewport().get_mouse_position()
		movement = DRAG_SPEED*(new_position - position)
	else:
		var momentum = MOMENTUM_MULT*last_vector
		var direction = (base_position-position)  #not normalized, this is intentional
		if (direction.length() < 0.1): #rounding down to prevent horrible bugs, not sure if necessary
			direction = Vector2(0,0)
			momentum = Vector2(0,0)
		var changed_direction = (last_vector + direction).length() < last_vector.length() + direction.length()
		if (changed_direction && !projectile.visible):
			projectile.visible = true
			projectile_target_position = target.position
			projectile_movement = (target.position - base_position)/PROJECTILE_SPEED_DIVISOR
			print("butt")
		last_vector = direction
		movement = RETURN_SPEED*(direction + momentum)
		
	move_and_slide(movement)
	
	manage_cord()
	
	target.position = 4*(base_position - position)
	target.visible = being_dragged
	
	if projectile.visible:
		projectile.move_and_slide(projectile_movement)
		if (projectile_movement.x > 0 && projectile_movement.x > projectile_target_position.x) || (projectile_movement.y > 0 && projectile_movement.y > projectile_target_position.y) || (projectile_movement.x < 0 && projectile_movement.x < projectile_target_position.x) || (projectile_movement.y < 0 && projectile_movement.y < projectile_target_position.y) || (projectile_movement.x == 0 && projectile_movement.y):
			print("ass")
			projectile.visible = false
			projectile.position = base_position

func manage_cord(): #yeah, this could be done a lot better
	cord.points[0] = base_position-position-Vector2(CORD_DISTANCE,0)
	#cord.points[1] = position
	cord.points[2] = base_position-position+Vector2(CORD_DISTANCE,0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
