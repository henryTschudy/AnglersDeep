extends Node

# The path of our saved data.
var path = "user://save.json"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
var data = { }

const GlobalManager = preload("global.gd") # Relative path
onready var global = GlobalManager.new()

func resetData():
	# Reset to defaults if path doesn't exist
	data = global.inventory.duplicate(true)

# load game function
func loadGame():
	var file = File.new()
	
	if not file.file_exists(path):
		resetData()
		return
	
	file.open(path, file.READ)
	var text = file.get_as_text()
	data = parse_json(text)
	
	file.close()

# save game function
func saveGame():
	var file
	
	file = File.new()
	file.open(path, File.WRITE)
	file.store_line(to_json(data))
	
	file.close()


# OPTIONAL: for buttons for save/load
func updateText():
	find_node("DataText").text = JSON.print(data)
	
func _on_SaveButton_pressed():
	saveGame()


func _on_LoadButton_pressed():
	loadGame()
	updateText()
