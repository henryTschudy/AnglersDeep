extends Node

# The path of our saved data.
var path = "res://data/save.json"
var data = { }
var default_inventory = {
	"Fish" : {},
	"Items" : {},
	"Equipment" : {
		"Normal Hook" : {
			"Name": "Normal Hook",
			"Item Components": ["N/A", "N/A"],
			"Item Description": "Allows the Fishing of lower-tier fish",
			"Equipped" : true
		}
	}
}
#var default_inventory = {
#	"Fish" : {
#		"Yaldagolathos, The Big One": {
#			"Name": "Yaldagolathos, The Big One",
#			"Metaphysical Notes": "In the depths of the world and deeper still writhes a deep God. When land was not even a glint in the many facated eyes of that primodial mass, it swam and was the water through which it swam. The lesser spawn exalted in its caliginous depths, when there was no distinction between water and God. Where there is life there is water, and where there is water there is The Big One, inscrutable and impercetible. Form now land, and those fish that walk upright but are always home in The Sea claim this air-water as their own, and lost that mass that swam as we crawled. Can you feel it? I can feel it, the preassure of the depths from every molocule of this not-water pressing down like so many planets and stars. And in that depth we are crushed, shaped into something befitting the the perfect perfect Perfect form of that which is water and pressure, that which is deep and which gives and takes and takes and takes in a rapturous undertow of all parts hydrodynamic and squamous, that sqirm and writhe and grasp and PULL.",
#			"Biological Notes": "The Big One is, to put it bluntly, unfathomable. Even the mere thought of its name causes severe headaches and nosebleeds. All that can be concluded is that it bears some great, deep knowledge, and the horrifying image perceived by humans is merely what the mortal mind can make sense of. Perhaps this form is the origin of biblical angels, or sea monsters, or any other number of...things. How does it have so many tentacles? So many tentacles. And fins. Eyes. Teeth. [ink splotches] from this all things came to be, our beginning and end, that which we do not understand and never shall. salt in the wound, the sting of cold sea air. crushing pressure of the ocean as it fills my lungs. wrapping round and round and round and round and round and round andround and round and round andround and round and round andround and round and round andround and round and round andround and round and round andround and round and round and",
#			"Location": "res://textures/the_big_one.png",
#			"Frequency": 1,
#			"Region": "The Big One's Lair",
#			"Produced Item": "Acceptance",
#			"Item Path": "res://textures/items/acceptance.png",
#			"Quantity": 1
#		}
#	},
#	"Items" : {
#		"Acceptance" : {#delete this later
#			"Name": "Acceptance",
#			"Location": "res://textures/items/acceptance.png",
#			"Item Description": "",
#			"Quantity" : 1
#		}
#	},
#	"Equipment" : {
#		"Normal Hook" : {
#			"Name": "Normal Hook",
#			"Item Components": ["N/A", "N/A"],
#			"Item Description": "Allows the Fishing of lower-tier fish",
#			"Equipped" : true
#		}
#	}
#}

const GlobalManager = preload("global.gd") # Relative path
onready var global = GlobalManager.new()

func resetData():
	# Reset to defaults if path doesn't exist
	data = Global.inventory.duplicate(true)
	
	Global.edit_JSON(Global.FISH_JSON_PATH, "all", "Have Caught", false)
	print("reset game data")

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
	file.store_line(to_json(global.inventory))
	
	file.close()


# OPTIONAL: for buttons for save/load
func updateText():
	find_node("DataText").text = JSON.print(global.inventory)
	
func _on_SaveButton_pressed():
	saveGame()


func _on_LoadButton_pressed():
	loadGame()
	updateText()
