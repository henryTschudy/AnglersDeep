extends KinematicBody2D

var FISH_ANGER_INCREMENT = 10

onready var fish_state_timer = get_node("fish_state_timer")
onready var fish_swim_timer = get_node("fish_swim_timer")

var screen_size = Vector2(0,0)

var hook_offset = Vector2(0,0)
var reel_state = false

var fish_direction
var fish_speed
var fish_anger

var fish_escaped = false
var fish_caught = false

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size.x = get_viewport().get_visible_rect().size.x # Get width
	screen_size.y = get_viewport().get_visible_rect().size.y # Get height
	
	hook_offset = Vector2(100, 35)
	fish_state_timer.connect("timeout",self,"on_fish_state_timer_timeout")  
	fish_swim_timer.connect("timeout",self,"on_fish_swim_timer_timeout") 
	fish_direction = Vector2(0,0)
	fish_speed = 1
	fish_anger = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _physics_process(_delta): #incorporate delta, dumpass
	if reel_state:
		fish_get_dragged()
	else:
		fish_swim()

func fish_swim():
	move_fish(fish_speed, fish_direction)
	check_offscreen()
	
func fish_get_dragged():
	move_fish(fish_speed, fish_direction)
	print(fish_speed)

func move_fish(move_speed, move_direction):
	#print(move_speed)
	#print(move_direction)
	rotation = move_direction.angle()
	move_and_slide(move_speed*move_direction)

func on_fish_state_timer_timeout():
	reel_state = !reel_state
	if(reel_state):
		#fish_direction = Vector2(0,0)
		fish_speed = 0
		fish_swim_timer.set_paused(true)
	else:
		fish_swim_timer.set_paused(false)
	
func on_fish_swim_timer_timeout():
	print(fish_swim_timer.paused)
	fish_direction = Vector2( rand_range(0,2)-1, rand_range(0,2)-rand_range(1,3) ).normalized() #tendency to go upward
	fish_speed = rand_range(50,200)
	
func check_offscreen():
	#if (position + hook_offset).x >= screen_size.x || (position + hook_offset).x <= 0:
	#	fish_direction.x = -fish_direction.x
	#if (position + hook_offset).y >= screen_size.y || (position + hook_offset).y <= 0:
	#	fish_direction.y = -fish_direction.y
	if (position + hook_offset).x >= screen_size.x || (position + hook_offset).x <= 0 || (position + hook_offset).y <= 0:
		fish_escaped = true
	elif (position + hook_offset).y >= screen_size.y: #for now, winning just checks if fish goes offscreen downward
		fish_caught = true
