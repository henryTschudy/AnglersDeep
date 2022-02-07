extends KinematicBody2D

var FISH_ANGER_INCREMENT = 10
var FISH_TURN_SLOWNESS = 5
var FISH_AWAY_TENDENCY = 0.5 #tendency for the fish to swim away from the line, keep this number pretty low
var WIN_DISTANCE = 150
var LOSS_DISTANCE = 1000

onready var fish_state_timer = get_node("fish_state_timer")
onready var fish_swim_timer = get_node("fish_swim_timer")
onready var line = get_node("../line")

var screen_size = Vector2(0,0)

var hook_offset_base_y = 0
var hook_offset = Vector2(0,0)
var reel_state = false

var fish_type

var fish_direction_target
var fish_direction
var fish_speed
var fish_anger

var fish_escaped = false
var fish_caught = false

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size.x = get_viewport().get_visible_rect().size.x #* get_parent().scale # Get width
	screen_size.y = get_viewport().get_visible_rect().size.y #* get_parent().scale # Get height
	
	hook_offset = Vector2(100, 35)
	hook_offset_base_y = hook_offset.y
	fish_state_timer.connect("timeout",self,"on_fish_state_timer_timeout")  
	fish_swim_timer.connect("timeout",self,"on_fish_swim_timer_timeout") 
	fish_direction = Vector2(0,0)
	fish_direction_target = Vector2(0,0)
	fish_speed = 1
	fish_anger = 0
	
	fish_type = "generic_fish"

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _physics_process(_delta): #incorporate delta, dumpass
	if reel_state:
		fish_get_dragged()
	else:
		fish_swim()

func fish_swim():
	fish_direction = (fish_direction + fish_direction_target/FISH_TURN_SLOWNESS).normalized()
	move_fish(fish_speed, fish_direction)
	check_win_loss_condition()
	
func fish_get_dragged():
	move_fish(fish_speed, fish_direction)
	#print(fish_speed)

func move_fish(move_speed, move_direction):
	#print(move_speed)
	#print(move_direction)
	if fish_direction.x < 0:
		set_fish_flipped(true)
	else:
		set_fish_flipped(false)
	
	rotation = move_direction.angle()
	move_and_slide(get_parent().scale.x * move_speed*move_direction)

func on_fish_state_timer_timeout():
	reel_state = !reel_state
	if(reel_state):
		#fish_direction = Vector2(0,0)
		fish_speed = 0
		fish_swim_timer.set_paused(true)
	else:
		fish_swim_timer.set_paused(false)
	
func on_fish_swim_timer_timeout():
	#print(fish_swim_timer.paused)
	#fish_direction = Vector2( rand_range(0,2)-1, rand_range(0,2)-rand_range(1,3) ).normalized() #tendency to go upward
	var fish_direction_target_base = ( Vector2(rand_range(-1,1), rand_range(-1,1)) ).normalized()
	var fish_direction_target_addon = FISH_AWAY_TENDENCY * ( position - line.points[0] ).normalized()
	fish_direction_target = (fish_direction_target_base + fish_direction_target_addon).normalized()
	fish_speed = rand_range(50,200)
	
func check_win_loss_condition(): #will need to redo this to be more flexible
	#if (position + hook_offset).x >= screen_size.x || (position + hook_offset).x <= 0:
	#	fish_direction.x = -fish_direction.x
	#if (position + hook_offset).y >= screen_size.y || (position + hook_offset).y <= 0:
	#	fish_direction.y = -fish_direction.y
	if get_fish_distance() > get_loss_distance():
		fish_escaped = true
	elif get_fish_distance() < get_win_distance(): #for now, winning just checks fish distance from line base
		fish_caught = true

func set_fish_type(given_fish_type):
	fish_type = given_fish_type
	
func get_fish_type():
	return fish_type
	
func get_fish_distance():
	return ((position + hook_offset)  * get_parent().scale.x).distance_to( (line.position + line.points[0]) * get_parent().scale.x) #this line might be overcompensating, idk
	
func get_win_distance():
	return WIN_DISTANCE * get_parent().scale.x
	
func get_loss_distance():
	return LOSS_DISTANCE * get_parent().scale.x

func set_fish_flipped(flip_state):
	get_node("fish_sprite").set_flip_v(flip_state)
	if (flip_state):
		hook_offset.y = -1*hook_offset_base_y
	else:
		hook_offset.y = hook_offset_base_y
