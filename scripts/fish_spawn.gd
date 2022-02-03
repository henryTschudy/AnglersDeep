extends Node

signal shadow_fish_deleted

onready var tilemap = get_node("TileMap")
onready var boat = get_node("../boat")
onready var slingshot = get_node("../boat/cast_scene/Node2D/slingshot")
var fish_shadows = []

var SPAWN_DISTANCE_X = 480 #there is probably a better way to get this distance from the camera
var SPAWN_DISTANCE_Y = 270
var SPAWN_AREA_OUTER = 1000
var MAX_FISH = 10

var ShadowFishy = load("res://scripts/fish_shadow.gd")

# Called when the node enters the scene tree for the first time.
func _ready():
	slingshot.connect("shadow_fish_collision", self, "_on_shadow_fish_collision")

func spawn_fish(coordinates):
	var new_fish = ShadowFishy.new()
	new_fish.set_fish_type("generic_fish")
	new_fish.position = coordinates
	
	owner.add_child(new_fish)
	fish_shadows.push_back(new_fish)
	
func try_generate_spawn_fish():
	var try_coordinates = generate_spawn_coordinates()
	var map_rect = tilemap.get_used_rect()
	
	if (map_rect.has_point(try_coordinates)):
		print("spawn point invalid: in map_rect?") #wait, what was i doing here?
		return
	
	if (tilemap.get_cellv(tilemap.world_to_map(try_coordinates)) != $TileMap.INVALID_CELL):
		#print("spawn point invalid: non-empty tile")
		return
	
	spawn_fish(try_coordinates)

func generate_spawn_coordinates(): #generate some coordinates just outside the field of view
	 # i THINK 0 is empty??
	
	var distance_x = rand_range(-SPAWN_AREA_OUTER, SPAWN_AREA_OUTER)
	var distance_y = rand_range(-SPAWN_AREA_OUTER, SPAWN_AREA_OUTER)
	
	if (distance_x < 0):
		distance_x -= SPAWN_DISTANCE_X
	else:
		distance_x += SPAWN_DISTANCE_X
	
	if (distance_y < 0):
		distance_y -= SPAWN_DISTANCE_Y
	else:
		distance_y += SPAWN_DISTANCE_Y
	
	return Vector2(distance_x, distance_y) + boat.position
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if fish_shadows.size() < MAX_FISH :
		try_generate_spawn_fish()
	
	for shadow_fish in fish_shadows:
		if (!shadow_fish.is_in_distance(boat.position, SPAWN_DISTANCE_X + SPAWN_AREA_OUTER/2, SPAWN_DISTANCE_Y + SPAWN_AREA_OUTER/2)):
			fish_shadows.erase(shadow_fish) 
			shadow_fish.despawn()
			
func _on_shadow_fish_collision(colliding_fish):
	emit_signal("shadow_fish_deleted", colliding_fish.fish_type)
	fish_shadows.erase(colliding_fish)
	colliding_fish.despawn()
