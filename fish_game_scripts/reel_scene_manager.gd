extends Node2D

var DRAG_SPEED = 65
var DRAG_SPEED_SWIM = 45

var screen_size = Vector2(0,0)

onready var fishy = get_node("fish")
onready var line = get_node("line")
onready var fish_anger_bar = get_node("fish_anger_bar")

#to make fish swim in the direction it was swimming before reeling in during swim mode
var fish_prev_direction = Vector2(0,0)
var fish_prev_speed = 0

var fishy_angry = false

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size.x = get_viewport().get_visible_rect().size.x # Get width
	screen_size.y = get_viewport().get_visible_rect().size.y # Get height

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	line.points[1] = fishy.global_position + fishy.hook_offset.rotated(fishy.fish_direction.angle()) - line.global_position
	if fishy_angry:
		fishy.fish_anger += fishy.FISH_ANGER_INCREMENT * delta
		fish_anger_bar.set_value(fishy.fish_anger)
		#print(fishy.fish_anger)
	if fishy.fish_anger >= fish_anger_bar.max_value || fishy.fish_escaped:
		lose_fish_game()
	elif fishy.fish_caught:
		win_fish_game()

func _unhandled_input(_event):
	if Input.is_action_pressed("reel_in"):
		if fishy.reel_state:
			fishy.fish_direction = (fishy.global_position.direction_to(line.points[0] + line.global_position)).normalized()
			fishy.fish_speed = DRAG_SPEED
			#print(line.points[0] + line.global_position)
			#print("reeling in")
		else:
			fish_prev_direction = fishy.fish_direction
			fish_prev_speed = fishy.fish_speed
			fishy.fish_direction = (fishy.global_position.direction_to(line.points[0] + line.global_position)).normalized()
			fishy.fish_speed = DRAG_SPEED_SWIM
			fishy_angry = true
			
	if Input.is_action_just_released("reel_in"):
		fishy_angry = false
		if fishy.reel_state:
			fishy.fish_speed = 0
			#print("stop reeling in")
		else:
			fishy.fish_direction = fish_prev_direction
			fishy.fish_speed = fish_prev_speed

func lose_fish_game():
	#print("GAME LOST!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
	var loss_text = RichTextLabel.new()
	loss_text.add_text("FISH ESCAPED")
	loss_text.position = Vector2(screen_size.x, screen_size.y)
	
func win_fish_game():
	print("GAME WON!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")