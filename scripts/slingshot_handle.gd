#https://www.davidepesce.com/2019/10/14/godot-tutorial-5-1-dragging-player-with-mouse/

extends KinematicBody2D

var DRAG_SPEED = 20
var RETURN_SPEED = 18
var CORD_DISTANCE = 200
var MOMENTUM_MULT = 1.5
var PROJECTILE_SPEED_DIVISOR = 0.5
var PROJECTILE_WEIGHT = 0.1 #how quickly the projectile slows down after launch

var being_dragged = false
var movement = Vector2(0,0)
var projectile_movement = Vector2(0,0)
var projectile_target_position = Vector2(0,0)
var base_position #initial position of the projectile, target, and slingshot sprite
var last_vector = Vector2(0,0)
var can_throw_projectile = true;
var being_thrown = false

onready var cord = get_node("cord")
onready var target = get_node("target")
onready var projectile = get_parent().get_node("projectile")
onready var boat = get_node_or_null("../../../") #THIS IS BAD CODE THAT WILL BREAK IF THINGS GET MOVED AROUND
var warning_printed = false #for warning when the above node path is not reached

## Called when the node enters the scene tree for the first time.
func _ready():
	set_pickable(true) #allows object to detect mouse entering and exiting, should be true by default, this is here for clarity
	base_position = position
	target.visible = false
	projectile.visible = false

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and not event.pressed:
			being_dragged = false

func _input_event(_viewport, event, _shape_idx): #for mouse events that specifically involve this object
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT:
			being_dragged = event.pressed

func _physics_process(_delta):
	if being_dragged:
		#move slingshot to cursor
		var new_position = get_global_mouse_position() #was get_viewport().get_mouse_position()
		movement = DRAG_SPEED*(new_position - global_position) #movement = DRAG_SPEED*(new_position - position)

		#maybe delete later, resets projectile on drag
		projectile.visible = false
		projectile.position = base_position

	else:
		var momentum = MOMENTUM_MULT*last_vector
		var direction
		
		if (boat != null):
			direction = base_position - position.rotated(boat.rotation)  #not normalized, this is intentional
		else: #this breaks when rotated, but it's here as a failsafe for running this scene on its own outside the overworld
			direction = base_position - position
			if(!warning_printed):
				print("spinny bug will occur if slingshot is rotated, check if scenes have moved, ignore if you are running the slingshot separately from overworld")
				warning_printed = true
			
		#if (direction.length() < 0.01): #rounding down to prevent horrible bugs, not sure if necessary
		#	direction = Vector2(0,0)
		#	momentum = Vector2(0,0)

		var changed_direction = (last_vector + direction).length() < last_vector.length() + direction.length()
		if (changed_direction && !projectile.visible):
			projectile.visible = true
			projectile_target_position = target.position
			projectile_movement = (target.position - base_position)/PROJECTILE_SPEED_DIVISOR
			print("butt") #DO NOT DELETE, or do, IDC
		last_vector = direction
		movement = RETURN_SPEED*(direction + momentum)

	move_and_slide(movement)

	manage_cord()

	target.position = 4*(base_position - position)
	target.visible = being_dragged

	#Move the projectile when it's visible
	if projectile.visible:
		projectile.position =  lerp(projectile.position, base_position + projectile_target_position, PROJECTILE_WEIGHT)
		#projectile_movement = lerp(projectile_movement, Vector2.ZERO, PROJECTILE_DRAG) #slow down projectile over time
		#projectile.move_and_slide(projectile_movement)

	# debug
	#print(cord.points)
	#print(target.position)
	#print(direction)
	manage_cord()

func manage_cord(): #yeah, this could be done a lot better
	cord.points[0] = base_position-position-Vector2(CORD_DISTANCE,0)
	#cord.points[1] = position
	cord.points[2] = base_position-position+Vector2(CORD_DISTANCE,0)

### og code below ###

## Called when the node enters the scene tree for the first time.
#func _ready():
#	set_pickable(true) #allows object to detect mouse entering and exiting, should be true by default, this is here for clarity
#	base_position = global_position
#	target.visible = false
#	projectile.visible = false

#func _input_event(_viewport, event, _shape_idx): #for mouse events that specifically involve this object
#	if event is InputEventMouseButton:
#		if event.button_index == BUTTON_LEFT:
#			being_dragged = event.pressed
#
#func _input(event):
#	if event is InputEventMouseButton:
#		if event.button_index == BUTTON_LEFT and not event.pressed:
#			being_dragged = false
#
#func _physics_process(_delta):
#	if being_dragged:
#		var new_position = get_viewport().get_mouse_position()
#		movement = DRAG_SPEED*(new_position - position)
#	else:
#		var momentum = MOMENTUM_MULT*last_vector
#		var direction = (base_position-position)  #not normalized, this is intentional
#		if (direction.length() < 0.1): #rounding down to prevent horrible bugs, not sure if necessary
#			direction = Vector2(0,0)
#			momentum = Vector2(0,0)
#
#		var changed_direction = (last_vector + direction).length() < last_vector.length() + direction.length()
#		if (changed_direction && !projectile.visible):
#			projectile.visible = true
#			projectile_target_position = target.position
#			projectile_movement = (target.position - base_position)/PROJECTILE_SPEED_DIVISOR
#			print("butt")
#		last_vector = direction
#		movement = RETURN_SPEED*(direction + momentum)
#
#	move_and_slide(movement)
#
#	manage_cord()
#
#	target.position = 4*(base_position - position)
#	target.visible = being_dragged
#
#	if projectile.visible:
#		projectile.move_and_slide(projectile_movement)
#		if (projectile_movement.x > 0 && projectile_movement.x > projectile_target_position.x) || (projectile_movement.y > 0 && projectile_movement.y > projectile_target_position.y) || (projectile_movement.x < 0 && projectile_movement.x < projectile_target_position.x) || (projectile_movement.y < 0 && projectile_movement.y < projectile_target_position.y) || (projectile_movement.x == 0 && projectile_movement.y):
#			print("ass")
#			projectile.visible = false
#			projectile.position = base_position
#
#func manage_cord(): #yeah, this could be done a lot better
#	cord.points[0] = base_position-position-Vector2(CORD_DISTANCE,0)
#	#cord.points[1] = position
#	cord.points[2] = base_position-position+Vector2(CORD_DISTANCE,0)
